//
//  WeatherImageModel+UIImage.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 15.04.2025.
//

import Foundation
import UIKit

extension WeatherImageModel {
    var uiImage: UIImage? {
        UIImage(data: imageData)
    }
}
