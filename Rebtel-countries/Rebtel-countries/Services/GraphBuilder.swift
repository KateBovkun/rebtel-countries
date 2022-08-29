//
//  GraphBuilder.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

protocol GraphBuilderProtocol {
    func buildGraph(with response: [CountryResponse]) -> AdjacencyList<Country>
}

final class GraphBuilder: GraphBuilderProtocol {

    func buildGraph(with response: [CountryResponse]) -> AdjacencyList<Country> {
        var countries = [String: CountryResponse]()
        for country in response {
            countries[country.cca3] = country
        }
        let adjacencyList = AdjacencyList<Country>()
        var vertexes = [String: Vertex<Country>]()
        for (key, sourceCountry) in countries {
            let getVertex: (String, CountryResponse) -> Vertex<Country> = { (key, country) in
                let vertex: Vertex<Country>
                if let savedVertex = vertexes[key] {
                    vertex = savedVertex
                } else {
                    vertex = adjacencyList.createVertex(data: Country(with: country))
                    vertexes[key] = vertex
                }
                return vertex
            }
            let source = getVertex(key, sourceCountry)
            if let borders = sourceCountry.borders {
                for code in borders {
                    guard let destinationCountry = countries[code] else {
                        continue
                    }
                    let destination = getVertex(code, destinationCountry)
                    adjacencyList.addEdge(between: source, and: destination)
                }
            }
        }
        return adjacencyList
    }


}
