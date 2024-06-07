//
//  JLDiscountVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//

import UIKit

class JLDiscountVC: JLBaseVC {
    @IBOutlet weak var webBg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.addWebVC()
    }
    
    func addWebVC(){
        let webVC = JLBaseWebVC()
        webVC.urlStr = "promotion_list"
        self.addChild(webVC)
        webVC.view.frame = self.webBg.bounds
        self.webBg.addSubview(webVC.view)
    }
}
