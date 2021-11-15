//
//  MineController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import SwiftEventBus

class MineController: BaseController {

    private let kMainMessageCellIdentifier = "MainMessageCell"
    private let kMainItemCellIdentifier = "MainItemCell"
    private let items = [
        [
            MainItemModel.init(
                icon: "mine_order",
                title: "我的订单",
                isShowMoreIcon: true,
                isShowBottomView: true
            ),
            MainItemModel.init(
                icon: "mine_recharge",
                title: "我要充值",
                isShowMoreIcon: true,
                isShowBottomView: true
            ),
            MainItemModel.init(
                icon: "mine_service",
                title: "联系客服",
                isShowMoreIcon: true,
                isShowBottomView: false
            ),
        ],
        [
            MainItemModel.init(
                icon: "mine_exit",
                title: "退出登录",
                isShowMoreIcon: false,
                isShowBottomView: false
            )
        ]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tableView.reloadData()
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
        
        initTableView()
        
        SwiftEventBus.onMainThread(self, name: kLoginEvent) { (result: Notification?) in
            self.tableView.reloadData()
        }
        
        SwiftEventBus.onMainThread(self, name: kLogoutEvent) { (result: Notification?) in
            self.tableView.reloadData()
        }
        
        SwiftEventBus.onMainThread(self, name: kConsumeEvent) { (result: Notification?) in
            self.tableView.reloadData()
        }
        
        SwiftEventBus.onMainThread(self, name: kPaySuccessEvent) { (result: Notification?) in
            if result == nil || result?.object == nil {            
                self.tableView.reloadData()
            }
        }
    }
    
    private func initTableView() {
        cellArray = [
            kMainMessageCellIdentifier,
            kMainItemCellIdentifier
        ]
        tableView.mj_h = kScreenHeight - StatusBarAndNavHeight
        tableView.mj_y = 0
        tableView.backgroundColor = UIColor.init(hex: 0xF5F5F5)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 2:
            return 1
        case 1:
            if !PreferenceTool.isTheLastVersion() {
                return 1
            }
            return 3
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return MainMessageCell.getHeight()
        default:
            return MainItemCell.getHeight()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: kMainMessageCellIdentifier) as! MainMessageCell
            cell.refresh()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: kMainItemCellIdentifier) as! MainItemCell
            if !PreferenceTool.isTheLastVersion() && indexPath.section == 1 {
                let model = items[indexPath.section-1][2]
                cell.setValue(model: model)
                return cell
            }
            
            let model = items[indexPath.section-1][indexPath.row]
            cell.setValue(model: model)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 16
        case 2:
            return 10
        default:
            return super.tableView(tableView, heightForHeaderInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let view = UIView.init()
            view.backgroundColor = UIColor.white
            return view
        case 2:
            let view = UIView.init()
            view.backgroundColor = UIColor.init(hex: 0xF5F5F5)
            return view
        default:
            return super.tableView(tableView, viewForHeaderInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if !LoginTool.isLogin() {
                LoginTool.pushLoginController()
                return
            }
            
            if !PreferenceTool.isTheLastVersion() {
                let controller = ServiceController.init(nibName: "ServiceController", bundle: nil)
                navigationController?.pushViewController(controller, animated: true)
                return
            }
            
            switch indexPath.row {
            case 0:
                pushOrderController()
            case 1:
                let controller = RechargeController.init(nibName: "RechargeController", bundle: nil)
                navigationController?.pushViewController(controller, animated: true)
            case 2:
                let controller = ServiceController.init(nibName: "ServiceController", bundle: nil)
                navigationController?.pushViewController(controller, animated: true)
            default:
                break
            }
            break;
        case 2:
            LoginTool.logout()
        default:
            break;
        }
    }
    
    func pushOrderController() {
        if !LoginTool.isLogin() {
            LoginTool.pushLoginController()
            return
        }
        
        let controller = OrderController()
        navigationController?.pushViewController(controller, animated: true)
    }
}
