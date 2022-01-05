//
//  LogViewModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/7/3.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class LogViewModel: BaseViewModel {
    
    static func startLog() {
        let url = URL_LOG + "?t=20&platform=ios&rseat=launch&item=&ext="
        request(url: url)
    }
    
    static func bannerDidClicked(item: String) {
        let url = URL_LOG + "?t=22&platform=ios&rseat=click_banner&item=" + item
        request(url: url)
    }
    
    static func indexItemClick(item: String) {
        let url = URL_LOG + "?t=22&platform=ios&rseat=click_product&item=" + item
        request(url: url)
    }
    
    static func productChallenge(item: String) {
        let url = URL_LOG + "?t=22&platform=ios&rseat=click_challenge&item=" + item
        request(url: url)
    }
    
    static func productRecharge(item: String) {
        let url = URL_LOG + "?t=22&platform=ios&rseat=click_recharge&item=" + item
        request(url: url)
    }
    
    static func payViewAppear() {
        let url = URL_LOG + "?t=21&platform=ios&rseat=prepay_window&item="
        request(url: url)
    }
    
    static func payType(type: String) {
        let url = URL_LOG + "?t=22&platform=ios&rseat=paytype&item=" + type
        request(url: url)
    }
    
    static func payConfirm() {
        let url = URL_LOG + "?t=22&platform=ios&rseat=pay_confirm&item="
        request(url: url)
    }
    
    static func payCancel() {
        let url = URL_LOG + "?t=22&platform=ios&rseat=pay_cancel&item="
        request(url: url)
    }
    
    static fileprivate func request(url: String) {
        AFHttpRequest.share()?.requestGET(withUrl: url, withParams: nil, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            print(result.debugDescription)
        })
    }
}
