//
//  CardInputAssembly.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import UIKit

enum CardInputAssembly {
    static func makeModule() -> UIViewController {
        let client = NetworkClientImp()
        let service = PaymentServiceImp(client: client)
        let viewModel = CardInputViewModel(service: service)
        return CardInputViewController(viewModel: viewModel)
    }
}
