//
//  ContentView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 07-02-26.
//

import SwiftUI

struct ContentView: View {

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isAuthenticated: Bool = false
    @State private var loginErrorMessage: String? = nil
    private let authService = AuthService()

    var body: some View {
        NavigationStack {
            ZStack {
                if isAuthenticated {
                    MainView(isAuthenticated: $isAuthenticated)
                } else {
                    VStack(spacing: 20) {
                        Text("Iniciar Sesión")
                            .font(.largeTitle)
                        
                        TextField("Nombre de Usuario", text: $username)
                            .standardInputStyle()

                        SecureField("Contraseña", text: $password)
                            .standardInputStyle()
                        
                        if let loginErrorMessage {
                            Text(loginErrorMessage)
                                .foregroundStyle(.red)
                                .padding(.bottom, 8)
                        }

                        HStack {
                            CustomButton(title: "Entrar") {
                                loginErrorMessage = nil
                                Task {
                                    let loginRequest = LoginRequest(username: username, password: password)
                                    do {
                                        _ = try await authService.login(request: loginRequest)
                                            self.isAuthenticated = true
                                    } catch {
                                        loginErrorMessage = error.localizedDescription
                                    }
                                }
                            }
                            CustomButton(title: "Cancelar", backgroundColor: .red) {
                                print("Botón 'Cancelar' presionado.")
                            }
                        }
                        .padding(20)
                        .background(Color.blue.opacity(0.3))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    }
                    .padding()
                    .navigationTitle("Login")
                    .navigationBarHidden(true)
                    .transition(.move(edge: .leading)) 
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
