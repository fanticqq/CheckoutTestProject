//
//  CardInputRouterMock.swift
//  CheckoutTestProjectTests
//
//  Created by Igor Zarubin on 10.11.2022.
//

@testable import CheckoutTestProject

final class CardInputRouterMock: CardInputRouter {
    var isShowVerificationCalled = false
    var isShowPaymentResultCalled = false
    
    var onShowVerification: (() -> Void)?
    var onShowPayment: (() -> Void)?
    
    func showVerification(with dependencies: CardVerificationDependencies) {
        self.isShowVerificationCalled = true
        self.onShowVerification?()
    }

    func showPaymentResult(isPaymentSucceeded: Bool) {
        self.isShowPaymentResultCalled = true
        self.onShowPayment?()
    }
}
