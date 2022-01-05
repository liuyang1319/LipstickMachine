//
//  OrderViewModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/9.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class OrderViewModel: BaseViewModel {

    static func getData(page: Int, callback: @escaping (_ results: [OrderModel]) -> ()) {
        var url = URL_HOST + "/api/jucaib/order/list" + "?X-Nideshop-Token=" + (LoginTool.getUser()?.token ?? "")
        url += "&page=" + "\(page)"
        url += "&size=10"
        AFHttpRequest.share()?.requestGET(withUrl: url, withParams: nil, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "请检查网络")
                    return
                }
                CBToast.showToastAction(message: errorDic?["errmsg"] as? NSString ?? "请检查网络")
                return
            }
            let data = (result as! [String : Any])["data"] as? [String: Any] ?? [:]
            let list = data["list"] as? [[String : Any]] ?? [[:]]
            var results: [OrderModel] = []
            for dic: [String : Any] in list {
                let model: OrderModel = OrderModel.deserialize(from: dic)!
                results.append(model)
            }
            callback(results)
        })
    }
    
    static func getLipstick(
        orderId: Int,
        consignee: String,
        address: String,
        mobile: String,
        callback: @escaping () -> ()) {
        let url = URL_HOST + "/api/jucaib/order/drawlipstick"
        let param = [
            "orderId"   : "\(orderId)",
            "consignee" : consignee,
            "address"   : address,
            "mobile"    : mobile,
            "X-Nideshop-Token" : LoginTool.getUser()?.token ?? ""
        ]
        AFHttpRequest.share()?.requestPOST(withUrl: url, withParams: param, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "请检查网络")
                    return
                }
                CBToast.showToastAction(message: errorDic?["errmsg"] as? NSString ?? "请检查网络")
                return
            }
            CBToast.showToastAction(message: "已成功")
            callback()
        })
    }
    
    
    static func paySuccess(orderId: String, callback: @escaping() -> ()) {
        let url = URL_HOST + "/api/jucaib/pay/get_pay_result"
        let param = [
            "orderId" : orderId,
            "X-Nideshop-Token" : LoginTool.getUser()?.token ?? ""
        ]
        AFHttpRequest.share()?.requestGET(withUrl: url, withParams: param, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "请检查网络")
                    return
                }
                CBToast.showToastAction(message: errorDic?["errmsg"] as? NSString ?? "请检查网络")
                return
            }
            callback()
        })
    }
    
}
