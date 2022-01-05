//
//  IndexGoodsModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class IndexGoodsModel: BaseModel {
    var gid: Int                = 0
    var name: String            = ""
    var description: String     = ""
    var brand: String           = ""
    var counterPrice: Int       = 0
    var marketPrice: Int        = 0
    var colorName: String       = ""
    var colorValue: String      = ""
    var primaryPicUrl: String   = ""
    var listPicUrl: String      = ""
    var addTime: String         = ""
    var updateTime: String      = ""
}
