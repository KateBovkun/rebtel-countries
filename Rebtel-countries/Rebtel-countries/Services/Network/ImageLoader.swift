//
//  ImageLoader.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-29.
//

import Foundation
import UIKit

protocol ImageLoaderProtocol {
    func fetch(_ urlRequest: URLRequest) async throws -> UIImage
}

actor ImageLoader: ImageLoaderProtocol {
    private var images: [URLRequest: LoaderStatus] = [:]
    private let dataLoader: DataLoaderProtocol

    private enum LoaderStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }

    init(dataLoader: DataLoaderProtocol) {
        self.dataLoader = dataLoader
    }

    public func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
        if let status = images[urlRequest] {
            switch status {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }

        let task: Task<UIImage, Error> = Task {
            let image = try await self.dataLoader.image(for: urlRequest)
            return image
        }
        images[urlRequest] = .inProgress(task)

        let image = try await task.value

        images[urlRequest] = .fetched(image)

        return image
    }
}
