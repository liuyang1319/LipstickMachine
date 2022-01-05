//
//  MarketViewModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class MarketViewModel: BaseViewModel {

    static func getData(callback: @escaping (_ results: [MarketItemModel]) -> ()) {
        let url = URL_HOST + "/api/jucaib/game/daichao"
        AFHttpRequest.share()?.requestGET(withUrl: url, isShowHud: false, withParams: nil, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "请检查网络")
                    return
                }
                CBToast.showToastAction(message: errorDic?["errmsg"] as? NSString ?? "请检查网络")
                return
            }
            let data = (result as! [String : Any])["data"] as? [[String: Any]] ?? []
            var results: [MarketItemModel] = []
            for item: [String : Any] in data {
                let model = MarketItemModel.deserialize(from: item)
                if model == nil {
                    continue
                }
                results.append(model!)
            }
            callback(results)
        })
    }
    
    static func action(model: MarketItemModel?) {
        if model == nil {
            return
        }
        let url = URL_HOST + "/api/jucaib/game/act"
        var param = [
            "json"  : "true",
            "dkId"  : "\(model?.dkid ?? 0)",
            "source": "ios",
        ]
        if LoginTool.isLogin() {
            param["uid"] = "\(LoginTool.getUser()?.user?.userId ?? 0)"
        }
        AFHttpRequest.share()?.requestPOST(withUrl: url, isShowHud: false, withParams: param, with: { (result: Any?, error: Error?, errodDic: [AnyHashable : Any]?) in
            
        })
    }
    
}
