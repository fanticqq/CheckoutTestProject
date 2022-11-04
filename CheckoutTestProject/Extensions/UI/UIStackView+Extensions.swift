//
//  UIStackView+Extensions.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            self.addArrangedSubview($0)
        }
    }
}
