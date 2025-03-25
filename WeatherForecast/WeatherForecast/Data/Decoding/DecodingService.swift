//
//  Decoding.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import Foundation

enum DecodingError: Error {
    case failedToDecode
}

protocol DecodingServiceProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, DecodingError>
}

class JSONDecodingService: DecodingServiceProtocol {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> Result<T, DecodingError> {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            
            return .success(decodedData)
        } catch {
            return .failure(DecodingError.failedToDecode)
        }
    }
}
