//
//  BaseArrayResponse.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/24.
//

import Foundation

class BaseArrayResponse<T: Decodable>: Decodable {
    var Success: BaseResponseCode
    var entities: [T]
}

struct BaseResponseCode: Decodable {
    var code: Int
}
