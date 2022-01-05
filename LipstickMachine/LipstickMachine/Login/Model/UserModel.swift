//
//  UserModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class UserModel: BaseModel {
    
    var expire : CLong              = 0
    var token                       = ""
    var user: UserInfoModel?
    
}

class UserInfoModel: BaseModel {
    var userId: Int                 = 0
    var username                    = ""
    var gender: Int                 = 0
    var birthday                    = ""
    var register_time               = ""
    var last_login_time             = ""
    var last_login_ip               = ""
    var user_level_id               = ""
    var nickname                    = ""
    var mobile                      = ""
    var register_ip                 = ""
    var avatar                      = ""
    var weixin_openid               = ""
    var company_name                = ""
    var company_address             = ""
}
