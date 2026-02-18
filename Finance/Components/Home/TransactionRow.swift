//
//  TransactionRow.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 10-02-26.
//

import SwiftUI

func formatAmount(_ amount: Double) -> String {
    let formattedNumber = abs(amount).formatted(.number.grouping(.automatic).precision(.fractionLength(0)))
    
    if amount < 0 {
        return "-$\(formattedNumber)"
    }
    return "$\(formattedNumber)"
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMM"
    formatter.locale = Locale(identifier: "en_US")
    
    return formatter.string(from: date)
}

struct TransactionRow: View {
    var transaction: Transaction
    var onIconTap: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            CategoryIcon(category: transaction.category)
                .onTapGesture {
                    onIconTap()
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.description ?? "")
                    .lineLimit(1)
                    .font(.system(size: 20, weight: .semibold, design: .default))
                HStack(spacing: 0) {
                    Text("\(transaction.category != nil ? transaction.category!.name : "Uncategorized") • ")
                        .lineLimit(1)
                        .foregroundStyle(Color(.gray))
                        .font(.system(size: 12, design: .default))
                        
                    Text(formatDate(transaction.timestamp))
                        .lineLimit(1)
                        .foregroundStyle(Color(.gray))
                        .font(.system(size: 12, design: .default))
                }
            }
            Spacer(minLength: 0)
            Text(formatAmount(transaction.amount))
                .foregroundStyle(transaction.amount > 0 ? .green : .primary)
                .font(.system(size: 20, weight: .semibold))
                .padding(.leading)
                
        }.frame(maxWidth: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var onIconTap: () -> Void = {}
        var body: some View {
            ZStack {
                Color("BackgroundColor").ignoresSafeArea()
                VStack(spacing: 10) {
                    ForEach(Transaction.mockArray) {transaction in
                        TransactionRow(transaction: transaction, onIconTap: onIconTap)
                    }
                }.padding(.horizontal)
                    .padding(.horizontal, 10)
            }
        }
    }
    return PreviewContainer()
}
