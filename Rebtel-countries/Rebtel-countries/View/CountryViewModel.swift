//
//  CountryViewModel.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation
import UIKit

final class CountryViewModel {

    enum CountryViewModelError: Error {
        case cannotLoadFlagImage
        case indexOutOfBounds
    }

    private let countriesGraph: AdjacencyList<Country>
    private let country: Vertex<Country>
    private let borders: [Edge<Country>]
    private let imageLoader: ImageLoaderProtocol

    var countryName: String {
        return country.data.name
    }

    init(graph: AdjacencyList<Country>,
         country: Vertex<Country>,
         borders: [Edge<Country>],
         imageLoader: ImageLoaderProtocol) {
        self.countriesGraph = graph
        self.country = country
        self.borders = borders
        self.imageLoader = imageLoader
    }

    func countryFlag() async throws -> UIImage {
        guard let flag = country.data.flag else {
            throw CountryViewModelError.cannotLoadFlagImage
        }
        let request = try Endpoint.image(flag).request()
        let image = try await imageLoader.fetch(request)
        return image
    }

    func bordersCount() -> Int {
        self.borders.count
    }

    func borderName(at index: Int) throws -> String {
        return try country(at: index).data.name
    }

    func countryViewModel(at index: Int) throws -> CountryViewModel {
        let country = try country(at: index)
        let borders = self.countriesGraph.edges(from: country)
        return CountryViewModel(graph: self.countriesGraph,
                                country: country,
                                borders: borders,
                                imageLoader: self.imageLoader)
    }

// MARK: - Private
    private func country(at index: Int) throws -> Vertex<Country> {
        guard self.borders.count > index else {
            throw CountryViewModelError.indexOutOfBounds
        }
        return self.borders[index].destination
    }
}
