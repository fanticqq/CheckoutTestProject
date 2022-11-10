//
//  PaymentResultViewModel.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import Combine
import UIKit

final class PaymentResultViewModel {
    
    let image: UIImage?
    let text: String?
    
    init(isPaymentSucceeded: Bool) {
        self.image = isPaymentSucceeded ? UIImage(named: "Success") : UIImage(named: "Failure")
        self.text = isPaymentSucceeded ? Strings.paymentSucceededText : Strings.paymentFailedText 
    }
}
