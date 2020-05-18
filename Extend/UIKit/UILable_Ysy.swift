//
//  UILable_Ysy.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import Foundation
extension Ysy where Target : UILabel{
    /// 设置行间距文本
    func setLineSpaceText(text:String,lineSpace: CGFloat) {
        if text.count == 0 || lineSpace == 0 {
            return
        }else{
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            style.lineBreakMode = target.lineBreakMode
            style.alignment =  target.textAlignment;
            let attrString = NSMutableAttributedString(string: text)
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            target.attributedText = attrString
        }
    }
    
    ///设置不同颜色
    func set(texts:Array<String>,colors:Array<UIColor>,lineSpace:CGFloat = 0)  {
        var text = ""
        for str in texts {
            if text.count > 0 {
                text = text.appending(" ")
            }
            text = text.appending(str)
        }
        let attributedStr = NSMutableAttributedString(string: text)
        var loc = 0
        
        for i in 0..<colors.count {
        attributedStr.addAttribute(NSAttributedString.Key.foregroundColor, value: colors[i], range: NSRange(location: loc, length: texts[i].count))
            loc = loc+texts[i].count+1;
        }
        if lineSpace > 0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            style.lineBreakMode = target.lineBreakMode
            style.alignment =  target.textAlignment;
            attributedStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
        }
        target.attributedText = attributedStr;
    }
        
}
