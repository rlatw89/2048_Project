//
//  Configuration.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2022/01/15.
//

import Foundation

/// Division Level
var DIVISION = 5

import Foundation

class CONFIG {
    static let shared = CONFIG()
    
    enum UserData: String {
        case division
        case bestScore
    }
    
    var division: Int {
        get { return (getData(type: .division) as? Int ?? 4) }
        set { setData(type: .division, data: newValue) }
    }
    
    var bestScore: Int {
        get { return (getData(type: .bestScore) as? Int ?? 0) }
        set { setData(type: .bestScore, data: newValue) }
    }

    func setData<T>(type: UserData, data: T) {
        UserDefaults.standard.setValue(data, forKey: type.rawValue)
    }
    
    private func getData(type: UserData) -> Any? {
        return UserDefaults.standard.value(forKey: type.rawValue)
    }
}
