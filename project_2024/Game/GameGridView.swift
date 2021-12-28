//
//  GameGridView.swift
//  project_2024
//
//  Created by 김태완 on 2021/05/19.
//
import UIKit

struct NumberLabelComponent {
    var column: Int
    var row: Int
    var value: Int {
        didSet {
            label.text = "\(value)"
        }
    }
    var label: UILabel
}

// MARK: - Game Grid View


///
class GameGridView: UIView {
    let lineWidth: CGFloat = 2
    let division: Int = 5
    let group = DispatchGroup()
    
    var numbersLabels: [NumberLabelComponent] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    func initialize() {
        for label in numbersLabels {
            label.label.removeFromSuperview()
        }
        numbersLabels = []
    }
    
    func undo(data: [[NumberComponent?]]) {
        initialize()
        
        for i in 0 ..< data.count {
            for j in 0 ..< data[i].count {
                if let number = data[i][j]?.value {
                    createNewNumber(at: i, column: j, number: number)
                }
            }
        }
    }
    
    func reSet() {
        for comp in numbersLabels {
            comp.label.removeFromSuperview()
        }
        numbersLabels = []
    }
    
    func createNewNumber(at row: Int, column: Int, number: Int) {
        let targetRect = getRectFrame(at: row, column: column)
        
        let label = UILabel(frame: targetRect)
        label.backgroundColor = .white
        label.layer.cornerRadius = 5
        label.text = "\(number)"
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        numbersLabels.append(NumberLabelComponent(column: column, row: row, value: number, label: label))
    }
    
    func moveLabel(index: Int, column: Int, row: Int, state: NumberState) {
        self.numbersLabels[index].column = column
        self.numbersLabels[index].row = row
        UIView.animate(withDuration: 0.2, animations: {
            self.numbersLabels[index].label.frame = self.getRectFrame(at: row, column: column)
        }, completion: {
            _ in
            if  state == .merged {
                UIView.animate(withDuration: 0.1, animations: {
                    self.numbersLabels[index].label.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.numbersLabels[index].label.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }, completion: { _ in
                        self.group.leave()
                    })
                })
            }
            else {
                self.group.leave()
            }
        })
    }
    
    func moveLabels(data: [[NumberComponent?]], completion: @escaping () -> Void) {
        var merged: [Int] = []
        var deleteIndex: [Int] = []
        
        for i in 0 ..< numbersLabels.count {
            let col = numbersLabels[i].column
            let row = numbersLabels[i].row
            
            
            if let state = data[row][col]?.state,
               let nextPos = data[row][col]?.nextPos {
                group.enter()
                moveLabel(index: i, column: nextPos.col, row: nextPos.row, state: state)
                if state == .remove {
                    deleteIndex.append(i)
                }
                else if state == .merged {
                    merged.append(i)
                }
            }
            else {
                deleteIndex.append(i)
            }
        }
        
        group.notify(queue: .main, execute: {
            deleteIndex.sort()
            for index in merged {
                self.numbersLabels[index].value *= 2
            }
            for index in deleteIndex.reversed() {
                if self.numbersLabels.count <= index {
                    continue
                }
                self.numbersLabels[index].label.removeFromSuperview()
                self.numbersLabels.remove(at: index)
            }
            completion()
        })
    }
    
    func getRectFrame(at row: Int, column: Int) -> CGRect {
        let lineWidths = CGFloat(division + 1) * lineWidth
        let diameter = (bounds.width - lineWidths) / CGFloat(division)
        let originX = CGFloat(column) * (diameter + lineWidth) + lineWidth
        let originY = CGFloat(row) * (diameter + lineWidth) + lineWidth
        
        return CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: diameter, height: diameter))
        }
    
    func drawGridLayout(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(lineWidth)
        
        let yFrom = rect.minY + lineWidth / 2
        let xFrom = rect.minX + lineWidth / 2
        
        let yTo = rect.minY + rect.height - lineWidth / 2
        let xTo = rect.minX + rect.width - lineWidth / 2
        
        let height = yTo - yFrom
        let width = xTo - xFrom
        
        for i in 0 ..< (division + 1) {
            let xOrigin = CGPoint(x: rect.minX, y: 1 / CGFloat(division) * CGFloat(i) * height + yFrom)
            let xLineTo = CGPoint(x: rect.maxX, y: xOrigin.y)
            
            context?.move(to: xOrigin)
            context?.addLine(to: xLineTo)
            
            let yOrigin = CGPoint(x: 1 / CGFloat(division) * CGFloat(i) * width + xFrom, y: rect.minY)
            let yLineTo = CGPoint(x: yOrigin.x, y: rect.maxY)
            
            context?.move(to: yOrigin)
            context?.addLine(to: yLineTo)
        }
        context?.strokePath()
    }
}
