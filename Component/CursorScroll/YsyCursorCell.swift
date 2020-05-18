//
//  YsyCursorCell.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import UIKit

class YsyCursorCell: UICollectionViewCell {

    @IBOutlet weak var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLab.font = UIFont.boldSystemFont(ofSize: 15)
    }

}
