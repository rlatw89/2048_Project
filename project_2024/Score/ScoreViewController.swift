//
//  ScoreViewController.swift
//  project_2024
//
//  Created by Taewan_MacBook on 2021/07/10.
//

import UIKit

struct User {
    var nickName: String
    var score: Int
}

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var scoreTableView: UITableView!
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let nameList: [User] = [User(nickName: "twtw", score: 43018)]
    
    let viewModel = ScoreViewModel()
    
    let line = 50
                
    @IBAction func backAction(_ sender: Any) {
        guard let back = self.storyboard?.instantiateViewController(identifier: "Home") else { return }
        self.navigationController?.popViewController(animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestList(completion: {
            
        })
        setNavigationView()
    }
    
    private func setNavigationView() {
        navView.backgroundColor = .white
        
        titleLabel.text = "Score"
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        titleLabel.textColor = .black
        
        backButton.setTitle("< Back", for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
    }

}

extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return line
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = scoreTableView.dequeueReusableCell(withIdentifier: "rankList", for: indexPath) as? ScoreTableViewCell {
        
        let temp = nameList[indexPath.row]
        cell.nickNameLabel.text = "\(temp.nickName)"
        cell.scoreLabel.text = "\(temp.score)"
        
        cell.setLabelLayout()
        
        return cell
        } else {
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        scoreTableView.reloadRows(at: [indexPath], with: .none)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 { return UIView(frame: .zero) }
//        else {
//            let headerView = UIView()
//            headerView.backgroundColor = .lightGray
//            headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
//
//            let titleLabel = UILabel()
//            titleLabel.textColor = .black
//            titleLabel.text = "Header"
//            titleLabel.frame = CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
//
//            headerView.addSubview(titleLabel)
//
//            return headerView
//        }
//    }
}

class ScoreTableViewCell: UITableViewCell {
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func setLabelLayout() {
        rankLabel.textAlignment = .center
        rankLabel.textColor = .black
        rankLabel.backgroundColor = .none
        
        nickNameLabel.textAlignment = .center
        nickNameLabel.textColor = .black
        nickNameLabel.backgroundColor = .none
        
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .black
        scoreLabel.backgroundColor = .none
    }
}

class MyScoreTableViewCell: UITableViewCell {
    
}
