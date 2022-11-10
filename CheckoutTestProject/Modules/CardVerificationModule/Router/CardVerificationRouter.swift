//
//  CardVerificationRouter.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import Foundation
import UIKit

protocol CardVerificationRouter: AnyObject {
    func dismiss(with completion: (() -> Void)?)
}

final class CardVerificationRouterImp: CardVerificationRouter {
    weak var presenter: UIViewController?
    
    func dismiss(with completion: (() -> Void)?) {
        self.presenter?.dismiss(animated: true, completion: completion)
    }
}
