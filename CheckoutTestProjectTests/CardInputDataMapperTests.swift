//
//  CardInputDataMapperTests.swift
//  CheckoutTestProjectTests
//
//  Created by Igor Zarubin on 02.11.2022.
//

import XCTest
@testable import CheckoutTestProject

final class CardInputDataMapperTests: XCTestCase {
    
    private let mapper = CardInputDataMapperImp()
    
    func testThatMapperReturnsCardIfDataIsValid() {
        // Arrange
        
        let givenCardNumber = "4242424242424242"
        let givenExpirationDate = "06/2030"
        let givenCvv = "100"
        
        let expectedCard = Card(
            number: 4242424242424242,
            expirationMonth: 6,
            expirationYear: 2030,
            cvv: 100
        )
        
        // Act
        
        let result = self.mapper.map(
            cardNumber: givenCardNumber,
            expirationDate: givenExpirationDate,
            cvv: givenCvv
        )
        
        // Assert
        
        XCTAssertEqual(result, .success(expectedCard))
    }
    
    func testThatMapperReturnsFailureIfCardDataIsEmpty() {
        // Arrange
        
        let givenCardNumber: String? = nil
        let givenExpirationDate: String? = nil
        let givenCvv: String? = nil
        
        // Act
        
        let result = self.mapper.map(
            cardNumber: givenCardNumber,
            expirationDate: givenExpirationDate,
            cvv: givenCvv
        )
        
        // Assert
        
        XCTAssertEqual(result, .failure(.dataIsMissing))
    }
    
    func testThatMapperReturnsFailureIfCardNumberIsIncorrect() {
        // Arrange
        
        let givenCardNumber = "424242424"
        let givenExpirationDate = "06/2030"
        let givenCvv = "100"
        
        // Act
        
        let result = self.mapper.map(
            cardNumber: givenCardNumber,
            expirationDate: givenExpirationDate,
            cvv: givenCvv
        )
        
        // Assert
        
        XCTAssertEqual(result, .failure(.incorrectCardNumber))
    }
    
    func testThatMapperReturnsFailureIfCvvIsIncorrect() {
        // Arrange
        
        let givenCardNumber = "4242424242424242"
        let givenExpirationDate = "06/2030"
        let givenCvv = "1"
        
        // Act
        
        let result = self.mapper.map(
            cardNumber: givenCardNumber,
            expirationDate: givenExpirationDate,
            cvv: givenCvv
        )
        
        // Assert
        
        XCTAssertEqual(result, .failure(.incorrectCvv))
    }
    
    func testThatMapperReturnsFailureIfExpirationMonthIsIncorrect() {
        // Arrange
        
        let givenCardNumber = "4242424242424242"
        let givenExpirationDate = "13/2030"
        let givenCvv = "100"
        
        // Act
        
        let result = self.mapper.map(
            cardNumber: givenCardNumber,
            expirationDate: givenExpirationDate,
            cvv: givenCvv
        )
        
        // Assert
        
        XCTAssertEqual(result, .failure(.incorrectExpirationMonth))
    }
    
    func testThatMapperReturnsFailureIfExpirationYearIsIncorrect() {
        // Arrange
        
        let givenCardNumber = "4242424242424242"
        let givenExpirationDate = "13/230"
        let givenCvv = "100"
        
        // Act
        
        let result = self.mapper.map(
            cardNumber: givenCardNumber,
            expirationDate: givenExpirationDate,
            cvv: givenCvv
        )
        
        // Assert
        
        XCTAssertEqual(result, .failure(.incorrectExpirationYear))
    }
}
