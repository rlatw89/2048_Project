//
//  MenuViewController.swift
//  project_2024
//
//  Created by 김태완 on 2021/05/19.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setButtonLayer() {
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.cornerRadius = 15
        
        scoreButton.layer.borderWidth = 1
        scoreButton.layer.borderColor = UIColor.black.cgColor
        scoreButton.layer.cornerRadius = 15
        
        settingButton.layer.borderWidth = 1
        settingButton.layer.borderColor = UIColor.black.cgColor
        settingButton.layer.cornerRadius = 15
    }
}
