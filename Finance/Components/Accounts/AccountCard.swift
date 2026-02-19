//
//  AccountCard.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 18-02-26.
//
import SwiftUI

struct AccountCard: View {
    let account: Account
    @State var isOpen: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle().frame(height: 1).foregroundColor(Color.secondary)
            HStack(spacing: 20) {
                AccountIcon(accountType: account.accountType, size: 30)
                VStack(alignment: .leading) {
                    Text(account.name)
                    Text(account.accountNumber).font(Font.caption).foregroundStyle(Color.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("$\(account.balance, specifier: "%.0f")")
                    Text(account.currency).font(Font.caption).foregroundStyle(Color.green)
                }
            }.padding()
            
            
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(account.cards) { card in
                        CardCard(card: card)
                    }
                }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.2), value: isOpen)
        .background(Color.primary.opacity(isOpen ? 0.03 : 0))
        .clipShape(Rectangle())
        .onTapGesture {
            withAnimation {
                isOpen.toggle()
            }
        }
    }
}

#Preview {
    ZStack{
        Color.background.ignoresSafeArea()
        AccountCard(account: Account.mockArray[0])
            .padding()
    }
}
