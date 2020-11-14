//
//  File.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation
import Combine

class APIService {
    
    private lazy var oxfordProvider = APIOxfordProvider()
    private lazy var merriamWebsterProvider = APIMerriemWebsterProvider()
    private lazy var urbanProvider = APIUrbanProvider()
    private lazy var wordnikProvider = APIWordnikProvider()
    
    func GET<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        
        var provider: APIProvider
        var request: URLRequest
        
        switch endpoint {
        case .oxford(let oxfordEndpoint):
            provider = oxfordProvider
            request = oxfordProvider.requestForGET(with: oxfordEndpoint)
            
        case .merriamWebster(let merriamWebsterEndpoint):
            provider = merriamWebsterProvider
            request = merriamWebsterProvider.requestForGET(with: merriamWebsterEndpoint)
            
        case .urban(let urbanEndpoint):
            provider = urbanProvider
            request = urbanProvider.requestForGET(with: urbanEndpoint)
            
        case .wordnik(let wordnikEndpoint):
            provider = wordnikProvider
            request = wordnikProvider.requestForGET(with: wordnikEndpoint)
        }
        
        let session = provider.session
        let decoder = provider.decoder
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                return try APIError.processResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                APIError.parseError(reason: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

enum APIError: Error {
    case unknown(data: Data)
    case badCode
    case parseError(reason: String)
    
    static func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpsResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(data: data)
        }
        
        if 200...299 ~= httpsResponse.statusCode {
            return data
        } else {
            throw APIError.badCode
        }
    }
}
