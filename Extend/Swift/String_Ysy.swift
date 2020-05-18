//
//  String_Ysy.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import Foundation

extension String:YsyCompatible{}
extension NSString:YsyCompatible{}

extension Ysy where Target : ExpressibleByStringLiteral{
    
    /// 计算文本尺寸
    func textSize(contentSize:CGSize,font:UIFont) -> CGSize {
        let str = target as! NSString
        return str.boundingRect(with: contentSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
    
    /// 计算文本宽度
    func textWidth(height:CGFloat,font:UIFont) -> CGFloat {
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        return self.textSize(contentSize: size, font: font).width
    }
    
    /// 计算文本高度
    func textHeight(width:CGFloat,font:UIFont) -> CGFloat {
        let size = CGSize(width:width , height: CGFloat(MAXFLOAT))
        return self.textSize(contentSize: size, font: font).height
    }
}
