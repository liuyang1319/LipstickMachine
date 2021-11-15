//
//  MainMessageCell.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class MainMessageCell: LYSwiftXibBaseCell {

    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        balanceView.layer.borderColor = UIColor.white.cgColor
        if !PreferenceTool.isTheLastVersion() {
            balanceView.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func avatarBtnClicked() {
        LoginTool.pushLoginController()
    }
    
    func refresh() {
        let user = LoginTool.getUser()
        if user == nil {
            avatar.image    = UIImage.init(named: "mine_user_avatar_default")
            name.text       = "欢迎使用口红机"
            balance.text    = "积分余额:--"
        } else {
            let userInfo = user?.user
            avatar.sd_setImage(with: URL.init(string: userInfo?.avatar ?? ""))
            name.text       = userInfo?.username
            LoginTool.getUserIntegral { (integral: Int) in
                self.balance.text   = "积分余额:" + "\(integral)"
            }
        }
    }
    
    static func getHeight() -> CGFloat {
        return 186+StatusBarHeight
    }
    
}
