//
//  CountryList.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

struct Country: Equatable, Hashable {
    let name: String
    let flag: String?

    init(with response: CountryResponse) {
        name = response.name.common
        flag = response.flags.png
    }
}
