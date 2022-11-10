//
//  String+Extensions.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import Foundation

extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let wrapped):
            return wrapped.isEmpty
        }
    }
}
