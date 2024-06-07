//
//  JLBaseXibView.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/27.
//

import UIKit

class JLBaseXibView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXibView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadXibView()
    }
    
    private func  loadXibView(){
        // 1. 加载 XIB 文件
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        // 2. 实例化 XIB
        for obj in nib.instantiate(withOwner: self, options: nil) {
            guard let obj = obj as? UIView else {
                return
            }
            if !obj.isMember(of: UIControl.self) && obj.isMember(of: UIView.self) {
                obj.frame = self.bounds
                obj.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                // 3. 将 XIB 的根视图添加到当前 UIView
                self.addSubview(obj)
                // 4. 适配
//                obj.layoutXib()
                initOthers()
                return
            }
        }
        
    }
    
    func initOthers(){
        
    }
}
