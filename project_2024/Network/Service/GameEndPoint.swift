//
//  GameEndPoint.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/24.
//

import Alamofire

enum GameEndPoint: APIEndPoint {
    
    case users
    case user
    
    private var basePath: String {
        return NetworkEnviroment.basePath
    }
    
    var urlString: String {
        var path = ""
        switch self {
        case .users: path = "/users"
        case .user: path = "/user"
        }
        
        return basePath + path
    }
    
    var method: HTTPMethod {
        switch self {
        case .users: return .get
        case .user: return .post
        }
    }
    
    var headers: HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Content-Type", value: "application/json")
        
        return headers
    }
}
