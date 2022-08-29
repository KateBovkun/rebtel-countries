//
//  Graph.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

protocol Graph {
    associatedtype Element

    func createVertex(data: Element) -> Vertex<Element>
    func addEdge(between source: Vertex<Element>, and destination: Vertex<Element>)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
}
