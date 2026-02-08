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
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
    }
}

// Opcional: Una forma más sencilla de aplicar el modificador
// Esto crea un método de extensión en `View` que puedes usar directamente.
extension View {
    func standardInputStyle() -> some View {
        self.modifier(StandardInputStyle())
    }
}
