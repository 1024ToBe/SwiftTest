//
//  JLScreen.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/31.
//

import UIKit
//1.通过协议调用swift xib view
protocol CustomViewProtocol {
    var contentView :UIView! {get}
    func loadFromNib(for customViewName:String)
}

extension CustomViewProtocol where Self: UIView{
    func loadFromNib(for customViewName:String){
        Bundle.main.loadNibNamed(customViewName, owner: self)
        addSubview(contentView)
        contentView.backgroundColor = UIColor.red
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
}

class JLScreen: UIView,CustomViewProtocol{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var historyLb: UILabel!
    @IBOutlet weak var inputLb: UILabel!
    
    var inputStr = ""
    var historyStr = ""
    let numArr = ["0","1","2","3","4","5","6","7","8","9","."]
    let funArr = ["+","-","*","/","%","^"]
    override init(frame: CGRect) {
        super.init(frame: frame)
//        loadFromNib(for: "JLScreen")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNib(for: "JLScreen")
        
        //2.加载xib
//        contentView = Bundle.main.loadNibNamed("JLScreen", owner: self)?.last as! UIView
//        contentView.backgroundColor = UIColor.red
//        contentView.frame = bounds
//        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        addSubview(contentView)
    }
    
    func inputContent(content:String){
        if !numArr.contains(String(content.last!)) && !funArr.contains(content) {
            return;
        }
        if inputStr.count > 0{
            if numArr.contains(String(inputStr.last!)){
                inputStr.append(content)
                inputLb?.text = inputStr
            }else{
                if numArr.contains(String(content.last!)){
                    inputStr.append(content)
                    inputLb?.text = inputStr
                }
            }
        }else{//首次输入必须为数字
            if numArr.contains(String(content.last!)){
                inputStr.append(content)
                inputLb?.text = inputStr
            }
        }
    }
    
    func refreshHis(){
        historyStr = inputStr
        historyLb?.text = historyStr
    }
    
    //清空显示屏中当前输入的信息
    func clearContent(){
        inputStr = ""
    }
    
    //清空显示屏中上次输入的信息
    func deleteInput(){
        if inputStr.count>0{
            inputStr.remove(at: inputStr.index(before: inputStr.endIndex))
        }
    }
}


