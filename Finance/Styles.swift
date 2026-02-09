//
//  Styles.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 07-02-26.
//

import SwiftUI

struct StandardInputStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.3))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
            
    }
}

extension View {
    func standardInputStyle() -> some View {
        self.modifier(StandardInputStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundStyle(.white)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .cornerRadius(12)
            .padding(.horizontal)
            
        }
}
