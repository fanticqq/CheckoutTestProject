//
//  CardInputView.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 02.11.2022.
//

import UIKit
import Combine

private enum Constants {
    static let sideOffset: CGFloat = 16
    static let interItemsSpace: CGFloat = 20
    static let labelBottomInset: CGFloat = 8
}

final class CardInputView: UIView {
    let onPayButtonPressed = PassthroughSubject<Void, Never>()
    
    var isProcessing: Bool = false {
        willSet {
            self.progressIndicator.isHidden = !newValue
            self.payButton.isEnabled = !newValue
            let title: NSAttributedString
            if newValue {
                self.progressIndicator.startAnimating()
                title = NSAttributedString(string: "")
            } else {
                title = self.buttonAttributedTitle
                self.progressIndicator.stopAnimating()
            }
            self.payButton.setAttributedTitle(title, for: .normal)
        }
    }
    
    private let stackView = UIStackView().forAutoLayout()
    private let cardDetailsContainerView = UIStackView().forAutoLayout()
    private let expirationDateContainerView = UIStackView().forAutoLayout()
    private let cvvContainerView = UIStackView().forAutoLayout()
    
    private let buttonAttributedTitle = NSAttributedString(
        string: Strings.pay,
        attributes: [.font:  UIFont.preferredFont(forTextStyle: .callout)]
    )
    
    private(set) lazy var cardNumberTextField = self.makeTextField()
    private lazy var cardNumberTitleLabel = self.makeLabel(with: Strings.cardNumber)
    
    private(set) lazy var expirationDateTextField = self.makeTextField()
    private lazy var expirationDateTitleLabel = self.makeLabel(with: Strings.expirationDate)
    
    private(set) lazy var cvvTextField = self.makeTextField()
    private lazy var cvvTitleLabel = self.makeLabel(with: Strings.cvv)
    
    private lazy var payButton = UIButton(type: .system)
    
    private lazy var progressIndicator = UIActivityIndicatorView(style: .medium).forAutoLayout()
    
    private var disposeBag = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        self.configureLayout()
    }
}

private extension CardInputView {
    func configureUI() {
        self.backgroundColor = .white
        self.addSubview(self.stackView)
        
        self.configureStackView()
        self.configureButton()
    }
    
    func configureButton() {
        self.payButton.setAttributedTitle(self.buttonAttributedTitle, for: .normal)
        self.payButton.addTarget(self, action: #selector(self.payButtonPressed), for: .touchUpInside)
        self.payButton.layer.borderColor = UIColor.black.cgColor
        self.payButton.layer.borderWidth = 1
    }
    
    func configureStackView() {
        [self.stackView, self.expirationDateContainerView, self.cvvContainerView].forEach {
            $0.axis = .vertical
        }
        
        self.cardDetailsContainerView.distribution = .fillEqually
        self.cardDetailsContainerView.spacing = Constants.interItemsSpace
        
        self.stackView.addArrangedSubviews([
            self.cardNumberTitleLabel,
            self.cardNumberTextField,
            self.cardDetailsContainerView,
            self.payButton
        ])
        
        self.cardDetailsContainerView.addArrangedSubviews([
            self.expirationDateContainerView,
            self.cvvContainerView
        ])
        
        self.expirationDateContainerView.addArrangedSubviews([
            self.expirationDateTitleLabel,
            self.expirationDateTextField
        ])
        
        self.cvvContainerView.addArrangedSubviews([
            self.cvvTitleLabel,
            self.cvvTextField
        ])
        
        self.payButton.addSubview(self.progressIndicator)
    }

    func configureLayout() {
        self.stackView.setCustomSpacing(Constants.labelBottomInset, after: self.cardNumberTitleLabel)
        self.stackView.setCustomSpacing(Constants.interItemsSpace, after: self.cardNumberTextField)
        self.stackView.setCustomSpacing(Constants.interItemsSpace, after: self.cardDetailsContainerView)
        
        self.cvvContainerView.setCustomSpacing(Constants.labelBottomInset, after: self.cvvTitleLabel)
        self.expirationDateContainerView.setCustomSpacing(Constants.labelBottomInset, after: self.expirationDateTitleLabel)
        
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.sideOffset),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.sideOffset),
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -100)
        ])
        
        NSLayoutConstraint.activate([
            self.progressIndicator.centerXAnchor.constraint(equalTo: self.payButton.centerXAnchor),
            self.progressIndicator.centerYAnchor.constraint(equalTo: self.payButton.centerYAnchor)
        ])
    }
    
    func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.addDoneButton()
        textField.font = .preferredFont(forTextStyle: .title1)
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        return textField
    }
    
    func makeLabel(with text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }
    
    @objc func payButtonPressed() {
        self.onPayButtonPressed.send()
    }
}
