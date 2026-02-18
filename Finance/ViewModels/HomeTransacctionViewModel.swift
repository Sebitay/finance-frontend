//
//  HomeTransactionViewModel.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 12-02-26.
//
import Foundation

@Observable
class HomeTransactionViewModel {
    enum State {
        case loading
        case loaded
        case error
    }
    
    var currentState: State = .loading
    var transactions: [Int: [Transaction]] = [:]
    var mock: Bool = false
    
    let apiService = ApiService()
    var decoder = JSONDecoder()
    
    init(){}
    
    init(mockTransactions: [Transaction]) {
        self.processTransactions(mockTransactions)
        self.mock = true
        self.currentState = .loaded
    }
    
    func initialize() async throws{
        if mock {return}
        self.currentState = .loading
        self.decoder = initDecoder()
        
        do {
            try await fetchTransactions()
            self.currentState = .loaded
        } catch {
            self.currentState = .error
            throw error
        }
    }
    
    func refresh() async throws {
        try await Task {
            self.decoder = initDecoder()
            do {
                try await fetchTransactions()
            } catch is CancellationError {
                print("Refresh cancelado por el sistema/usuario.")
            } catch let error as URLError where error.code == .cancelled {
                print("Petición de red cancelada.")
            } catch {
                print("Error real: \(error.localizedDescription)")
                self.currentState = .error
                throw error
            }
        }.value
    }
    
    func fetchTransactions() async throws {
        let queryItems = [
            URLQueryItem(name: "limit", value: "20"),
        ]
        
        let data = try await apiService.FetchRequest(path: "/transaction", method: "GET", queryItems: queryItems)
        
        do {
            let fetchedTransactions = try self.decoder.decode([Transaction].self, from: data)
            self.transactions = [:]
            self.processTransactions(fetchedTransactions)
            
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
            throw decodingError
        } catch {
            throw error
        }
    }
    
    private func processTransactions(_ list: [Transaction]) {
        transactions[0] = list
        for transaction in list {
            self.transactions[transaction.accountId, default: []].append(transaction)
        }
    }
    

    
    func categorizeTransaction(transactionId: Int, newCategory: Category) {

        guard let index = transactions[0]?.firstIndex(where: { $0.id == transactionId }),
              let transaction = transactions[0]?[index] else {
            return
        }
        
        let originalCategory = transaction.category
        let accountId = transaction.accountId
        
        updateLocalCategory(transactionId: transactionId, category: newCategory, accountId: accountId)
        
        Task {
            do {
                let body = try JSONEncoder().encode(["transaction_id": transactionId, "category_id": newCategory.id])
                _ = try await apiService.FetchRequest(path: "/transaction/categorize", method: "POST", body: body)
                
                print("Categoría actualizada en backend correctamente")
                
            } catch {
                print("Error actualizando categoría: \(error). Revertiendo cambios.")
                
                await MainActor.run {
                    self.updateLocalCategory(transactionId: transactionId, category: originalCategory, accountId: accountId)
                }
            }
        }
    }
    
    func updateLocalCategory(transactionId: Int, category: Category?, accountId: Int) {
        if let idx = transactions[0]?.firstIndex(where: { $0.id == transactionId }) {
            var modifiedTransaction = transactions[0]![idx]
            modifiedTransaction.category = category
            transactions[0]![idx] = modifiedTransaction
        }
        
        // 2. Actualizar en lista específica de la cuenta
        if let idx = transactions[accountId]?.firstIndex(where: { $0.id == transactionId }) {
            var modifiedTransaction = transactions[accountId]![idx]
            modifiedTransaction.category = category
            transactions[accountId]![idx] = modifiedTransaction
        }
    }
    
    func initDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
