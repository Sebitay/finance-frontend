//
//  CardCard.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 18-02-26.
//
import SwiftUI

struct CardCard: View {
    let card: Card
    
    func cardType() -> String {
        switch (self.card.cardType) {
        case .debit: return "Debit"
        case .credit: return "Credit"
        case .prepaid: return "Prepaid"
        }
    }
    
    func cardColor() -> Color {
        switch (self.card.cardType) {
        case .debit: return Color.accentColor
        case .credit: return Color.black
        case .prepaid: return Color.gray
        }
    }
    
    func cardDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.string(from: self.card.expirationDate)
    }
    
    var body: some View {
        VStack(spacing: 0){
            Rectangle().frame(height: 1).foregroundColor(Color.secondary).padding(.horizontal)
            HStack(spacing: 20) {
                Image(systemName: "creditcard.fill")
                    .symbolColorRenderingMode(.gradient)
                    .foregroundColor(cardColor())
                    .font(.system(size: 30))
                
                VStack(alignment: .leading) {
                    Text(self.card.name)
                    Text("•••• \(self.card.cardNumber)").font(Font.caption).foregroundStyle(Color.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text(cardDate())
                    Text(cardType()).font(Font.caption).foregroundStyle(Color.secondary)
                    
                }
            }.padding()
                .padding(.horizontal)
        }
    }
}

#Preview {
    ZStack {
        Color.background.ignoresSafeArea()
        CardCard(card: Card.mockArray[0])
    }
}
