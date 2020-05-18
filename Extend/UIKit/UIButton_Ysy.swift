//
//  UIButton_Ysy.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import UIKit

extension Ysy where Target : UIButton{

    /// 按钮倒计时
    /// - Parameters:
    ///   - startTime: 倒计时总时间
    ///   - title: 常态标题
    ///   - countDownTitle: 倒计时标题
    func countDown(startTime:NSInteger,title:String,countDownTitle:String){
        var count = startTime
        self.target.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            count = count - 1
            self.target.setTitle("\(countDownTitle)\(count) S", for: .disabled)
            if(count == 0){
                self.target.isEnabled = true
                self.target.setTitle(title, for: .normal)
                timer.invalidate()
            }
        }
    }

}
