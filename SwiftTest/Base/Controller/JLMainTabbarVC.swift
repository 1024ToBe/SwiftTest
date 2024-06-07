//
//  JLMainTabbarVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//

import UIKit
//import CommonDefine

class JLMainTabbarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTabbarVC()
    }
    
    
    // Do any additional setup after loading the view.
    func initTabbarVC(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : kRGB(r: 102, g: 102, b: 102), NSAttributedString.Key.font :kScaleFont(fontSize: 10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor :kRGB(r: 223, g: 65, b: 51), NSAttributedString.Key.font : kScaleFont(fontSize: 10)], for: .selected)
        
        //homeVC
        let homeImageName = "tabbar_home"
        let homeVC = JLHomeVC()
        let homeNaviVC = JLBaseNaviVC(rootViewController: homeVC)
        homeNaviVC.title = "首页"
        homeNaviVC.tabBarItem.image = UIImage(named: homeImageName)?.withRenderingMode(.alwaysOriginal)
        homeNaviVC.tabBarItem.selectedImage = UIImage(named: homeImageName + "_s")?.withRenderingMode(.alwaysOriginal)
        addChild(homeNaviVC)
        
        //discountVC
        let vipImageName = "tabbar_discounts_usdt"
        let vipVC = JLCalculatorVC()
        let vipNaviVC = JLBaseNaviVC(rootViewController: vipVC)
        vipNaviVC.title = "计算器"
        vipNaviVC.tabBarItem.image = UIImage(named: vipImageName)?.withRenderingMode(.alwaysOriginal)
        vipNaviVC.tabBarItem.selectedImage = UIImage(named: vipImageName + "_s")?.withRenderingMode(.alwaysOriginal)
        addChild(vipNaviVC)
        
        //vipVC
        let discountImageName = "tabbar_gbh"
        let discountVC = JLNoteBookHomeVC()
        let disCountNaviVC = JLBaseNaviVC(rootViewController: discountVC)
        disCountNaviVC.title = "点滴生活"
        disCountNaviVC.tabBarItem.image = UIImage(named: discountImageName)?.withRenderingMode(.alwaysOriginal)
        disCountNaviVC.tabBarItem.selectedImage = UIImage(named: discountImageName + "_s")?.withRenderingMode(.alwaysOriginal)
        addChild(disCountNaviVC)
        
        //discountVC
        let partnerImageName = "tabbar_partner"
        let partnerVC = JLLaunchVC()
        let partnerNaviVC = JLBaseNaviVC(rootViewController: partnerVC)
        partnerNaviVC.title = "中国象棋"
        partnerNaviVC.tabBarItem.image = UIImage(named: partnerImageName)?.withRenderingMode(.alwaysOriginal)
        partnerNaviVC.tabBarItem.selectedImage = UIImage(named: partnerImageName + "_s")?.withRenderingMode(.alwaysOriginal)
        addChild(partnerNaviVC)
        
        //mineVC
        let mineImageName = "tabbar_mine"
        let mineVC = JLMineVC()
        let mineNaviVC = JLBaseNaviVC(rootViewController: mineVC)
        mineNaviVC.title = "我的"
        mineNaviVC.tabBarItem.image = UIImage(named: mineImageName)?.withRenderingMode(.alwaysOriginal)
        mineNaviVC.tabBarItem.selectedImage = UIImage(named: mineImageName + "_s")?.withRenderingMode(.alwaysOriginal)
        addChild(mineNaviVC)
    }

    
}
