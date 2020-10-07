//
//  File.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation
import Combine

/// Oxford`s dictionary: https://developer.oxforddictionaries.com/documentation#

class API {
    static public let shared = API()
    
    static private let URL_PREFIX = "https://"
    static private let HOST = "od-api.oxforddictionaries.com"
    static private let basePath = "api/v2"
    
    static private let language = "en-us"
    
    private var session: URLSession
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        session = URLSession(configuration: API.makeSessionConfiguration())
    }
    
    static private func makeSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        let headers = [
            "Accept": "application/json",
            "app_id": APIKeys.appId,
            "app_key": APIKeys.appKey
        ]
        configuration.httpAdditionalHeaders = headers
        return configuration
    }
    
    static private func makeURL() -> URL {
        return URL(string: "\(API.URL_PREFIX)\(API.HOST)/\(API.basePath)/entries/\(language)/")!
    }
    
    public func request<T: Decodable>(word: String) -> AnyPublisher<T, Error> {
        var request: URLRequest
        
        var url = API.makeURL()
        url.appendPathComponent(word)
        
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                return try API.processResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    static private func processResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpsResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        
        if 200...200 ~= httpsResponse.statusCode {
            return data
        } else {
            throw NetworkError.badCode
        }
    }
}

enum NetworkError: Error {
    case unknown
    case badCode
}
