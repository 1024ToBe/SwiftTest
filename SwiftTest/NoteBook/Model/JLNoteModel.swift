//
//  JLNoteModel.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/4.
//

import UIKit

class JLNoteModel: NSObject {
    //记事时间
    var time:String?
    //记事标题
    var title:String?
    //记事内容
    var body:String?
    //记事标题
    var group:String?
    //主键
    var noteId:Int?
    //数据模型转字典
    func toDic()->Dictionary<String,Any>{
        var dic:[String:Any] = ["time":time!,"title":title!,"body":body!,"ownGroup":group!]
        if let id = noteId{
            dic["noteId"] = id
        }
        return dic
    }
    
}
