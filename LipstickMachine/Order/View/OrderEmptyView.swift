//
//  OrderEmptyView.swift
//  LipstickMachine
//
//  Created by easyto on 2019/6/13.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

protocol OrderEmptyViewDelegate {
    func orderEmptyClicked()
}

class OrderEmptyView: BaseView {
    
    var delegate: OrderEmptyViewDelegate?
    
    public static func instanceView () -> OrderEmptyView{
        let myView = Bundle.main.loadNibNamed("OrderEmptyView", owner: nil, options: nil)?.first as! OrderEmptyView;
        myView.addGestureRecognizer(UITapGestureRecognizer.init(target: myView, action: #selector(click)))
        return myView;
    }
    
    @objc fileprivate func click() {
        delegate?.orderEmptyClicked();
    }
    
}
