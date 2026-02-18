//
//  DecimalInput.swift
//  Finance
//
//  Created by Sebastian Valenzuela on 14-02-26.
//
import SwiftUI
import UIKit

struct DecimalInput: UIViewRepresentable {
    let title: String
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = title
        textField.keyboardType = .decimalPad
        textField.textAlignment = .right
        textField.delegate = context.coordinator
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
        let toolbar = UIToolbar()
        toolbar.isTranslucent = true
        
        let screenWidth = UIScreen.main.bounds.size.width
        let fillWidth = screenWidth - 128

        let rightIcon = UIImage(systemName: "keyboard.chevron.compact.down")
        let rightButton = UIBarButtonItem(image: rightIcon, style: .plain, target: context.coordinator, action:#selector(Coordinator.doneButtonTapped))
        
        let initialIconName = text.contains("-") ? "plus" : "minus"
        let centerFillView = UIView(frame: CGRect(x: 0, y: 10, width: fillWidth, height: 36))
        let centerIconView = UIImageView(image: UIImage(systemName: initialIconName))
        centerIconView.contentMode = .scaleAspectFit
        centerIconView.tintColor = .label
        centerIconView.frame = CGRect(x: fillWidth/2 - 6, y: 8, width: 20, height: 20)
        centerFillView.addSubview(centerIconView)
        
        
        let rightSeparator = UIView(frame: CGRect(x: fillWidth, y: 6, width: 1, height: 24))
        let leftSeparator = UIView(frame: CGRect(x: 0 , y: 6, width: 1, height: 24))
        leftSeparator.backgroundColor = .opaqueSeparator
        rightSeparator.backgroundColor = .opaqueSeparator
        centerFillView.addSubview(leftSeparator)
        centerFillView.addSubview(rightSeparator)
        
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.minusButtonTapped))
        centerFillView.addGestureRecognizer(tapGesture)

        let centerButton = UIBarButtonItem(customView: centerFillView)
        
        let leftIcon = UIImage(systemName: "xmark")
        let leftButton = UIBarButtonItem(image: leftIcon, style: .plain, target: context.coordinator, action:#selector(Coordinator.clearText))
    
        toolbar.items = [leftButton, centerButton, rightButton]
        
        let bottomPadding: CGFloat = 10

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 36 + bottomPadding))
        containerView.backgroundColor = .clear
        containerView.isUserInteractionEnabled = true

        toolbar.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 36)
        toolbar.autoresizingMask = .flexibleWidth
        containerView.addSubview(toolbar)
        textField.inputAccessoryView = containerView
        
        context.coordinator.textField = textField
        context.coordinator.minusImageView = centerIconView
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: DecimalInput
        weak var textField: UITextField?
        weak var minusImageView: UIImageView?
        
        init(_ parent: DecimalInput) {
            self.parent = parent
        }
        
        @objc func clearText() {
            guard let textField = self.textField else { return }
            textField.text = ""
        }
        
        @objc func doneButtonTapped() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        @objc func minusButtonTapped() {
            guard let textField = self.textField else { return }
            let currentText = textField.text ?? ""
            
            var isNowNegative = false
            
            if currentText.starts(with: "-") {
                let index = currentText.index(after: currentText.startIndex)
                textField.text = String(currentText[index...])
                isNowNegative = false
            } else {
                textField.text = "-" + currentText
                isNowNegative = true
            }
            
            let newIconName = isNowNegative ? "plus" : "minus"
            self.minusImageView?.image = UIImage(systemName: newIconName)
            
            validateAndUpdate(textField)
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            validateAndUpdate(textField)
        }
        
        func validateAndUpdate(_ textField: UITextField) {
            guard let newValue = textField.text else { return }
            
            var numbers: String = "0123456789"
            let negativeIndicator: Character = "-"
            let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
            
            numbers += decimalSeparator
            numbers += String(negativeIndicator)
            
            var finalText = newValue
            
            if newValue.components(separatedBy: decimalSeparator).count > 2 {
                finalText = String(newValue.dropLast())
            } else if newValue.last == negativeIndicator && newValue != "-" {
                finalText = String(newValue.dropLast())
            } else {
                let filtered = newValue.filter { numbers.contains($0) }
                if filtered != newValue {
                    finalText = filtered
                }
            }
            
            if finalText != newValue {
                textField.text = finalText
            }
            
            let isNegative = finalText.contains("-")
            let iconName = isNegative ? "plus" : "minus"
            if self.minusImageView?.image != UIImage(systemName: iconName) {
                self.minusImageView?.image = UIImage(systemName: iconName)
            }
            
            DispatchQueue.main.async {
                self.parent.text = finalText
            }
        }
    }
    
    func getTextField() -> UITextField? {
        return nil
    }
}

extension DecimalInput.Coordinator {
    fileprivate func findTextField() -> UITextField? {
        return nil
    }
}
