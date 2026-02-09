//
//  AuthService.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 07-02-26. // Usa tu fecha actual
//

import Foundation
import LocalAuthentication

struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
    let user: User
}

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case KeychainError
    case other(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("Invalid username or password", comment: "Invalid credentials error")
        case .KeychainError:
            return NSLocalizedString("An error occurred with the keychain", comment: "Keychain error")
        case .other(let message):
            return message
        }
    }
}

@Observable
class AuthViewModel {
    enum AuthState {
        case checking
        case authenticated
        case unauthenticated
    }
    
    var currentState: AuthState = .checking
    let authURL = APIConfig.baseURL.appendingPathComponent("/auth")
    
    init() {
        checkLoginStatus()
    }
    
    func checkLoginStatus() {
        let token = KeychainService.getToken()
        
        DispatchQueue.main.async {
            if let tokenFound = token, !tokenFound.isEmpty {
                self.authenticateUser()
            } else {
                self.currentState = .unauthenticated
            }
        }
    }
    
    func login(username: String, password: String) async throws {
        
        if username.isEmpty || password.isEmpty {
            throw AuthError.invalidCredentials
        }
        
        let loginURL = authURL.appendingPathComponent("/token")
        
        var urlRequest = URLRequest(url: loginURL)
        urlRequest.httpMethod = "POST"
        
        let formBody = "username=\(username)&password=\(password)"
        urlRequest.httpBody = formBody.data(using: .utf8)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.other("Invalid response from API")
        }
        
        if httpResponse.statusCode == 200 {
            let decoder = JSONDecoder()
            let loginResponse: LoginResponse = try decoder.decode(LoginResponse.self, from: data)
            let status = KeychainService.saveToken(loginResponse.access_token)
            if status == errSecSuccess {
                currentState = .authenticated
                return
            } else {
                throw AuthError.KeychainError
            }
        } else if httpResponse.statusCode == 401 {
            throw AuthError.invalidCredentials
        } else {
            throw AuthError.other("Response error: \(httpResponse.statusCode)")
        }
    }
    
    func logout() {
        KeychainService.deleteToken()
        currentState = .unauthenticated
    }
    
    func authenticateUser() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identifícate para acceder a tus finanzas."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.currentState = .authenticated
                    } else {
                        print("Error in biometrics: \(authenticationError?.localizedDescription ?? "Unknown error")")
                        self.currentState = .unauthenticated
                    }
                }
            }
        } else {
            print("Biometrics not available: \(error?.localizedDescription ?? "No configurada")")
            self.currentState = .unauthenticated
        }
    }
}
