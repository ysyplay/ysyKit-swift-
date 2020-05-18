//
//  YsyExtend.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import Foundation
import UIKit

//前缀命名空间类
class Ysy<Target> {
    let target:Target
    init(_ target:Target) {
        self.target = CoreLib.compatible(target, secret: YsyTools.Constant.Tools_key) as! Target
    }
}
//实现该协议的都具有前缀类
protocol YsyCompatible {}
extension YsyCompatible{
    var ysy: Ysy<Self> {
        set {}
        get {
            Ysy(self)
        }
    }
    static var ysy:Ysy<Self>.Type{
        set {}
        get {
            Ysy<Self>.self
        }
    }
}
//example
//extension String:YsyCompatible{}
//extension Ysy where Target == String{
//    var sayHello: String{
//        return "hello \(target)"
//    }
//
//    static var sayHello:String{
//        return "hello String"
//    }
//}
//
//print("123".ysy.sayHello)
//print(String.ysy.sayHello)

