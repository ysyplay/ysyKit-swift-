//
//  GrayBgView.swift
//  DevildomAPP
//
//  Created by Lothar on 2020/3/4.
//  Copyright © 2020 Devildom. All rights reserved.
//

import UIKit
@IBDesignable
class GrayBgView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ysy.clipCorner(radius: 12)
        self.backgroundColor = YsyTools.Color.grayBgColor
    }
    
}
