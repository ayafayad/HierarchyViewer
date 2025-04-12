//
//  NetworkError.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 11/04/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case requestFailed(Error)
    case invalidResponse
    case invalidUrl(String)
    case decodingFailed(Error)
    case statusCodeError(Int)

    var errorDescription: String? {
        switch self {
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidUrl(let urlString):
            return "Invalid URL: \(urlString)"
        case .decodingFailed(let error):
            return "Decoding failed: \(error.localizedDescription)"
        case .statusCodeError(let statusCode):
            return "Request failed with status code: \(statusCode)"
        }
    }
}
