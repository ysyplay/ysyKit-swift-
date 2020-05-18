//
//  YsySearchView.swift
//  DevildomAPP
//
//  Created by Lothar on 2020/4/15.
//  Copyright © 2020 Devildom. All rights reserved.
//  不涉及搜索相关的操作，仅仅作为一个展示，和一个点击事件

import UIKit

class YsySearchView: UIView {
    
    var contentLab:UILabel!
    
    
    var contentStr: String? {
        willSet{
            self.contentLab.text = newValue
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.configUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func  configUI(){
        self.ysy.clipCorner(radius: 20)
        self.backgroundColor = YsyTools.Color.grayBgColor
        //放大镜
        let iconView = UIImageView(image: UIImage(named: "搜索"))
        iconView.contentMode = .center
        self.addSubview(iconView)
        iconView.snp.makeConstraints { (make) in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(self.frame.size.height)
        }
        //红色分割
        let flag = UIView()
        flag.backgroundColor = YsyTools.Color.hexColor(hex: 0xF82428)
        self.addSubview(flag)
        flag.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(-3)
            make.width.equalTo(1.5)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        //搜索内容显示
        contentLab = UILabel().chain.text("请输入搜索内容").textColor(YsyTools.Color.grayTextColor).systemFont(ofSize: 14).build
        self.addSubview(contentLab)
        contentLab.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(flag.snp.right).offset(8)
            make.width.equalTo(self.frame.size.width - 60)
        }
    }
}
