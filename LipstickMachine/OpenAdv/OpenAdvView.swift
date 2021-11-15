//
//  OpenAdvView.swift
//  LipstickMachine
//
//  Created by liuyang04 on 2021/11/12.
//

import UIKit

class OpenAdvView: BaseView {

    @IBOutlet private weak var img: UIImageView!
    @IBOutlet private weak var btn: UIButton!
    
    private var timer: Timer?
    private var countdown = 5
    
    static func instance() -> OpenAdvView {
        let view = OpenAdvView.instanceView(type: "OpenAdvView") as! OpenAdvView
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        view.getData()
        view.img.addGestureRecognizer(UITapGestureRecognizer.init(
            target: view,
            action: #selector(clicked))
        )
        return view
    }
    
    override func appear() {
        super.appear()
        startTimer()
    }

    @IBAction func btnClicked(_ sender: Any) {
        disappear()
    }
    
    /// 加载网络图片
    private func getData() {
        let imgString = PreferenceTool.getAdvImg()
        img.sd_setImage(with: URL(string: imgString), placeholderImage: UIImage.init(named: "launchScreen"))
    }
    
    /// 启动定时器
    private func startTimer() {
        stopTimer()
        countdown = 5
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerAction),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopTimer() {
        timer?.invalidate()
    }
    
    /// 点击跳转
    private func pushToController() {
        stopTimer()
        disappear()
        let controller = WebController()
        controller.url = PreferenceTool.getAdvLink()
        let tab = LYTabbarController.share
        let nav = tab.viewControllers?.first as? UINavigationController
        nav?.pushViewController(controller, animated: true)
    }
    
    @objc private func timerAction() {
        countdown -= 1
        btn.setTitle("\(countdown)秒", for: .normal)
        if countdown > 0 {
            return
        }
        
        stopTimer()
        btnClicked(btn as Any)
    }
    
    @objc private func clicked() {
        pushToController()
    }
    
}
