//
//  UITableView_Ysy.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import Foundation
extension Ysy where Target : UITableView{
    /// 添加cell出场动画
    func showCellAnimate() {
        target.reloadData()
        DispatchQueue.main.async {
            self.target.layoutIfNeeded()
            let cells = self.target.visibleCells
            for (index, cell) in cells.enumerated() {

                cell.transform = CGAffineTransform(translationX: -self.target.bounds.size.width, y: 0)
                UIView.animate(withDuration: 0.9, delay: 0.15 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: -10, options: [], animations: {
                      cell.transform = CGAffineTransform(translationX: 0, y: 0);
                  }, completion: nil)
            }
        }
    }
}
