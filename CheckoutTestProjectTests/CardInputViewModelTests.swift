//
//  CardInputViewModelTests.swift
//  CheckoutTestProjectTests
//
//  Created by Igor Zarubin on 10.11.2022.
//

import XCTest
import Combine
@testable import CheckoutTestProject

final class CardInputViewModelTests: XCTestCase {
    
    private var viewModel: CardInputViewModel!
    private var paymentService: PaymentServiceMock!
    private var cardMapper: CardInputDataMapperMock!
    private var router: CardInputRouterMock!
    private var disposeBag = Set<AnyCancellable>()

    override func setUpWithError() throws {
        self.paymentService = .init()
        self.cardMapper = .init()
        self.router = .init()
        self.viewModel = .init(
            service: self.paymentService,
            cardMapper: self.cardMapper,
            router: self.router
        )
    }
    
    func testThatViewModelObtainsURLDataAndOpenVerificationScreenIfCardValidationSucceeded() {
        // Arrange
        
        self.cardMapper.cardMapResult = .success(.fake())
        self.paymentService.obtainPaymentURLResult = Just(
            PaymentResult(url: .fake(), successURL: .fake(), failureURL: .fake())
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
        self.setupCardData()
        
        let showPaymentExpectation = XCTestExpectation(description: "Verificaiton screen opened")
        self.router.onShowVerification = {
            showPaymentExpectation.fulfill()
        }
        
        // Act
        
        self.viewModel.buy()
        wait(for: [showPaymentExpectation], timeout: 5)
        
        // Assert
        
        XCTAssertTrue(self.router.isShowVerificationCalled)
    }
    
    func testThatViewModelChangesProcessingStateWhenBuyActionCalled() {
        // Arrange
        
        self.cardMapper.cardMapResult = .success(.fake())
        self.paymentService.obtainPaymentURLResult = Just(
            PaymentResult(url: .fake(), successURL: .fake(), failureURL: .fake())
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
        self.setupCardData()
        
        let processingExpectation = XCTestExpectation(description: "Payment processing")
        
        let expectedProcessingStates = [false, true, false]
        var givenProcessingStates = [Bool]()
        self.viewModel.$isProcessing
            .sink(receiveValue: {
                givenProcessingStates.append($0)
                if givenProcessingStates.count == expectedProcessingStates.count {
                    processingExpectation.fulfill()
                }
            })
            .store(in: &self.disposeBag)
        
        // Act
        
        self.viewModel.buy()
        wait(for: [processingExpectation], timeout: 5)
        
        // Assert
        
        XCTAssertEqual(givenProcessingStates, expectedProcessingStates)
    }
    
    func testThatViewModelShowsErrorIfValidationFailed() {
        // Arrange
        
        let expectedError: CardInputDataMapperError = .dataIsMissing
        
        self.cardMapper.cardMapResult = .failure(expectedError)
        self.paymentService.obtainPaymentURLResult = Just(
            PaymentResult(url: .fake(), successURL: .fake(), failureURL: .fake())
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
        self.setupCardData()
        
        let errorExpectation = XCTestExpectation(description: "Error received")
        var receivedErrorMessage: CardInputErrorMessage!
        
        self.viewModel.errors
            .sink(receiveValue: { error in
                receivedErrorMessage = error
                errorExpectation.fulfill()
            })
            .store(in: &self.disposeBag)
        
        // Act
        
        self.viewModel.buy()
        wait(for: [errorExpectation], timeout: 5)
        
        // Assert
        
        XCTAssertEqual(receivedErrorMessage.text, expectedError.localizedDescription)
    }
    
    func testThatViewModelShowsErrorIfUnknownErrorFromServiceReceived() {
        // Arrange
        
        let expectedError: CardInputErrorMessage = .serviceError
        
        self.cardMapper.cardMapResult = .success(.fake())
        self.paymentService.obtainPaymentURLResult = Fail.init(
            outputType: PaymentResult.self,
            failure: NSError(domain: "unknown", code: 0) as Error
        )
        .eraseToAnyPublisher()
        self.setupCardData()
        
        let errorExpectation = XCTestExpectation(description: "Error received")
        var receivedErrorMessage: CardInputErrorMessage!
        
        self.viewModel.errors
            .sink(receiveValue: { error in
                receivedErrorMessage = error
                errorExpectation.fulfill()
            })
            .store(in: &self.disposeBag)
        
        // Act
        
        self.viewModel.buy()
        wait(for: [errorExpectation], timeout: 5)
        
        // Assert
        
        XCTAssertEqual(receivedErrorMessage.text, expectedError.text)
    }
}

private extension CardInputViewModelTests {
    func setupCardData(
        givenCardNumber: String = "4242424242424242",
        givenExpirationDate: String = "06/2030",
        givenCvv: String = "100"
    ) {
        self.viewModel.change(cardNumber: givenCardNumber)
        self.viewModel.change(expirationDate: givenExpirationDate)
        self.viewModel.change(cvv: givenCvv)
    }
}
