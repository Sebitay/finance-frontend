//
//  CategorySheetView.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 18-02-26.
//
import SwiftUI

struct CategorySheetView: View {
    let categoryViewModel: HomeCategoryViewModel
    let applyCategory: (Int, Category) -> Void
    let createCategory: (String, ColorType, String, Transaction?) -> Void
    @Binding var sheetDetent: PresentationDetent
    @Binding var selectedTransaction: Transaction?
    
    var body: some View {
        ZStack(alignment: .top) {
            if sheetDetent == .large || categoryViewModel.categories.isEmpty {
                CreateCategoryView(
                    onConfirm: { name, color, icon in
                        createCategory(name, color, icon, selectedTransaction)
                    }, onDismiss: {
                        withAnimation(.smooth) {
                            if categoryViewModel.categories.isEmpty {
                                self.selectedTransaction = nil
                            } else {
                                self.sheetDetent = .medium
                            }
                        }
                    })
                .ignoresSafeArea()
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(.easeIn(duration: 0.2)),
                        removal: .opacity.animation(.easeOut(duration: 0.2))
                    )
                )
                .zIndex(2)
            }
            else {
                CategorySelect(
                    transaction: selectedTransaction,
                    categoryViewModel: categoryViewModel,
                    onApply: applyCategory,
                    onNewTap: {
                        withAnimation(.smooth) {
                            self.sheetDetent = .large
                        }
                    }
                )
                .padding()
                .transition(
                    .asymmetric(
                        insertion: .opacity.animation(.easeIn(duration: 0.2)),
                        removal: .opacity.animation(.easeOut(duration: 0.2))
                    )
                )
                .zIndex(1)
            }
        }
        .animation(.smooth, value: sheetDetent)
        .presentationDetents(categoryViewModel.categories.isEmpty ? [.large] : [.medium, .large], selection: $sheetDetent)
        .interactiveDismissDisabled(!categoryViewModel.categories.isEmpty && sheetDetent == .large)
    }
}
