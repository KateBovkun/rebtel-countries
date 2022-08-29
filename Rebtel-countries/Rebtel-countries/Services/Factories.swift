//
//  Factories.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

protocol JSONDecoderFactory {
    func makeDecoder() -> JSONDecoder
}

protocol DataLoaderFactory {
    func makeDataLoader() -> DataLoaderProtocol
}

protocol GraphBuilderFactory {
    func makeGraphBuilder() -> GraphBuilderProtocol
}

protocol ImageLoaderFactory {
    func makeImageLoader(dataLoader: DataLoaderProtocol) -> ImageLoaderProtocol
}
