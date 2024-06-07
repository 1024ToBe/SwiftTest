//
//  JLBoard.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/31.
//

import UIKit
import SnapKit
protocol JLBoardBtnDelegate {
    func boardBtnClick(content:String)
}


class JLBoard: UIView {
    //代码调用
//    class func initCustomView()->JLBoard{
//        let view = Bundle.main.loadNibNamed("JLBoard", owner: nil)?.first as! JLBoard
//        return view
//    }
    var delegate:JLBoardBtnDelegate?
    var dataArr = [
        "0",".","%","=",
        "1","2","3","+",
        "4","5","6","-",
        "7","8","9","*",
        "AC","Delete","^","/",
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        installUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        installUI()
    }
    
    func installUI() -> Void {
        var frontBtn : JLFuncBtn!
        for index in 0..<dataArr.count{
            let btn = JLFuncBtn()
            self.addSubview(btn)
            btn.snp.makeConstraints { make in
                //每一行第一个，x=0
                if index%4 == 0 {
                    make.left.equalTo(0)
                }else{
                    make.left.equalTo(frontBtn.snp.right)
                }
                //第一行 bottom=0
                if index/4 == 0{
                    make.bottom.equalTo(0)
                }else if index%4 == 0{//非第一行左边第一个按钮
                    make.bottom.equalTo(frontBtn.snp.top)
                }else{
                    make.bottom.equalTo(frontBtn.snp.bottom)
                }
                
                make.width.equalTo(btn.superview!.snp.width).multipliedBy(0.25)
                make.height.equalTo(btn.superview!.snp.height).multipliedBy(0.2)
            }
            btn.tag = index + 100
            btn.addTarget(self, action: #selector(btnClick(button:)), for: .touchUpInside)
            btn.setTitle(dataArr[index], for: UIControl.State.normal)
            frontBtn = btn
        }
    }
    
    @objc func btnClick(button:JLFuncBtn){
        print(button.title(for: .normal) ?? "")
        if delegate != nil{
            delegate?.boardBtnClick(content: button.currentTitle!)
        }
    }
    
}
