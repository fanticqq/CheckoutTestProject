//
//  PaymentServiceMock.swift
//  CheckoutTestProjectTests
//
//  Created by Igor Zarubin on 10.11.2022.
//

import Combine
@testable import CheckoutTestProject

final class PaymentServiceMock: PaymentService {
    var obtainPaymentURLResult: AnyPublisher<PaymentResult, Error>!
    
    func obtainPaymentURL(by card: Card) -> AnyPublisher<PaymentResult, Error> {
        return self.obtainPaymentURLResult
    }
}
