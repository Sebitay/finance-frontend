//
//  AccountIcon.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 10-02-26.
//

import SwiftUI

struct AccountIcon: View {
    let accountType: AccountType
    var body: some View {
        switch accountType {
        case .checking:
            Image(systemName: "building.columns.fill")
                .imageScale(.large)
                .foregroundColor(.blue)
        case .savings:
            Image(systemName: "leaf.fill")
                .imageScale(.large)
                .foregroundColor(.green)
        case .credit:
            Image(systemName: "creditcard.fill")
                .imageScale(.large)
                .foregroundColor(.purple)
        case .vista:
            Image(systemName: "person.text.rectangle.fill")
                .imageScale(.large)
                .foregroundColor(.orange)
        case .main:
            Image(systemName: "wallet.bifold.fill")
                .imageScale(.large)
                .foregroundColor(.yellow)
        }
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor").ignoresSafeArea()
        HStack {
            AccountIcon(accountType: .checking)
            AccountIcon(accountType: .savings)
            AccountIcon(accountType: .credit)
            AccountIcon(accountType: .vista)
            AccountIcon(accountType: .main)
        }
    }
}
