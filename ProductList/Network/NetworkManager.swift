//
//  NetworkManager.swift
//  ProductList
//
//  Created by Alejandro Velasco on 31/08/25.
//

import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(_ urlString: String, method: String = "GET", headers: [String: String]? = nil, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
