//
//  YsyursorScroll.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import UIKit



protocol YsyCursorScrollDelegate :NSObjectProtocol {
    /// cell选中、正常状态下的UI样式代理
    func
        YsyCursorScrollConfigCellUI(cursorScrollView:YsyCursorScroll,
                                    cell:YsyCursorCell,
                                   state:YsyCursorScroll.itemState)
    /// cell尺寸
    func
        YsyCursorScrollCellSize(cursorScrollView:YsyCursorScroll,
                                indexPath: IndexPath) -> CGSize
}


class YsyCursorScroll: UICollectionView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    ///cell是否选中的状态枚举
    enum itemState {
        case normal
        case Selected
    }
   
    /// cell选中、正常状态下的UI样式代理
    weak var itemUIDelegate:YsyCursorScrollDelegate?
    
    var itemSize   : CGSize!
    
    var disableFeedback : Bool = false
    
    var autoScroll      : Bool = true
    
    var dataArr:Array<TitleValueM<Any>> = []{
        didSet{
            self.reloadData()
        }
    }
        
    var selectIndex:Int?{
        didSet{
            self.reloadData()
        }
    }
    
    init(itemSize:CGSize,scrollDirection:UICollectionView.ScrollDirection = .horizontal) {

        let layout                     = UICollectionViewFlowLayout()
        layout.itemSize                = itemSize
        layout.sectionInset            = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing      = 12
        layout.scrollDirection         = scrollDirection
    
        super.init(frame: .zero, collectionViewLayout: layout)
        self.showsHorizontalScrollIndicator = false
        self.backgroundColor = .white
        self.itemSize        = itemSize
        self.bounces         = false
        self.delegate        = self
        self.dataSource      = self
        self.register(UINib(nibName: "YsyCursorCell", bundle: .main), forCellWithReuseIdentifier: "cell")
    }
    

    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = itemUIDelegate {
            //自定义cell尺寸
             return itemUIDelegate!.YsyCursorScrollCellSize(cursorScrollView: self, indexPath: indexPath)
            }
        return itemSize
      }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataArr[indexPath.row]
        let cell:YsyCursorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! YsyCursorCell
        cell.titleLab.text = model.title
        cell.ysy.clipCorner(radius: itemSize.height/2 - 1)
        //字体设置
        if model.title.contains("\n") {
            cell.titleLab.font = UIFont.HelveticaNeue(type: .Heavy, size: 15)
        }else{
            cell.titleLab.font = UIFont.boldSystemFont(ofSize: 15)
        }
        //选中、正常效果设置
        if let i = selectIndex, i == indexPath.row{
            if let _ = itemUIDelegate {
                //自定义选中效果
                itemUIDelegate!.YsyCursorScrollConfigCellUI(cursorScrollView: self , cell: cell, state: .Selected)
            }else{
                //默认选中效果
                cell.backgroundColor    = YsyTools.Color.redCustomColor
                cell.titleLab.textColor = .white
            }
        }else{
            if let _ = itemUIDelegate {
                //自定义正常效果
                itemUIDelegate?.YsyCursorScrollConfigCellUI(cursorScrollView: self , cell: cell, state: .normal)
            }else{
                //默认正常效果
                cell.backgroundColor    = .white
                cell.titleLab.textColor = YsyTools.Color.darkTextColor
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //根据点击情况，适当滚动调整(只适用于水平滚动)
        if autoScroll {
            let cell   = collectionView.cellForItem(at: indexPath)!
            let cellX  = cell.frame.origin.x
            let cellW  = cell.frame.size.width
            let offset = collectionView.contentOffset.x
            let width  = collectionView.frame.size.width
            if cellX + 2 * cellW > offset + width - 10 {
                UIView.animate(withDuration: 0.3) {
                    let a = cellX + 2 * cellW - width + 10
                    let b = collectionView.contentSize.width - width
                    collectionView.contentOffset.x = min(a, b)
                }
            }else if cellX - cellW < offset{
                UIView.animate(withDuration: 0.35) {
                    let a = cellX - cellW - 12
                    collectionView.contentOffset.x =  max(a, 0)
                }
            }
        }
        //选中
        selectIndex = indexPath.row
        guard disableFeedback else {
            YsyTools.Function.feedback()
            return
        }

    }
    
    //滚动反馈
    var oldPosition = 0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard disableFeedback else {
            let a = scrollView.contentOffset.x / ((itemSize.width+12)/2)
            if oldPosition != Int(a){
                oldPosition = Int(a)
                DispatchQueue.main.async {
                    YsyTools.Function.feedback()
                }
            }
            return
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard disableFeedback else {
            YsyTools.Function.feedback()
            return
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard disableFeedback else {
            YsyTools.Function.feedback()
            return
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

