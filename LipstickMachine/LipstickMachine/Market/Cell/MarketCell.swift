//
//  MarketCell.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class MarketCell: LYSwiftXibBaseCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var range: UILabel!
    @IBOutlet weak var apply: UILabel!
    @IBOutlet weak var receiveBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isDrawLine = true
    }

    func setValue(model: MarketItemModel?) {
        if model == nil {
            return
        }
        icon.sd_setImage(with: URL.init(string: model?.dkIcon ?? ""))
        name.text       = (model?.dkName ?? "") + " - " + (model?.dkType ?? "")
        range.text      = model?.dkRange
        apply.text      = "\(model?.dkApplyNum ?? 0)" + "人申请"
        apply.isHidden  = !PreferenceTool.isTheLastVersion()
        receiveBtn.isHidden = apply.isHidden
    }
    
    static func getHeight() -> CGFloat {
        return 88
    }
    
}
