//
//  Finance.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 09-02-26.
//
import Foundation

enum AccountType: String, Codable {
    case checking = "checking"
    case savings = "savings"
    case credit = "credit"
    case vista = "vista"
    case main = "main"
}

enum ColorType: String, Codable, CaseIterable {
    case white = "white"
    case blue = "blue"
    case purple = "purple"
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
}

enum CardType: String, Codable, CaseIterable {
    case credit = "credit"
    case debit = "debit"
    case prepaid = "prepaid"
}

struct Bank: Codable, Identifiable {
    var id: Int
    var name: String
}

struct Card: Codable, Identifiable {
    var id: Int
    var name: String
    var cardNumber: String
    var cardType: CardType
    var expirationDate: Date
    var accountId: Int
}

struct Account: Codable, Identifiable {
    var id: Int
    var name: String
    var accountNumber: String
    var accountType: AccountType
    var currency: String
    var balance: Double
    var userId: Int
    var bank: Bank
    var cards: [Card]
}

struct Category: Codable, Identifiable {
    var id: Int
    var name: String
    var color: ColorType
    var icon: String
}

struct Transaction: Codable, Identifiable {
    var id: Int
    var amount: Double
    var code: String
    var timestamp: Date
    var description: String?
    var accountId: Int
    var category: Category?
    var card: Card?
}

class TransactionFilter: Codable {
    var id: Int?
    var code: String?
    var startDate: Date?
    var endDate: Date?
    var categoryId: Int?
    var accountId: Int?
    var description: String?
    var cardId: Int?
    var bankId: Int?
    var minAmount: Double?
    var maxAmount: Double?
    var limit: Int?
    
    init () {
        self.id = nil
        self.code = nil
        self.startDate = nil
        self.endDate = nil
        self.categoryId = nil
        self.accountId = nil
        self.description = nil
        self.cardId = nil
        self.bankId = nil
        self.minAmount = nil
        self.maxAmount = nil
        self.limit = nil
    }
    
    func getQueryItems() -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        func addQuery(name: String, value: Any?) {
            if let value = value {
                queryItems.append(URLQueryItem(name: name, value: "\(value)"))
            }
        }

        addQuery(name: "id", value: self.id)
        addQuery(name: "code", value: self.code)
        addQuery(name: "category_id", value: self.categoryId)
        addQuery(name: "account_id", value: self.accountId == 0 ? nil : self.accountId)
        addQuery(name: "description", value: self.description)
        addQuery(name: "card_id", value: self.cardId)
        addQuery(name: "bank_id", value: self.bankId)
        addQuery(name: "min_amount", value: self.minAmount)
        addQuery(name: "max_amount", value: self.maxAmount)
        addQuery(name: "limit", value: self.limit)
        
        if let start = self.startDate {
            queryItems.append(URLQueryItem(name: "start_date", value: dateFormatter.string(from: start)))
        }
        
        if let end = self.endDate {
            queryItems.append(URLQueryItem(name: "end_date", value: dateFormatter.string(from: end)))
        }
        
        return queryItems
    }
}

struct BalanceHistory: Codable, Identifiable {
    var id: Int
    var accountId: Int
    var balance: Double
    var date: Date
}
