//
//  CardInputViewModel.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Combine

final class CardInputViewModel {
    
    @Published var cardNumber: String? = "4243754271700719"
    @Published var expirationDate: String? = "06/2030"
    @Published var cvv: String? = "100"
    
    private let service: PaymentService
    private let router: CardInputRouter
    
    private var disposeBag = Set<AnyCancellable>() 
    
    init(service: PaymentService, router: CardInputRouter) {
        self.service = service
        self.router = router
    }
    
    func change(cardNumber: String) {
        guard cardNumber.count < 17 else {
            self.cardNumber = self.cardNumber
            return
        }
        self.cardNumber = cardNumber
    }

    func change(expirationDate: String) {
        var rawText = expirationDate.replacingOccurrences(of: "/", with: "")
        guard rawText.count < 7 else {
            self.expirationDate = self.expirationDate
            return
        }
        if rawText.count > 2 && expirationDate.count > 2 {
            rawText.insert("/", at: rawText.index(rawText.startIndex, offsetBy: 2))
        }
        self.expirationDate = rawText
    }

    func change(cvv: String) {
        guard cvv.count < 4 else {
            self.cvv = self.cvv
            return
        }
        self.cvv = cvv
    }
    
    func buy() {
        let expirationDate = self.expirationDate ?? ""
        let dateComponents = expirationDate.split(separator: "/")
        guard 
            let cardNumber = Int(self.cardNumber ?? ""),
            dateComponents.count == 2,
        let month = Int(dateComponents[0]),
        let year = Int(dateComponents[1]),
            let cvv = Int(self.cvv ?? "") else {
            return
        }

        let card = Card(number: cardNumber, expirationMonth: month, expirationYear: year, cvv: cvv)
        self.service.obtainPaymentURL(by: card)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("!!! error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] payload in
                guard let self = self else {
                    return
                }
                let dependencies = CardVerificationDependencies(
                    url: payload.url,
                    successURL: payload.successURL,
                    failureURL: payload.failureURL,
                    output: self
                )
                self.router.showVerification(with: dependencies)
            })
            .store(in: &self.disposeBag)
    }
}

extension CardInputViewModel: CardVerificationViewModelOutput {
    func cardVerificationComplete() {
        print("!!! cardVerificationComplete")
    }
    
    func cardVerificationFailed() {
        print("!!! cardVerificationFailed")
    }
}
