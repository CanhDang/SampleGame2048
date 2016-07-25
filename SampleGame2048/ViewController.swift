//
//  ViewController.swift
//  SampleGame2048
//
//  Created by HuuLuong on 7/21/16.
//  Copyright © 2016 CanhDang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lbl_Score: UILabel!
    
    @IBOutlet weak var lbl_BestScore: UILabel!
    
    var score = 0
    
    var array = Array(count: 4, repeatedValue: Array(count: 4, repeatedValue: 0))
    
    let bestScoreKey = "bestScore"
    
    let arrayKey = "arrayOld"
    
    let currentScoreKey = "currentScore"
    
    var testArray = ["A","B"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let directions: [UISwipeGestureRecognizerDirection] = [.Right, .Left, .Up, .Down]
        
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
            
        }
        
        if let bestScoreKeyValue = PlistManager.sharedInstance.getValueForKey(bestScoreKey) {
            
            lbl_BestScore.text = bestScoreKeyValue as? String
        }
        
        if let currentScoreKeyValue = PlistManager.sharedInstance.getValueForKey(currentScoreKey) {
            if let lastScore = (currentScoreKeyValue as? String) {
                lbl_Score.text = lastScore
                score = (Int(lastScore))!
            }
        }
        
        if score == 0 {
            randomNum()
        }
        else {
            if let arrayValue = PlistManager.sharedInstance.getValueForKey(arrayKey) {
                if let lastArray = (arrayValue as? Array<Array<Int>>) {
                array = lastArray
                transfer()
                }
            }
        }

    }
    
    
    func randomNum() {
        var rnLableX = arc4random_uniform(4)
        var rnLableY = arc4random_uniform(4)
        let rdNum = arc4random_uniform(2) == 0 ? 2 : 4;
        var isChanged: Bool = false
        
        if array[Int(rnLableX)][Int(rnLableY)] == 0 {
            isChanged = true
        }
        
        if isArrayFull() == false {
            while (array[Int(rnLableX)][Int(rnLableY)] != 0) {
                rnLableX = arc4random_uniform(4)
                rnLableY = arc4random_uniform(4)
                isChanged = true
            }
        }
        if isChanged == true {
            array[Int(rnLableX)][Int(rnLableY)] = rdNum
        }
        transfer()
        
        lbl_Score.text = String(score)
        
        PlistManager.sharedInstance.saveValue(String(score), forKey: currentScoreKey)
        
        PlistManager.sharedInstance.saveValue(array, forKey: arrayKey)
    }
    
    
//    func readDataFromPlist() {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
//        let documentsDirectory = paths.objectAtIndex(0) as! NSString
//        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
//        
//        let dict = NSMutableDictionary(contentsOfFile: path)
//        
//        array = (dict![arrayKey] as? NSArray) as! Array<Array<Int>>
//        if let currentScoreValue =  dict![currentScoreKey] as? Int {
//            score = currentScoreValue
//        }
//        
//
//    }
//    
//    func saveDataToPlist() {
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
//        let documentsDirectory = paths.objectAtIndex(0) as! NSString
//        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
//        
//        var dict = NSMutableDictionary(contentsOfFile: path)
//        
//        dict!.setValue(array, forKey: "arrayOld")
//        dict!.setValue(score, forKey: currentScoreKey)
//        
//        dict!.writeToFile(path, atomically: false)
//        print(path)
//    }
    
    
    func isArrayFull() -> Bool{
        var check = true
        for row in 0...3 {
            for col in 0...3 {
                if array[row][col] == 0 {
                    check = false
                    break
                }
            }
        }
        return check
    }
    
    func convertNumLabel(numlabel: Int,let value: String) {
        let label = self.view.viewWithTag(numlabel) as! UILabel
        if value != "0" {
            label.text = value
        } else {
            label.text = ""
        }
        
        
    }
    func changeColor(numLabel: Int, color: UIColor) {
        let label = self.view.viewWithTag(numLabel) as! UILabel
        label.backgroundColor = color
    }
    
    func transfer() {
        for i in 0..<4 {
            for j in 0..<4 {
                let numlabel = 101 + (i*4) + j
                convertNumLabel(numlabel, value: String(array[i][j]))
                switch array[i][j] {
                case 0: changeColor(numlabel, color: UIColor.lightGrayColor())
                case 2:
                    changeColor(numlabel, color: UIColor.grayColor())
                case 4: changeColor(numlabel, color: UIColor.darkGrayColor())
                case 8: changeColor(numlabel, color: UIColor.brownColor())
                case 16: changeColor(numlabel, color: UIColor.blueColor())
                case 32: changeColor(numlabel, color: UIColor.greenColor())
                case 64: changeColor(numlabel, color: UIColor.yellowColor())
                case 128: changeColor(numlabel, color: UIColor.orangeColor())
                case 256: changeColor(numlabel, color: UIColor.purpleColor())
                case 512: changeColor(numlabel, color: UIColor.redColor())
                case 1024: changeColor(numlabel, color: UIColor.yellowColor())
                case 2048: changeColor(numlabel, color: UIColor.orangeColor())
                default:
                    changeColor(numlabel, color: UIColor.redColor())
                }
            }
        }
    }
    
    func checkUp(rowc: Int, colc: Int) -> Bool {
        var check = false
        if array[rowc][colc] == array[rowc-1][colc] {
            check = true
        }
        return check
    }
    
    func checkDown(rowc: Int, colc: Int) -> Bool {
        var check = false
        if array[rowc][colc] == array[rowc+1][colc] {
            check = true
        }
        return check
    }
    
    func checkRight(rowc: Int, colc: Int) -> Bool {
        var check = false
        if array[rowc][colc] == array[rowc][colc+1] {
            check = true
        }
        return check
    }
    
    func checkLeft(rowc: Int, colc: Int) -> Bool {
        var check = false
        if array[rowc][colc] == array[rowc][colc-1] {
            check = true
        }
        return check
    }
    
    
    func gameOver() -> Bool{
        var check = true
        if isArrayFull() {
            for col in 0...3 {
                for row in 0...3 {
                    
                    
                    if row > 0 && checkUp(row, colc: col) == true {
                        return false
                    }
                    
                    if row < 3 && checkDown(row, colc: col) == true {
                        return false
                    }
                    
                    if col > 0 && checkLeft(row, colc: col) == true {
                        return false
                    }
                    
                    if col < 3 && checkRight(row, colc: col) == true {
                        return false
                    }
            
                }
            }
        } else {
            check = false
        }
        
        return check
    }
    
    func checkGameOver() {
        
        if gameOver() {
            
            if let bestScoreKeyValue = PlistManager.sharedInstance.getValueForKey(bestScoreKey) {
                if Int(bestScoreKeyValue as! String) < score {
                    PlistManager.sharedInstance.saveValue(String(score), forKey: bestScoreKey)
                }
            }
            
            PlistManager.sharedInstance.saveValue("0", forKey: currentScoreKey)
            
            let alert = UIAlertController(title: "GameOver", message: "Play again?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                self.playAgain()
            }))
                
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func playAgain() {
        
        array = Array(count: 4, repeatedValue: Array(count: 4, repeatedValue: 0))
        
        score = 0
        
        let directions: [UISwipeGestureRecognizerDirection] = [.Right, .Left, .Up, .Down]
        
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
            
        }
        
        if let bestScoreKeyValue = PlistManager.sharedInstance.getValueForKey(bestScoreKey) {
            
            lbl_BestScore.text = bestScoreKeyValue as! String
        }
        
        randomNum()

    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Left:
                left()
                randomNum()
                print("left")
                checkGameOver()
            case UISwipeGestureRecognizerDirection.Right:
                right()
                randomNum()
                print("right")
                checkGameOver()
            case UISwipeGestureRecognizerDirection.Up:
                up()
                randomNum()
                print("up")
                checkGameOver()
            case UISwipeGestureRecognizerDirection.Down:
                down()
                randomNum()
                print("down")
                checkGameOver()
            default:
                break
            }
        }
    }
    
    func right(){
        for row in 0...3 {
            //for col in 3...0 
            for (var col = 2; col >= 0; col -= 1) {
                var moveCol = col
                
                if (array[row][col] == 0) {
                    continue
                }
                
                for (var colNext = col + 1; colNext < 4; colNext += 1) {
                    if (array[row][colNext] != 0 && array[row][colNext] != array[row][col]) {
                        break
                    } else {
                        moveCol = colNext
                    }
                }
                
                if (moveCol == col){
                    continue
                }
                
                if array[row][col] == array[row][moveCol] {
                    array[row][moveCol] *= 2
                    score += array[row][moveCol]
                } else {
                    array[row][moveCol] = array[row][col]
                }
                
                array[row][col] = 0
                
            }
        }
    }
    
    
    func left() {
        
        for row in 0...3 {
            for col in 1...3 {
                var moveCol = col
                
                if (array[row][col] == 0) {
                    continue
                }
                
                for (var colNext = col - 1; colNext > -1; colNext -= 1) {
                    if (array[row][colNext] != 0 && array[row][colNext] != array[row][col]) {
                        break
                    } else {
                        moveCol = colNext
                    }
                }
                
                if (moveCol == col){
                    continue
                }
                
                if array[row][col] == array[row][moveCol] {
                    array[row][moveCol] *= 2
                    score += array[row][moveCol]
                } else {
                    array[row][moveCol] = array[row][col]
                }
                
                array[row][col] = 0
                
            }
        }
    }
    
    
    func down() {
        for col in 0...3 {
            //for row in 3...0 
            for (var row = 2; row >= 0; row -= 1){
                
                var moveRow = row
                
                if (array[row][col] == 0) {
                    continue
                }
                
                for (var rowNext = row + 1; rowNext < 4 ; rowNext += 1 ) {
                    if (array[rowNext][col] != 0 && array[rowNext][col] != array[row][col]) {
                        break
                    } else {
                        moveRow = rowNext
                    }
                }
                
                if (moveRow == row) {
                    continue
                }
                
                if (array[row][col] == array[moveRow][col]) {
                    array[moveRow][col] *= 2
                    score += array[moveRow][col]
                } else {
                    array[moveRow][col] = array[row][col]
                }
                
                array[row][col] = 0
                
                
            }
        }

        
    }
    
    func up() {
        for (var col = 0; col < 4; col++) {
            for (var row = 1; row < 4; row++) {
                
                var moveRow = row
                
                if (array[row][col] == 0) {
                    continue
                }
                
                for (var rowNext = row - 1; rowNext > -1 ; rowNext -= 1 ) {
                    if (array[rowNext][col] != 0 && array[rowNext][col] != array[row][col]) {
                        break
                    } else {
                        moveRow = rowNext
                    }
                }
                
                if (moveRow == row) {
                    continue
                }
                
                if (array[row][col] == array[moveRow][col]) {
                    array[moveRow][col] *= 2
                    score += array[moveRow][col]
                } else {
                    array[moveRow][col] = array[row][col]
                }
                
                array[row][col] = 0
                
                
            }
        }
    }

}

