//
//  JLPartnerVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//

import UIKit

class JLPartnerVC: JLBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addWebVC()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func addWebVC(){
        let webVC = JLBaseWebVC()
        webVC.urlStr = "agent"
        self.addChild(webVC)
        webVC.view.frame = self.view.bounds
        self.view.addSubview(webVC.view)
    }

}
