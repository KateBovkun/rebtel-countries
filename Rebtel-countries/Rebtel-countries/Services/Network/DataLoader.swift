//
//  DataLoader.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-25.
//

import Foundation
import UIKit

protocol DataLoaderProtocol {
    func object<T: Decodable>(for request: URLRequest) async throws -> T
    func image(for request: URLRequest) async throws -> UIImage
}

final class DataLoader: DataLoaderProtocol {
    enum LoaderError: Error {
        case badResponse
        case statusCode(Int)
        case imageDecodingError
    }

    private let session: URLSession
    private let decoderFactory: JSONDecoderFactory

    private lazy var decoder = decoderFactory.makeDecoder()

    init(session: URLSession, factory: JSONDecoderFactory) {
        self.session = session
        self.decoderFactory = factory
    }

    func object<T>(for request: URLRequest) async throws -> T where T : Decodable {
        let data = try await data(for: request)
        return try decoder.decode(T.self, from: data)
    }

    func image(for request: URLRequest) async throws -> UIImage {
        let data = try await data(for: request)
        guard let image = UIImage(data: data) else {
            throw LoaderError.imageDecodingError
        }
        return image
    }

    func data(for request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw LoaderError.badResponse
        }
        guard httpResponse.statusCode == 200 else {
            throw LoaderError.statusCode(httpResponse.statusCode)
        }
        return data
    }
}
