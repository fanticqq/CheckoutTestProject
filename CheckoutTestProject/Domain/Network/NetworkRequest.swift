//
//  NetworkRequest.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Foundation

struct NetworkRequest<Parameters: Encodable> {
    let endpoint: Endpoints
    let method: HTTPMethods
    let parameters: Parameters
}
