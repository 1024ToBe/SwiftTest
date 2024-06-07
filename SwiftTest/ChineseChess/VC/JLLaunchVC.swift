//
//  JLLaunchVC.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/5.
//

import UIKit

class JLLaunchVC: JLBaseVC {
    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var musicBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "中国象棋"
       //读取用户音频设置状态
        if JLUserInfoManager.getAudioState(){
            musicBtn.setTitle("音乐：开", for: .normal)
            //进行音频播放
            JLMusicEngine.shareInstance.playBgMusic()
        }else{
            musicBtn.setTitle("音乐：关", for: .normal)
            //停止音频播放
            JLMusicEngine.shareInstance.stopBgMusic()
        }
    }
    
    //开始游戏
    @IBAction func startGameClick(_ sender: UIButton) {
        let gameVC = JLChineseChessVC()
//        self.present(gameVC, animated: true)
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    //用户点击音频设置按钮后，进行状态的切换
    @IBAction func musicBtnClick(_ sender: UIButton) {
        if JLUserInfoManager.getAudioState(){
            musicBtn.setTitle("音乐：关", for: .normal)
            JLUserInfoManager.setAudioState(isOn: false)
            JLMusicEngine.shareInstance.stopBgMusic()
        }else{
            musicBtn.setTitle("音乐：开", for: .normal)
            JLUserInfoManager.setAudioState(isOn: true)
            JLMusicEngine.shareInstance.playBgMusic()
        }
    }
    
}
