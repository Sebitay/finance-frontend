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

    func FetchRequest(path: String, method: String, queryItems: [URLQueryItem] = [], body: Data? = nil) async throws -> Data {
        let url = apiURL.appendingPathComponent(path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        components.queryItems = queryItems
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.httpMethod = method
        
        if let body = body {
            urlRequest.addValue( "application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = body
        }
        
        let token = KeychainService.getToken()
        
        if token == nil {
            throw AuthError.invalidCredentials
        }
        
        urlRequest.addValue( "Bearer \(token!)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.other("Invalid response from API")
        }
        
        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 || httpResponse.statusCode == 204 {
            return data
        } else if httpResponse.statusCode == 401 {
            throw ApiError.invalidCredentials
        } else {
            throw ApiError.other("Response error: \(httpResponse.statusCode)")
        }
        
    }
}
