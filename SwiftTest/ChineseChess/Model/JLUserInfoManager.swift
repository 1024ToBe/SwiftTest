//
//  JLUserInfoManager.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/5.
//

import UIKit

class JLUserInfoManager: NSObject {

    //获取用户音频设置状态
    class func getAudioState()->Bool{
        let isOn = UserDefaults.standard.string(forKey: "audioKey")
        if let on = isOn{
            if on == "on"{
                return true
            }else{
                return false
            }
        }
        return true
    }
    
    //用户音频状态设置的存储
    class func setAudioState(isOn:Bool){
        if isOn{
            UserDefaults.standard.set("on", forKey: "audioKey")
        }else{
            UserDefaults.standard.set("off", forKey: "audioKey")
        }
        UserDefaults.standard.synchronize()
    }
}
