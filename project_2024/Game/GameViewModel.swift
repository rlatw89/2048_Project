//
//  GameViewModel.swift
//  project_2024
//
//  Created by 김태완 on 2021/05/23.
//
import Foundation

enum ScrollDirection {
    case left
    case right
    case up
    case down
}

struct NumberPos {
    var col: Int
    var row: Int
    
    static func == (lhs: NumberPos, rhs: NumberPos?) -> Bool {
        return lhs.col == rhs?.col && lhs.row == rhs?.row
    }
    static func != (lhs: NumberPos, rhs: NumberPos?) -> Bool {
        return lhs.col != rhs?.col || lhs.row != rhs?.row
    }
    func printForm() -> String {
        return "(\(row), \(col))"
    }
}

enum NumberState {
    case new, stay, move, remove, merged
}

struct NumberComponent {
    var value: Int
    var curPos: NumberPos
    var nextPos: NumberPos?
    var state: NumberState
    
    func printForm() -> String {
        return "\(value), \(curPos.printForm()), \(nextPos?.printForm() ?? "nil"), \(state))"
    }
}

class GameViewModel {
    private let MAX_COLUMN: Int = 5
    private let MAX_ROW:Int = 5
    
    var numbers: [[NumberComponent?]]
    var undoNumbers: [[NumberComponent?]] = []
    var isFull: Bool {
        return !numbers.contains(where: { $0.contains(where: { $0 == nil })})
    }
    
    init() {
        numbers = Array(repeating: Array(repeating: nil, count: MAX_COLUMN), count: MAX_ROW)
    }
//    var isGameOver: Bool {
//        get {
//            for numbers in numbers {
//                if numbers.contains(nil) {
//                    return false
//                }
//            }
//            return true
//        }
//    }
    
    func undo() {
        self.numbers = undoNumbers.map { $0.map { $0} }
    }
    
    func reSet() {
        
    }
    
    /// createRandomNumber
    /// - Returns: <#description#>
    func createRandomNum() -> NumberComponent? {
        if isFull { return nil }
        
        let randRow = Int.random(in: 0 ..< MAX_ROW)
        let randCol = Int.random(in: 0 ..< MAX_COLUMN)
        if numbers[randRow][randCol] != nil {
            return createRandomNum()  //recursive function
        }
        else {
            numbers[randRow][randCol] = NumberComponent(
                value: 2,
                curPos: NumberPos(col: randCol, row: randRow),
                state: .new)
            
            return numbers[randRow][randCol]
        }
    }
    
    func setMove(direction: ScrollDirection) -> Bool {
        switch direction {
        case .left: return setMove()
        case .right: return setMove(reversed: true)
        case .up: return setMove(transposed: true)
        case .down: return setMove(reversed: true, transposed: true)
        }
    }
    
    private func setMove(reversed: Bool = false, transposed: Bool = false) -> Bool {
        let tempUndo = numbers.map { $0.map { $0} }
        
        var hasChanged: Bool = false
    
        let temp = transposed ? matrixTranspose(numbers) : numbers.map { $0.map { $0 } }
        for row in 0 ..< temp.count {
            var tempRow: [NumberComponent] = temp[row].compactMap { $0 }
            if reversed { tempRow = tempRow.reversed() }
            
            mergeIfNeeded(nums: &tempRow)
            
            for col in 0 ..< tempRow.count {
                let curPos = tempRow[col].curPos
                guard let nextPos = tempRow[col].nextPos else {
                    print("Someting Wrong")
                    return false
                }
                let next_col = reversed ? MAX_COLUMN - 1 - nextPos.col : nextPos.col
                let next_row = transposed ? MAX_ROW - 1 - nextPos.row : nextPos.row
                
                let next = transposed ? NumberPos(col: curPos.col, row: next_col) : NumberPos(col: next_col, row: next_row)
                numbers[curPos.row][curPos.col]?.nextPos = next
                
                if tempRow[col].state != .stay {
                    numbers[curPos.row][curPos.col]?.state = tempRow[col].state
                } else {
                    numbers[curPos.row][curPos.col]?.state = next == curPos ? .stay : .move
                }
                
                if curPos != next {
                    hasChanged = true
                }
            }
        }
        
        if hasChanged {
            undoNumbers = tempUndo
        }
        
        return hasChanged
    }
    
    func merge() {
        var result: [[NumberComponent?]] = Array(repeating: Array(repeating: nil, count: MAX_COLUMN), count: MAX_ROW)
        
        for row in 0 ..< numbers.count {
            for col in 0 ..< numbers.count {
                guard let num = numbers[row][col] else { continue }
                
                switch num.state {
                case .new, .stay:
                    result[row][col] = NumberComponent(value: num.value, curPos: num.curPos, nextPos: nil, state: .stay)
                case .move:
                    guard let nextPos = num.nextPos else {
                        print("Wrong")
                        return }
                    result[nextPos.row][nextPos.col] = NumberComponent(value: num.value, curPos: nextPos, nextPos: nil, state: .stay)
                case .remove:
                    continue
                case .merged:
                guard let nextPos = num.nextPos else {
                    print("Wrong")
                    return }
                    result[nextPos.row][nextPos.col] = NumberComponent(value: num.value * 2, curPos: nextPos, nextPos: nil, state: .stay)
                }
            }
        }
        numbers = result.map { $0.map { $0 } }
    }
    
    private func mergeIfNeeded(nums: inout [NumberComponent]) {
        if nums.count < 2 {
            if nums.count == 1 {
                nums[0].state = .stay
                nums[0].nextPos = NumberPos(col: 0, row: nums[0].curPos.row)
            }
            return
        }
        
        var i = 0
        var pos = 0
        
        while i < nums.count {
            if i < nums.count - 1 && nums[i].value == nums[i + 1].value {
                nums[i].state = .merged
                nums[i + 1].state = .remove
                nums[i].nextPos = NumberPos(col: pos, row: nums[i].curPos.row)
                nums[i + 1].nextPos = nums[i].nextPos
                i += 2
            }
            else {
                nums[i].state = .stay
                nums[i].nextPos = NumberPos(col: pos, row: nums[i].curPos.row)
                i += 1
            }
            pos += 1
        }
    }
    
    private func matrixTranspose<T>(_ matrix: [[T?]]) -> [[T?]] {
        if matrix.isEmpty { return matrix }
        var result = [[T?]] ()
        for i in 0 ..< matrix.first!.count {
            result.append(matrix.map { $0[i] })
        }
        return result
    }
    
    func printAll() {
        for row in 0 ..< numbers.count {
            for col in 0 ..< numbers[row].count {
                let num = numbers[row][col]
                print(num?.printForm() ?? "\t \t nil \t \t", terminator: "  ")
            }
            print()
        }
        print()
    }
}
