//
//  ScoreViewController.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/10.
//

import UIKit

class ScoreViewController: UIViewController {
    let viewModel = ScoreViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SCORE"
        
        viewModel.requestList(completion: {
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
