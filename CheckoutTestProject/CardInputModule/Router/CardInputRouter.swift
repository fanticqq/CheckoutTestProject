//
//  CardInputRouter.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import UIKit

protocol CardInputRouter {
    func showVerification(with dependencies: CardVerificationDependencies)
}

final class CardInputRouterImp: CardInputRouter {
    weak var presenter: UIViewController?
    
    func showVerification(with dependencies: CardVerificationDependencies) {
        let viewController = CardVerificationAssembly.makeModule(with: dependencies)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presenter?.present(navigationController, animated: true)
    }
}
