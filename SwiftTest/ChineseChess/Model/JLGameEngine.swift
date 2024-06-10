//
//  JLGameEngine.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/6.
//

import UIKit
protocol JLGameEngineDelegate{
    func gameOver(renWin:Bool)
    
    //当前行棋的一方改变时调用
    func couldRedMove(red:Bool)
}

class JLGameEngine: NSObject,JLChessBoardDelegate {

    var delegate:JLGameEngineDelegate?
    //开始游戏的表标记
    var isStarting = false
    //当前游戏棋盘
    var gameBoard:JLChessBoard?
    //设置是否红方先走，默认true
    var redFirstMove = true
    //标记当前需要行棋的一方
    var shouldRedRemove = true
    
    //行棋路径数组
    let checkMoveDic:[String:[[(Int,Int)]]] = [
        "兵":[[(0,-1)],[(0,-1)],[(-1,0)],[(1,0)]],
        //第一个元素是没过界前的可行算法，第二个元素是过界之后的
        "卒":[[(0,1)],[(0,1)],[(-1,0)],[(1,0)]],
        
        "将":[[(0,1)],[(0,-1)],[(1,0)],[(-1,0)]],
        "帥":[[(0,1)],[(0,-1)],[(1,0)],[(-1,0)]],
        
        "仕":[[(1,1)],[(-1,-1)],[(-1,1)],[(1,-1)]],
        "士":[[(1,1)],[(-1,-1)],[(-1,1)],[(1,-1)]],
        
        "相":[[(2,2)],[(-2,-2)],[(2,-2)],[(-2,2)]],
        "象":[[(2,2)],[(-2,-2)],[(2,-2)],[(-2,2)]],
        
        "马":[[(1,2)],[(1,-2)],[(2,1)],[(2,-1)],[(-1,2)],[(-1,-2)],[(-2,1)],[(-2,-1)]],
        "馬":[[(1,2)],[(1,-2)],[(2,1)],[(2,-1)],[(-1,2)],[(-1,-2)],[(-2,1)],[(-2,-1)]]
    ]
    
    init(board:JLChessBoard){
        gameBoard = board
        super.init()
        gameBoard?.delegate = self
    }
    
    //开始游戏
    func startGame(){
        isStarting = true
        gameBoard?.reStartGame()
        shouldRedRemove = redFirstMove
        if delegate != nil {
            delegate?.couldRedMove(red: shouldRedRemove)
        }
    }
    //设置先行棋的一方
    func setRedFirstMove(red:Bool){
        redFirstMove = red
        shouldRedRemove = red
    }
    
  
    
    //点击棋子的回调
    func chessItemClick(item: JLChessItem) {
        //判断点击的棋子是否是应该行棋的一方
        if shouldRedRemove{
            if item.isRed{
                gameBoard?.cancelAllSelect()
                item.setSelectedState()
            }else{
                return
            }
        }else{
            if !item.isRed{
                gameBoard?.cancelAllSelect()
                item.setSelectedState()
            }else{
                return
            }
        }
        //进行行棋的算法
        checkCanMove(item: item)
    }
    
    //检测可以移动的位置
    /*func checkCanMove(item:JLChessItem){
        // 获取棋子在二维矩阵中的位置
        let position = gameBoard!.transfromPositionToMatrix(item: item)
        let name = item.title(for: .normal)!
        var wantMoveList:[(Int,Int)]?
        if name != "车" && name != "車" && name != "炮"{
                //判断棋子是否过界
            if(item.isRed && position.1<5) || (!item.isRed && position.1>4){
                //过界
                if checkMoveDic.count>1{
                    wantMoveList = checkMoveDic[name]!.last
                }else{
                    wantMoveList = checkMoveDic[name]!.first
                }
            }else{
                //没过界
                wantMoveList = checkMoveDic[name]!.first
            }
            calcuateNormalItemPosition(wantMove: wantMoveList!, position: position, item: item)
        }else{
            calcuateSpecItemPosition(item: item)
        }
    }
    
    func calcuateNormalItemPosition(wantMove:[(Int,Int)],position:(Int,Int),item:JLChessItem){
        // 构造行棋位置数组
        var couldMove = Array<(Int,Int)>()
        let redList = gameBoard!.getAllRedMatrixList()
        let greenList = gameBoard!.getAllGreenMatrixList()
        let name = item.title(for: .normal)!
        if name == "兵" || name == "卒"{
            wantMove.forEach ({ (pos) in
                let newPos = (position.0+pos.0,position.1+pos.1)
                if newPos.0<0 || newPos.0>8 || newPos.1<0 || newPos.1>9{
                    
                }else{
                    couldMove.append(newPos)
                }
            })
        }
        
        if name == "将" || name == "仕"{
            wantMove.forEach ({ (pos) in
                let newPos = (position.0+pos.0,position.1+pos.1)
                if newPos.0<3 || newPos.0>5 || newPos.1<0 || newPos.1>2{
                    
                }else{
                    couldMove.append(newPos)
                }
            })
        }
        
        if name == "帥" || name == "士"{
            wantMove.forEach { (pos) in
                let newPos = (position.0+pos.0,position.1+pos.1)
                if newPos.0<3 || newPos.0>5 || newPos.1<7 || newPos.1>9{
                    
                }else{
                    couldMove.append(newPos)
                }
            }
        }
        
        if name == "相" {
            wantMove.forEach { (pos) in
                let newPos = (position.0+pos.0,position.1+pos.1)
                if newPos.0<0 || newPos.0>8 || newPos.1<5 || newPos.1>9{
                    
                }else{
                    if redList.contains(where: { (po)->Bool in
                        return po == (position.0+pos.0/2,position.1+pos.1/2)
                    }) || greenList.contains(where: { (po)->Bool in
                        return po == (position.0+pos.0/2,position.1+pos.1/2)
                    }){
                        //塞象眼，不添加此位置
                    }else{
                        couldMove.append(newPos)
                    }
                }
            }
        }
        
        if name == "象" {
            wantMove.forEach { (pos) in
                let newPos = (position.0+pos.0,position.1+pos.1)
                if newPos.0<0 || newPos.0>8 || newPos.1<0 || newPos.1>4{
                    
                }else{
                    if redList.contains(where: { (po)->Bool in
                        return po == (position.0+pos.0/2,position.1+pos.1/2)
                    }) || greenList.contains(where: { (po)->Bool in
                        return po == (position.0+pos.0/2,position.1+pos.1/2)
                    }){
                        //塞象眼，不添加此位置
                    }else{
                        couldMove.append(newPos)
                    }
                }
            }
        }
        
        if name == "馬" ||  name == "马" {
            wantMove.forEach { (pos) in
                let newPos = (position.0+pos.0,position.1+pos.1)
                if newPos.0<0 || newPos.0>8 || newPos.1<0 || newPos.1>9{
                    
                }else{
                    let tmpPo:(Int,Int)?
                    if abs(pos.0)<abs(pos.1){
                        tmpPo = (position.0,position.1+pos.1/2)
                    }else{
                        tmpPo = (position.0+pos.0/2,position.1)
                    }
                   
                    if redList.contains(where: { (po)->Bool in
                        return po == tmpPo!
                    }) || greenList.contains(where: { (po)->Bool in
                        return po == tmpPo!
                    }){
                        //蹩马腿，不添加此位置
                    }else{
                        couldMove.append(newPos)
                    }
                }
            }
        }
        
        //交换给棋盘类进行 移动提示
        gameBoard?.wantMoveItem(positions: couldMove, item: item)
        
    }
    func calcuateSpecItemPosition(item:JLChessItem){
        // 获取棋子在二维矩阵中的位置
        let position = gameBoard!.transfromPositionToMatrix(item: item)
        var wantMove = Array<(Int,Int)>()
        let redList = gameBoard!.getAllRedMatrixList()
        let greenList = gameBoard!.getAllGreenMatrixList()
        let name = item.title(for: .normal)!
        //车 車 沿水平和竖直 两个方向行棋
        if name == "车" || name == "車"{
            //沿水平和竖直 两个方向行棋
            var temP = position
            while temP.0-1>=0{
                //如果有棋子则退出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })){
                    wantMove.append((temP.0-1,temP.1))
                    break
                }else{
                    wantMove.append((temP.0-1,temP.1))
                }
                temP.0 -= 1
            }
            temP = position
            
            while temP.0+1<=8{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })){
                    wantMove.append((temP.0+1,temP.1))
                    break
                }else{
                    wantMove.append((temP.0+1,temP.1))
                }
                temP.0 += 1
            }
            temP = position
            
            while temP.1+1<=9{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })){
                    wantMove.append((temP.0,temP.1+1))
                    break
                }else{
                    wantMove.append((temP.0,temP.1+1))
                }
                temP.1 += 1
            }
            temP = position
            
            while temP.1-1>=0{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })){
                    wantMove.append((temP.0,temP.1-1))
                    break
                }else{
                    wantMove.append((temP.0,temP.1-1))
                }
                temP.1 -= 1
            }
        }
        
        //炮 沿水平和竖直 两个方向行棋，
        if name == "炮"{
            //沿水平和竖直 两个方向行棋
            var temP = position
            var isFirst = true
            while temP.0-1>=0{
                //如果有棋子则找出其后面的最近一颗棋子，之后推出循环（隔一个棋子吃子）
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0-1,temP.1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0-1,temP.1))
                    }
                }
                temP.0 -= 1
            }
            temP = position
            isFirst = true
            
            while temP.0+1<=8{
                //如果有棋子则退出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0+1,temP.1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0+1,temP.1))
                    }
                }
                temP.0 += 1
            }
            temP = position
            isFirst = true
            
            while temP.1+1<=9{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0,temP.1+1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0,temP.1+1))
                    }
                }
                temP.1 += 1
            }
            temP = position
            isFirst = true
            
            while temP.1-1>=0{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0,temP.1-1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0,temP.1-1))
                    }
                }
                temP.1 -= 1
            }
        }
        
        //交换给棋盘类进行 移动提示
        gameBoard?.wantMoveItem(positions: wantMove, item: item)
    }*/
    
    func checkCanMove(item:JLChessItem){
        //进行“兵”行棋算法
        if item.title(for: .normal) == "兵"{
            // 获取棋子在二维矩阵中的位置
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            //如果没有过界 那么“b”只能前进
            var wantMove = Array<(Int,Int)>()
            if position.1>4{
                wantMove = [(position.0,position.1-1)]
            }else{
                //左右前
                if position.0>0{
                    wantMove.append((position.0-1,position.1))
                }
                if position.0<8{
                    wantMove.append((position.0+1,position.1))
                }
                if position.1>0{
                    wantMove.append((position.0,position.1-1))
                }
            }
            
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "卒"{
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            if position.1<5{
                wantMove = [(position.0,position.1+1)]
            }else{
                //左、右、前
                if position.0>0{
                    wantMove.append((position.0-1,position.1))
                }
                if position.0<8{
                    wantMove.append((position.0+1,position.1))
                }
                if position.1<9{
                    wantMove.append((position.0,position.1+1))
                }
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        //士 仕
        if item.title(for: .normal) == "士"{//只能斜线走一格
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            //左上 右上 左下 右下
            if position.0<5 &&  position.1>7{
                wantMove = [(position.0+1,position.1-1)]
            }
            if position.0>3 &&  position.1<9{
                wantMove.append((position.0-1,position.1+1))
            }
            if position.0>3 &&  position.1<7{
                wantMove.append((position.0-1,position.1-1))
            }
            if position.0<5 &&  position.1<9{
                wantMove.append((position.0+1,position.1+1))
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "仕"{//只能斜线走一格
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            //左上 右上 左下 右下
            if position.0<5 &&  position.1<2{
                wantMove = [(position.0+1,position.1+1)]
            }
            if position.0>3 &&  position.1>0{
                wantMove.append((position.0-1,position.1-1))
            }
            if position.0>3 &&  position.1<2{
                wantMove.append((position.0-1,position.1+1))
            }
            if position.0<5 &&  position.1>0{
                wantMove.append((position.0+1,position.1-1))
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        //帥 将
        if item.title(for: .normal) == "帥"{//只能横/竖走一格
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            //上 下 左 右
            if position.1<9{
                wantMove = [(position.0,position.1+1)]
            }
            if position.1>7{
                wantMove.append((position.0,position.1-1))
            }
            if position.0<5{
                wantMove.append((position.0+1,position.1))
            }
            if position.0>3{
                wantMove.append((position.0-1,position.1))
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "将"{//只能横/竖走一格
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            //上 下 左 右
            if position.1<2{
                wantMove = [(position.0,position.1+1)]
            }
            if position.1>0{
                wantMove.append((position.0,position.1-1))
            }
            if position.0<5{
                wantMove.append((position.0+1,position.1))
            }
            if position.0>3{
                wantMove.append((position.0-1,position.1))
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        //相 象 象飞田（循对角线走两格）
        if item.title(for: .normal) == "相"{//只能横/竖走一格
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            
            //左上 右上 左下 右下
            if position.0-2>=0 && position.1-2>4{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1-1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1-1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0-2,position.1-2))
                }
            }
            if position.0+2<=8 && position.1+2<=9{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1+1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1+1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0+2,position.1+2))
                }
            }
            if position.0+2<=8 && position.1+2>4{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1-1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1-1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0+2,position.1-2))
                }
            }
            if position.0+2>=0 && position.1+2<=9{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1+1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1+1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0-2,position.1+2))
                }
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        if item.title(for: .normal) == "象"{//只能横/竖走一格
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            
            //左上 右上 左下 右下
            if position.0-2>=0 && position.1-2>=0{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1-1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1-1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0-2,position.1-2))
                }
            }
            if position.0+2<=8 && position.1+2<=4{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1+1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1+1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0+2,position.1+2))
                }
            }
            if position.0+2<=8 && position.1-2>=0{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1-1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1-1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0+2,position.1-2))
                }
            }
            if position.0+2>=0 && position.1+2<=4{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1+1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1+1)
                }){
                    //塞象眼，不添加此位置
                }else{
                    wantMove.append((position.0-2,position.1+2))
                }
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        //马 馬
        if item.title(for: .normal) == "马" || item.title(for: .normal) == "馬"{//一直一斜 馬走日
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            
            //日字行走 8个方向 上 下 左 右各两个方向
            if position.0-1>=0 && position.1-2>=0{
                //判断是否有棋子蹩马腿
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1-1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1-1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0-1,position.1-2))
                }
            }
            if position.0+1<=8 && position.1-2>=0{
                //判断是否有棋子蹩马腿
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1-1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1-1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0+1,position.1-2))
                }
            }
            if position.0+2<=8 && position.1-1>=0{
                //判断是否有棋子蹩马腿
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0+2,position.1-1))
                }
            }
            if position.0+2<=8 && position.1+1<=9{
                //判断是否有棋子蹩马腿
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0+1,position.1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0+2,position.1+1))
                }
            }
            
            if position.0+1<=8 && position.1+2<=9{
                //判断是否有棋子蹩马腿
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1+1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1+1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0+1,position.1+2))
                }
            }
            
            if position.0-1>=0 && position.1+2<=9{
                //判断是否有棋子塞象眼
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1+1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0,position.1+1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0-1,position.1+2))
                }
            }
            
            if position.0-2>=0 && position.1+1<=9{
                //判断是否有棋子蹩马腿
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0-2,position.1+1))
                }
            }
            
            if position.0-2>=0 && position.1-1>=0{
                //判断是否有棋子蹩马腿
                if redList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1)
                }) || greenList.contains(where: { (pos)->Bool in
                    return pos == (position.0-1,position.1)
                }){
                    //蹩马腿，不添加此位置
                }else{
                    wantMove.append((position.0-2,position.1-1))
                }
            }
            
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        //车 車 沿水平和竖直 两个方向行棋
        if item.title(for: .normal) == "车" || item.title(for: .normal) == "車"{
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            
            //沿水平和竖直 两个方向行棋
            var temP = position
            while temP.0-1>=0{
                //如果有棋子则退出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })){
                    wantMove.append((temP.0-1,temP.1))
                    break
                }else{
                    wantMove.append((temP.0-1,temP.1))
                }
                temP.0 -= 1
            }
            temP = position
            
            while temP.0+1<=8{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })){
                    wantMove.append((temP.0+1,temP.1))
                    break
                }else{
                    wantMove.append((temP.0+1,temP.1))
                }
                temP.0 += 1
            }
            temP = position
            
            while temP.1+1<=9{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })){
                    wantMove.append((temP.0,temP.1+1))
                    break
                }else{
                    wantMove.append((temP.0,temP.1+1))
                }
                temP.1 += 1
            }
            temP = position
            
            while temP.1-1>=0{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })){
                    wantMove.append((temP.0,temP.1-1))
                    break
                }else{
                    wantMove.append((temP.0,temP.1-1))
                }
                temP.1 -= 1
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
        
        //炮 沿水平和竖直 两个方向行棋，
        if item.title(for: .normal) == "炮"{
            let position = gameBoard!.transfromPositionToMatrix(item: item)
            var wantMove = Array<(Int,Int)>()
            let redList = gameBoard!.getAllRedMatrixList()
            let greenList = gameBoard!.getAllGreenMatrixList()
            
            //沿水平和竖直 两个方向行棋
            var temP = position
            var isFirst = true
            while temP.0-1>=0{
                //如果有棋子则找出其后面的最近一颗棋子，之后推出循环（隔一个棋子吃子）
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0-1,temP.1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0-1,temP.1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0-1,temP.1))
                    }
                }
                temP.0 -= 1
            }
            temP = position
            isFirst = true
            
            while temP.0+1<=8{
                //如果有棋子则退出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0+1,temP.1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0+1,temP.1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0+1,temP.1))
                    }
                }
                temP.0 += 1
            }
            temP = position
            isFirst = true
            
            while temP.1+1<=9{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1+1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0,temP.1+1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0,temP.1+1))
                    }
                }
                temP.1 += 1
            }
            temP = position
            isFirst = true
            
            while temP.1-1>=0{
                //如果有棋子则推出循环
                if(redList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })) || (greenList.contains(where: { (pos)->Bool in
                    return pos == (temP.0,temP.1-1)
                })){
                    if !isFirst{
                        wantMove.append((temP.0,temP.1-1))
                        break
                    }
                    isFirst = false
                }else{
                    if isFirst{
                        wantMove.append((temP.0,temP.1-1))
                    }
                }
                temP.1 -= 1
            }
            //交换给棋盘类进行 移动提示
            gameBoard?.wantMoveItem(positions: wantMove, item: item)
        }
    }
    
    //一方行棋完成后 换另一方行棋
    func chessMoveEnd() {
        shouldRedRemove = !shouldRedRemove
        gameBoard?.cancelAllSelect()
    }
    
    func gameOver(redWin: Bool) {
        isStarting = false
        //将胜负结果传递给界面
        if delegate != nil {
            delegate?.gameOver(renWin: redWin)
        }
    }
}


