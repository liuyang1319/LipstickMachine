//
//  OrderCell.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import SwiftEventBus

class OrderCell: LYSwiftXibBaseCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var stateBtn: UIButton!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var logisticsView: UIView!
    @IBOutlet weak var logistics: UILabel!
    @IBOutlet weak var logisticsId: UILabel!
    
    var model: OrderModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stateBtn.layer.borderColor = UIColor.black.cgColor
        logisticsView.isHidden = true
        
        SwiftEventBus.onMainThread(self, name: kOrderCompleteAddress) { (result: Notification?) in
            if self.model == nil {
                return
            }
            let model: OrderModel = result!.object as! OrderModel
            if self.model!.gid == model.gid {
                self.model!.orderStatus = 1
                self.setValue(model: self.model)
            }
        }
    }
    
    static func getHeight(model: OrderModel?) -> CGFloat {
        if model == nil {
            return 0
        }
        if model?.orderStatus == 0 || model?.orderStatus == 1 {
            return 141
        } else {
            return 172
        }
    }
    
    func setValue(model: OrderModel?) {
        self.model = model
        if model == nil {
            return
        }
        date.text       = model!.addTime
        name.text       = model?.good?.name
        color.text      = model?.good?.colorName
        price.text      = "专柜价：¥" + "\(model?.good?.counterPrice ?? 0)"
        var title = ""
        var isLogisticsHidden = true
        var logisticsCompany: String?
        var logisticsIdString: String?
        switch model?.orderStatus {
        case 0:
            title = "领取口红"
            isLogisticsHidden = true
            stateBtn.layer.borderColor = UIColor.clear.cgColor
            stateBtn.setBackgroundImage(UIImage.init(named: "order_get_lipstick_background"), for: .normal)
        case 1:
            title = "待发货"
            isLogisticsHidden = true
            stateBtn.layer.borderColor = UIColor.black.cgColor
            stateBtn.setBackgroundImage(nil, for: .normal)
        case 2:
            title = "已发货"
            isLogisticsHidden = false
            logisticsCompany = model?.shippingName
            logisticsIdString = model?.shippingNo
            stateBtn.layer.borderColor = UIColor.black.cgColor
            stateBtn.setBackgroundImage(nil, for: .normal)
        case 3:
            title = "确认收货"
            isLogisticsHidden = false
            logisticsCompany = model?.shippingName
            logisticsIdString = model?.shippingNo
            stateBtn.layer.borderColor = UIColor.black.cgColor
            stateBtn.setBackgroundImage(nil, for: .normal)
        default:
            break
        }
        stateBtn.setTitle(title, for: .normal)
        icon.sd_setImage(with: URL.init(string: model?.good?.listPicUrl ?? ""))
        logisticsView.isHidden = isLogisticsHidden
        logistics.text      = logisticsCompany
        logisticsId.text    = logisticsIdString
    }
}
