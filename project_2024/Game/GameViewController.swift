//
//  GameViewController.swift
//  project_2024
//
//  Created by 김태완 on 2021/05/19.
//

import UIKit

class GameViewController: UIViewController {
    
    let viewModel = GameViewModel()

    @IBOutlet weak var gameView: GameGridView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    /// HOME Button
    /// - Parameter sender: return MenuView
    @IBAction func homeEvent(_ sender: Any) {
        guard (self.storyboard?.instantiateViewController(identifier: "Home")) != nil else { return }
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func undoEvent(_ sender: Any) {
        viewModel.undo()
        gameView.undo(data: viewModel.numbers)
        
    }
    @IBAction func resetEvent(_ sender: Any) {
//        viewModel.reSet()
//        gameView.reSet()
    }
    
    @IBOutlet weak var scoreWrapper: UIView! {
        didSet { scoreWrapper.layer.cornerRadius = 8 }
    }
    @IBOutlet weak var bestscoreWrapper: UIView! {
        didSet { bestscoreWrapper.layer.cornerRadius = 8 }
    }
 
    var isAnimating: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        setButtonLayout()
    }
    
    private func setButtonLayout() {
        homeButton.layer.borderWidth = 1
        homeButton.layer.borderColor = UIColor.black.cgColor
        homeButton.backgroundColor = .green
        homeButton.layer.cornerRadius = 8
        
        undoButton.layer.borderWidth = 1
        undoButton.layer.borderColor = UIColor.black.cgColor
        undoButton.backgroundColor = .green
        undoButton.layer.cornerRadius = 8
        
        
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.black.cgColor
        resetButton.backgroundColor = .green
        resetButton.layer.cornerRadius = 8
    }
    
    private func configuration() {
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(gameViewScroll))
        gameView.addGestureRecognizer(gesture)
        
        createNewNumber()
    }
    
    @discardableResult
    private func createNewNumber() -> Bool {
        guard let newNumber = viewModel.createRandomNum() else {
            return false
        }
        DispatchQueue.main.async {
            self.gameView.createNewNumber(at: newNumber.curPos.row, column: newNumber.curPos.col, number: newNumber.value)
        }
        return true
    }
    
    @objc private func gameViewScroll(gesture: UIPanGestureRecognizer) {
        if isAnimating || gesture.state != .began { return }
        
        let verticalVelocity = gesture.velocity(in: gameView).y
        let horizontalVelocity = gesture.velocity(in: gameView).x
        
        let threshold: CGFloat = 100
        
        if abs(verticalVelocity) > abs(horizontalVelocity) && abs(verticalVelocity) > threshold {
            if viewModel.setMove(direction: verticalVelocity < 0 ? .up : .down) {
                isAnimating = true
                
                self.gameView.moveLabels(data: self.viewModel.numbers, completion: {
                    self.viewModel.merge()
                    self.createNewNumber()
                    self.isAnimating = false
                })
            }
        } else if abs(horizontalVelocity) > abs(verticalVelocity) && abs(horizontalVelocity) > threshold {
            if viewModel.setMove(direction: horizontalVelocity < 0 ? .left : .right) {
                isAnimating = true
                
                self.gameView.moveLabels(data: self.viewModel.numbers, completion: {
                    self.viewModel.merge()
                    self.createNewNumber()
                    self.isAnimating = false
                })
            }
        }
        else { isAnimating = false }
    }
}
