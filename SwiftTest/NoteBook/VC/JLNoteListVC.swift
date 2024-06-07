//
//  JLNoteListVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/4.
//

import UIKit

class JLNoteListVC: UITableViewController {
        
    //数据源头
    var dataArr = Array<JLNoteModel>()
    let cellID = "noteListCellID"
    
    //当前分组
    var name:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tableView.register(UINib(nibName:"JLNoteListCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.title = name
        //进行导航栏配置
        installNaviItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //从数据库中读取记事
        dataArr = JLDataManager.getNote(group: name!)
        self.tableView.reloadData()
    }
    
    //自定义导航右侧按钮
    func installNaviItem(){
        let rightNaviBtn = UIButton()
        rightNaviBtn.setTitleColor(.white, for: .normal)
        rightNaviBtn.setTitleColor(.red, for: .highlighted)
        rightNaviBtn.setTitle("添加", for: .normal)
        rightNaviBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNaviBtn.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        rightNaviBtn.sizeToFit()
        
        let rightNaviBtn1 = UIButton()
        rightNaviBtn1.setTitleColor(.white, for: .normal)
        rightNaviBtn1.setTitleColor(.red, for: .highlighted)
        rightNaviBtn1.setTitle("删除", for: .normal)
        rightNaviBtn1.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rightNaviBtn1.addTarget(self, action: #selector(deleteGroup), for: .touchUpInside)
        rightNaviBtn1.sizeToFit()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: rightNaviBtn),UIBarButtonItem(customView: rightNaviBtn1)]
    }

    @objc func addNote(){
        let noteInfoVC = JLNoteInfoVC()
        noteInfoVC.group = name!
        noteInfoVC.isNew = true
        self.navigationController?.pushViewController(noteInfoVC, animated: true)
    }
        
    @objc func deleteGroup(){
        let alertVC = UIAlertController(title: "警告", message: "您确定要删除此分组下的所有记事么", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel){(_) in
            return
        }
        alertVC.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "确定", style: .default){(_) in
            JLDataManager.deleteGroup(name: self.name!)
            self.navigationController!.popViewController(animated: true)
        }
        alertVC.addAction(confirmAction)
        self.present(alertVC, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? JLNoteListCell else{
            return JLNoteListCell()
        }
        let model = dataArr[indexPath.row]
        cell.titleLb.text = model.title
        cell.timeLb.text = model.time
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消当前cell的选中状态
        tableView.deselectRow(at: indexPath, animated: true)
        let noteInfoVC = JLNoteInfoVC()
        noteInfoVC.group = name!
        noteInfoVC.isNew = false
        noteInfoVC.noteModel = dataArr[indexPath.row]
        self.navigationController?.pushViewController(noteInfoVC, animated: true)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
