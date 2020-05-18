//
//  UIViewExtend_Ysy.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import Foundation
import UIKit

extension UIView:YsyCompatible{}

// MARK: 对象方法
extension Ysy where Target : UIView{
    
    ///裁切圆角
    func clipCorner(radius: CGFloat) {
        target.layer.cornerRadius = radius
        target.clipsToBounds      = true
    }
    
    /// 裁切指定圆角
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: [.topLeft,.topRight,.bottomLeft,.bottomRight]
    func clipCorner(radius: CGFloat,corners: UIRectCorner) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
            let bezierPath = UIBezierPath(roundedRect: self.target.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
             let shapeLayer = CAShapeLayer()
             shapeLayer.frame = self.target.bounds
             shapeLayer.path = bezierPath.cgPath
             self.target.layer.mask = shapeLayer
        }
    }
    
    /// 描边
    /// - Parameters:
    ///   - color: 边线颜色
    ///   - width: 边线宽度
    func border(color: UIColor,width: CGFloat) {
        target.layer.borderWidth = width
        target.layer.borderColor = color.cgColor
    }
    
    /// 添加渐变背景色
    func gradient(colors:Array<CGColor>,startPoint:CGPoint = CGPoint(x: 0, y: 0),endPoint:CGPoint = CGPoint(x: 1, y: 1)) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.02) {
            let gradientLayer         = CAGradientLayer()
            gradientLayer.colors      = colors
            gradientLayer.frame       = self.target.bounds
            gradientLayer.startPoint  = startPoint
            gradientLayer.endPoint    = endPoint
            self.target.layer.insertSublayer(gradientLayer, at: 0)
            self.target.clipsToBounds = true
        }
    }
}



// MARK: 类方法
extension Ysy where Target : UIView{
    /// 创建Xib中的view
    static func viewFromXib<T: UIView>(class: T.Type = T.self) -> T{
        let object = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.last
        return object as! T
    }
}
