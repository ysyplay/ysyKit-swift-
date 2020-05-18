//
//  TitleValueM.swift
//  DevildomAPP
//
//  Created by ysyplay on 2020/1/28.
//  Copyright © 2020 ysyplay. All rights reserved.
//

import UIKit
class TitleValueM<T> :NSObject{
    var title = ""
    var value:T
    
    init(title:String,value:T) {
        self.title = title
        self.value = value
    }
}
