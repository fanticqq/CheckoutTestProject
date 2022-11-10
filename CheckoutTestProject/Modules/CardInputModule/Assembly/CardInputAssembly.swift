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
        let router = CardInputRouterImp()
        let service = PaymentServiceImp(client: client)
        let cardMapper = CardInputDataMapperImp()
        let viewModel = CardInputViewModel(service: service, cardMapper: cardMapper, router: router)
        let viewController = CardInputViewController(viewModel: viewModel)
        router.presenter = viewController
        return viewController
    }
}
