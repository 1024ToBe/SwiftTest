//
//  JLChessBoard.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/5.
//

import UIKit
protocol JLChessBoardDelegate{
    //点击某个棋子
    func chessItemClick(item:JLChessItem)
    //棋子移动完成后触发
    func chessMoveEnd()
    //游戏结束的回调  参数传入true则代表红方胜
    func gameOver(redWin:Bool)
}

//棋盘类
class JLChessBoard: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(codet:) has not been implemented")
    }

    
    //代理
    var delegate:JLChessBoardDelegate?
    //棋盘上所有可以行棋的位置标记的实例数组
    var tipBtnArr = Array<JLTipBtn>()
    //当前行棋可以前进的矩阵位置
    var currentCanMovePosition = Array<(Int,Int)>()
    //单个格子宽度
    let width = (kScreenWidth-40)/9
    let allRedChess = ["車","馬","相","仕","帥","仕","相","馬","車","炮","炮","兵","兵","兵","兵","兵"]
    let allGreenChess = ["车","马","象","士","将","士","象","马","车","炮","炮","卒","卒","卒","卒","卒"]
    //棋盘上所剩下的红方棋子对象
    var currentRedItem = Array<JLChessItem>()
    //棋盘上所剩下的绿方棋子对象
    var currentGreenItem = Array<JLChessItem>()
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(0.5)
        //绘制水平线
        for index in 0...9{
            //通过移动点来确定每行的起点
            context?.move(to: CGPoint(x: width/2, y: width/2+width*CGFloat(index)))
            //从左向右绘制水平线
            context?.addLine(to: CGPoint(x: rect.size.width-width/2, y: width/2+width*CGFloat(index)))
            context?.drawPath(using: .stroke)
        }
        
        //竖线绘制
        for index in 0..<9{
            //最左边和最右边的线贯穿始终
            if index==0 || index==8 {
                context?.move(to: CGPoint(x: width/2+width*CGFloat(index), y: width/2))
                context?.addLine(to: CGPoint(x: width*CGFloat(index)+width/2, y: rect.size.height-width/2))
            }else{//中间的线以楚河汉界为分隔
                context?.move(to: CGPoint(x: width/2+width*CGFloat(index), y: width/2))
                context?.addLine(to: CGPoint(x: width*CGFloat(index)+width/2, y: rect.size.height/2-width/2))
                
                context?.move(to: CGPoint(x: width/2+width*CGFloat(index), y: rect.size.height/2+width/2))
                context?.addLine(to: CGPoint(x: width*CGFloat(index)+width/2, y: rect.size.height-width/2))
            }
        }
        
        // 绘制双方主帅田字格
        context?.move(to: CGPoint(x: width/2+width*3, y: width/2))
        context?.addLine(to: CGPoint(x: width/2+width*5, y: width/2+width*2))
        context?.move(to: CGPoint(x: width/2+width*5, y: width/2))
        context?.addLine(to: CGPoint(x: width/2+width*3, y: width/2+width*2))
        context?.move(to: CGPoint(x: width/2+width*3, y: width*10-width/2))
        context?.addLine(to: CGPoint(x: width/2+width*5, y: width*10-width/2-width*2))
        
        context?.move(to: CGPoint(x: width/2+width*5, y: width*10-width/2))
        context?.addLine(to: CGPoint(x: width/2+width*3, y: width*10-width/2-width*2))
        context?.drawPath(using: .stroke)
    }
    
    init(origin:CGPoint){
        //根据屏幕宽度计算棋盘宽度
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: kScreenWidth-40, height: width*10))
        //设置棋盘背景色
        self.backgroundColor = UIColor(red: 1, green: 252/255.0, blue: 234/255.0, alpha: 1)
        //楚河汉界标签
        let lb1 = UILabel(frame: CGRect(x: width, y: width*9/2, width: width*3, height: width))
        lb1.backgroundColor = .clear
        lb1.text = "楚河"
        self.addSubview(lb1)
        
        //楚河汉界标签
        let lb2 = UILabel(frame: CGRect(x: width*5, y: width*9/2, width: width*3, height: width))
        lb2.backgroundColor = .clear
        lb2.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        lb2.text = "漢界"
        self.addSubview(lb2)
        
        //进行游戏重置
        reStartGame()
    }
   
    func reStartGame(){
        //清理所有提示点
        tipBtnArr.forEach { (item) in
            item.removeFromSuperview()
        }
        tipBtnArr .removeAll()
        //取消所有棋子的选中状态
        self.cancelAllSelect()
        
        //清理残局
        currentGreenItem.forEach { (item) in
            item.removeFromSuperview()
        }
        currentRedItem.forEach { (item) in
            item.removeFromSuperview()
        }
        currentGreenItem.removeAll()
        currentRedItem.removeAll()
        
        //棋子布局
        var redItem:JLChessItem?
        var greenItem:JLChessItem?
        //红绿双方各有16个棋子
        for index in 0..<16{
            //进行非兵 非炮棋子的布局
            if index<9{
                //红方布局
                redItem = JLChessItem(center: CGPoint(x: width/2+width*CGFloat(index), y:width*10-width/2))
                redItem?.setTitle(title: allRedChess[index], isOwn: true)
                
                //绿方布局
                greenItem = JLChessItem(center: CGPoint(x: width/2+width*CGFloat(index), y:width/2))
                greenItem?.setTitle(title: allGreenChess[index], isOwn: false)
            } else if index<11{//进行炮 棋子的绘制
                if index==9{
                    redItem = JLChessItem(center: CGPoint(x: width/2+width, y: width*10-width/2-width*2))
                    redItem?.setTitle(title: allRedChess[index], isOwn: true)
                    
                    greenItem = JLChessItem(center: CGPoint(x: width/2+width, y: width/2+width*2))
                    greenItem?.setTitle(title: allGreenChess[index], isOwn: false)
                }else{
                    redItem = JLChessItem(center: CGPoint(x: width*9-width/2-width, y: width*10-width/2-width*2))
                    redItem?.setTitle(title: allRedChess[index], isOwn: true)
                    
                    greenItem = JLChessItem(center: CGPoint(x: width*9-width/2-width, y: width/2+width*2))
                    greenItem?.setTitle(title: allGreenChess[index], isOwn: false)
                }
            }else {//进行兵 棋子的布局
                redItem = JLChessItem(center: CGPoint(x: width/2+width*2*CGFloat(index-11), y:width*10-width/2-width*3))
                redItem?.setTitle(title: allRedChess[index], isOwn: true)
                
                greenItem = JLChessItem(center:  CGPoint(x: width/2+width*2*CGFloat(index-11), y:width/2+width*3))
                greenItem?.setTitle(title: allGreenChess[index], isOwn: false)
            }
            
            self.addSubview(redItem!)
            self.addSubview(greenItem!)
            currentRedItem.append(redItem!)
            currentGreenItem.append(greenItem!)
            redItem?.addTarget(self, action: #selector(itemClick(item:)), for: .touchUpInside)
            greenItem?.addTarget(self, action: #selector(itemClick(item:)), for: .touchUpInside)
        }
    }
        
    @objc func itemClick(item:JLChessItem){
        if delegate != nil{
            delegate?.chessItemClick(item: item)
        }
    }
    
    //取消所有棋子的选中状态
    func cancelAllSelect(){
        currentRedItem.forEach { (item) in
            item.setUnSelectedState()
        }
        currentGreenItem.forEach { (item) in
            item.setUnSelectedState()
        }
    }
    
    //将棋子坐标映射为二维矩阵中的点
    func transfromPositionToMatrix(item:JLChessItem)->(Int,Int){
        let res = (Int(item.center.x-width/2)/Int(width),Int(item.center.y-width/2)/Int(width))
        return res
    }
    
    //获取棋盘上所有红方棋子在二维矩阵中位置的数组
    func getAllRedMatrixList()->[(Int,Int)]{
        var list = Array<(Int,Int)>()
        currentRedItem.forEach { (item) in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    //获取棋盘上所有绿方棋子在二维矩阵中位置的数组
    func getAllGreenMatrixList()->[(Int,Int)]{
        var list = Array<(Int,Int)>()
        currentGreenItem.forEach { (item) in
            list.append(self.transfromPositionToMatrix(item: item))
        }
        return list
    }
    
    //将可以移动到的位置进行标记
    func wantMoveItem(positions:[(Int,Int)],item:JLChessItem){
        //如果是红方，且在路径上有己方棋子 则不能移动
        var list:Array<(Int,Int)>?
        if item.isRed {
            list = getAllRedMatrixList()
        }else{
            list = getAllGreenMatrixList()
        }
        currentCanMovePosition.removeAll()
        positions.forEach { (position) in
            if list!.contains(where: { (pos)->Bool in
                if pos == position{
                    return true
                }
                return false
            }){
            }else{
                currentCanMovePosition.append(position)
            }
        }
        
        //将可以进行前进的位置使用按钮进行标记
        tipBtnArr.forEach { (item) in
            item.removeFromSuperview()
        }
        tipBtnArr.removeAll()
        for index in 0..<currentCanMovePosition.count{
            //将矩阵转换成位置坐标
            let position = currentCanMovePosition[index]
            let center = CGPoint(x: CGFloat(position.0)*width+width/2, y: CGFloat(position.1)*width+width/2)
            let tip = JLTipBtn(center: center)
            tip.addTarget(self, action: #selector(moveItem(tipBtn:)), for: .touchUpInside)
            tip.tag = 100+index
            self.addSubview(tip)
            tipBtnArr.append(tip)
        }
    }
    
    
    @objc func moveItem(tipBtn:JLTipBtn){
        //得到要移动的位置
        let position = currentCanMovePosition[tipBtn.tag-100]
        //转换成坐标
        let point = CGPoint(x: CGFloat(position.0)*width+width/2, y: CGFloat(position.1)*width+width/2)
        //找到被选中的棋子
        var isRed:Bool?
        currentRedItem.forEach { (item) in
            if item.selectedState{
                isRed = true
                //进行动画移动
                UIView.animate(withDuration: 0.3) {
                    item.center = point
                }
            }
        }
        
        currentGreenItem.forEach { (item) in
            if item.selectedState{
                isRed = false
                //进行动画移动
                UIView.animate(withDuration: 0.3) {
                    item.center = point
                }
            }
        }
        
        //检查是否有敌方棋子，如果有，吃掉对方棋子
        var shouldDeleItem:JLChessItem?
        if isRed!{
            currentGreenItem.forEach { (item) in
                if transfromPositionToMatrix(item: item) == position{
                    shouldDeleItem = item
                }
            }
        }else{
            currentRedItem.forEach { (item) in
                if transfromPositionToMatrix(item: item) == position{
                    shouldDeleItem = item
                }
            }
        }
        
        if let it = shouldDeleItem{
            it.removeFromSuperview()
        
            if isRed!{
                currentGreenItem.remove(at: currentGreenItem.firstIndex(of: it)!)
            }else{
                currentRedItem.remove(at: currentRedItem.firstIndex(of: it)!)
            }
            
            //胜负判断逻辑
            if it.title(for: .normal) == "将"{
                if delegate != nil {
                    delegate!.gameOver(redWin: true)
                }
                
            }
            
            if it.title(for: .normal) == "帥"{
                if delegate != nil {
                    delegate!.gameOver(redWin: false)
                }
                
            }
        }
        
       
        
        //将标记移除
        tipBtnArr.forEach { (item) in
            item.removeFromSuperview()
        }
        tipBtnArr.removeAll()
        if delegate != nil {
            delegate?.chessMoveEnd()
        }
    }
    
}

