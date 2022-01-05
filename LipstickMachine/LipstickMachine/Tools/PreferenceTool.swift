//
//  PreferenceTool.swift
//  LipstickMachine
//
//  Created by easyto on 2019/7/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class PreferenceTool: NSObject {
    fileprivate static let versionPath = "versionPath"
    fileprivate static let advImgPath = "advImgPath"
    fileprivate static let advLinkPath = "advLinkPath"
    
    static func savaAppStoreVersion(version: String) {
        print("savaAppStoreVersion version: " + version)
        UserDefaults.standard.setValue(version, forKey: versionPath)
    }
    
    static func getAppStoreVersion() -> String {
        return UserDefaults.standard.object(forKey: versionPath) as! String
    }
    
    static func isTheLastVersion() -> Bool {
        let info: [String : Any] = Bundle.main.infoDictionary!
        let currentVersion: String = info["CFBundleShortVersionString"] as! String
        let currentVersionFloatString = currentVersion.replacingOccurrences(of: ".", with: "")
        let appStoreVersionFloatString = getAppStoreVersion().replacingOccurrences(of: ".", with: "")
        let isTheLastVersion: Bool = currentVersionFloatString.toFloat() == appStoreVersionFloatString.toFloat()
        print("isTheLastVersion:" + "\(isTheLastVersion)")
        print("currentVersion: " + currentVersion)
        print("getAppStoreVersion: " + getAppStoreVersion())
        return isTheLastVersion
    }
    
    /// 保存广告图片远程连接
    /// - Parameter imgUrl: imgUrl description
    static func saveAdvImg(imgUrl: String) {
        UserDefaults.standard.setValue(imgUrl, forKey: advImgPath)
    }
    
    /// 获取广告图片远程连接地址
    /// - Returns: url
    static func getAdvImg() -> String {
        return (UserDefaults.standard.value(forKey: advImgPath) as? String) ?? ""
    }
    
    /// 保存广告点击链接
    /// - Parameter link: link description
    static func saveAdvLike(link: String) {
        UserDefaults.standard.setValue(link, forKey: advLinkPath)
    }
    
    static func getAdvLink() -> String {
        return (UserDefaults.standard.value(forKey: advLinkPath) as? String) ?? ""
    }
}
