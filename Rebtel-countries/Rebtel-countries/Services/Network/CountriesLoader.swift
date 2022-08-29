//
//  CountriesLoader.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

final class CountriesLoader {
    let dataLoader: DataLoaderProtocol
    private let graphBuilder: GraphBuilderProtocol

    init(dataLoader: DataLoaderProtocol, graphBuilder: GraphBuilderProtocol) {
        self.dataLoader = dataLoader
        self.graphBuilder = graphBuilder
    }
    
    func loadCountries() async throws -> AdjacencyList<Country> {
        let request = try Endpoint.countries.request()
        let countriesResponse: [CountryResponse] = try await dataLoader.object(for: request)
        return graphBuilder.buildGraph(with: countriesResponse)
    }

}
