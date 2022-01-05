//
//  BaseFlowLayout.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class BaseFlowLayout: UICollectionViewFlowLayout {

    
    override init() {
        super.init()
        
        self.minimumLineSpacing = 0.0
        self.minimumInteritemSpacing = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
        if array.count == 3 {
            
            for item in array {
                let indexPath: IndexPath = item.indexPath
                if indexPath.row == 0 {
                    
                    let att: UICollectionViewLayoutAttributes = array.last!
                    var rect: CGRect = att.frame
                    rect.origin.x = 0
                    att.frame = rect
                }
            }
        }
        
        return array
        
    }
}
