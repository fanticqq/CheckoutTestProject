//
//  NetworkClient.swift
//  CheckoutTestProject
//
//  Created by Igor Zarubin on 03.11.2022.
//

import Foundation
import Combine

protocol NetworkClient {
    func obtainData<Response: Decodable, Parameters: Encodable>(
        for request: NetworkRequest<Parameters>
    ) -> AnyPublisher<Response, Error>
}

final class NetworkClientImp: NetworkClient {
    private let urlSession: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let receivingQueue: DispatchQueue
    
    init(urlSession: URLSession, decoder: JSONDecoder, encoder: JSONEncoder, receivingQueue: DispatchQueue) {
        self.urlSession = urlSession
        self.decoder = decoder
        self.encoder = encoder
        self.receivingQueue = receivingQueue
    }
    
    convenience init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        self.init(urlSession: .shared, decoder: JSONDecoder(), encoder: encoder, receivingQueue: .main)
    }
    
    func obtainData<Response: Decodable, Parameters: Encodable>(
        for request: NetworkRequest<Parameters>
    ) -> AnyPublisher<Response, Error> {
        var urlRequest = URLRequest(url: request.endpoint.url)
        urlRequest.httpBody = try? encoder.encode(request.parameters)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = 10
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
            .map(\.data)
            .decode(type: Response.self, decoder: self.decoder)
            .receive(on: self.receivingQueue)
            .eraseToAnyPublisher()
    }
}
