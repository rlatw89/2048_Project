//
//  ScoreViewModel.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/24.
//

import Alamofire

class ScoreViewModel {
    
    var idList: [UsersResponse] = []
    
    func requestList(completion: @escaping () -> Void) {
        
        APIManager.shared.request(
            Router(.users),
            of: BaseArrayResponse<UsersResponse>.self,
            completion: { response in
            
                if response.Success.code == 1000 {
                    self.idList = response.entities
                    completion()
                }
                else {
                    // error handle
                }
        })
        
    }
    
}

