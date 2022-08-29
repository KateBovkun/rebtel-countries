//
//  RandomCountryViewModel.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

final class RandomCountryViewModel {
    enum RandomCountryError: Error {
        case cannotSelectCountry
    }
    private let countriesLoader: CountriesLoader
    private var countriesGraph: AdjacencyList<Country>? = nil

    var isReady = false

    init(loader: CountriesLoader) {
        self.countriesLoader = loader
    }

    func loadCountries() async throws {
        if countriesGraph == nil {
            self.countriesGraph = try await countriesLoader.loadCountries()
        }
        self.isReady = !(self.countriesGraph?.isEmpty() ?? true)
    }

    func selectRandom(with imageLoader: ImageLoaderProtocol) throws -> CountryViewModel {
        guard let graph = self.countriesGraph, let (country, borders) = self.countriesGraph?.randomElement() else {
            throw RandomCountryError.cannotSelectCountry
        }
        return CountryViewModel(graph: graph, country: country, borders: borders, imageLoader: imageLoader)
        
    }
}
