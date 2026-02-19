//
//  AccountIcon.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 10-02-26.
//

import SwiftUI

struct AccountIcon: View {
    let accountType: AccountType
    let size: CGFloat
    
    init(accountType: AccountType) {
        self.accountType = accountType
        self.size = 22
    }
    
    init(accountType: AccountType, size: CGFloat) {
        self.accountType = accountType
        self.size = size
    }
    
    var body: some View {
        switch accountType {
        case .checking:
            Image(systemName: "building.columns.fill")
                .font(.system(size: size))
                .foregroundColor(.blue)
        case .savings:
            Image(systemName: "leaf.fill")
                .font(.system(size: size))
                .foregroundColor(.green)
        case .credit:
            Image(systemName: "creditcard.fill")
                .font(.system(size: size))
                .foregroundColor(.purple)
        case .vista:
            Image(systemName: "person.text.rectangle.fill")
                .font(.system(size: size))
                .foregroundColor(.orange)
        case .main:
            Image(systemName: "wallet.bifold.fill")
                .font(.system(size: size))
                .foregroundColor(.yellow)
        }
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor").ignoresSafeArea()
        HStack {
            AccountIcon(accountType: .checking, size: 30)
            AccountIcon(accountType: .savings)
            AccountIcon(accountType: .credit)
            AccountIcon(accountType: .vista)
            AccountIcon(accountType: .main)
        }
    }
}
