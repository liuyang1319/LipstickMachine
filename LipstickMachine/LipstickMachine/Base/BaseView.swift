//
//  BaseView.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class BaseView: UIView {

    public static func instanceView (type: String) -> AnyObject{
        let myView = Bundle.main.loadNibNamed(type, owner: nil, options: nil)?.first;
        return myView as AnyObject;
    }
    
    func appear() {
        let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let window: UIWindow = app.window!
        self.frame = kScreenBounds
        window.addSubview(self)
        
    }
    
    func disappear() {
        self.removeFromSuperview()
    }

}
