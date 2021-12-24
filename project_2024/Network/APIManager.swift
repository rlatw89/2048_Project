//
//  APIManager.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/24.
//

import Alamofire

class APISession {
    static let shared = APISession()
    var config: URLSessionConfiguration
    var session: Session
    private init() {
        config = URLSessionConfiguration.default
        session = Session(configuration: config)
    }
}

final class APIManager {
    enum APIError {
        case disconnected_Network
        case server_internal_error
    }
    
    static let shared = APIManager()
    private init() { }
    
    /// Data request
    /// - Parameters:
    ///   - router: <#router description#>
    ///   - of: <#of description#>
    ///   - completion: <#completion description#>
    /// - Returns: request
    @discardableResult
    func request<T: Decodable>(_ router: Router, of: T.Type, completion: @escaping (T) -> Void) -> Request? {
        let request = APISession.shared.session.request(router).responseDecodable(of: T.self, completionHandler: { response in
            
            Log.response(response: response.data)
            
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure:
                Log.error()
            }
        })
        return request
    }
}


class Log {
    static func log() {
        
    }
    
    static func error() {
        
    }
    
    static func request(request: URLRequest) {
        print("===============[REQUEST]===============")
        print("url: \(request.url?.absoluteString ?? "Empty")")
        if let body = request.httpBody?.prettyPrintedJSONString {
            print("body: \(body)")
        }
    }
    
    static func response(response: Data?) {
        print("===============[RESPONSE]===============")
        if let response = response?.prettyPrintedJSONString {
            print(response)
        } else {
            print("Response is empty.")
        }
    }
}
