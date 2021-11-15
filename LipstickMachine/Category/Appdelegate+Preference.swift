//
//  Appdelegate+Preference.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import Foundation
import SwiftEventBus

let kConfigPath         = "configPath"
let kConfigAdUrl        = "ad_url"
let kConfigAppName      = "app_name"
let kConfigKeFu         = "kefu"
let kConfigShowDaiCao   = "show_daicao"
let kWeChatId           = "weixin_id"
let kFreeGameUrl        = "free_game_url"

extension AppDelegate {
    
    func preference() {
        AFHttpRequest.share().configAFInAppDeletage()
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        
        //处理多个按钮同时响应事件
        UIButton.appearance().isExclusiveTouch = true
        
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey(UMENG_APP_KEY, channel: "App Store")
        
        LogViewModel.startLog()
        
    }
    
    func config() {
        let url = BaseViewModel.URL_HOST + "/api/jucaib/user/jsonconfig"
        let param = [
            "screen_size" : "\(Int(kScreenWidth))_\(Int(kScreenHeight))",
            "platform" : "ios"
        ]
        AFHttpRequest.share()?.requestGET(withUrl: url, isShowHud: false, withParams: param, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                return
            }
            var data = (result as! [String : Any])["data"] as! [String : Any]
            data = self.filterData(dic: data)
            UserDefaults.standard.setValue(data, forKey: kConfigPath)
            PreferenceTool.savaAppStoreVersion(version: (data["version"] as? String) ?? "0")
            let screenAd = data["screen_ad"] as? [String : Any]
            PreferenceTool.saveAdvImg(imgUrl: (screenAd?["image_url"] as? String) ?? "")
            PreferenceTool.saveAdvLike(link: (screenAd?["link"] as? String) ?? "")
            
            let tabbar = LYTabbarController.share
            self.window?.rootViewController = tabbar
        })
    }
    
    static func isShowMarket() -> Int {
        let data: [String : Any]? = UserDefaults.standard.object(forKey: kConfigPath) as? [String : Any]
        if data == nil {
            return 0
        }
        return (data![kConfigShowDaiCao] as? Int) ?? 0
    }

    static func getServiceWeChatId() -> String {
        let data: [String : Any]? = UserDefaults.standard.object(forKey: kConfigPath) as? [String : Any]
        if data == nil {
            return ""
        }
        return (data![kWeChatId] as? String) ?? ""
    }
    
    static func getFreeGameUrl() -> String {
        let data: [String : Any]? = UserDefaults.standard.object(forKey: kConfigPath) as? [String : Any]
        if data == nil {
            return ""
        }
        return (data![kFreeGameUrl] as? String) ?? ""
    }
    
    func alipay(result: [AnyHashable : Any]?) {

        if result == nil {
            print("aliPay result is nil.")
            return
        }
        
        let status = result!["resultStatus"] as! String
        switch status {
        case "9000":
            let resultDate = result!["result"] as? String
            if resultDate == nil {
                CBToast.showToastAction(message: (result!["memo"] as? String ?? "") as NSString)
                return
            }
            let data = resultDate?.data(using: String.Encoding.utf8)
            var dic: Dictionary<String, Any>
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                dic = json as! Dictionary<String, Any>
            }catch _ {
                CBToast.showToastAction(message: (result!["memo"] as? String ?? "") as NSString)
                return
            }
            let payResponse = dic["alipay_trade_app_pay_response"] as? [String : Any]
            if payResponse == nil {
                return
            }
            let orderId = payResponse!["out_trade_no"] as? String
            if orderId == nil {
                CBToast.showToastAction(message: (result!["memo"] as? String ?? "") as NSString)
                return
            }
            
            SwiftEventBus.post(kPaySuccessEvent, sender: orderId! as NSString)
        default:
            break
        }
    }
    
    
    /// 处理数据
    /// - Parameter dic: <#dic description#>
    /// - Returns: <#description#>
    private func filterData(dic: [String : Any]) -> [String : Any] {
        var tmp: [String : Any] = [:]
        for key in dic.keys {
            var value = dic[key]
            if value is [String : Any] {
                value = filterData(dic: value as! [String : Any])
            }
            
            if value == nil || value is NSNull{
                value = ""
            }
            tmp[key] = value
        }
        return tmp
    }
}
