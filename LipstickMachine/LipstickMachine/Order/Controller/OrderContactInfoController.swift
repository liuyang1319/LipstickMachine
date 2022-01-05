//
//  OrderContactInfoController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import SwiftEventBus

class OrderContactInfoController: BaseController {

    @IBOutlet weak var realNameTextfield: UITextField!
    @IBOutlet weak var contactInfoTextfield: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var model: OrderModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "联系方式"
        edgesForExtendedLayout = .bottom
        addressTextView.layer.borderColor = UIColor.init(hex: 0xE1E1E1).cgColor
        cancelBtn.layer.borderColor = UIColor.black.cgColor
        tableView.removeFromSuperview()
    }

    @IBAction func getLipstickBtnClicked() {
        if realNameTextfield.text?.count == 0 {
            CBToast.showToastAction(message: "请正确填写真实姓名")
            return
        }
        
        if contactInfoTextfield.text?.count == 0 || !LoginTool.PhoneNumberIsValidated(vStr: contactInfoTextfield.text!) {
            CBToast.showToastAction(message: "请正确填写联系方式")
            return
        }
        
        if addressTextView.text?.count == 0 {
            CBToast.showToastAction(message: "请正确填写收货地址")
            return
        }
        
        getLipstick()
    }
    
    private func getLipstick() {
        if model == nil {
            return
        }
        OrderViewModel.getLipstick(
            orderId: model!.id,
            consignee: realNameTextfield.text!,
            address: addressTextView.text,
            mobile: contactInfoTextfield.text!) {
                SwiftEventBus.post(kOrderCompleteAddress, sender: self.model!)
                self.leftBtnClicked()
        }
    }
    
    @IBAction func cancelBtnClicked() {
        leftBtnClicked()
    }
}
