//
//  CardVerificationViewModel.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 10.11.2022.
//

import Foundation
import WebKit

protocol CardVerificationViewModelOutput: AnyObject {
    func cardVerificationComplete()
    func cardVerificationFailed()
}

final class CardVerificationViewModel: NSObject, WKNavigationDelegate {
    
    let url: URL
    private let successURL: URL
    private let failureURL: URL
    
    private weak var output: CardVerificationViewModelOutput?
    private let router: CardVerificationRouter
    
    init(with dependencies: CardVerificationDependencies, router: CardVerificationRouter) {
        self.url = dependencies.url
        self.successURL = dependencies.successURL
        self.failureURL = dependencies.failureURL
        self.output = dependencies.output
        self.router = router
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let host = navigationAction.request.url?.host
        if host == self.successURL.host {
            decisionHandler(.cancel)
            self.router.dismiss(with: { [weak self] in
                self?.output?.cardVerificationComplete()                
            })
        } else if host == self.failureURL.host {
            decisionHandler(.cancel)
            self.router.dismiss(with: { [weak self] in
                self?.output?.cardVerificationFailed()                
            })
        } else {
            decisionHandler(.allow)
        }
    }
}
