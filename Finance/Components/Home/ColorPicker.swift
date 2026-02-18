//
//  ColorPicker.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 17-02-26.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var selectedColor: ColorType
    
    let columns = [
        GridItem(.adaptive(minimum: 50), spacing: 15)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(ColorType.allCases, id: \.self) { colorType in
                ColorItem(color: colorType)
                    .padding(4)
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(selectedColor == colorType ? 1 : 0), lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedColor = colorType
                        }
                    }
            }
        }
        .padding()
    }
}

struct ColorItem: View {
    var color: Color
    
    init(color: ColorType) {
        switch color {
        case .blue:
            self.color = Color.blue
        case .green:
            self.color = Color.green
        case .orange:
            self.color = Color.orange
        case .purple:
            self.color = Color.purple
        case .red:
            self.color = Color.red
        case .yellow:
            self.color = Color("YellowCategoryIcon")
        case .white:
            self.color = Color.white
        }
    }
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: 50, height: 50)
            .shadow(radius: 2)
    }
}
   

#Preview {
    struct PreviewContainer: View {
        @State var selectedColor: ColorType = .white
        var body: some View {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                ColorPicker(selectedColor: $selectedColor)
            }
        }
    }
    return PreviewContainer()
}
