//
//  HomeView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 09-02-26.
//

import SwiftUI

struct HomeView: View {
    let accountViewModel: HomeAccountViewModel
    let transactionViewModel: HomeTransactionViewModel
    let categoryViewModel: HomeCategoryViewModel
    
    @State private var sheetDetent: PresentationDetent = .medium
    @State private var selectedTransaction: Transaction? = nil
    @State private var loadingError: Error?
    
    init() {
        self.accountViewModel = HomeAccountViewModel()
        self.transactionViewModel = HomeTransactionViewModel()
        self.categoryViewModel = HomeCategoryViewModel()
    }
    
    init (accountViewModel: HomeAccountViewModel, transactionViewModel: HomeTransactionViewModel, categoryViewModel: HomeCategoryViewModel) {
        self.accountViewModel = accountViewModel
        self.transactionViewModel = transactionViewModel
        self.categoryViewModel = categoryViewModel
    }
    
    func applyCategory(transactionId: Int, category: Category) {
        self.selectedTransaction = nil
        Task {
            transactionViewModel.categorizeTransaction(transactionId: transactionId, newCategory: category)
        }
    }
    
    func createCategory(name: String, color: ColorType, icon: String, transaction: Transaction? = nil) {
        let oldCategory = transaction?.category

        
        if let transaction = transaction {
            let tempCategory = Category(id: -1, name: name, color: color, icon: icon)
            categoryViewModel.categories.append(tempCategory)
            
            transactionViewModel.updateLocalCategory(transactionId: transaction.id, category: tempCategory, accountId: transaction.accountId)
        }
        
        withAnimation(.smooth) {
            self.selectedTransaction = nil
            self.sheetDetent = .medium
        }
        Task {
            do {
                let newCategory = try await categoryViewModel.createCategory(name: name, color: color, icon: icon, replace: -1)
                if let transaction = transaction {
                    transactionViewModel.categorizeTransaction(transactionId: transaction.id, newCategory: newCategory)
                }
            } catch {
                print(error.localizedDescription)
                if let transaction = transaction {
                    transactionViewModel.updateLocalCategory(transactionId: transaction.id, category: oldCategory, accountId: transaction.accountId)
                }
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea(edges: .all)
                switch accountViewModel.currentState {
                case .loading:
                    ProgressView("Loading...")
                    
                case .error:
                    Text(loadingError?.localizedDescription ?? "An error occurred")
                    
                case .loaded:
                    VStack(spacing: 0) {
                        VStack(spacing: 5) {
                            Text("Total Balance")
                                .foregroundStyle(Color.gray)
                            Text(accountViewModel.accounts[accountViewModel.selectedAccount].balance, format: .currency(code: "CLP").precision(.fractionLength(0)))
                                .font(.system(size: 50))
                                .bold()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(accountViewModel.accounts) { account in
                                    HomeAccountCard(
                                        account: account,
                                        selectedAccount: accountViewModel.selectedAccount
                                    ).onTapGesture {
                                        accountViewModel.selectedAccount = account.id
                                    }
                                }
                            }.padding()
                        }.scrollClipDisabled(true)
                        
                        
                        HStack {
                            Text("Recent Movements")
                                .font(.system(size: 20))
                            Spacer()
                            NavigationLink {
                                TransactionFilterView(
                                    accounts: accountViewModel.accounts,
                                    categoryViewModel: categoryViewModel,
                                )
                            } label: {
                                Text("See all")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }.padding(.horizontal).padding(.vertical, 10)
                        
                        ZStack {
                            ScrollView{
                                VStack(spacing: 20){
                                    ForEach(transactionViewModel.transactions[accountViewModel.selectedAccount] ?? []) {transaction in
                                        TransactionRow(
                                            transaction: transaction,
                                            onIconTap: {
                                                self.sheetDetent = categoryViewModel.categories.isEmpty ? .large : .medium
                                                self.selectedTransaction = transaction
                                            }
                                        )
                                    }
                                }.padding(.horizontal)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(.bottom, 95)
                                    .padding(.horizontal, 10)
                                    .padding(.top, 20)
                                    
                            }.refreshable {
                                do {
                                    try await accountViewModel.refresh()
                                    try await transactionViewModel.refresh()
                                } catch {
                                    loadingError = error
                                }
                            }
                            VStack {
                                Rectangle()
                                    .frame(height: 20)
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color("BackgroundColor").opacity(0),
                                                Color("BackgroundColor")
                                            ],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                Spacer()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 80)
                    .sheet(item: $selectedTransaction) { transaction in
                        CategorySheetView(
                            categoryViewModel: categoryViewModel,
                            applyCategory: applyCategory,
                            createCategory: createCategory,
                            sheetDetent: $sheetDetent,
                            selectedTransaction: $selectedTransaction
                        )
                    }
                }
            }.task {
                do {
                    if accountViewModel.accounts.isEmpty {
                        try await accountViewModel.initialize()
                    }
                    if transactionViewModel.transactions.isEmpty {
                        try await transactionViewModel.initialize()
                    }
                    if categoryViewModel.categories.isEmpty {
                        try await categoryViewModel.initialize()
                    }
                } catch {
                    loadingError = error
                }
                
            }.ignoresSafeArea(.all)
        }.toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor").ignoresSafeArea(edges: .all)
        HomeView(accountViewModel: HomeAccountViewModel(mockAccounts: Account.mockArray), transactionViewModel: HomeTransactionViewModel(mockTransactions: Transaction.mockArray), categoryViewModel: HomeCategoryViewModel(mockCategories: Category.mockArray))
    }.ignoresSafeArea(edges: .all)
}

