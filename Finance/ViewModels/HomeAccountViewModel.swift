//
//  HomeAccountViewModel.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 12-02-26.
//
import Foundation

@Observable
class HomeAccountViewModel {
    enum State {
        case loading
        case loaded
        case error
    }
    
    var currentState: State = .loading

    var selectedAccount: Int = 0
    var accounts: [Account] = []
    var mock: Bool = false
    
    let apiService = ApiService()
    var decoder = JSONDecoder()
    
    init(){}
    
    init(mockAccounts: [Account]) {
        self.accounts = mockAccounts
        let mainWallet: Account = Account(
            id: 0,
            name: "Main Wallet",
            accountNumber: "0-000-00-0000",
            accountType: .main,
            currency: "CLP",
            balance: getTotalBalance(),
            userId: 1,
            bank: Bank(id: 0, name: "All Banks"),
            cards: []
        )
    
        self.accounts.insert(mainWallet, at:0)
        self.mock = true
        self.currentState = .loaded
    }
    
    func initialize() async throws{
        if mock {return}
        self.currentState = .loading
        self.decoder = initDecoder()
        
        do {
            self.accounts = try await fetchAccounts()
            
            let mainWallet: Account = Account(
                id: 0,
                name: "Main Wallet",
                accountNumber: "0-000-00-0000",
                accountType: .main,
                currency: "CLP",
                balance: getTotalBalance(),
                userId: accounts.first!.userId,
                bank: Bank(id: 0, name: "All Banks"),
                cards: []
            )
   
            self.accounts.insert(mainWallet, at: 0)
        
            self.currentState = .loaded
        } catch {
            self.currentState = .error
            throw error
        }
    }
    
    func refresh() async throws{
        try await Task {
            self.decoder = initDecoder()
            do {
                self.accounts = try await fetchAccounts()
                
                let mainWallet: Account = Account(
                    id: 0,
                    name: "Main Wallet",
                    accountNumber: "0-000-00-0000",
                    accountType: .main,
                    currency: "CLP",
                    balance: getTotalBalance(),
                    userId: accounts.first!.userId,
                    bank: Bank(id: 0, name: "All Banks"),
                    cards: []
                )
                
                self.accounts.insert(mainWallet, at: 0)
                
                self.currentState = .loaded
            } catch {
                self.currentState = .error
                throw error
            }
        }.value
    }
    
    func fetchAccounts() async throws -> [Account]{
        let data = try await apiService.FetchRequest(path: "/account", method: "GET")
        
        do {
            return try self.decoder.decode([Account].self, from: data)
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
    
    func getTotalBalance() -> Double {
        var balance: Double = 0.0
        
        for account in self.accounts {
            balance += account.balance
        }
        
        return balance
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
