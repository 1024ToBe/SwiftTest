//
//  JLDataManager.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/4.
//

import UIKit
import SQLiteSwift3
class JLDataManager: NSObject {
    //数据库操作对象
    static var sqHandle:SQLiteSwift3?
    //数据库是否打开
    static var isOpen = false
    
    //存储分组数据
    class func saveGroup(name:String){
        //如果数据未打开-去打开
        if !isOpen{
            self.openDataBase()
        }
        //创建一个数据表字段对象
        let key = SQLiteKeyObject()
        //设置表的字段名
        key.name = "groupName"
        //设置字段名为字符串
        key.fieldType = TEXT
        //将字段修饰为唯一
        key.modificationType = UNIQUE
        //创建表，如果已经存在，则不执行任何操作
        sqHandle!.createTable(withName: "grouTable", keys: [key])
        //进行数据的插入
        sqHandle!.insertData(["groupName":name], intoTable: "grouTable")
    }
    
    //获取分组数据
    class func getGroupData()->[String]{
        if !isOpen{
            self.openDataBase()
        }
        //创建查询请求对象
        let request = SQLiteSearchRequest()
        //查询结果容器数组
        var array = Array<String>()
        //查询数据
        sqHandle?.searchData(withReeuest: request, inTable: "groupTable", searchFinish: {
            (success, dataArr) in
            //遍历查询到的数据，赋值进结果数组中
            dataArr?.forEach({ (element) in
                array.append(element.values.first! as! String)
            })
        })
        return array
    }
    
    //打开数据库
    class func openDataBase(){
        //获取沙河路径
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //进行文件名的拼接
        let file = path + "/DataBase.sqlite"
        delog(file)
        //打开数据库,如果不存则会创建
        sqHandle = SQLiteSwift3.openDB(file)
        //设置数据库打开标志
        isOpen = true        
    }
    
    class func addNote(note:JLNoteModel){
        if !isOpen{
            self.openDataBase()
        }
        
        //创建记事表
        self.createNoteTable()
        
        //将记事模型转换为字典进行存表
        sqHandle!.insertData(note.toDic(), intoTable: "noteTable")
    }
    
    //记事本数据
    //根据分组获取记事
    class func getNote(group:String)->[JLNoteModel]{
        if !isOpen{
            self.openDataBase()
        }
        
        //创建查询请求
        let request = SQLiteSearchRequest()
        //设置查询条件
        request.contidion = "ownGroup=\"\(group)\""
        var arr = Array<JLNoteModel>()
        sqHandle?.searchData(withReeuest: request, inTable: "noteTable", searchFinish: {
            (success, dataArr) in
            //遍历查询到的数据，赋值进结果数组中
            dataArr?.forEach({ (element) in
                let note = JLNoteModel()
                //对记事模型进行赋值
                note.time = element["time"] as! String?
                note.title = element["title"] as! String?
                note.body = element["body"] as! String?
                note.group = element["group"] as! String?
                note.noteId = element["noteId"] as! Int?
                arr.append(note)
            })
        })
        return arr
        
    }
        
    class func createNoteTable(){
        let key1 = SQLiteKeyObject()
        key1.name = "noteId"
        key1.fieldType = INTEGER
        //将noteId做为主键
        key1.modificationType = PRIMARY_KEY
        
        let key2 = SQLiteKeyObject()
        key2.name = "ownGroup"
        key2.fieldType = TEXT
        
        let key3 = SQLiteKeyObject()
        key3.name = "body"
        key3.fieldType = TEXT
        key3.tSize = 400
        
        let key4 = SQLiteKeyObject()
        key4.name = "title"
        key4.fieldType = TEXT
        
        let key5 = SQLiteKeyObject()
        key5.name = "time"
        key5.fieldType = TEXT
        
        sqHandle!.createTable(withName: "noteTable", keys: [key1,key2,key3,key4,key5])
    }
    
    class func updateNote(note:JLNoteModel){
        if !isOpen{
            self.openDataBase()
        }
        
        sqHandle?.updateData(note.toDic(), intoTable: "noteTable", while: "noteId = \(note.noteId!)", isSecurity: true)
    }
    
    //删除一条记事
    class func deleteNote(note:JLNoteModel){
        if !isOpen{
            self.openDataBase()
        }
        
        sqHandle?.deleteData("noteId = \(note.noteId!)", intoTable: "noteTable", isSecurity: true)
    }
    
    //删除一个分组，将其下所有记事删除
    class func deleteGroup(name:String){
        if !isOpen{
            self.openDataBase()
        }
        //首先删除分组下的所有记事
        sqHandle?.deleteData("ownGroup=\"\(name)\"", intoTable: "noteTable", isSecurity: true)
        //再删除分组
        sqHandle?.deleteData("GroupName=\"\(name)\"", intoTable: "noteTable", isSecurity: true)
    }
    
    
    
}
