//
//  Endpoints.swift
//  Rebtel-countries
//
//  Created by Ekaterina Zyryanova on 2022-08-26.
//

import Foundation

enum EndpointError: Error {
    case cannotMakeURL(endpoint: Endpoint)
}

enum Endpoint {
    case countries
    case image(String)
}

extension Endpoint {
    private enum HTTPMethod: String {
        case get = "GET"
    }

    private enum Accept: String {
        case json = "application/json"
        case image = "image/png"
    }

    private var url: URL? {
        let urlString: String
        switch self {
        case .countries:
            urlString = "https://restcountries.com/v3.1/all"
        case .image(let imageUrl):
            urlString = imageUrl
        }
        return URL(string: urlString)
    }

    private var parameters: (HTTPMethod, Accept) {
        switch self {
        case .countries: return (.get, .json)
        case .image(_): return (.get, .image)
        }
    }

    func request() throws -> URLRequest {
        guard let url = url else {
            throw EndpointError.cannotMakeURL(endpoint: self)
        }

        let (method, accept) = self.parameters
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue(accept.rawValue, forHTTPHeaderField: "Accept")
        return request
    }
}
