//
//  CustomButton.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 07-02-26.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void

    init(title: String, backgroundColor: Color = .accentColor, action: @escaping () -> Void = {}) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.action = action
    }

    var body: some View {
        Button(title) {action()}
        .buttonStyle(.borderedProminent)
        .tint(backgroundColor)
    }
}


#Preview {
    VStack(spacing: 20) {

        CustomButton(title: "Botón con Acción Personalizada") {
            print("Botón con Acción Personalizada presionado!")
        }

        CustomButton(title: "Botón Solo Título")

        CustomButton(title: "Mi Botón Verde", backgroundColor: .green)

        CustomButton(title: "Mi Botón Rojo", backgroundColor: .red) {
            print("Botón rojo presionado!")
        }

        CustomButton(title: "Botón Azul", backgroundColor: .blue) {
            print("Botón azul presionado!")
        }
    }
    .padding()
}

