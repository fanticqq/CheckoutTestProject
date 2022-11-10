//
//  TextField.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import UIKit

class TextField: UITextField {
   override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
   }
}
