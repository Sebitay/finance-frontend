//
//  Filters.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 12-02-26.
//

import SwiftUI

struct TransactionFilters: View {

    let categories: [Category]
    let accounts: [Account]
    let applyFilters: () -> Void
    @Binding var filterFields: FilterFields


    init(categories: [Category], accounts: [Account], applyFilters: @escaping () -> Void, filterFields: Binding<FilterFields>){
        self._filterFields = filterFields

        var allCategories = categories

        allCategories.insert(Category(id: 0, name: "All Categories", color: .white, icon: ""), at: 0)

        self.categories = allCategories
        self.accounts = accounts
        self.applyFilters = applyFilters
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack{
                Group {
                    VStack(spacing: 0) {
                        ZStack {
                            Text("Filters").font(Font.title.bold())
                            
                            HStack{
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 25))
                                    .foregroundStyle(Color.primary)
                                    .frame(width: 50, height: 50)
                                    .glassEffect(.clear.interactive())
                                    .onTapGesture {
                                        dismiss()
                                    }
                                Spacer()
                                Text("Clear").font(Font.custom("system", size: 18))
                                    .padding(15)
                                    .frame(height: 50)
                                    .glassEffect(.clear.interactive())
                                    .onTapGesture {
                                        filterFields.resetFilterFields()
                                    }
                            }
                        }
                        Form {
                            Section {
                                Picker("Category", selection: $filterFields.categoryId){
                                    ForEach(categories) {category in
                                        Text(category.name).tag(category.id)
                                    }
                                }
                                Picker("Account", selection: $filterFields.accountId){
                                    ForEach(accounts) {account in
                                        Text(account.name).tag(account.id)
                                    }
                                }
                            }.listRowBackground(Color(.tertiarySystemFill))
                            
                            Section("Date") {
                                DateRangePicker(text: "From", dateField: $filterFields.startDate)
                                DateRangePicker(text: "To", dateField: $filterFields.endDate)
                            }.listRowBackground(Color(.tertiarySystemFill))
                            Section("Amount") {
                                HStack{
                                    Text("Min")
                                    Spacer()
                                    DecimalInput(title: "0", text: $filterFields.minAmount)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 12)
                                        .background(Color(uiColor: .tertiarySystemFill))
                                        .clipShape(Capsule())
                                        .frame(width: 150)
                                }
                                HStack{
                                    Text("Max")
                                    Spacer()
                                    DecimalInput(title: "0", text: $filterFields.maxAmount)
                                        .padding(.vertical, 7)
                                        .padding(.horizontal, 12)
                                        .background(Color(uiColor: .tertiarySystemFill))
                                        .clipShape(Capsule())
                                        .frame(width: 150)
                                }
                            }.listRowBackground(Color(.tertiarySystemFill))
                            Section {
                                Button(action: {
                                    applyFilters()
                                    dismiss()
                                }) {
                                    Text("Apply Filters")
                                        .font(.headline)
                                        .foregroundStyle(.white) // Letras Blancas
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 15)
                                        .background(Color.blue)
                                        .clipShape(Capsule())
                                        
                                }
                                .glassEffect(.regular.interactive())
                            }
                            .listRowBackground(Color.clear)
                        }.scrollContentBackground(.hidden)
                    }.padding(.horizontal)
                        .padding(.top)
                }
            }
        }
    }
}


#Preview {
    struct PreviewContainer: View {
        @State var filterFields = FilterFields()
        var body: some View {
            ZStack {
                TransactionFilters(categories: Category.mockArray, accounts: Account.mockArray,applyFilters: {} ,filterFields: $filterFields)
            }
        }
    }
    return PreviewContainer()
}

