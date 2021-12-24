//
//  Router.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/24.
//

import Alamofire

class Router: URLRequestConvertible {
    private var endPoint: GameEndPoint
    private var query: String?
    private var body: Data?
    
    init(_ endPoint: GameEndPoint, query: String? = nil, body: Data? = nil) {
        self.endPoint = endPoint
        self.query = query
        self.body = body
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: endPoint.urlString + (query ?? ""))
        
        var request = try URLRequest(url: url!, method: endPoint.method, headers: endPoint.headers)
        request.httpBody = body
        
        Log.request(request: request)
        
        return request
    }
}
