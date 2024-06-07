//
//  JLCalculatorVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/31.
//

import UIKit

class JLCalculatorVC: JLBaseVC,JLBoardBtnDelegate {
    @IBOutlet weak var board: JLBoard!
    @IBOutlet weak var screen: JLScreen!
    override func viewDidLoad() {
        super.viewDidLoad()
        board.delegate = self
        // Do any additional setup after loading the view.
        
        //代码调用xib 自定义View
//        lazy var boardView : JLBoard = {
//            let view = JLBoard.initCustomView()
//            return view
//        }()
//
//        self.view .addSubview(boardView)
    }
    
    func boardBtnClick(content:String){
        //计算引擎实例
        let calculator = JLCalculatorEngine()
        //这个输入是否需要刷新显示屏
        var isNew = false
        
        //逻辑处理
        if content == "AC" || content == "Delete" || content == "="{
            switch content{
            case "AC":
                screen.clearContent()
                screen.refreshHis()
            case "Delete":
                screen.deleteInput()
            case "=":
                let result = calculator.calculatEquation(equation: screen.inputStr)
                screen.refreshHis()
                screen.clearContent()
                screen.inputContent(content: String(result))
                isNew = true
            default:
                screen.refreshHis()
            
            }
        }else{//仅输入处理
            if isNew {
                screen.clearContent()
                isNew = false
            }
            screen.inputContent(content: content)
        }
    }

}
