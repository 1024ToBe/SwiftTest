//
//  JLHomeVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//

import UIKit

class JLHomeVC: JLBaseVC {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
