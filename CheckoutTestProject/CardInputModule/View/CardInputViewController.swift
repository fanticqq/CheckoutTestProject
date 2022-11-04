//
//  CardInputViewController.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 02.11.2022.
//

import UIKit
import Combine

final class CardInputViewController: UIViewController {
    private let cardInputView = CardInputView().forAutoLayout()
    private let viewModel: CardInputViewModel
    private var disposeBag = Set<AnyCancellable>()
    
    init(viewModel: CardInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureBinding()
    }
}

private extension CardInputViewController {
    func configureUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.cardInputView)
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.cardInputView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.cardInputView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.cardInputView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.cardInputView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func configureBinding() {
        let viewModelSubscriptions = [
            self.viewModel.$cardNumber.assign(to: \.text, on: self.cardInputView.cardNumberTextField),
            self.viewModel.$expirationDate.assign(to: \.text, on: self.cardInputView.expirationDateTextField),
            self.viewModel.$cvv.assign(to: \.text, on: self.cardInputView.cvvTextField)
        ]
        viewModelSubscriptions.forEach { $0.store(in: &self.disposeBag) }
        
        self.cardInputView.cardNumberTextField
            .observeTextChanges()
            .sink(receiveValue: { [weak self] in self?.viewModel.change(cardNumber: $0) })
            .store(in: &self.disposeBag)
        
        self.cardInputView.expirationDateTextField
            .observeTextChanges()
            .sink(receiveValue: { [weak self] in self?.viewModel.change(expirationDate: $0) })
            .store(in: &self.disposeBag)
        
        self.cardInputView.cvvTextField
            .observeTextChanges()
            .sink(receiveValue: { [weak self] in self?.viewModel.change(cvv: $0) })
            .store(in: &self.disposeBag)
        
        self.cardInputView.onPayButtonPressed
            .sink(receiveValue: { [weak self] in self?.viewModel.buy() })
            .store(in: &self.disposeBag)
    }
}

