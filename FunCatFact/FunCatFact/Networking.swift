//
//  Networking.swift
//  FunCatFact
//
//  Created by Kathryn Verkhogliad on 08.03.2025.
//

import Foundation
import RxSwift
import UIKit

enum CatError: String, Error {
    case failedToFetchFact = "Failed to fetch a cat fact"
    case failedToParseFact = "Failed to parse a cat fact"
    case failedToFetchImage = "Failed to fetch a cat image"
    case failedToParseImage = "Failed to parse a cat image"
}

func getFunCatFact() -> Single<String> {
    return Single<String>.create { single in
        let url = URL(string: "https://catfact.ninja/fact")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                single(.failure(CatError.failedToFetchFact)); return
            }
            
            guard let data else {
                single(.failure(CatError.failedToFetchFact)); return
            }
            
            do {
                print(String(data: data, encoding: .utf8) ?? "")
                
                let decodedData = try JSONDecoder().decode(CatFactModel.self, from: data)
                
                single(.success(decodedData.fact))
            } catch {
                single(.failure(CatError.failedToParseFact)); return
            }
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}

func getCatImage() -> Single<UIImage> {
    return Single<UIImage>.create { single in
        let url = URL(string: "https://cataas.com/cat")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                single(.failure(CatError.failedToFetchImage)); return
            }
            
            guard let data else {
                single(.failure(CatError.failedToFetchImage)); return
            }
            
            guard let catImage = UIImage(data: data) else {
                single(.failure(CatError.failedToParseImage)); return
            }
            
            single(.success(catImage))
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}
