//
//  CategoryViewModel.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 16-02-26.
//

import Foundation

@Observable
class HomeCategoryViewModel {
    enum State {
        case loading
        case loaded
        case error
    }
    
    var currentState: State = .loading

    var categories: [Category] = []
    var mock: Bool = false
    
    let apiService = ApiService()
    var decoder = JSONDecoder()
    
    init(){}
    
    init(mockCategories: [Category]) {
        self.categories = mockCategories
        self.mock = true
        self.currentState = .loaded
    }
    
    func initialize() async throws{
        if mock {return}
        
        self.currentState = .loading
        self.decoder = initDecoder()
        
        do {
            self.categories = try await fetchCategories()
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
                self.categories = try await fetchCategories()
                self.currentState = .loaded
            } catch {
                self.currentState = .error
                throw error
            }
        }.value
    }
    
    func fetchCategories() async throws -> [Category]{
        let data = try await apiService.FetchRequest(path: "/category", method: "GET")
        
        do {
            return try self.decoder.decode([Category].self, from: data)
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
    
    func createCategory(name: String, color: ColorType, icon: String, replace: Int?) async throws -> Category{
        let body = try JSONEncoder().encode(["name": name, "color": color.rawValue, "icon": icon])
        
        let data = try await apiService.FetchRequest(path: "/category", method: "POST", body: body)
        
        let newCategory =  try self.decoder.decode(Category.self, from: data)

        if let replace = replace {
            let idx = categories.firstIndex(where: { $0.id == replace })
            self.categories[idx!] = newCategory
        } else {
            self.categories.append(newCategory)
        }
        
        return newCategory
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
