//
//  CardInputViewModel.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Combine

final class CardInputViewModel {
    
    @Published var cardNumber: String? = nil
    @Published var expirationDate: String? = nil
    @Published var cvv: String? = nil
    
    private let service: PaymentService
    
    private var disposeBag = Set<AnyCancellable>() 
    
    init(service: PaymentService) {
        self.service = service
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
        let card = Card(number: 4242424242424242, expirationMonth: 6, expirationYear: 2032, cvv: 100)
        self.service.obtainPaymentURL(by: card)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("!!! error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { payload in
                print("!!! payload: \(payload)")              
            })
            .store(in: &self.disposeBag)
    }
}
