//
//  CardVerificationViewController.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import UIKit
import WebKit

final class CardVerificationViewController: UIViewController {
    
    private let webView = WKWebView()
    private let viewModel: CardVerificationViewModel
    
    init(viewModel: CardVerificationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.webView.navigationDelegate = self.viewModel
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.load(URLRequest(url: self.viewModel.url))
    }
} 
