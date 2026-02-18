//
//  IconPicker.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 17-02-26.
//

import SwiftUI

struct IconPicker: View {
    @Binding var selectedIcon: String
    let color: ColorType
    
    let icons = [
        "dollarsign",
        "fork.knife",
        "house",
        "play.fill",
        "movieclapper",
        "dumbbell",
        "car",
        "fuelpump",
        "airplane.up.right",
        "party.popper",
    ]
    
    let columns = [
        GridItem(.adaptive(minimum: 50), spacing: 15)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(icons, id: \.self) { icon in
                CategoryIcon(icon: icon, color: color, size: 50)
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(selectedIcon == icon ? 1 : 0), lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedIcon = icon
                        }
                    }
            }
        }
        .padding()
    }
}
   

#Preview {
    struct PreviewContainer: View {
        @State var selectedIcon: String = "fork.knife"
        var body: some View {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                IconPicker(selectedIcon: $selectedIcon, color: .purple)
            }
        }
    }
    return PreviewContainer()
}
