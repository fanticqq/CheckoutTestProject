//
//  CardInputDataMapperMock.swift
//  CheckoutTestProjectTests
//
//  Created by Igor Zarubin on 10.11.2022.
//

@testable import CheckoutTestProject

final class CardInputDataMapperMock: CardInputDataMapper {
    var cardMapResult: Result<Card, CardInputDataMapperError>!
    
    func map(cardNumber: String?, expirationDate: String?, cvv: String?) -> Result<Card, CardInputDataMapperError> {
        return cardMapResult
    }
}
