//
//  PaymentService.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Foundation
import Combine

protocol PaymentService {
    func obtainPaymentURL(by card: Card) -> AnyPublisher<PaymentResult, Error>
}

final class PaymentServiceImp: PaymentService {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func obtainPaymentURL(by card: Card) -> AnyPublisher<PaymentResult, Error> {
        let parameters = PaymentParameters(
            number: card.number,
            expiryMonth: card.expirationMonth,
            expiryYear: card.expirationYear,
            cvv: card.cvv,
            successUrl: Constants.successURL.absoluteString,
            failureUrl: Constants.failureURL.absoluteString
        )
        let request = NetworkRequest<PaymentParameters>(
            endpoint: .pay,
            method: .post,
            parameters: parameters
        )
        return self.client
            .obtainData(for: request)
            .map { (payload: PaymentURLPayload) -> PaymentResult in
                .init(url: payload.url, successURL: Constants.successURL, failureURL: Constants.failureURL) 
            }
            .eraseToAnyPublisher()
    }
}

private extension PaymentServiceImp {
    struct PaymentParameters {
        let number: Int
        let expiryMonth: Int
        let expiryYear: Int
        let cvv: Int
        let successUrl: String
        let failureUrl: String
    }
    
    struct PaymentURLPayload: Decodable {
        let url: URL
    }
}

extension PaymentServiceImp.PaymentParameters: Encodable {
    enum CodingKeys: String, CodingKey {
        case number
        case expiryMonth
        case expiryYear
        case cvv
        case successUrl
        case failureUrl
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(String(self.number), forKey: .number)
        try container.encode(String(self.expiryMonth), forKey: .expiryMonth)
        try container.encode(String(self.expiryYear), forKey: .expiryYear)
        try container.encode(String(self.cvv), forKey: .cvv)
        try container.encode(self.successUrl, forKey: .successUrl)
        try container.encode(self.failureUrl, forKey: .failureUrl)
    }
}

private enum Constants {
    static let successURL: URL = {
        guard let url = URL(string: "https://success.com") else {
            fatalError("Success url build failed")
        }
        return url
    }()

    static let failureURL: URL = {
        guard let url = URL(string: "https://failure.com") else {
            fatalError("Failure url build failed")
        }
        return url
    }()
}
