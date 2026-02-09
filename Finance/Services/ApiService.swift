//
//  ApiService.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 08-02-26.
//

import Foundation

enum ApiError: Error, LocalizedError {
    case invalidCredentials
    case other(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Could not validate credentials.", comment: "Invalid credentials error")
        case .other(let message):
            return message
        }
    }
}

class ApiService {
    
    private let apiURL = APIConfig.baseURL.appendingPathComponent("/api")

    func FetchRequest(path: String, method: String, data: Data ) async throws -> Data {
        let url = apiURL.appendingPathComponent(path)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        
        let token = KeychainService.getToken()
        
        if token == nil {
            throw AuthError.invalidCredentials
        }
        
        urlRequest.addValue( "Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        urlRequest.httpBody = data

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.other("Invalid response from API")
        }
        
        if httpResponse.statusCode == 200 {
            return data
        } else if httpResponse.statusCode == 401 {
            throw ApiError.invalidCredentials
        } else {
            throw ApiError.other("Response error: \(httpResponse.statusCode)")
        }
        
    }
}
