//
//  MainItemModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/4.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class MainItemModel: NSObject {
    
    var icon: String            = ""
    var title: String           = ""
    var isShowMoreIcon: Bool    = false
    var isShowBottomView: Bool  = false

    init(icon: String, title: String, isShowMoreIcon: Bool, isShowBottomView: Bool) {
        self.icon = icon
        self.title = title
        self.isShowMoreIcon = isShowMoreIcon
        self.isShowBottomView = isShowBottomView
    }
}
