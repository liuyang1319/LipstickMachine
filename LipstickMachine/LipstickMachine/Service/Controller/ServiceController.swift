//
//  ServiceController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class ServiceController: BaseController {

    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var service: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "联系客服"
        tableView.removeFromSuperview()
        edgesForExtendedLayout = .bottom
        copyBtn.layer.borderColor = UIColor.black.cgColor
        let config = UserDefaults.standard.object(forKey: kConfigPath)
        if config == nil {
            return
        }
        let servicePath = (config as! [String : Any])[kConfigKeFu] as? String
        QRImage.sd_setImage(with: URL.init(string: servicePath ?? ""))
        service.text = "专属客服微信号 " + AppDelegate.getServiceWeChatId()
    }
    
    @IBAction func copyBtnClicked() {
        //        TODO: config service num
        UIPasteboard.general.string = AppDelegate.getServiceWeChatId()
        CBToast.showToastAction(message: "复制成功")
    }
    
}
