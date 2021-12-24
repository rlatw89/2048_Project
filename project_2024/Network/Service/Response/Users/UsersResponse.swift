//
//  UsersResponse.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/24.
//

import Foundation

class UsersResponse: Decodable {
    var nickname: String
    var score: Int
    var rank: Int
    
    var printForm: String {
        return ("nickname: \(nickname)\nscore:\(score)\nrank:\(rank)")
    }
}
