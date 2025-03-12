//
//  ViewController.swift
//  MorseAlphabet
//
//  Created by Kathryn Verkhogliad on 25.02.2025.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private var vm = MorseViewModel()
    private let disposeBag = DisposeBag()
//    private var ouputLabelDisposable: Disposable?
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBAction func dot(_ sender: UIButton) {
        vm.inputSymbols.onNext(MorseSymbols.dot.rawValue)
    }
    
    @IBAction func dash(_ sender: UIButton) {
        vm.inputSymbols.onNext(MorseSymbols.dash.rawValue)
    }
    
    @IBAction func pause(_ sender: UIButton) {
        vm.inputSymbols.onNext(MorseSymbols.pause.rawValue)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        // MARK: Recreating subjects is a very bad approach!
//        ouputLabelDisposable?.dispose() // MARK: Crucial to dispose!!!
//        vm.outputSymbols = BehaviorSubject<String>(value: "")
//        ouputLabelDisposable = vm.outputSymbols
//            .scan("") { $0 + $1 }
//            .subscribe(
//                onNext: {[weak self] in self?.outputLabel.text = $0},
//                onDisposed: { print("Disposed!") }
//            )
        
        vm.outputSymbols.onNext(MorseSymbols.reset.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeErrorState()
        subscribeOutputSymbols()
    }

    private func subscribeErrorState() {
        vm.errorState.subscribe(
            onNext: { [weak self] in
                self?.showAlert(title: "Error", message: $0)
            }
        ).disposed(by: disposeBag)
    }
    
    private func subscribeOutputSymbols() {
        vm.outputSymbols
            .scan("") { accumulated, newSymbol in
                return newSymbol == MorseSymbols.reset.rawValue ? "" : accumulated + newSymbol
            }
            .subscribe(
                onNext: {[weak self] in self?.outputLabel.text = $0}
            )
            .disposed(by: disposeBag)
    }
}
