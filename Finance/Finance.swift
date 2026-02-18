//
//  Finance.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 08-02-26.
//

import SwiftUI

@main
struct FinanceApp: App {
    init() {
        UICollectionView.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

enum APIConfig {
    static var baseURL: URL {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BackendUrl") as? String,
              let url = URL(string: urlString) else {
            fatalError("BackendUrl no configurado en Info.plist")
        }
        return url
    }
}
