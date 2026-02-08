//
//  AuthService.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 07-02-26. // Usa tu fecha actual
//

import Foundation

struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
    let user: User
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case networkError(Error)
    case invalidResponse
    case unknownError

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("El nombre de usuario o la contraseña son incorrectos.", comment: "Invalid credentials error")
        case .networkError(let error):
            return NSLocalizedString("Problema de conexión: \(error.localizedDescription)", comment: "Network error")
        case .invalidResponse:
            return NSLocalizedString("Respuesta inválida del servidor. Por favor, inténtelo de nuevo.", comment: "Invalid response error")
        case .unknownError:
            return NSLocalizedString("Ha ocurrido un error.", comment: "Unknown error")
        }
    }
}

class AuthService {
    
    private let baseURL = URL(string: "https://finance-api.sebitay.cl/auth/")!

    func login(request: LoginRequest) async throws -> LoginResponse {
        
        let loginURL = baseURL.appendingPathComponent("token")
        
        var urlRequest = URLRequest(url: loginURL)
        urlRequest.httpMethod = "POST"
        
        let formBody = "username=\(request.username)&password=\(request.password)"
        urlRequest.httpBody = formBody.data(using: .utf8)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthError.invalidResponse
            }
            
            print(httpResponse.statusCode)

            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                return loginResponse
            } else if httpResponse.statusCode == 401 {
                throw AuthError.invalidCredentials
            } else {
                throw AuthError.unknownError
            }
        } catch {
            throw AuthError.networkError(error)
        }
    }
}
