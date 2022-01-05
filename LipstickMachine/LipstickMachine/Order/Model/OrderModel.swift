//
//  OrderModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/9.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class OrderModel: BaseModel {
    
    var id: Int                 = 0
    var orderSn: String         = ""
    var gid: Int                = 0
    var uid: Int                = 0
    var orderStatus: Int        = 0     //0领取口红,1代发货,2已发货,3确认收货
    var shippingStatus: Int     = 0
    var consignee: String       = ""
    var address: String         = ""
    var mobile: String          = ""
    var shippingFee: String     = ""
    var shippingNo: String      = ""
    var shippingName: String    = ""
    var addTime: String         = ""
    var updateTime: String      = ""
    var confirmTime: String     = ""
    var good: IndexGoodsModel?
    

}
