//
//  JLHomeView.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/3.
//

import UIKit
protocol JLHomeViewDelegate{
    func homeBtnClick(title:String)
}

class JLHomeView: UIScrollView {
    var homeViewDelegate:JLHomeViewDelegate?
    //列间距
    let interSpace = 15
    //行间距
    let lineSpace = 25
    //存放所有分组标题
    var dataArr:Array<String>?
    //存放所有分组按钮
    var itemArr:Array<UIButton> = Array<UIButton>()

    func updateLayout(){
        //按钮宽度
        let itemW = (self.frame.size.width - CGFloat(4*interSpace))/3.0
        //按钮高度
        let itemH = itemW/3*4
        //先将界面上已有按钮移除
        itemArr.forEach { element in
            element.removeFromSuperview()
        }
        //移除数组所有元素
        itemArr.removeAll()
        //进行布局
        if (dataArr != nil) && (dataArr!.count>0){
            //遍历数据
            for index in 0..<dataArr!.count{
                let btn = UIButton(type: .system)
                btn.setTitle(dataArr![index], for: .normal)
                btn.frame = CGRectMake(CGFloat(interSpace)+CGFloat(index%3)*(CGFloat(interSpace)+itemW), CGFloat(lineSpace)+CGFloat(index/3)*(CGFloat(lineSpace)+itemH), itemW, itemH)
                btn.layer.masksToBounds = true
                btn.layer.cornerRadius = 15.0
                btn.setTitleColor(.gray, for: .normal)
                btn.backgroundColor = kRGB(r: 1, g: 242, b: 216)
                btn.tag = index
                btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
                self.addSubview(btn)
                itemArr.append(btn)
            }
            //设置滚动时图内容尺寸
            self.contentSize = CGSize(width: 0, height: itemArr.last!.frame.origin.y+itemArr.last!.frame.size.height+CGFloat(lineSpace))
        }
    }
    
    @objc func btnClick(btn:UIButton){
        if homeViewDelegate != nil{
            homeViewDelegate?.homeBtnClick(title: dataArr![btn.tag])
        }
    }
    
}

