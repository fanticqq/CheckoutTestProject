//
//  PaymentResultAssembly.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import UIKit

enum PaymentResultAssembly {
    static func makeModule(isPaymentSucceeded: Bool) -> UIViewController {
        return PaymentResultViewController(
            viewModel: .init(isPaymentSucceeded: isPaymentSucceeded)
        )
    }
}
