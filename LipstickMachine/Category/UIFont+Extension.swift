//
//  UIFont+Font.swift
//  PipixiaTravel
//
//  Created by admin on 2017/7/24.
//  Copyright © 2017年 easyto. All rights reserved.
//

import UIKit

extension UIFont {
    class func Font(font: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: font);
    }
    
    class func Bold(font: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize:font);
    }
    
}
