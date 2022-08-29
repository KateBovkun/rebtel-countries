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
    enum State {
        case initial
        case loading
        case loaded
        case error
    }
    private let countriesLoader: CountriesLoader
    private var countriesGraph: AdjacencyList<Country>? = nil

    private(set) var state = State.initial

    init(loader: CountriesLoader) {
        self.countriesLoader = loader
    }

    func loadCountries() async throws {
        switch state {
        case .loading, .loaded:
            return
        case .initial, .error:
            self.state = .loading
            do {
                self.countriesGraph = try await self.countriesLoader.loadCountries()
            } catch {
                self.state = .error
                throw error
            }
            self.state = .loaded
        }
    }

    func gameButtonOptions() -> (title: String, isEnabled: Bool) {
        switch state {
        case .loading, .initial:
            return (Strings.GamePrep.buttonTitleLoading.rawValue, false)
        case .error:
            return (Strings.GamePrep.buttonTitleReload.rawValue, true)
        case .loaded:
            return (Strings.GamePrep.buttonTitleGo.rawValue, true)
        }
    }

    func getRandomCountryViewModel(with imageLoader: ImageLoaderProtocol) throws -> CountryViewModel {
        guard let graph = self.countriesGraph, let (country, borders) = self.countriesGraph?.randomElement() else {
            self.state = .error
            self.countriesGraph = nil
            throw RandomCountryError.cannotSelectCountry
        }
        return CountryViewModel(graph: graph, country: country, borders: borders, imageLoader: imageLoader)
        
    }
}
