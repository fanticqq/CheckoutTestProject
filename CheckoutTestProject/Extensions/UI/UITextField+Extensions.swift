//
//  UITextField+Extensions.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import UIKit
import Combine

extension UITextField {
    func addDoneButton() {
        let toolbar = UIToolbar()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: Strings.done, style: .done, target: self, action: #selector(self.resignFirstResponder))
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    func observeTextChanges() -> AnyPublisher<String, Never>  {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { notification -> String in
                guard let textField = notification.object as? UITextField else {
                    return ""
                }
                return textField.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}
