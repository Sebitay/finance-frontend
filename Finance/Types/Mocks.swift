//
//  Mocks.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 10-02-26.
//
import Foundation

extension Account {
    static let mockArray = [
        Account(
            id: 1,
            name: "Cuenta Corriente",
            accountNumber: "0-000-97-56068-4",
            accountType: .checking,
            currency: "CLP",
            balance: 143740.0,
            userId: 1,
            bank: Bank(id: 1, name: "Banco Santander"),
            cards: []
        ),
        Account(
            id: 2,
            name: "Ahorro",
            accountNumber: "1-234-56-78901-2",
            accountType: .savings,
            currency: "CLP",
            balance: 500200.0,
            userId: 1,
            bank: Bank(id: 2, name: "Banco de Chile"),
            cards: []
        )
    ]
}

extension Transaction {
    static let mockArray: [Transaction] = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        func date(_ s: String) -> Date {
            formatter.date(from: s) ?? Date()
        }

        return [
            Transaction(id: 763, amount: 5500.0, code: "6029803", timestamp: date("2026-01-30T00:00:00"), description: "MERPAGO*LITTLECAESARS", accountId: 1, category: Category.mockArray[0], card: nil),
            Transaction(id: 762, amount: -6312.0, code: "6029799", timestamp: date("2026-01-30T00:00:00"), description: "Compra Nacional C. VERDE C. COLON 6071", accountId: 2, category: Category.mockArray[1], card: nil),
            Transaction(id: 761, amount: -3180.0, code: "6028796", timestamp: date("2026-01-29T00:00:00"), description: "Compra Nacional COLON 2", accountId: 1, category: Category.mockArray[2], card: nil),
            Transaction(id: 758, amount: 21700.0, code: "6028151", timestamp: date("2026-01-28T00:00:00"), description: "Compra Nacional GOOGLE PLAY YOUTUBE GOOGL", accountId: 2, category: Category.mockArray[3], card: nil),
            Transaction(id: 757, amount: -39900.0, code: "6027652", timestamp: date("2026-01-28T00:00:00"), description: "Compra Nacional MERPAGO*MERCADOLIBRE", accountId: 2, category: Category.mockArray[4], card: nil),
            Transaction(id: 759, amount: -15000.0, code: "0000000", timestamp: date("2026-01-28T00:00:00"), description: "0760791814 Transf a PUNTO PAGOS", accountId: 1, category: Category.mockArray[5], card: nil),
            Transaction(id: 760, amount: 5963.0, code: "0000000", timestamp: date("2026-01-28T00:00:00"), description: "COM.MANTENCION PLAN", accountId: 1, category: Category.mockArray[6], card: nil),
            Transaction(id: 756, amount: -20950.0, code: "6027611", timestamp: date("2026-01-27T00:00:00"), description: "Compra Nacional MERPAGO*MERCADOLIBRE", accountId: 2, category: nil, card: nil),
            Transaction(id: 748, amount: -4970.0, code: "6025102", timestamp: date("2026-01-26T00:00:00"), description: "Compra Nacional ARAMCO", accountId: 2, category: nil, card: nil),
            Transaction(id: 747, amount: 5250.0, code: "6025715", timestamp: date("2026-01-26T00:00:00"), description: "Compra Nacional BOTILLERIA TIO PETTE", accountId: 1, category: nil, card: nil),
            Transaction(id: 745, amount: 9995.0, code: "6026160", timestamp: date("2026-01-26T00:00:00"), description: "Compra Nacional NP MERPAGO*CABIFY2605XQNO7SF", accountId: 1, category: nil, card: nil),
            Transaction(id: 746, amount: -8599.0, code: "6026274", timestamp: date("2026-01-26T00:00:00"), description: "Compra Nacional NP EPIDEMICSD", accountId: 2, category: nil, card: nil),
            Transaction(id: 755, amount: -159.0, code: "6026227", timestamp: date("2026-01-26T00:00:00"), description: "Compra Nacional CABIFY", accountId: 1, category: nil, card: nil),
            Transaction(id: 754, amount: 1270.0, code: "6025199", timestamp: date("2026-01-26T00:00:00"), description: "Compra Nacional NP MOVIRED.", accountId: 2, category: nil, card: nil)
        ]
    }()
}


extension Category {
    static let mockArray = [
        Category(id: 1, name: "1", color: .red, icon: "dollarsign"),
        Category(id: 2, name: "Category 2", color: .purple, icon: "dollarsign"),
        Category(id: 3, name: "Category 3", color: .blue, icon: "dollarsign"),
        Category(id: 4, name: "Category 4", color: .green, icon: "dollarsign"),
        Category(id: 5, name: "Category 5", color: .yellow, icon: "dollarsign"),
        Category(id: 6, name: "Category 6", color: .orange, icon: "dollarsign"),
        Category(id: 7, name: "Category 7", color: .white, icon: "dollarsign"),
    ]
}
