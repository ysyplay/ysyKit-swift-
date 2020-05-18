//
//  YsyTools.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import RTRootNavigationController
import SnapKit
import WebKit
enum YsyTools {
    
    // MARK: 项目常用日期格式**************************
    enum DateFormat {
       static let second    = "yyyy-MM-dd HH:mm:ss"
       static let day       = "yyyy-MM-dd"
       static let monthDay  = "MM-dd"
       
    }

    // MARK: 常用的常量**************************
    ///常用的常量
    enum Constant {
        ///屏幕宽度
        static let ScreenWidth     = UIScreen.main.bounds.width
        ///屏幕高度
        static let ScreenHeight    = UIScreen.main.bounds.height
        ///controller有效高度
        static let MainViewHeight  = ScreenHeight - TopHeight
        ///状态栏高度
        static let StatusBarHeight = UIApplication.shared.statusBarFrame.size.height
        ///导航栏高度
        static let NavBarHeight    = 44.0
        ///顶部导航+状态栏高度
        static let TopHeight       = StatusBarHeight + CGFloat(NavBarHeight)
        ///设备号
        static let UUIDString      = YsyTools.Function.getUUIDString()
        ///版本号
        static let APPVersion      = YsyTools.Function.getAPPVersion()
        ///aes key
        static let AES_key         = "UITN25LMUQC436IM"
        ///Tools key
        static let Tools_key       = "Nw==*TnclM0QlM0Q="
    }
   
    
    
    // MARK: 项目常用颜色**************************
    ///项目常用颜色
    enum Color{
        
        static var grayBgColor     = hexColor(hex: 0xF6F6F6)
        static var grayTextColor   = hexColor(hex: 0x7A858F)
        static var darkTextColor   = hexColor(hex: 0x000101)
        static var submitButtColor = hexColor(hex: 0x000000)
        static var redPriceColor   = hexColor(hex: 0xF72428)
        static var redTextColor    = hexColor(hex: 0xE43E36)
        static var redCustomColor  = hexColor(hex: 0xF72428)
        static var pinkColor       = hexColor(hex: 0xFCEFEF)
     
        
        static func hexColor(hex: Int, alpha: CGFloat = 1.0) ->UIColor {
            
            let red   = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue  = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)

        }
        
        static func RGBA(r:Int,g:Int,b:Int, alpha: CGFloat = 1.0) ->UIColor {
            return UIColor(red: CGFloat(r)/255.0, green:CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        }
    }
    
    
    
    // MARK: 工具方法**************************
    /// 工具方法
    enum Function {
        
       /// 获取当前UIViewController
       static var currentVC: UIViewController? {
            var window:UIWindow! = UIApplication.shared.delegate?.window!!
            if window.windowLevel != .normal {
                let windows = UIApplication.shared.windows
                for tmpWin in windows {
                    if tmpWin.windowLevel == .normal {
                        window = tmpWin
                        break
                    }
                }
            }
            var rootVC = window.rootViewController!
            var activityVC : UIViewController!
            while true {
                if rootVC.isKind(of: UINavigationController.self) {
                    activityVC = (rootVC as? UINavigationController)?.visibleViewController
                }else if rootVC.isKind(of: UITabBarController.self) {
                    activityVC = (rootVC as? UITabBarController)?.selectedViewController
                }else if rootVC.presentingViewController != nil {
                    activityVC = rootVC.presentedViewController
                }else if rootVC.isKind(of: RTContainerController.self){
                    let rtVC:RTContainerController = rootVC as! RTContainerController
                    activityVC = rtVC.contentViewController
                }else{
                    break
                }
                rootVC = activityVC;
            }
            return activityVC
       }
        
        ///获取UIView的截图
        static func screenShot(from view:UIView) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return screenshotImage!;
        }
        
        /// 震动反馈,1520短，1521连续。
        /// - Parameter soundId: http://iphonedevwiki.net/index.php/AudioServices
        static func feedback(soundId:SystemSoundID = 1520){
            AudioServicesPlaySystemSound(soundId)
        }
        
        ///获取设备号
        static func getUUIDString() ->String{
            let keyChainStore = UICKeyChainStore(service: "DevildomAPP")
            let str = keyChainStore.string(forKey: "uuid")
            if let uuid = str {
                return uuid
            }else{
                let Sys_UDID  = UIDevice.current.identifierForVendor?.uuidString
                if let uuid = Sys_UDID {
                    keyChainStore.setString(uuid, forKey: "uuid")
                    return uuid
                }else{
                     return ""
                }
            }
        }
        
        ///获取版本号
        static func getAPPVersion() ->String{
            let infoDictionary = Bundle.main.infoDictionary!
            let appCurVersion = infoDictionary["CFBundleShortVersionString"]
            return appCurVersion as! String
        }
        
      ///控制台打印
      static func log<T>(_ message:T,file:String = #file,funcName:String = #function,lineNum:Int = #line){
            #if DEBUG
            let file = (file as NSString).lastPathComponent;
            print("\(file):(\(lineNum))******\(message)");
            #endif
        }
        
    }
    // MARK: other*************************************
}

