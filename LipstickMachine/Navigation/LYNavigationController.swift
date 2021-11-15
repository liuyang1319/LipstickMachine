//
//  LYNavigationController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class LYNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
            let leftItem = UIBarButtonItem.init(
                image: UIImage.init(named: "back"),
                style: .plain,
                target: viewController,
                action: #selector(BaseController.leftBtnClicked)
            )
            viewController.navigationItem.leftBarButtonItem = leftItem
        }
        super.pushViewController(viewController, animated: animated)
    }
    
}
