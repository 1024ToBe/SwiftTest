//
//  JLChineseChessVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/5.
//

import UIKit

class JLChineseChessVC: JLBaseVC,JLGameEngineDelegate {
    //开始游戏
    @IBOutlet weak var startGaneBtn: UIButton!
    //切换先行棋方按钮
    @IBOutlet weak var setFirstBtn: UIButton!
    //结局提示
    @IBOutlet weak var tipLb: UILabel!
    // 棋盘
    var chessBoard:JLChessBoard?
    // 游戏引擎
    var gameEngine:JLGameEngine?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chessBoard = JLChessBoard(origin: CGPoint(x: 20, y: 150))
        self.view.addSubview(chessBoard!)
        self.view .bringSubviewToFront(tipLb)
        
        //游戏引擎实例化
        gameEngine = JLGameEngine(board: chessBoard!)
        gameEngine?.delegate = self
    }
    
    //测试棋子
    @objc func itemClick(item:JLChessItem){
        if item.selectedState{
            item.setUnSelectedState()
        }else{
            item.setSelectedState()
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        tipLb.isHidden = true
        gameEngine?.startGame()
        setFirstBtn.backgroundColor = .gray
        setFirstBtn.isEnabled = false
    }
    
    @IBAction func setFirstGame(_ sender: UIButton) {
        if sender.title(for: .normal) == "红方行棋"{
            gameEngine?.setRedFirstMove(red: false)
            sender.setTitle("绿方行棋", for: .normal)
        }else{
            gameEngine?.setRedFirstMove(red: true)
            sender.setTitle("红方行棋", for: .normal)
        }
    }
    
    func gameOver(renWin: Bool) {
        if renWin{
            tipLb.text = "红方胜"
            tipLb.textColor = .red
        }else{
            tipLb.text = "绿方胜"
            tipLb.textColor = .green
        }
        tipLb.isHidden = false
        setFirstBtn.isEnabled = true
        setFirstBtn.backgroundColor = UIColor.green
    }
    
    func couldRedMove(red: Bool) {
        if red{
            setFirstBtn.setTitle("红方行棋", for: .normal)
        }else{
            setFirstBtn.setTitle("绿方行棋", for: .normal)
        }
    }
}
