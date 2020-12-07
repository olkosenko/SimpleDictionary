//
//  APIKeys.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-09-07.
//

import Foundation

protocol APIProvider {
    var decoder: JSONDecoder { get }
    var session: URLSession { get }
}

class APIOxfordProvider: APIProvider {
    let decoder = JSONDecoder()
    lazy var session = URLSession(configuration: makeSessionConfiguration())
    
    /// https://od-api.oxforddictionaries.com/api/v2/entries/en-gb/ace
    private let scheme = "https"
    private let host = "od-api.oxforddictionaries.com"
    private let basePath = "api/v2"
    private let language = "en-us"
    private let appId = "f1628160"
    private let appKey = "befcdb81ac57168c93d30128fedb20b0"
    
    func requestForGET(with endpoint: OxfordEndpoint) -> URLRequest {
        var request = URLRequest(url: makeURL(from: endpoint))
        request.httpMethod = "GET"
        
        return request
    }
    
    private func makeSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        let headers = [
            "Accept": "application/json",
            "app_id": appId,
            "app_key": appKey
        ]
        configuration.httpAdditionalHeaders = headers
        return configuration
    }
    
    private func makeURL(from endpoint: OxfordEndpoint) -> URL {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/\(basePath)/\(endpoint.path)/\(language)/\(endpoint.word)"
        
        return urlComponents.url!
    }
}

class APIMerriamWebsterProvider: APIProvider {
    let decoder = JSONDecoder()
    lazy var session = URLSession(configuration: makeSessionConfiguration())
    
    /// https://dictionaryapi.com/api/v3/references/thesaurus/json/test?key=15202ab4-4624-4b70-bdb7-69c497a28f1f
    private let scheme = "https"
    private let host = "dictionaryapi.com"
    private let basePath = "api/v3/references"
    private let format = "json"
    private let apiKey = "15202ab4-4624-4b70-bdb7-69c497a28f1f"
    
    func requestForGET(with endpoint: MerriamWebsterEndpoint) -> URLRequest {
        var request = URLRequest(url: makeURL(from: endpoint))
        request.httpMethod = "GET"
        
        return request
    }
    
    private func makeSessionConfiguration() -> URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    private func makeURL(from endpoint: MerriamWebsterEndpoint) -> URL {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/\(basePath)/\(endpoint.path)/\(format)/\(endpoint.word)"
        urlComponents.queryItems = [URLQueryItem(name: "key", value: apiKey)]
        
        return urlComponents.url!
    }
}

class APIUrbanProvider: APIProvider {
    let decoder = JSONDecoder()
    lazy var session = URLSession(configuration: makeSessionConfiguration())
    
    /// https://dictionaryapi.com/api/v3/references/thesaurus/json/test?key=befcdb81ac57168c93d30128fedb20b0
    private let scheme = "https"
    private let host = "mashape-community-urban-dictionary.p.rapidapi.com"
    private let apiKey = "211d749b10msh226200831615109p1b54f6jsn51b63ca56df0"
    
    func requestForGET(with endpoint: UrbanEndpoint) -> URLRequest {
        var request = URLRequest(url: makeURL(from: endpoint))
        request.httpMethod = "GET"
        
        return request
    }
    
    private func makeSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        let headers = [
            "Accept": "application/json",
            "x-rapidapi-host": host,
            "x-rapidapi-key": apiKey
        ]
        configuration.httpAdditionalHeaders = headers
        return configuration
    }
    
    private func makeURL(from endpoint: UrbanEndpoint) -> URL {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/\(endpoint.path)"
        urlComponents.queryItems = [URLQueryItem(name: "term", value: endpoint.word)]
        
        return urlComponents.url!
    }
}

class APIWordnikProvider: APIProvider {
    let decoder = JSONDecoder()
    lazy var session = URLSession(configuration: makeSessionConfiguration())
    
    /// https://api.wordnik.com/v4/words.json/wordOfTheDay?date=2020-10.11&api_key=YOURAPIKEY
    private let scheme = "https"
    private let host = "api.wordnik.com"
    private let basePath = "v4"
    private let apiKey = "qzz7v2zfsbp1xfevyug7ps1hdeucfe3td4mknq0knkyi4oqcz"
    
    func requestForGET(with endpoint: WordnikEndpoint) -> URLRequest {
        var request = URLRequest(url: makeURL(from: endpoint))
        request.httpMethod = "GET"
        
        return request
    }
    
    private func makeSessionConfiguration() -> URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    
    private func makeURL(from endpoint: WordnikEndpoint) -> URL {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "/\(basePath)/\(endpoint.path)"
        
        var queryItems = [URLQueryItem]()
        switch endpoint {
        case .wod(let date):
            queryItems.append(.init(name: "date", value: date.yearMonthDayLocal))
        case .randomWord:
            queryItems.append(.init(name: "hasDictionaryDef", value: "true"))
        case .audio(_):
            queryItems.append(.init(name: "limit", value: "3"))
        }
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
       
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}


