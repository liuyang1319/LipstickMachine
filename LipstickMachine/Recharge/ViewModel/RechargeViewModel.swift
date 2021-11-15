//
//  RechargeViewModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class RechargeViewModel: BaseViewModel {

    static func getData(callback: @escaping (_ results: [RechargeModel]) -> ()) {
        let url = URL_HOST + "/api/jucaib/game/recharge"
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
            var results: [RechargeModel] = []
            for item: [String : Any] in data {
                let model = RechargeModel.deserialize(from: item)
                if model == nil {
                    continue
                }
                results.append(model!)
            }
            callback(results)
        })
    }
    
}
