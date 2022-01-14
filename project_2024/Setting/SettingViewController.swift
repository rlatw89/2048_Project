//
//  SettingViewController.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/12/28.
//

import UIKit

class SettingViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Setting"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
