//
//  DependencyContainer.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-29.
//

import Foundation

final class FactoriesContainer {}

extension FactoriesContainer: JSONDecoderFactory {
    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension FactoriesContainer: DataLoaderFactory {
    func makeDataLoader() -> DataLoaderProtocol {
        DataLoader(session: .shared, factory: self)
    }
}

extension FactoriesContainer: GraphBuilderFactory {
    func makeGraphBuilder() -> GraphBuilderProtocol {
        GraphBuilder()
    }
}

extension FactoriesContainer: ImageLoaderFactory {
    func makeImageLoader(dataLoader: DataLoaderProtocol) -> ImageLoaderProtocol {
        ImageLoader(dataLoader: dataLoader)
    }
}
