//
//  APIEndPoint.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/24.
//

import Alamofire

protocol APIEndPoint {
    var urlString: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
}
