//
//  JLNoteBookHomeVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/3.
//

import UIKit

class JLNoteBookHomeVC: JLBaseVC,JLHomeViewDelegate {
    var dataArr:Array<String>?
    @IBOutlet weak var homeView: JLHomeView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "点滴生活"
        //　取消导航栏对页面布局的影响
        self.edgesForExtendedLayout = UIRectEdge()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //从JLDataManager中获取分组数据
        dataArr = JLDataManager.getGroupData()
        installUI()
    }
    
    func installUI(){
        homeView.homeViewDelegate = self
        homeView?.dataArr = self.dataArr
        homeView?.updateLayout()
        installNaviItem()
    }
    
    //自定义导航右侧按钮
    func installNaviItem(){
        let rightNaviBtn = UIButton()
        rightNaviBtn.setTitleColor(.white, for: .normal)
        rightNaviBtn.setTitleColor(.red, for: .highlighted)
        rightNaviBtn.setTitle("添加", for: .normal)
        rightNaviBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNaviBtn.addTarget(self, action: #selector(addGroup(btn:)), for: .touchUpInside)
        rightNaviBtn.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightNaviBtn)
    }
    
    @objc func addGroup(btn:UIButton){
        let alertVC = UIAlertController(title: "添加记事分组", message: "添加的分组名不能重复或为空", preferredStyle: .alert)
        //警告弹窗中添加一个文本输入框
        alertVC.addTextField{(textField) in
            textField.placeholder = "请输入记事分组名称"
        }
        //警告弹窗中添加一个取消按钮
        let actionCancel = UIAlertAction(title: "取消", style: .cancel) { (_) in
            return
        }
        alertVC.addAction(actionCancel)
       
        //警告弹窗中添加一个确定按钮
        let actionConfirm =  UIAlertAction(title: "确定", style: .default) { (_) in
            //分组有效性判断
            var exist = false
            self.dataArr?.forEach({ (element) in
                //如果此分组已经存在，或者用户输入为空
                if element == alertVC.textFields?.first!.text || alertVC.textFields?.first!.text?.count==0{
                    exist = true
                }
            })
            if exist{
                return
            }
            //将用户添加的分组追加进dataArr中
            self.dataArr?.append(alertVC.textFields!.first!.text!)
            //进行homeView刷新
            self.homeView?.dataArr = self.dataArr
            self.homeView?.updateLayout()
            //将添加的分组写入数据库
            JLDataManager.saveGroup(name: alertVC.textFields!.first!.text!)
        }
        alertVC.addAction(actionConfirm)
        //展示警告窗
        self.present(alertVC, animated: true)
    }
    
    func homeBtnClick(title: String) {
         let notelListVC = JLNoteListVC()
         notelListVC.name = title
        self.navigationController?.pushViewController(notelListVC, animated: true)
    }
}

