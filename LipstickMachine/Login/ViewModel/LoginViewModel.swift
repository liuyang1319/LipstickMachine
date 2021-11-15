//
//  LoginViewModel.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

class LoginViewModel: BaseViewModel {
    
    static let kServiceAgreementUrl = "https://api.jucaib.com/xieyi.html"
    
    static func login(mobile: String, code: String, callback: @escaping (_ error: Error?, _ errorDic: [AnyHashable : Any]?, _ user: UserModel?) -> ()) {
        let url = URL_HOST + "/api/jucaib/user/login"
        let param = [
            "mobile"    : mobile,
            "code"      : code
        ]
        AFHttpRequest.share()?.requestPOST(withUrl: url, withParams: param, with: { (request: Any?, error:Error?, errorDic:[AnyHashable : Any]?) in
            if error != nil {
                callback(error, errorDic, nil)
                return
            }
            let data = (request as! [String : Any])["data"] as? NSDictionary
            if data == nil {
                return
            }
            let user = UserModel.deserialize(from: (data!))
            callback(nil, nil, user)
        })
    }
    
    static func sendeSmscode(mobile: String, callback: @escaping (_ success: Bool) -> ()) {
        let url = URL_HOST + "/api/jucaib/user/smscode"
        AFHttpRequest.share()?.requestGET(withUrl: url, isShowHud: true, withParams: ["phone":mobile], with: { (request: Any?, error:Error?, errorDic:[AnyHashable : Any]?) in
            if error == nil {
                callback(true)
            } else {
                callback(false)
            }
        })
    }
}
