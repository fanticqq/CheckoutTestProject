//
//  PaymentResultViewController.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import UIKit

final class PaymentResultViewController: UIViewController {
    
    private let imageView = UIImageView().forAutoLayout()
    private let textLabel = UILabel().forAutoLayout()
    
    private let viewModel: PaymentResultViewModel
    
    init(viewModel: PaymentResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureLayout()
    }
}

private extension PaymentResultViewController {
    func configureUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(close)
        )
        
        self.view.backgroundColor = .white
        
        self.textLabel.font = .preferredFont(forTextStyle: .title1)
        self.textLabel.textAlignment = .center
        self.imageView.image = self.viewModel.image
        self.textLabel.text = self.viewModel.text
        self.view.addSubview(self.imageView)
        self.view.addSubview(self.textLabel)
    }
    
    func configureLayout() {
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            self.textLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.textLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.textLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 16)
        ])
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
