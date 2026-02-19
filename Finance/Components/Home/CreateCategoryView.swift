//
//  CreateCategoryView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 17-02-26.
//

import SwiftUI

struct CreateCategoryView: View {
    
    @State var name: String = ""
    @State var color: ColorType = .white
    @State var icon: String = "dollarsign"
    
    let onConfirm: (String, ColorType, String) -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 25))
                    }.frame(width: 50, height: 50, alignment: .center)
                        .glassEffect(.regular.interactive())
                    
                    Spacer()
                    Text("New Category")
                        .font(.title2.bold())
                    Spacer()
                    
                    Button {
                        onConfirm(name, color, icon)
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.system(size: 25))
                    }.frame(width: 50, height: 50)
                        .glassEffect(.regular.interactive())
                        .disabled(name.isEmpty)
                }
                HStack(spacing: 25){
                    CategoryIcon(category: Category(id: 0, name: name, color: color, icon: icon))
                    if !name.isEmpty {
                        Text(name).font(Font.title.bold())
                    }
                }.padding(25)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(style: .init(lineWidth: 1, dash: [9])))
                
                VStack(alignment: .leading) {
                    Text("Category Name").padding(.leading, 5)
                    TextField("Name", text: $name)
                        .padding()
                        .background(Color.primary.opacity(0.04))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                }
                
                VStack(alignment: .leading) {
                    Text("Category Color").padding(.leading, 5)
                    ColorPicker(selectedColor: $color)
                }
                
                VStack(alignment: .leading) {
                    Text("Category Icon").padding(.leading, 5)
                    IconPicker(selectedIcon: $icon, color: color)
                }
                
                
            }.padding()
        }
    }
}


#Preview {
    CreateCategoryView(onConfirm: {color, name, icon in}, onDismiss: {})
}
