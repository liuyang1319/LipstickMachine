//
//  IndexImageCollectionCell.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/2.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit


class IndexImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var scrollBackView: UIView!
    @IBOutlet weak var cycleScrollView: WRCycleScrollView!
    @IBOutlet weak var ingegral: UILabel!
    @IBOutlet weak var ingegralTextLabel: UILabel!
    @IBOutlet weak var ingegtalImage: UIImageView!
    private var scrollTextView: MarqueeView?
    private var banners: [IndexBannerModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let isTheLastVersion = PreferenceTool.isTheLastVersion()
        ingegral.isHidden = !isTheLastVersion
        ingegtalImage.isHidden = ingegral.isHidden
        ingegralTextLabel.isHidden = ingegral.isHidden
        addScrollTextView()
        addScrollView()
    }
    
    private func addScrollTextView() {
        scrollTextView = MarqueeView.init(frame: CGRect.init(x: 15, y: 10, width: kScreenWidth-30, height: 22.5))
        scrollTextView?.backgroundColor = UIColor.init(hex: 0xF2F2F2)
        scrollBackView.addSubview(scrollTextView!)
        
    }
    
    private func addScrollView() {
        cycleScrollView!.delegate = self
        cycleScrollView!.showPageControl = false
        cycleScrollView!.imageContentModel = .scaleToFill
    }
    
    func setValue(models: [IndexBannerModel]?) {
        banners = models
        if models == nil {
            return
        }
        var images: [String] = []
        for banner: IndexBannerModel in models! {
            images.append(banner.image_url)
        }
        cycleScrollView.serverImgArray = images
        if LoginTool.isLogin() {
            LoginTool.getUserIntegral { (integral: Int) in
                self.ingegral.text = "\(integral)" + "个积分"
            }
        } else {
            ingegral.text =  "0个积分"
        }
    }
    
    func setScrollText(notice: [String]?) {
        if notice == nil {
            return
        }
        scrollTextView?.setTitles(notice!)
    }

    @IBAction private func showInstruction() {
        IndexChallengeInstructionsView.share.appear()
    }
}

extension IndexImageCollectionCell: WRCycleScrollViewDelegate
{
    /// 点击图片回调
    func cycleScrollViewDidSelect(at index:Int, cycleScrollView:WRCycleScrollView) {
        let webController = WebController()
        if (banners?.count ?? 0) < index {
            return
        }
        let banner: IndexBannerModel = banners![index]
        webController.url = banner.link
        LoginTool.getNavigationController().pushViewController(webController, animated: true)
        LogViewModel.bannerDidClicked(item: "\(banner.id)")
    }
    /// 图片滚动回调
    func cycleScrollViewDidScroll(to index:Int, cycleScrollView:WRCycleScrollView) {
        print("滚动到了第\(index+1)个图片")
    }
}
