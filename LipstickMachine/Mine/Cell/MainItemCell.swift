//
//  MainItemCell.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/4.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class MainItemCell: LYSwiftXibBaseCell {

    @IBOutlet weak private var icon: UIImageView!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var moreIcon: UIImageView!
    @IBOutlet weak private var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValue(model: MainItemModel) {
        icon.image = UIImage.init(named: model.icon)
        title.text = model.title
        moreIcon.isHidden = !model.isShowMoreIcon
        bottomView.isHidden = !model.isShowBottomView
    }
    
    static func getHeight() -> CGFloat {
        return 50
    }
    
}
