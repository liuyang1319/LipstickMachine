//
//  IndexGoodsCell.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class IndexGoodsCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btn.layer.borderColor = UIColor.black.cgColor
        layer.borderColor = UIColor.init(hex: 0xDDDDDD).cgColor
        
    }

    func setValue(model: IndexGoodsModel?) {
        if model == nil {
            return
        }
        image.sd_setImage(with: URL.init(string: model?.listPicUrl ?? ""))
        price.text  = "专柜价：¥" + "\(model?.counterPrice ?? 0)"
        brand.text  = model?.brand
        name.text   = model?.name
        if PreferenceTool.isTheLastVersion() {
            btn.setTitle("\(String(describing: model?.marketPrice ?? 0))" + "积分挑战", for: .normal)
        } else {
            btn.setTitle("购买", for: .normal)
        }
        
    }
    
    @IBAction func btnClicked() {
    }
}
