//
//  JLMusicEngine.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/5.
//

import UIKit
import AVFoundation
class JLMusicEngine: NSObject {
    //音频引擎单例子
    static let shareInstance = JLMusicEngine()
    //音频播放器
    var player:AVAudioPlayer?
    
    private override init(){
        //获取音频文件
        var path = Bundle.main.path(forResource: "bgMusic", ofType: "mp3")
        let data =  try! Data(contentsOf: URL(fileURLWithPath: path!))
        player = try! AVAudioPlayer(data: data)
        //进行音频的预加载
        player?.prepareToPlay()
        //设置音频循环播放次数
        player?.numberOfLoops = -1
    }
    
    //播放背景音乐
    func playBgMusic(){
        //如果音频没有在播放状态，就进行播放
        if !player!.isPlaying{
            player?.play()
        }
    }
    
    //停止背景音乐
    func stopBgMusic(){
        //如果音频没有在播放状态，就进行播放
        if player!.isPlaying{
            player?.stop()
        }
    }
}
