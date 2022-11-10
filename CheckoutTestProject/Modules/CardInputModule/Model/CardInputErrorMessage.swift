//
//  CardInputErrorMessage.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

enum CardInputErrorMessage {
    case validationError(String)
    case serviceError
    
    var text: String {
        switch self {
        case .validationError(let message):
            return message
        case .serviceError:
            return Strings.serviceError
        }
    }
}
