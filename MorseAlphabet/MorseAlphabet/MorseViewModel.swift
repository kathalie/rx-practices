//
//  MorseViewModel.swift
//  MorseAlphabet
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import Foundation
import RxSwift

class MorseViewModel {
    private let morseAlphabet: [String: String] = [
        ".-": "A",
        "-...": "B",
        "-.-.": "C",
        "-..": "D",
        ".": "E",
        "..-.": "F",
        "--.": "G",
        "....": "H",
        "..": "I",
        ".---": "J",
        "-.-": "K",
        ".-..": "L",
        "--": "M",
        "-.": "N",
        "---": "O",
        ".--.": "P",
        "--.-": "Q",
        ".-.": "R",
        "...": "S",
        "-": "T",
        "..-": "U",
        "...-": "V",
        ".--": "W",
        "-..-": "X",
        "-.--": "Y",
        "--..": "Z"
    ]
    
    private let disposeBag = DisposeBag()
    
    var inputSymbols = BehaviorSubject<String>(value: "")
    var outputSymbols = BehaviorSubject<String>(value: "")
    let errorState = PublishSubject<String>()
    
    init() {
        inputSymbols
            .scan("") { $0 + $1 }
            .subscribe(
                onNext: {[weak self] in
                    self?.processInput(input: $0)
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func processInput(input: String) {
        print("Current morse sequence: \(input)")
        
        guard input.last == MorseSymbols.pause.rawValue.last else { return }
        
        let morseSequence = retrieveLastMorseSequence(from: input)
        
        print(morseSequence)
        
        guard let translatedSymbol = translated(morseSequence) else {
            errorState.onNext("Wrong sequence of Morse symbols entered. Please, try again.")
            
            return
        }
                
        outputSymbols.onNext(translatedSymbol)
    }
    
    private func translated(_ morseSequence: String) -> String? {
        return morseAlphabet[morseSequence]
    }
    
    private func retrieveLastMorseSequence(from input: String) -> String {
        return String(input.split(separator: MorseSymbols.pause.rawValue).last ?? "")
    }
}


enum InputError: String, Error {
    case wrongMorseSequence = "Wrong sequence of morse symbols entered. Please, try again."
}
