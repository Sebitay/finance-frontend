//
//  AccountView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 11-02-26.
//

import SwiftUI

struct AccountsView: View {
    let viewModel: AccountsViewModel
    
    init() {
        self.viewModel = AccountsViewModel()
    }
    
    init (mockAccounts: [Account]) {
        self.viewModel = AccountsViewModel(mockAccounts: mockAccounts)
    }
    
    var body: some View {
        ZStack {
            switch viewModel.currentState {
            case .loading:
                ProgressView()
            case .error:
                Text("Error")
            case .loaded:
                Color.background.ignoresSafeArea(edges: .all)
                VStack {
                    Text("Accounts").font(Font.largeTitle.bold())
                    ScrollView {
                        VStack {
                            ForEach(Array(viewModel.banks.keys).sorted(), id: \.self) { bankName in
                                BankCard(name: bankName, accounts: viewModel.banks[bankName] ?? [])
                            }
                            Spacer()
                        }
                    }
                }
            }
        }.task {
            do {
                if viewModel.banks.isEmpty {
                    try await viewModel.initialize()
                }
            }catch {
                viewModel.currentState = .error
            }
        }
    }
}

#Preview {
    AccountsView(mockAccounts: Account.mockArray)
}
