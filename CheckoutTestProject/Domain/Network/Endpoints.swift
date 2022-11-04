//
//  Endpoints.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Foundation

enum Endpoints {
    case pay
    
    var url: URL {
        let urlString: String
        switch self {
        case .pay:
            urlString = "pay"
        }
        guard let url = URL(string: "https://integrations-cko.herokuapp.com/\(urlString)") else {
            fatalError("Couldn't build URL for method: \(urlString)")
        }
        return url
    }
}
