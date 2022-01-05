//
//  Constant.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import Foundation
import UIKit

let kScreenBounds = UIScreen.main.bounds
let kScreenWidth = kScreenBounds.size.width
let kScreenHeight = kScreenBounds.size.height

let IsIphone5:Bool                               = (kScreenWidth == 320
    && kScreenHeight == 568) ? true : false
let IsIphoneX:Bool                               = ((kScreenWidth == 375
    && kScreenHeight == 812) || (kScreenWidth == 414
        && kScreenHeight == 896)) ? true : false
//常用高度
let StatusBarHeight: CGFloat                     = (IsIphoneX ? 44 : 20)
let NavigationHeight: CGFloat                    = 44.0
let TabBarHeight: CGFloat                        = (IsIphoneX ? (49 + 34) : 49)
let StatusBarAndNavHeight                        = (StatusBarHeight + NavigationHeight)
let TabbarSafeBottomMargin: CGFloat              = (IsIphoneX ? 34 : 0)

func getScal(height: CGFloat) -> CGFloat {
    return (kScreenWidth / 375) * height
}
//常用颜色
let TABBAR_TITLE_NORMAL_COLOR                   = UIColor.init(hex: 0x666666)
let TABBAR_TITLE_SELECTED_COLOR                 = UIColor.init(hex: 0xFC598D)
let TABBAR_BACKGROUND_COLOR                     = UIColor.white

let APP_NAME        = "口红机"
let WEXIN_ID        = "wx9002438d10b58a95"
let WEXIN_SECERT    = "f5d3532ee736a903836494d705a1b4ed"
let UMENG_APP_KEY   = "5d1c34010cafb2e1de000f3d"
