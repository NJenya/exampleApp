//
//  NetworkError.swift
//  Music AI Application
//
//  Created by Нурбол Мухаметжан on 02.03.2025.
//

import Foundation

enum NetworkError: LocalizedError {
    case missingURL
    case invalidURL
    
    case noConnection
    case requestFailed

    case invalidData
    case missingData
    case encodingError
    case decodingError

    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .missingURL:
            return "The request URL is missing."
        case .invalidURL:
            return "The request URL is invalid."
        case .noConnection:
            return "No internet connection available."
        case .requestFailed:
            return "The network request failed."
        case .invalidData:
            return "Received invalid data."
        case .missingData:
            return "Required data is missing."
        case .encodingError:
            return "Failed to encode data."
        case .decodingError:
            return "Failed to decode response."
        case .invalidResponse:
            return "Received an invalid response from the server."
        }
    }
}
