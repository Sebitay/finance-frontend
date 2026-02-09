//
//  ContentView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 07-02-26.
//

import SwiftUI

struct ContentView: View {

    @State private var authViewModel = AuthViewModel()

    var body: some View {
        ZStack {
            switch authViewModel.currentState {
            case .checking:
                ProgressView("Loading...")
            case .authenticated:
                MainView()
            case .unauthenticated:
                LoginView(authViewModel: $authViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
