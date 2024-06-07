//
//  CommonDefine.swift
//  SwiftTest
//
//  Created by jolly on 2024/5/25.
//
import UIKit
import Foundation

//1.屏幕尺寸常量
let kScreenBounds                    = UIScreen.main.bounds.size
let kScreenWidth:CGFloat             = kScreenBounds.width
let kScreenHeight:CGFloat            = kScreenBounds.height

//2.手机型号
func kISiPhoneX() ->Bool{
    return UIScreen.main.bounds.height == 812
}

//3.适配相关
let kScale_W                        = kScreenWidth/375.0
let kScale_H                        = kScreenWidth/667.0
func kScaleFont(fontSize:CGFloat) ->UIFont{
    return UIFont.init(name:"PingFangSC-Regular", size: fontSize*kScale_W)!
}

//4.颜色设置
func kRGB(r:Int,g:Int,b:Int) ->UIColor{
    return UIColor.init(_colorLiteralRed: Float(r)/255.0, green: Float(g)/255.0, blue: Float(b)/255.0, alpha: 1.0)
}
func UIColorFromHex(h:Int) ->UIColor{
    return kRGB(r :Int(((h)>>16) & 0xFF),g :Int(((h)>>16) & 0xFF),b :Int(((h)>>16) & 0xFF))
}

//5.自定义日志打印方法
func delog<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".swift", with: "")
    print(fileName + "-line\(rowCount):" + " \(message)" + "\n")
    #endif
}
