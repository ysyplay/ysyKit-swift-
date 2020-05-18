//
//  YsyAutoLayoutScroll.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import UIKit

enum YsyOrientation {
    case vert
    case horz
}

class YsyAutoLayoutScroll: UIScrollView{

    init(contentView:UIView,direction:YsyOrientation) {
        super.init(frame: CGRect.zero)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            if direction == .vert {
                make.width.equalToSuperview()
            }else{
                make.height.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

