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
    @State private var showPassword: Bool = false
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
            Text("Finance")
                .font(.largeTitle)
                .bold(true)
            
            Text(loginErrorMessage)
                .foregroundStyle(.red)
                .frame(minHeight: 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("RUT")
                
                HStack {
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.gray)
                    
                    TextField("12.345.678-9", text: $username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                }
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(15)
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                
                HStack {
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if showPassword {
                            TextField("password", text: $password)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("••••••••", text: $password)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .frame(height: 22)
                        }
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                            .contentTransition(.symbolEffect(.replace))
                    }.buttonStyle(.plain)
                }
                .standardInputStyle()
            }

            Button() {login()} label: {
                HStack(spacing: 8) {
                    Text("Sign In")
                    Image(systemName: "arrow.right")
                        .imageScale(.small)
                }
            }
            .padding(.top)
            .buttonStyle(PrimaryButtonStyle())
            .font(.title2.bold())
            
        }.padding(.horizontal, (30))
    }
}


#Preview {
    LoginView(authViewModel: .constant(AuthViewModel()))
}
