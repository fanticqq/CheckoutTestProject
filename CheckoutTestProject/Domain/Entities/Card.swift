//
//  Card.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Foundation

struct Card: Equatable {
    let number: Int
    let expirationMonth: Int
    let expirationYear: Int
    let cvv: Int
}
