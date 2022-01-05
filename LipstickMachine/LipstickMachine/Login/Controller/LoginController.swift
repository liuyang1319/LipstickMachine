//
//  LoginController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/4.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import SwiftEventBus

class LoginController: BaseController {

    @IBOutlet weak private var mobeilTextField: UITextField!
    @IBOutlet weak private var verificationTextField: UITextField!
    @IBOutlet weak var verificationBtn: UIButton!
    @IBOutlet weak var backgroundImageTop: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageBottom: NSLayoutConstraint!
    
    private var timer: Timer?
    private var timeInterval = 60
    
    @IBOutlet weak var wechatBtn: UIButton!
    @IBOutlet weak var wechatTitle: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.removeFromSuperview()
        edgesForExtendedLayout = .bottom
        verificationBtn.layer.borderColor = UIColor.black.cgColor
        backgroundImageTop.constant = -StatusBarHeight
        backgroundImageBottom.constant = -TabbarSafeBottomMargin
        
        SwiftEventBus.onMainThread(self, name: kLoginEvent) { (result: Notification?) in
            self.leftBtnClicked()
        }
        
        SwiftEventBus.onBackgroundThread(self, name: kWechatLogin) { (result: Notification?) in
            print("kWechatLogin event")
            let code = result!.object as! String
            LoginTool.wecahtLogin(code: code)
        }
    }

    @IBAction private func backBtnClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func verficationBtnClicked(_ sender: UIButton) {
        if !LoginTool.PhoneNumberIsValidated(vStr: mobeilTextField.text ?? "") {
            CBToast.showToastAction(message: "请填写正确的电话号码")
            return
        }
        
        if timer != nil {
            CBToast.showToastAction(message: "请稍后重试")
            return
        }
        
        LoginViewModel.sendeSmscode(mobile: mobeilTextField.text ?? "") { (isSuccess: Bool) in
            if !isSuccess {
                CBToast.showToastAction(message: "请重新发送")
                return
            }
            
            self.verificationBtn.setTitle("60秒后重试", for: .normal)
            self.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(LoginController.verficationTimeAction),
                userInfo: nil,
                repeats: true
            )
        }

    }
    
    @IBAction private func serviceAgreementBtnClicked() {
        let webController = WebController()
        webController.url = LoginViewModel.kServiceAgreementUrl
        navigationController?.pushViewController(webController, animated: true)
    }
    
    @IBAction private func loginBtnClicked() {
        view.endEditing(true)
        
        if !LoginTool.PhoneNumberIsValidated(vStr: mobeilTextField.text ?? "") {
            CBToast.showToastAction(message: "请填写正确的电话号码")
            return
        }
        
        if verificationTextField.text?.count == 0 {
            CBToast.showToastAction(message: "请填写正确的验证码")
            return
        }
        
        LoginTool.login(
            mobeil: mobeilTextField.text ?? "",
            verifivation: verificationTextField.text ?? ""
        ) 
    }
    
    @IBAction private func wechatLoginBtnClicked() {
    
    }
        
    @objc private func verficationTimeAction() {
        timeInterval -= 1
        if timeInterval == 0 {
            timeInterval = 60
            verificationBtn.setTitle("获取验证码", for: .normal)
            timer?.invalidate()
            timer = nil
            return
        }
        let interval = "\(timeInterval)" + "秒后重试"
        verificationBtn.setTitle(interval, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
