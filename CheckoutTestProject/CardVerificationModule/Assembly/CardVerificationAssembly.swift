//
//  CardVerificationAssembly.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import UIKit

struct CardVerificationDependencies {
    let url: URL
    let successURL: URL
    let failureURL: URL
    let output: CardVerificationViewModelOutput
}

enum CardVerificationAssembly {
    static func makeModule(with dependencies: CardVerificationDependencies) -> UIViewController {
        let router = CardVerificationRouterImp()
        let viewModel = CardVerificationViewModel(with: dependencies, router: router)
        let viewController = CardVerificationViewController(viewModel: viewModel)
        router.presenter = viewController
        return viewController
    }
}
