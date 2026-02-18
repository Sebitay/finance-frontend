//
//  CategorySelect.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 16-02-26.
//
import SwiftUI

struct CategorySelect: View {
    var transaction: Transaction?
    var categoryViewModel: HomeCategoryViewModel
    var onApply: (Int, Category) -> Void
    var onNewTap: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(.vertical){
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(categoryViewModel.categories) { category in
                            Button {
                                Task {
                                    print(transaction?.id ?? "none")
                                    if let transaction = transaction {
                                        onApply(transaction.id, category)
                                    }
                                }
                            } label: {
                                HStack(alignment: .center){
                                    CategoryIcon(category: category)
                                    Text(category.name)
                                        .font(.title2)
                                        .fixedSize()
                                }.foregroundStyle(.foreground)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding(.vertical, 5)
                                .padding(.leading, 5)
                                .padding(.trailing, 10)
                                .background(transaction?.category?.id ?? 0 == category.id ? Color.blue.opacity(0.1) : Color.blue.opacity(0))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }.padding(.bottom, 70)
                }.clipShape(.rect(cornerRadius: 25)).refreshable {
                    Task {
                        try await categoryViewModel.refresh()
                    }
                }
            }
            VStack() {
                if !categoryViewModel.categories.isEmpty {
                    Spacer()
                }
                Button {
                    onNewTap()
                } label: {
                    HStack(alignment: .center){
                        Image(systemName: "plus")
                            .font(.title2)
                            .frame(width: 30, height: 30)
                            .padding(.vertical, 10)
                        
                        Text("New")
                            .font(.title2)
                            .padding(.trailing, 8)
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.primary)
                }.glassEffect(.clear.tint(Color.primary.opacity(0.2)).interactive())
            }
        }
        .task {
            if categoryViewModel.categories.isEmpty {
                do {
                    try await categoryViewModel.initialize()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor")
        VStack {
            Spacer()
            CategorySelect(categoryViewModel: HomeCategoryViewModel(mockCategories: Category.mockArray),onApply: {a, b in}, onNewTap: {})
            Spacer()
        }
    }.ignoresSafeArea()
}
