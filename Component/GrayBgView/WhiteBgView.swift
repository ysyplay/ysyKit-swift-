//
//  WhiteBgView.swift
//  DevildomAPP
//
//  Created by Lothar on 2020/4/13.
//  Copyright © 2020 Devildom. All rights reserved.
//

import UIKit
@IBDesignable
class WhiteBgView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.ysy.clipCorner(radius: 12)
        self.backgroundColor = UIColor.white
    }

}
