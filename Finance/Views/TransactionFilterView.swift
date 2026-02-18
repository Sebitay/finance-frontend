//
//  TransactionView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 10-02-26.
//
import SwiftUI

struct TransactionFilterView: View {

    let accounts: [Account]
    let transactionViewModel: TransactionFilterViewModel
    let categoryViewModel: HomeCategoryViewModel
    @State private var searchText: String = ""
    @State private var showFilters: Bool = false
    @State private var loadingError: Error?
    @State var selectedTransaction: Transaction? = nil
    @State var sheetDetent: PresentationDetent = .medium
    @Namespace var namespace
    @Environment(\.dismiss) private var dismiss
    
    
    private var filteredTransactions: [Transaction] {
        if searchText.isEmpty {
            return transactionViewModel.transactions
        } else {
            return transactionViewModel.transactions.filter {
                $0.description?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
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
            
            transactionViewModel.updateLocalCategory(transactionId: transaction.id, category: tempCategory)
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
                    transactionViewModel.updateLocalCategory(transactionId: transaction.id, category: oldCategory)
                }
            }
        }
    }
    
    init(accounts: [Account], categoryViewModel: HomeCategoryViewModel) {
        self.transactionViewModel = TransactionFilterViewModel()
        self.categoryViewModel = categoryViewModel
        self.accounts = accounts
    }
    
    init(transactionViewModel: TransactionFilterViewModel, categoryViewModel: HomeCategoryViewModel, mockAccounts: [Account]) {
        self.transactionViewModel = transactionViewModel
        self.categoryViewModel = categoryViewModel
        self.accounts = mockAccounts
    }
    
    
    var body: some View {
        ZStack{
            Color("BackgroundColor")
                .ignoresSafeArea(.all)
            
            switch transactionViewModel.currentState {
            case .loading:
                ProgressView("Loading...")
            case .error:
                Text(loadingError?.localizedDescription ?? "An error occured.")
            case .loaded:
                VStack {
                    HStack{
                        Image(systemName: "chevron.left")
                            .font(.system(size: 25))
                            .foregroundStyle(Color.primary)
                            .frame(width: 50, height: 50)
                            .glassEffect(.clear.interactive())
                            .onTapGesture {
                                dismiss()
                            }
                        
                        Spacer()
                        
                        Text("Movements").font(Font.title.bold())
                        
                        Spacer()
                        Image(systemName: "switch.2")
                            .font(.system(size: 25))
                            .foregroundStyle(Color.primary)
                            .frame(width: 50, height: 50)
                            .glassEffect(.clear.interactive())
                            .onTapGesture {
                                showFilters.toggle()
                            }
                    }
                    ZStack {
                        ScrollView(.vertical, showsIndicators: false){
                            VStack(spacing: 20){
                                ForEach(filteredTransactions){transaction in
                                    TransactionRow(
                                        transaction: transaction,
                                        onIconTap: {
                                            self.sheetDetent = categoryViewModel.categories.isEmpty ? .large : .medium
                                            self.selectedTransaction = transaction
                                        }
                                    )
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.bottom, 85)
                            .padding(.horizontal, 10)
                            .padding(.top, 60)
                            .animation(.default, value: searchText)
                        }.refreshable {
                            do {
                                try await transactionViewModel.refresh()
                            } catch is CancellationError {
                                print("Refresh cancelado (normal)")
                            } catch {
                                self.loadingError = error
                            }
                        }
                        VStack {
                            Rectangle()
                                .frame(height: 90)
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
                        VStack(spacing: 15) {
                            TextField("Search", text: $searchText)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .glassEffect(.regular.interactive())
                            Spacer()
                        }
                    }
                    Spacer()
                }.padding(.horizontal)
                .ignoresSafeArea(edges: .bottom)
                .sheet(isPresented: $showFilters) {
                    TransactionFilters(
                        categories: transactionViewModel.categories,
                        accounts: accounts,
                        applyFilters: {
                            Task { @MainActor in
                                do {
                                    try await transactionViewModel.fetchTransactions()
                                } catch {
                                    loadingError = error
                                }
                            }
                        },
                        filterFields: Binding(get: { transactionViewModel.filterFields }, set: { transactionViewModel.filterFields = $0 })
                    )
                }.sheet(item: $selectedTransaction) { transaction in
                    CategorySheetView(
                        categoryViewModel: categoryViewModel,
                        applyCategory: applyCategory,
                        createCategory: createCategory,
                        sheetDetent: $sheetDetent,
                        selectedTransaction: $selectedTransaction
                    )
                }
            }
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            do {
                if transactionViewModel.transactions.isEmpty {
                    try await transactionViewModel.initialize()
                }
            } catch {
                loadingError = error
            }
        }
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor").ignoresSafeArea()
        TransactionFilterView(transactionViewModel: TransactionFilterViewModel(mockTransactions: Transaction.mockArray), categoryViewModel: HomeCategoryViewModel(mockCategories: Category.mockArray), mockAccounts: Account.mockArray)
    }
}

