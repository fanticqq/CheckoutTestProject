//
//  UIView+Extensions.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 02.11.2022.
//

import UIKit

extension UIView {
    func forAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
