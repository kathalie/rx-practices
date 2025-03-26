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
