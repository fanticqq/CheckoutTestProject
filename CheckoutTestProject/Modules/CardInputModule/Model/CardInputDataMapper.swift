//
//  CardInputDataMapper.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import Foundation

enum CardInputDataMapperError: Error {
    case dataIsMissing
    case incorrectCvv
    case incorrectCardNumber
    case incorrectExpirationDate
    case incorrectExpirationMonth
    case incorrectExpirationYear
    
    var localizedDescription: String {
        switch self {
        case .dataIsMissing:
            return Strings.cardMappingErrorDataIsMissing
        case .incorrectCvv:
            return Strings.cardMappingErrorIncorrectCvv
        case .incorrectCardNumber:
            return Strings.cardMappingErrorIncorrectCardNumber
        case .incorrectExpirationDate:
            return Strings.cardMappingErrorIncorrectExpirationDate
        case .incorrectExpirationMonth:
            return Strings.cardMappingErrorIncorrectExpirationMonth
        case .incorrectExpirationYear:
            return Strings.cardMappingErrorIncorrectExpirationYear
        }
    }
}

protocol CardInputDataMapper {
    func map(cardNumber: String?, expirationDate: String?, cvv: String?) -> Result<Card, CardInputDataMapperError>
}

final class CardInputDataMapperImp: CardInputDataMapper {
    func map(cardNumber: String?, expirationDate: String?, cvv: String?) -> Result<Card, CardInputDataMapperError> {
        guard !cardNumber.isNilOrEmpty, !expirationDate.isNilOrEmpty, !cvv.isNilOrEmpty else {
            return .failure(.dataIsMissing)
        }
        guard cardNumber?.count == 16 else {
            return .failure(.incorrectCardNumber)
        }
        guard cvv?.count == 3 else {
            return .failure(.incorrectCvv)
        }
        if 
            let cardNumber = cardNumber.flatMap(Int.init),
            let expirationDate = expirationDate,
            let cvv = cvv.flatMap(Int.init) {
            
            let dateComponents = expirationDate.split(separator: "/")
            guard 
                dateComponents.count == 2, 
                let month = Int(dateComponents[0]), 
                let year = Int(dateComponents[1]) 
            else {
                return .failure(.incorrectExpirationDate)
            }
            
            guard String(year).count == 4 else {
                return .failure(.incorrectExpirationYear)
            }
            
            guard (1...12).contains(month) else {
                return .failure(.incorrectExpirationMonth)
            }

            let card = Card(number: cardNumber, expirationMonth: month, expirationYear: year, cvv: cvv)
            return .success(card)
        } else {
            return .failure(.dataIsMissing)
        }
    }
}
