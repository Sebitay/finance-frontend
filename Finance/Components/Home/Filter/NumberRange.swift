//
//  NumberRange.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 14-02-26.
//
import SwiftUI



struct NumberRangePicker: View {
    var text: String
    @Binding var numberField: String
    @Binding var enabled: Bool
    @FocusState var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Text(text).frame(width: 100, alignment: .leading)
                Spacer()
                Group {
                    if enabled {
                        DecimalInput(title: "0", text: $numberField)
                            .padding(.vertical, 7)
                            .padding(.horizontal, 12)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                            .padding(.leading, 30)
                            
                    } else {
                        Text("Disabled")
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                    }
                }
            }
            .animation(.snappy, value: enabled)
            Toggle("", isOn: Binding(
                get: {self.enabled},
                set: { newValue in
                    if newValue {
                        self.numberField = ""
                    }
                    self.enabled = newValue
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
        @State var number: String = ""
        @State var enabled: Bool = false
        var body: some View {
            Form {
                Section("Amount") {
                    NumberRangePicker(text: "From", numberField: $number, enabled: $enabled )
                }
            }
            
        }
    }
    return PreviewContainer()
}

