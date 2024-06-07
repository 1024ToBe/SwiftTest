//
//  JLTipBtn.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/6.
//

import UIKit

class JLTipBtn: UIButton {
    // 该类用于标记当前选中棋子可以移动到的位置
    init(center:CGPoint){
        super.init(frame: CGRect(x: center.x-10, y: center.y-10, width: 20, height: 20))
        installUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func installUI(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .orange
    }
}
