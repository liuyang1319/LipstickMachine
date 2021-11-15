//
//  IndexViewModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class IndexViewModel: BaseViewModel {

    static func getData(callback: @escaping (_ banner: [IndexBannerModel], _ goods: [IndexGoodsModel], _ notice: [String]) -> ()) {
        var url = URL_HOST + "/api/jucaib/game/index"
        if LoginTool.isLogin() {
            url += "?X-Nideshop-Token=" + (LoginTool.getUser()?.token ?? "")
        }
        AFHttpRequest.share()?.requestGET(withUrl: url, isShowHud: false, withParams: nil, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "请检查网络")
                    return
                }
                CBToast.showToastAction(message: errorDic?["errmsg"] as? NSString ?? "请检查网络")
                return
            }
            let data = (result as! [String : Any])["data"] as? [String : Any]?
            if data == nil {
                return
            }
            var banners: [IndexBannerModel] = []
            let dataBanners = data!?["banner"] as? [[String : Any]]
            for dic:[String:Any] in dataBanners ?? [] {
                let bannerModel = IndexBannerModel.deserialize(from: dic)
                if bannerModel == nil {
                    continue
                }
                banners.append(bannerModel!)
            }
            
            var goods: [IndexGoodsModel] = []
            let dataGoods = data!?["goods"] as? [[String : Any]]
            for dic:[String:Any] in dataGoods ?? [] {
                let goodsModel = IndexGoodsModel.deserialize(from: dic)
                if goodsModel == nil {
                    continue
                }
                goods.append(goodsModel!)
            }
            
            var notice: [String]?
            let noticeDic = data!?["notice"] as? [String]
            notice = noticeDic == nil ? [] : noticeDic
            
            callback(banners, goods, notice!)
        })
    }
    
    static func startGame(gid: Int, callback: @escaping (_ gameUrl: String) -> ()) {
        var url = URL_HOST + "/api/jucaib/game/init?gid=\(gid)&X-Nideshop-Token="
        url += LoginTool.getUser()?.token ?? ""
        AFHttpRequest.share()?.requestGET(withUrl: url, withParams: nil, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "请检查网络")
                    return
                }
                CBToast.showToastAction(message: errorDic?["errmsg"] as? NSString ?? "请检查网络")
                return
            }
            let data = (result as! [String : Any])["data"] as? [String : Any]?
            if data == nil {
                return
            }
            
            
            callback((data!?["game_url"] as? String) ?? "")
        })
    }
    
}
