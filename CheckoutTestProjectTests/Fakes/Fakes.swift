//
//  Fakes.swift
//  CheckoutTestProjectTests
//
//  Created by Igor Zarubin on 10.11.2022.
//

import Foundation
@testable import CheckoutTestProject

extension Card {
    static func fake() -> Card {
        return .init(number: 4242424242424242, expirationMonth: 6, expirationYear: 2030, cvv: 100)
    }
}

extension URL {
    static func fake() -> URL {
        guard let url = URL(string: "https://test.com") else {
            fatalError("Failed to build test url")
        }
        return url
    }
}
