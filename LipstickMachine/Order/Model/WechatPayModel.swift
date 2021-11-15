//
//  WechatPayModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/22.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class WechatPayModel: BaseModel {
    var appid               = ""
    var partnerid           = ""
    var prepayid            = ""
    var sign                = ""
    var timestamp           = ""
    var noncestr            = ""
    var package             = "Sign=WXPay"
}
