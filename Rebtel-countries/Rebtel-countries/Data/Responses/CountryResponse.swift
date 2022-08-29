//
//  CountryResponse.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

struct CountryResponse: Decodable {
    let borders: [String]?
    let cca3: String
    let flags: CountryFlagResponse
    let name: CountryNameResponse
}

struct CountryFlagResponse: Decodable {
    let png: String?
}

struct CountryNameResponse: Decodable {
    let common: String
}
