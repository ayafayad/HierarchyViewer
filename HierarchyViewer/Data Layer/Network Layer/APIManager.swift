//
//  APIManager.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: Decodable>(_ urlString: String, type: T.Type) async -> Result<T, NetworkError>
}

class APIManager: APIManagerProtocol {
    
    private let urlSession: URLSession
    private let networkMonitor: NetworkMonitor
    private let decoder = JSONDecoderService()
    
    init(urlSession: URLSession = .shared,
         networkMonitor: NetworkMonitor = PathNetworkMonitor(),
         decoder: JSONDecoderService = .init()) {
        self.urlSession = urlSession
        self.networkMonitor = networkMonitor
    }
    
    func request<T: Decodable>(_ urlString: String, type: T.Type) async -> Result<T, NetworkError> {
        
        guard networkMonitor.isReachable() else {
            return .failure(.noInternetConnection)
        }
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidUrl(urlString))
        }
        
        do {
            let (data, response) = try await urlSession.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }
            
            let statusCode = httpResponse.statusCode
            guard (200..<300).contains(statusCode) else {
                return .failure(.statusCodeError(statusCode))
            }

            do {
                let result: T = try decoder.decode(from: data)
                return .success(result)
            } catch {
                return .failure(.decodingFailed(error))
            }
        } catch {
            return .failure(.requestFailed(error))
        }
    }
}
