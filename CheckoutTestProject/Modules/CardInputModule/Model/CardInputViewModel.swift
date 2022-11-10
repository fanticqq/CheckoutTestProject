//
//  CardInputViewModel.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Combine

final class CardInputViewModel {
    
    @Published var cardNumber: String?
    @Published var expirationDate: String?
    @Published var cvv: String?
    @Published var isProcessing: Bool = false
    
    let errors = PassthroughSubject<CardInputErrorMessage, Never>()
    
    private let service: PaymentService
    private let cardMapper: CardInputDataMapper
    private let router: CardInputRouter
    
    private var disposeBag = Set<AnyCancellable>() 
    
    init(service: PaymentService, cardMapper: CardInputDataMapper, router: CardInputRouter) {
        self.service = service
        self.cardMapper = cardMapper
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
        let mappingResult = self.cardMapper.map(
            cardNumber: self.cardNumber,
            expirationDate: self.expirationDate,
            cvv: self.cvv
        )
        switch mappingResult {
        case .success(let card):
            self.isProcessing = true
            self.obtainPaymentURL(by: card)
        case .failure(let error):
            self.errors.send(.validationError(error.localizedDescription))
        }
    }
}

extension CardInputViewModel: CardVerificationViewModelOutput {
    func cardVerificationComplete() {
        self.router.showPaymentResult(isPaymentSucceeded: true)
    }
    
    func cardVerificationFailed() {
        self.router.showPaymentResult(isPaymentSucceeded: false)
    }
}

private extension CardInputViewModel {
    func obtainPaymentURL(by card: Card) {
        self.service.obtainPaymentURL(by: card)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isProcessing = false
                switch completion {
                case .failure:
                    self?.errors.send(.serviceError)
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
