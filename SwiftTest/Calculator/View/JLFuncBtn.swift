//
//  JLFuncBtn.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/31.
//

import UIKit

class JLFuncBtn: UIButton {
    init() {
        super.init(frame: CGRect.zero)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = kRGB(r: 219, g: 219, b: 219).cgColor
        self.setTitleColor(UIColor.orange, for: UIControl.State.normal)
        self.titleLabel?.font = kScaleFont(fontSize: 25.0)
        self.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) hasnot been implemented")
    }
}
