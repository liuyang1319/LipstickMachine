//
//  IndexGoodsAlertView.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

protocol IndexGoodsAlertDelegate {
    func startGame(gameUrl: String)
}

class IndexGoodsAlertView: BaseView {

    static let share = IndexGoodsAlertView.instanceView(type: "IndexGoodsAlertView") as! IndexGoodsAlertView
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var rechargeBtn: UIButton!
    @IBOutlet weak var buyBtn: UIButton!
    
    
    var delegate: IndexGoodsAlertDelegate?
    var model: IndexGoodsModel?
    
    func setValue(model: IndexGoodsModel?) {
        self.model = model
        if model == nil {
            disappear()
            return
        }
        
        buyBtn.isHidden = PreferenceTool.isTheLastVersion()
        challengeBtn.isHidden = !buyBtn.isHidden
        rechargeBtn.isHidden = !buyBtn.isHidden
        
        image.sd_setImage(with: URL.init(string: model?.primaryPicUrl ?? ""))
        brand.text  = model?.brand
        name.text   = model?.name
        price.text  = "专柜价：¥" + "\(String(describing: model?.counterPrice ?? 0))"
        colorView.backgroundColor   = UIColor.init(hex: model?.colorValue.hexStringToInt() ?? 0x000000)
        colorLabel.text     = model?.colorName
        challengeBtn.setTitle("\(String(describing: model?.marketPrice ?? 0))" + "积分挑战", for: .normal)
    }

    @IBAction private func challenge() {
        disappear()
        if !LoginTool.isLogin() {
            CBToast.showToastAction(message: "请先登录")
            LoginTool.pushLoginController()
            return
        }
        if model == nil {
            return
        }
        IndexViewModel.startGame(gid: model?.gid ?? 0) { (gameUrl: String) in
            self.delegate?.startGame(gameUrl: gameUrl)
            LogViewModel.productChallenge(item: "\(String(describing: self.model?.gid))")
        }
    }
    
    @IBAction private func recharge(_ sender: Any) {
        disappear()
        let controller = RechargeController.init(nibName: "RechargeController", bundle: nil)
        LoginTool.getNavigationController().pushViewController(controller, animated: true)
    }
    
    
    @IBAction func btnClicked() {
        disappear()
        CBToast.showToastAction(message: "购买成功，稍后会有客服人员联系您")
    }
    
    @IBAction private func dismiss() {
        disappear()
    }
}
