//
//  AccountCard.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 10-02-26.
//

import SwiftUI

struct AccountCard: View {
    let account: Account
    let selectedAccount: Int
    
    init(account: Account, selectedAccount: Int){
        self.selectedAccount = selectedAccount
        self.account = account
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                AccountIcon(accountType: account.accountType)
                Spacer()
                Text(account.name)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundStyle(Color.primary)
            }
        }
        .padding(13)
        .frame(width: 150, height: 100, alignment: .leading)
        .background(selectedAccount == account.id ? Color.blue.opacity(0.4) : Color.clear, in: .rect(cornerRadius: 15))
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 15))
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor").ignoresSafeArea()
        HStack(spacing: 5) {
            AccountCard(account: .mockArray[0], selectedAccount: 1)
            AccountCard(account: .mockArray[1], selectedAccount: 1)
        }
    }
}
