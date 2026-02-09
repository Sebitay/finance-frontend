//
//  LoginView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 08-02-26.
//
import SwiftUI

struct LoginView: View {
    
    @Binding var authViewModel: AuthViewModel
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loginErrorMessage: String = ""
    
    private func login() {
        Task {
            do {
                _ = try await authViewModel.login(username: username, password: password)
                    loginErrorMessage = ""
            } catch {
                loginErrorMessage = error.localizedDescription
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold(true)
            
            Text(loginErrorMessage)
                .foregroundStyle(.red)
                .frame(minHeight: 20)
            
            TextField("RUT", text: $username)
                .standardInputStyle()
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            SecureField("Password", text: $password)
                .standardInputStyle()
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button("Login") {login()}
                .padding(.top)
                .buttonStyle(PrimaryButtonStyle())
            
        }
    }
}


#Preview {
    LoginView(authViewModel: .constant(AuthViewModel()))
}
