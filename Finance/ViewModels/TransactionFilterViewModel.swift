//
//  HomeContext.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 09-02-26.
//
import Foundation

enum FieldState {
    case unmodified
    case modified
    case error
}

struct FilterFields {
    var accountId: Int = 0
    var categoryId: Int = 0
    var startDate: Date? = nil
    var endDate: Date? = nil
    var minAmount: String = ""
    var maxAmount: String = ""
    
    var minAmountEnabled: Bool = false
    var maxAmountEnabled: Bool = false
    
    mutating func resetFilterFields() {
        self.accountId = 0
        self.categoryId = 0
        self.startDate = nil
        self.endDate = nil
        self.minAmount = ""
        self.maxAmount = ""
        self.minAmountEnabled = false
        self.maxAmountEnabled = false
    }
    
    func parseLocalDouble(_ text: String) -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        return formatter.number(from: text)?.doubleValue
    }
    
    func getTransactionFilter() -> TransactionFilter {
        let filters = TransactionFilter()
        
        filters.accountId = self.accountId == 0 ? nil : self.accountId
        filters.categoryId = self.categoryId == 0 ? nil : self.categoryId
        filters.startDate = self.startDate
        filters.endDate = self.endDate
        filters.minAmount = self.minAmount == "" ? nil : parseLocalDouble(self.minAmount)
        filters.maxAmount = self.maxAmount == "" ? nil : parseLocalDouble(self.maxAmount)
        
        return filters
    }
}

@Observable
class TransactionFilterViewModel {
    enum State {
        case loading
        case loaded
        case error
    }
    
    var currentState: State = .loading
    var transactions: [Transaction] = []
    var categories: [Category] = []
    var filterFields = FilterFields()
    var mock: Bool = false
    
    let apiService = ApiService()
    var decoder = JSONDecoder()
    
    init() {}
    
    init(mockTransactions: [Transaction]) {
        self.transactions = mockTransactions
        self.mock = true
        self.currentState = .loaded
    }
    
    func initialize() async throws{
        if mock {return}
        self.currentState = .loading
        self.decoder = initDecoder()
        
        do {
            try await fetchTransactions()
            try await fetchCategories()
            self.currentState = .loaded
        } catch {
            self.currentState = .error
            throw error
        }
    }
    
    func refresh() async throws {
        try await Task {
            if mock {return}
            do {
                try await fetchTransactions()
                try await fetchCategories()
                self.currentState = .loaded
            } catch is CancellationError {
                throw CancellationError()
            } catch let error as URLError where error.code == .cancelled {
                throw CancellationError()
            } catch {
                self.currentState = .error
                throw error
            }
        }.value
    }
    
    func fetchCategories() async throws {
        let data = try await apiService.FetchRequest(path: "/category", method: "GET")
        
        do {
            self.categories = try self.decoder.decode([Category].self, from: data)
            
        } catch let decodingError as DecodingError {
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Falta la llave: \(key.stringValue). Ruta: \(context.codingPath)")
            case .typeMismatch(let type, let context):
                print("El tipo no coincide: \(type). Ruta: \(context.codingPath)")
            case .valueNotFound(let type, let context):
                print("Valor nulo donde se esperaba \(type). Ruta: \(context.codingPath)")
            case .dataCorrupted(let context):
                print("JSON corrupto. Contexto: \(context)")
            @unknown default:
                print("Error desconocido de decodificación")
            }
            throw decodingError
        } catch {
            throw error
        }
    }
    
    func fetchTransactions() async throws{
        let data = try await apiService.FetchRequest(path: "/transaction", method: "GET", queryItems: self.filterFields.getTransactionFilter().getQueryItems())

        do {
            self.transactions = try self.decoder.decode([Transaction].self, from: data)
            
        } catch let decodingError as DecodingError {
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Falta la llave: \(key.stringValue). Ruta: \(context.codingPath)")
            case .typeMismatch(let type, let context):
                print("El tipo no coincide: \(type). Ruta: \(context.codingPath)")
            case .valueNotFound(let type, let context):
                print("Valor nulo donde se esperaba \(type). Ruta: \(context.codingPath)")
            case .dataCorrupted(let context):
                print("JSON corrupto. Contexto: \(context)")
            @unknown default:
                print("Error desconocido de decodificación")
            }
            throw decodingError
        } catch {
            throw error
        }
    }
    
    func categorizeTransaction(transactionId: Int, newCategory: Category) {
            
        guard let index = transactions.firstIndex(where: { $0.id == transactionId }) else {
            return
        }
        let originalCategory = transactions[index].category
        
        updateLocalCategory(transactionId: transactionId, category: newCategory)
        
        
        Task {
            do {
                let body = try JSONEncoder().encode(["transaction_id": transactionId, "category_id": newCategory.id])
                
                _ = try await apiService.FetchRequest(path: "/transaction/categorize", method: "POST", body: body)
                
                print("Categoría actualizada en backend correctamente")
                
            } catch {
                print("Error actualizando categoría: \(error). Revertiendo cambios.")
  
                await MainActor.run {
                    self.updateLocalCategory(transactionId: transactionId, category: originalCategory)
                }
            }
        }
    }
        
    func updateLocalCategory(transactionId: Int, category: Category?) {
        if let index = transactions.firstIndex(where: { $0.id == transactionId }) {
            var modifiedTransaction = transactions[index]
            modifiedTransaction.category = category
            
            transactions[index] = modifiedTransaction
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

