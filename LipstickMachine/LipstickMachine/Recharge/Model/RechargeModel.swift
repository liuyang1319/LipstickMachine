//
//  RechargeModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

public let TYPE_IOS_PAY = "ios_check"

class RechargeModel: BaseModel {
    var productId: String = ""
    var id: Int         = 0
    var payNum: Int     = 0
    var jifen: Int      = 0
    var type: String    = ""
    
    func isIosPay() -> Bool {
        return type == TYPE_IOS_PAY
    }
}
