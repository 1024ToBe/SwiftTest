//
//  JLBaseNaviVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//

import UIKit

class JLBaseNaviVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *){
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.orange
            //title文字样式
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, .font:kScaleFont(fontSize: 17)]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        }else{
            UINavigationBar.appearance().barTintColor = UIColor.orange
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor:UIColor.white, .font:kScaleFont(fontSize: 17)]
            UINavigationBar.appearance().tintColor = .white
        }
    }

}
