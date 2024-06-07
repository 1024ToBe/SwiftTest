//
//  JLChessItem.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/5.
//

import UIKit

class JLChessItem: UIButton {
    //标记棋子是否选中
    var selectedState:Bool = false
    //标记是否为红方棋子
    var isRed:Bool = true
    //自定义构造方法
    init(center: CGPoint) {
        let itemtSize = CGSizeMake((kScreenWidth-40)/9-4,(kScreenWidth-40)/9-4)
        super.init(frame: CGRect(origin: CGPoint(x: center.x-itemtSize.width/2, y: center.y-itemtSize.width/2), size: itemtSize))
        installUI()
    }
    required init?(coder: NSCoder) {
        fatalError("ini(coder:) has not been implemented")
    }
    
    //进行棋子UI的设计
    func installUI(){
        self.layer.borderWidth = 0.5
        self.layer.masksToBounds = true
        self.layer.cornerRadius = ((kScreenWidth-40)/9-4)/2
    }
    //设置棋子标题，isOwn属性决定是己方还是敌方
    func setTitle(title:String,isOwn:Bool){
        self.backgroundColor = .white
        self.setTitle(title, for: .normal)
        if isOwn{
            self.layer.borderColor = UIColor.red.cgColor
            self.setTitleColor(UIColor.red, for: .normal)
            self.isRed = true
        }else{
            self.layer.borderColor = UIColor.green.cgColor
            self .setTitleColor(UIColor.green, for: .normal)
            //敌方棋子要进行180度旋转
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.isRed = false
        }
    }

    //将棋子设置为选中状态
    func setSelectedState(){
        if !selectedState{
            selectedState = true
            self.backgroundColor = UIColor.purple
        }
    }
    
    //将棋子设置为非选中状态
    func setUnSelectedState(){
        if selectedState{
            selectedState = false
            self.backgroundColor = UIColor.white
        }
    }
}
