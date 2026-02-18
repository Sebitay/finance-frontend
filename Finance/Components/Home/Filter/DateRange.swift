//
//  DateRange.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 13-02-26.
//
import SwiftUI

struct DateRangePicker: View {
    var text: String
    @Binding var dateField: Date?
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Text(text).frame(width: 100, alignment: .leading)
                Spacer()
                Group {
                    if let endDate = dateField {
                        
                        DatePicker("", selection: Binding(
                            get: { endDate },
                            set: { dateField = $0 }
                        ), displayedComponents: .date)
                        .labelsHidden()
                        .transition(.blurReplace.combined(with: .scale(0.9)))
                    } else {
                        Text("Disabled")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 12)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                            .transition(.blurReplace.combined(with: .scale(0.9)))
                    }
                }
            }
            .animation(.smooth, value: dateField != nil)
            Toggle("", isOn: Binding(
                get: { dateField != nil },
                set: { isActive in
                    withAnimation(.snappy) {
                        if !isActive {
                            dateField = nil
                        } else {
                            dateField = Date()
                        }
                    }
                }
            ))
            .labelsHidden()
            .padding(.leading, 55)
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var filterFields = FilterFields()
        var body: some View {
            Form {
                Section("Date") {
                    DateRangePicker(text: "Date", dateField: $filterFields.endDate)
                }
            }
            
        }
    }
    return PreviewContainer()
}

