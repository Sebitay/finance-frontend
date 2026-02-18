//
//  CategoryIcon.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 10-02-26.
//

import SwiftUI

struct CategoryIcon: View {
    var size: CGFloat
    var icon: String
    let iconColor: Color
    let backgroundColor: Color
    
    init() {
        self.icon = "dollarsign"
        self.size = 50
        self.iconColor = Color.white
        self.backgroundColor = Color("WhiteCategoryBackground")
    }
    
    init(icon: String, color: ColorType, size: CGFloat) {
        self.icon = icon
        self.size = size
        switch color {
        case .white:
            self.iconColor = Color.white
            self.backgroundColor = Color("WhiteCategoryBackground")
        case .blue:
            self.iconColor = Color.blue
            self.backgroundColor = Color("BlueCategoryBackground")
        case .green:
            self.iconColor = Color.green
            self.backgroundColor = Color("GreenCategoryBackground")
        case .yellow:
            self.iconColor = Color("YellowCategoryIcon")
            self.backgroundColor = Color("YellowCategoryBackground")
        case .orange:
            self.iconColor = Color.orange
            self.backgroundColor = Color("OrangeCategoryBackground")
        case .red:
            self.iconColor = Color.red
            self.backgroundColor = Color("RedCategoryBackground")
        case .purple:
            self.iconColor = Color.purple
            self.backgroundColor = Color("PurpleCategoryBackground")
        }
    }
    
    init(category: Category?, size: CGFloat = 50){
        if let category = category {
            self.icon = category.icon
            switch category.color {
            case .white:
                self.iconColor = Color.white
                self.backgroundColor = Color("WhiteCategoryBackground")
            case .blue:
                self.iconColor = Color.blue
                self.backgroundColor = Color("BlueCategoryBackground")
            case .green:
                self.iconColor = Color.green
                self.backgroundColor = Color("GreenCategoryBackground")
            case .yellow:
                self.iconColor = Color("YellowCategoryIcon")
                self.backgroundColor = Color("YellowCategoryBackground")
            case .orange:
                self.iconColor = Color.orange
                self.backgroundColor = Color("OrangeCategoryBackground")
            case .red:
                self.iconColor = Color.red
                self.backgroundColor = Color("RedCategoryBackground")
            case .purple:
                self.iconColor = Color.purple
                self.backgroundColor = Color("PurpleCategoryBackground")
            }
        } else {
            self.icon = "dollarsign"
            self.iconColor = Color.white
            self.backgroundColor = Color("WhiteCategoryBackground")
        }
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
                .foregroundColor(backgroundColor)
            Image(systemName: icon)
                .imageScale(.large)
                .foregroundStyle(iconColor)
        }
        
    }
}

#Preview {
    ZStack {
        Color("BackgroundColor").ignoresSafeArea()
        HStack{
            ForEach(Category.mockArray) { category in
                HStack {
                    CategoryIcon(category: category)
                }
            }
        }
    }
}
