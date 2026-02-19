//
//  BankCard.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 18-02-26.
//
import SwiftUI

struct BankCard: View {
    let name: String
    let accounts: [Account]
    @State var isOpen: Bool = false
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(name)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    Text("\(accounts.count) Account\(accounts.count == 1 ? "" : "s")" ).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isOpen ? 180 : 0))
                    .foregroundStyle(.gray)
                    .animation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.2), value: isOpen)
            }.padding()
            .animation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.2), value: isOpen)
            .onTapGesture {
                withAnimation(.snappy) {
                    isOpen.toggle()
                }
            }
            
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(accounts) { account in
                        AccountCard(account: account)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 15))
        .animation(.spring(response: 0.35, dampingFraction: 0.85, blendDuration: 0.2), value: isOpen)
        .padding()
    }
}

#Preview {
    ZStack{
        Color.background.ignoresSafeArea()
        VStack {
            BankCard(name: "Banco Santander", accounts: Account.mockArray)
            Spacer()
        }
    }
}
