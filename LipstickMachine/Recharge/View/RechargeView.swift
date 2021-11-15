//
//  RechargeView.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

protocol RechargeViewDelegate {
    func RechargeSelected(view: RechargeView)
}

class RechargeView: BaseView {
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var integral: UILabel!
    private var isSelected: Bool = false
    private var model: RechargeModel?
    
    var delegate: RechargeViewDelegate?
    
    static func instance () -> RechargeView{
        let myView: RechargeView = Bundle.main.loadNibNamed("RechargeView", owner: nil, options: nil)?.first as! RechargeView
        myView.mj_size = CGSize.init(width: 168, height: 45)
        myView.layer.borderColor = UIColor.init(hex: 0xAFAFAF).cgColor
        myView.addTapGestureRecognizer()
        return myView
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(RechargeView.clicked))
        addGestureRecognizer(tap)
    }
    
    func setSelected(isSelected: Bool) {
        self.isSelected = isSelected
        backgroundImage.image = isSelected ? UIImage.init(named: "recharge_background_selected") : nil
        layer.borderColor = isSelected ? UIColor.clear.cgColor : UIColor.init(hex: 0xAFAFAF).cgColor
        price.textColor = isSelected ? UIColor.init(hex: 0xFC598D) : UIColor.init(hex: 0xA8A8A8)
        integral.textColor = price.textColor
    }
    
    func setValue(model: RechargeModel?) {
        self.model = model
        if model == nil {
            return
        }
        price.text  = "¥ \(model?.payNum ?? 0)"
        integral.text   = "\(model?.jifen ?? 0)积分(首充翻倍)"
    }
    
    func getModel() -> RechargeModel? {
        return model
    }
    
    @objc private func clicked() {
        isSelected = !isSelected
        setSelected(isSelected: true)
        delegate?.RechargeSelected(view: self)
    }
}
