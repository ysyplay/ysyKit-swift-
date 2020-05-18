//
//  YsySearchBar.swift
//  U17
//
//  Created by Lothar on 2020/1/10.
//  Copyright © 2020 None. All rights reserved.
//  

import UIKit

enum YsySearchBarIconAlign {
    case Left
    case Center
}

@objc protocol YsySearchBarDelegate : UIBarPositioningDelegate{
    @objc optional func
    searchBarShouldBeginEditing(searchBar:YsySearchBar)->Bool
    @objc optional func
    searchBarTextDidEndEditing(searchBar:YsySearchBar)->Void
    @objc optional func
    searchBarTextDidChange(searchBar:YsySearchBar,searchText:String)->Void
    @objc optional func
    searchBarSearchButtonClicked(searchBar:YsySearchBar)->Void
    @objc optional func
    searchBarCancelButtonClicked(searchBar:YsySearchBar)->Void
}


/// 自定义SearchBar
class YsySearchBar: UIView{
    /// 搜索框代理
    weak var delegate:YsySearchBarDelegate?
    
    /// icon的图片
    var iconImage:UIImage?{
        willSet{
            let leftView                    = UIView(frame: CGRect(x: 0, y: 0, width:textField.frame.size.height+10, height: textField.frame.size.height))
            let iconView                    = UIImageView(image: newValue)
            iconView.center                 = leftView.center
            leftView.addSubview(iconView)
            textField.leftView              = leftView
            textField.leftViewMode          = .always
            textField.leftView?.contentMode = .scaleAspectFill
        }
    }
    
    /// 右边取消按钮
    lazy private var cancelButton: UIButton = {
        let _cancelButton              = UIButton(type: .custom)
        _cancelButton.frame            = CGRect(x: self.frame.size.width-60, y: 5, width: 60, height: 40)
        _cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _cancelButton.autoresizingMask = .flexibleLeftMargin
        _cancelButton.addTarget(self, action: #selector(cancelButtonTouched), for: .touchUpInside)
        _cancelButton.setTitle("取消", for: .normal)
        _cancelButton.setTitleColor(.black, for: .normal)
        addSubview(_cancelButton)
        return _cancelButton
    }()
    //取消按钮被点击
    @objc private func cancelButtonTouched(butt:UIButton){
        textField.text = ""
        textField.resignFirstResponder()
        delegate?.searchBarCancelButtonClicked?(searchBar: self)
        textFieldDidChange(textField: textField)
    }
 
    /// 右边取消按钮是否隐藏
    var isHiddenCancelButton = false{
        willSet{
            cancelButton.isHidden = newValue
            textField.frame = CGRect(x: 24, y: 4, width: self.frame.size.width-24*2, height: 40)
        }
    }
    
    lazy var textField: UITextField = {
        let _textField = UITextField(frame: CGRect(x: 24, y: 4, width: self.frame.size.width-24-60, height: 40))
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: 50)
        _textField.delegate = self
        _textField.borderStyle = .none
        _textField.contentVerticalAlignment = .center
        _textField.returnKeyType = UIReturnKeyType.search
        _textField.enablesReturnKeyAutomatically = true;
        _textField.font = UIFont.systemFont(ofSize: 16)
        _textField.clearButtonMode = .whileEditing;
        _textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        _textField.autoresizingMask = .flexibleWidth
        _textField.borderStyle = .none
        _textField.layer.cornerRadius = 20
        _textField.layer.masksToBounds = true
        _textField.backgroundColor = UIColor.colorWithHexString("#f8f8f8", alpha: 1)
        addSubview(_textField)
        addSubview(self.cancelButton)
        return _textField
    }()

    @objc private func textFieldDidChange(textField:UITextField){
        delegate?.searchBarTextDidChange?(searchBar: self, searchText: textField.text ?? "")
    }
    
   
    public func isFirstResponder()->Bool{
       return textField.isFirstResponder
    }
    public override func resignFirstResponder()->Bool{
       return textField.resignFirstResponder()
    }
    public override func becomeFirstResponder()->Bool{
       return textField.becomeFirstResponder()
    }

}

 //MARK: UITextFieldDelegate
extension YsySearchBar:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            delegate?.searchBarShouldBeginEditing?(searchBar: self) ?? true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarTextDidEndEditing?(searchBar: self)
    }
    
   func textFieldShouldClear(_ textField: UITextField) -> Bool {
        delegate?.searchBarTextDidChange?(searchBar: self, searchText:"")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.searchBarSearchButtonClicked?(searchBar: self)
        return true
    }
}
