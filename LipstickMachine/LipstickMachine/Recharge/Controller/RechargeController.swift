//
//  RechargeController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import SwiftEventBus

class RechargeController: BaseController, RechargeViewDelegate {
    
    @IBOutlet weak var rechargeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rechargeView: UIView!
    @IBOutlet weak var integral: UILabel!
    
    private var selectedRechargeView: RechargeView?
    
    var isShowLeftBtn = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setIntegral()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "充值"
        tableView.removeFromSuperview()
        edgesForExtendedLayout = .bottom
        getData()
        
        SwiftEventBus.onMainThread(self, name: kPaySuccessEvent) { (result: Notification?) in
            if result == nil || result?.object == nil {
                if self.navigationController?.viewControllers.count == 1 {
                    self.setIntegral()
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
                return
            }
            let orderId = result!.object as! String
            OrderViewModel.paySuccess(orderId: orderId, callback: {
                SwiftEventBus.post(kPaySuccessEvent)
            })
        }
    }
    
    override func getData() {
        RechargeViewModel.getData { (results: [RechargeModel]) in
            self.dataArray = results
            self.addRechargeView()
        }
    }
    
    private func addRechargeView() {
        for subView: UIView in rechargeView.subviews {
            if subView is RechargeView {
                subView.removeFromSuperview()
            }
        }

        if dataArray.count == 0 {
            return
        }
        
        addMobilePay()
    }
    
//    fileprivate func addInnerPay() {
//        let model = RechargeModel()
//        model.id = 1
//        model.jifen = 6
//        model.payNum = 6
//        model.type = "ios_check"
//        let width = (kScreenWidth - 40) / 2.0 as CGFloat
//        let frame = CGRect.init(
//            x: 0,
//            y: 0,
//            width: width,
//            height: 45.0
//        )
//        let view: RechargeView = RechargeView.instance()
//        view.frame = frame
//        view.setValue(model: model)
//        view.delegate = self
//        rechargeView.addSubview(view)
//        rechargeViewHeight.constant = 45 + 12
//    }
//
    fileprivate func addMobilePay() {
        let lineCount = dataArray.count%2 == 0 ? dataArray.count/2 : dataArray.count/2+1
        rechargeViewHeight.constant = CGFloat(lineCount)*(45 + 12)
        var i = 0
        let width = (kScreenWidth - 40) / 2.0 as CGFloat
        for model: RechargeModel in dataArray as! [RechargeModel] {
            let frame = CGRect.init(
                x: i%2 == 0 ? 0 : 10 + width,
                y: (CGFloat)(i/2)*(45.0+12.0),
                width: width,
                height: 45.0
            )
            let view: RechargeView = RechargeView.instance()
            view.frame = frame
            view.setValue(model: model)
            view.delegate = self
            rechargeView.addSubview(view)
            i += 1
        }
    }
    
    func RechargeSelected(view: RechargeView) {
        if selectedRechargeView == nil {
            selectedRechargeView = view
            return
        }
        if selectedRechargeView == view {
            selectedRechargeView?.setSelected(isSelected: true)
            return
        }
        selectedRechargeView!.setSelected(isSelected: false)
        selectedRechargeView = view
    }
    
    @IBAction func rechargeBtnClicked() {
        if selectedRechargeView == nil {
            CBToast.showToastAction(message: "请选择要充值的选项")
            return
        }
        
        if !LoginTool.isLogin() {
            CBToast.showToastAction(message: "请登录")
            LoginTool.pushLoginController()
            return
        }
        
        let model = selectedRechargeView?.getModel()
        if model == nil {
            return
        }
        
        LogViewModel.productRecharge(item: "\(String(describing: model?.id))")
    }
    
    private func setIntegral() {
        if !LoginTool.isLogin() {
            integral.text = "当前积分：--"
        } else {
            LoginTool.getUserIntegral { (integral: Int) in
                self.integral.text = "当前积分：\(integral)"
            }
        }
    }
}
