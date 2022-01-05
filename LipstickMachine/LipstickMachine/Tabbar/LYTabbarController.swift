//
//  LYTabbarController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class LYTabbarController: UITabBarController, UITabBarControllerDelegate {

    static let share = LYTabbarController()
    let titleString     = "title"
    let normalImg       = "img"
    let selectedImg     = "selectedImg"
    let classNameStr    = "class"
    let packageName     = "LipstickMachine"
    
    private let advView = OpenAdvView.instance()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        advView.appear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

        setupControllers()
        
    }
    
    private func setupControllers() {
        self.viewControllers = nil
        self.view.backgroundColor = UIColor.clear
        UITabBar.appearance().barTintColor = UIColor.white
//        [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"ffffff"]];
        let items: [[String : String]] = [
            [
                titleString     : "首页",
                normalImg       : "tabbar_index",
                selectedImg     : "tabbar_index_selected",
                classNameStr    : "IndexController"
            ],
            [
                titleString     : "充值",
                normalImg       : "tabbar_recharge",
                selectedImg     : "tabbar_recharge_selected",
                classNameStr    : "RechargeController"
            ],
            [
                titleString     : "每日资讯",
                normalImg       : "tabbar_market",
                selectedImg     : "tabbar_market_selected",
                classNameStr    : "MarketController"
            ],
            [
                titleString     : "我的",
                normalImg       : "tabbar_mine",
                selectedImg     : "tabbar_mine_selected",
                classNameStr    : "MineController"
            ],
        ]
        var childControllers: [UIViewController] = []
        for item: [String : String] in items {
            let className: String = packageName + "." + item[classNameStr]!
            let cls: AnyClass? = NSClassFromString(className)
            // Swift中如果想通过一个Class来创建一个对象, 必须告诉系统这个Class的确切类型
            guard let typeClass = cls as? UIViewController.Type else {
                print("cls不能当做UIViewController")
                return
            }
    
            if !PreferenceTool.isTheLastVersion() {
                if item[classNameStr] == "RechargeController"  || item[classNameStr] == "MarketController" {
                    continue
                }
            }
//            
//            if AppDelegate.isShowMarket() == 0 {
//                if item[classNameStr] == "MarketController" {
//                    continue
//                }
//            }
            
            let childController = typeClass.init()
            if childController is RechargeController {
                let recharge = childController as! RechargeController
                recharge.isShowLeftBtn = false
            }
            
            let image = UIImage.init(named: item[normalImg]! )
            let selectedImage = UIImage.init(named: item[selectedImg]!)
            let navigation = LYNavigationController.init(rootViewController: childController)
            navigation.title = item[titleString]!
            navigation.tabBarItem.image = image
            navigation.tabBarItem.selectedImage = selectedImage
            
            navigation.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: TABBAR_TITLE_SELECTED_COLOR], for: .selected)
            navigation.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: TABBAR_TITLE_NORMAL_COLOR], for: .normal)
            
            childControllers.append(navigation)
        }
        self.viewControllers = childControllers
        self.selectedIndex = 0;
    }

    func pushIndexController() {
        let navigationController = LoginTool.getNavigationController()
        navigationController.popToRootViewController(animated: true)
        if self.selectedIndex != 0 {
            self.selectedIndex = 0
        }
    }
    
    func pushOrderController() {
        let navigationController = LoginTool.getNavigationController()
        navigationController.popToRootViewController(animated: true)
        if self.selectedIndex != self.viewControllers!.count - 1 {
            self.selectedIndex = self.viewControllers!.count - 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let mineController = navigationController.topViewController
            if !(mineController is MineController) {
                self.pushOrderController()
                return
            }
            let mine = mineController as! MineController
            mine.pushOrderController()
        }
    }
}
