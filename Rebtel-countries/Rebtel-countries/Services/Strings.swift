//
//  Strings.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-29.
//

import Foundation

struct Strings {
    enum GamePrep: String {
        case stepOne = "1. Think of a destination country."
        case stepTwo = "2. Press the button."
        case stepThree = "3. Try to get to your destination."
        case buttonTitleLoading = "LOADING"
        case buttonTitleGo = "GO"
        case buttonTitleReload = "RELOAD"
        case alertTitle = "Error"
        case alertMessage = "Countries loading failed. Retry?"
        case alertMessageNoCountry = "Error occured. Try to reload countries."
        case cancelButton = "Cancel"
        case okButton = "OK"
    }

    enum Country: String {
        case borders = "Borders"
        case tryAgain = "Try again!"
    }
}
