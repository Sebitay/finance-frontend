//
//  AccountsViewModel.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 18-02-26.
//

import Foundation

@Observable
class AccountsViewModel {
    enum State {
        case loading
        case loaded
        case error
    }
    
    var currentState: State = .loading
    var banks: [String : [Account]] = [:]
    var mock: Bool = false
    
    let apiService = ApiService()
    var decoder = JSONDecoder()
    
    init(){}
    
    init(mockAccounts: [Account]) {
        getBanks(accounts: mockAccounts)
        self.mock = true
        self.currentState = .loaded
    }
    
    func initialize() async throws{
        if mock {return}
        self.currentState = .loading
        self.decoder = initDecoder()
        
        do {
            let accounts = try await fetchAccounts()
            getBanks(accounts: accounts)
            self.currentState = .loaded
        } catch {
            self.currentState = .error
            throw error
        }
    }
    
    func refresh() async throws{
        if mock {return}
        try await Task {
            self.decoder = initDecoder()
            do {
                let accounts = try await fetchAccounts()
                getBanks(accounts: accounts)
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
    
    func getBanks(accounts: [Account]) {
        for account in accounts {
            self.banks[account.bank.name, default: []].append(account)
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
