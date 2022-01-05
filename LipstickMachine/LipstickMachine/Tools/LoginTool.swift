//
//  LoginTool.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/4.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import SwiftEventBus

enum ValidatedType {
    case Email
    case PhoneNumber
}

class LoginTool: NSObject {

    static private let kUserInfoAddress = "kUserInfoAddress"
    static private var userInfo: UserModel? {
        set {
            if newValue == nil {
                UserDefaults.standard.removeObject(forKey: kUserInfoAddress)
            } else {
                UserDefaults.standard.set(newValue?.toJSONString(), forKey: kUserInfoAddress)
            }
        }
        
        get {
            let userString = UserDefaults.standard.object(forKey: kUserInfoAddress) as? String
            return userString == nil ? nil : UserModel.deserialize(from: userString)
        }
    }
    
    @objc static func isLogin() -> Bool {
        return self.userInfo != nil
    }
    
    static func getUser() -> UserModel? {
        return self.userInfo
    }
    
    static func login(mobeil: String, verifivation: String) {
        if LoginTool.isLogin() {
            return
        }
        
        print("login mobeil: %s", mobeil)
        LoginViewModel.login(
            mobile: mobeil,
            code: verifivation) { (error: Error?, errorDic: [AnyHashable : Any]?, userModel: UserModel?) in
                if error != nil {
                    if errorDic == nil {
                        CBToast.showToastAction(message: "服务器错误")
                    } else {
                        CBToast.showToastAction(message: (errorDic!["msg"] ?? "") as! NSString)
                    }
                    return
                }
                CBToast.showToastAction(message: "登陆成功")
                userInfo = userModel!
                SwiftEventBus.post(kLoginEvent)
        }
    }
    
    static func wecahtLogin(code: String) {
        if LoginTool.isLogin() {
            return
        }
        
        print("wecahtLogin code: %s", code)
        let url = BaseViewModel.URL_HOST + "/api/jucaib/user/login_by_weixin"
        let param = [
            "code"      : code,
        ]
        AFHttpRequest.share()?.requestPOST(withUrl: url, withParams: param, with: { (result: Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "服务器错误")
                } else {
                    CBToast.showToastAction(message: (errorDic!["errmsg"] ?? "") as! NSString)
                }
                return
            }
            let data = (result as! [String : Any])["data"]
            if data == nil {
                CBToast.showToastAction(message: "登录失败")
                return
            }
            
            let userModel = UserModel.deserialize(from: data as? [String : Any])
            CBToast.showToastAction(message: "登陆成功")
            userInfo = userModel!
            SwiftEventBus.post(kLoginEvent)
        })
    }
    
    @objc static func logout() {
        userInfo = nil
        SwiftEventBus.post(kLogoutEvent)
        CBToast.showToastAction(message: "已经退出登录")
        pushLoginController()
    }
    
    //    MARK: 跳转登录页
    @objc static func pushLoginController() {
        let navigation = getNavigationController()
        if navigation.topViewController is LoginController {
            return
        }
        let loginController = LoginController.init(
            nibName: "LoginController",
            bundle: nil
        )
        navigation.pushViewController(loginController, animated: true)
    }
    
    static func getNavigationController() -> LYNavigationController {
        let window: UIWindow? = UIApplication.shared.delegate!.window!
        let tabbar = window?.rootViewController as! LYTabbarController
        let navigation = tabbar.selectedViewController as! LYNavigationController
        return navigation
    }
    
    static func getTabController() -> LYTabbarController {
        let window: UIWindow? = UIApplication.shared.delegate!.window!
        let tabbar = window?.rootViewController as! LYTabbarController
        return tabbar
    }
    
    static func getUserIntegral(callback: @escaping (_ integral: Int) -> ()) {
        let url = BaseViewModel.URL_HOST + "/api/jucaib/user/jsonuser?X-Nideshop-Token=" + (getUser()?.token ?? "")
        AFHttpRequest.share()?.requestGET(withUrl: url, isShowHud: false, withParams: nil, with: { (result : Any?, error: Error?, errorDic: [AnyHashable : Any]?) in
            if error != nil {
                if errorDic == nil {
                    CBToast.showToastAction(message: "请检查网络")
                    return
                }
                CBToast.showToastAction(message: errorDic?["errmsg"] as? NSString ?? "请检查网络")
                return
            }
            let data = (result as! [String : Any])["data"] as? [String: Any] ?? [:]
            let integral = data["jifen"] ?? 0
            callback(integral as! Int)
            print("积分：%d", integral)
        })
    }
    
    private static func validateText(type: ValidatedType, validate: String) -> Bool {
        do {
            let pattern: String
            if type == ValidatedType.Email {
                pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            } else {
                pattern = "^1[0-9]{10}$"
            }
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(
                in: validate,
                options: .reportProgress,
                range: NSMakeRange(0, validate.count)
            )
            return matches.count > 0
        } catch {
            return false
        }
    }
    
    static func EmailIsValidated(vStr: String) -> Bool {
        return validateText(type: ValidatedType.Email, validate: vStr)
    }
    
    static func PhoneNumberIsValidated(vStr: String) -> Bool {
        return validateText(type: ValidatedType.PhoneNumber, validate: vStr)
    }
    
}
