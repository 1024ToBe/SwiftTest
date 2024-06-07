//
//  JLVipVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//

import UIKit

class JLVipVC: JLBaseVC {
    @IBOutlet weak var webBg: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VIP贵宾会"
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.addWebVC()
    }
    
    func addWebVC(){
        let webVC = JLBaseWebVC()
        webVC.urlStr = "honoured_club_new"
        self.addChild(webVC)
        webVC.view.frame = self.webBg.bounds
        self.webBg.addSubview(webVC.view)
    }
    
}
