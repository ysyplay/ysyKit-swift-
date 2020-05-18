//
//  YsyScreenView.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import UIKit

class YsyScreenView: UIView {
    
    var contentView : UIView!
    var contentViewHeight:CGFloat = 0.0
    
    init(contentView:UIView) {
        super.init(frame: CGRect(x: 0, y: 0, w: YsyTools.Constant.ScreenWidth, h: YsyTools.Constant.MainViewHeight))
        self.backgroundColor        = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.contentView            = contentView
        self.contentViewHeight      = contentView.frame.size.height
        contentView.backgroundColor = .white
        self.addSubview(contentView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.contentView?.h  = self.contentViewHeight
        }
    }
    
    func showInView(view:UIView){
        self.frame = CGRect(x: 0, y: 0, w: ScreenWidth, h: view.h)
        view.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.contentView?.h  = self.contentViewHeight
        }
    }
    
    @objc func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor        = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
            self.contentView?.h  = 0
        }) { (bool) in
            self.removeFromSuperview()
        }
    }
}

extension YsyScreenView : UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.contentView) ?? true{
           return false
        }
        return true
    }
}
