//
//  JLNoteInfoVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/4.
//

import UIKit
import SnapKit
class JLNoteInfoVC: JLBaseVC {
    //当前编辑的记事数据模型
    var noteModel:JLNoteModel?
    //标题文本框
    @IBOutlet weak var titleTF: UITextField!
    //记事本文本时图
    @IBOutlet weak var titleTV: UITextView!
    //记事所属分组
    var group:String?
    var isNew = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge()
        self.view.backgroundColor = .white
        self.title = "记事"
        //监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        installUI()
    }


    //键盘弹出
    @objc internal func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let frameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject
        let height = frameInfo.cgRectValue.size.height
        titleTV.snp.updateConstraints { make in
            make.bottom.equalTo(-30-height)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    //键盘收起
    @objc internal func keyboardWillHide(_ notification: Notification?) {
        titleTV.snp.updateConstraints { make in
            make.bottom.equalTo(-30)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    //点击屏幕非文本区域 收起键盘
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTV.resignFirstResponder()
        titleTF.resignFirstResponder()
    }
    
    //析构方法中移除键盘的监听
    deinit{
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func installUI(){
        installNaviItem()
        if !isNew{
            titleTF.text = noteModel?.title
            titleTV.text = noteModel?.body
        }
    }
    
    //自定义导航右侧按钮
    func installNaviItem(){
        let rightNaviBtn = UIButton()
        rightNaviBtn.setTitleColor(.white, for: .normal)
        rightNaviBtn.setTitleColor(.red, for: .highlighted)
        rightNaviBtn.setTitle("保存", for: .normal)
        rightNaviBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNaviBtn.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        rightNaviBtn.sizeToFit()
        
        let rightNaviBtn1 = UIButton()
        rightNaviBtn1.setTitleColor(.white, for: .normal)
        rightNaviBtn1.setTitleColor(.red, for: .highlighted)
        rightNaviBtn1.setTitle("删除", for: .normal)
        rightNaviBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNaviBtn1.addTarget(self, action: #selector(deleteNote), for: .touchUpInside)
        rightNaviBtn1.sizeToFit()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightNaviBtn),UIBarButtonItem(customView: rightNaviBtn1)]
    }
    
    //添加记事
    @objc func addNote(){
        //如果是新记事 则数据库新增
        if isNew{
            if titleTF.text!.count>0{
                noteModel = JLNoteModel()
                noteModel?.title = titleTF.text
                noteModel?.body = titleTV.text
                //将当前时间进行格式化
                let dateFor = DateFormatter()
                dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFor.string(from: Date())
                noteModel?.group = group
                JLDataManager.addNote(note: noteModel!)
                self.navigationController?.popViewController(animated: true)
            }
        }else{//修改
            if titleTF.text!.count > 0{
                noteModel?.title = titleTF.text
                noteModel?.body = titleTV.text
                //将当前时间进行格式化
                let dateFor = DateFormatter()
                dateFor.dateFormat = "yyyy-MM-dd HH:mm:ss"
                noteModel?.time = dateFor.string(from: Date())
                JLDataManager.updateNote(note: noteModel!)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    @objc func deleteNote(){
        let alertVC = UIAlertController(title: "警告", message: "您确定要删除此条记事么", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel){(_) in
            return
        }
        alertVC.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "确定", style: .default){(_) in
            //如果不是新建记事 就删除
            if !self.isNew{
                JLDataManager.deleteNote(note: self.noteModel!)
                self.navigationController!.popViewController(animated: true)
            }
        }
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true)
    }
    
}
