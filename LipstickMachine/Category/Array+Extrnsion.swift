//
//  Array+Extrnsion.swift
//  Consult
//
//  Created by admin on 2017/8/29.
//  Copyright © 2017年 com.easyto.consult. All rights reserved.
//

import UIKit


extension Array {
    mutating func addFromArray(array: [Element]) {
        
        for item: Element in array {
            self.append(item)
        }
    }

    mutating func removeObject(obj: Element) {
        if obj == nil {
            return
        }
        
        let array: NSMutableArray = NSMutableArray.init(array: self)
        if array.contains(obj) {
            array.remove(obj)
        }
        
        if self.count > array.count {
            self.removeAll()
            
            for item in array {
                let element: Element = item as! Element
                self.append(element)
            }
        }
        
    }
}
