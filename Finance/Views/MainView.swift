//
//  MainView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 08-02-26.
//
import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                Rectangle()
                    .frame(height: 85)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color("BackgroundColor").opacity(0),
                                Color("BackgroundColor")
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                AccountsView()
                    .tabItem {
                        Label("Accounts", systemImage: "creditcard.fill")
                    }
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
        }
        .ignoresSafeArea(edges: .all)
            
        
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor").ignoresSafeArea(edges: .all)
        MainView()
    }
}
