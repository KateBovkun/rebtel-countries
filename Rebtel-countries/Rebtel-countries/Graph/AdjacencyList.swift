//
//  AdjacencyList.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

class AdjacencyList <T: Hashable>: Graph {
    private var adjacencies: [Vertex<T>: [Edge<T>]] = [:]

    init() {}

    func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(data: data, index: adjacencies.count)
        adjacencies[vertex] = []
        return vertex
    }

    private func addDirectedEdge(between source: Vertex<T>, and destination: Vertex<T>) {
        let edge = Edge(source: source, destination: destination)
        self.adjacencies[source]?.append(edge)
    }

    func addEdge(between source: Vertex<T>, and destination: Vertex<T>) {
        addDirectedEdge(between: source, and: destination)
    }

    func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjacencies[source] ?? []
    }

    func vertexes() -> [Vertex<T>] {
        return Array(adjacencies.keys)
    }

    func randomElement() -> (Vertex<T>, [Edge<T>])? {
        adjacencies.randomElement()
    }

    func isEmpty() -> Bool {
        return adjacencies.isEmpty
    }
}
