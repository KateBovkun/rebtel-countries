//
//  DependencyContainer.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-29.
//

import Foundation

final class DependencyContainer {

    private init() {}

    static let shared = DependencyContainer()
}

extension DependencyContainer: JSONDecoderFactory {
    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension DependencyContainer: DataLoaderFactory {
    func makeDataLoader() -> DataLoaderProtocol {
        return DataLoader(session: .shared, factory: self)
    }
}

extension DependencyContainer: GraphBuilderFactory {
    func makeGraphBuilder() -> GraphBuilderProtocol {
        return GraphBuilder()
    }
}

extension DependencyContainer: ImageLoaderFactory {
    func makeImageLoader(dataLoader: DataLoaderProtocol) -> ImageLoaderProtocol {
        return ImageLoader(dataLoader: dataLoader)
    }
}
