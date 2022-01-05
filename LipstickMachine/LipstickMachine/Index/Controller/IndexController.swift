//
//  IndexController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit
import SwiftEventBus

class IndexController: BaseController {
    private var collectionView: UICollectionView?
    private let kImageCellIdentifier = "IndexImageCollectionCell"
    private let kGoodsCellIdentifier = "IndexGoodsCell"
    private var banners: [IndexBannerModel]?
    private var notice: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "首页"
        initCollection()
        getData()
        let isTheLastVersion = PreferenceTool.isTheLastVersion()
        if isTheLastVersion {
            addFreeGameBtn()
        }
    }
    
    private func initCollection() {
        let frame = CGRect.init(
            x: 0,
            y: StatusBarAndNavHeight,
            width: kScreenWidth,
            height: kScreenHeight-TabBarHeight-StatusBarAndNavHeight
        )
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 7.5
        layout.sectionInset = UIEdgeInsets.init(
            top: 0,
            left: 15,
            bottom: 0,
            right: 15
        )
        layout.itemSize = CGSize(
            width: kScreenWidth/3-10*2,
            height: 229
        )
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView.init(
            frame: frame,
            collectionViewLayout: layout
        )
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        view.addSubview(collectionView!)
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        collectionView?.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.reFreshData()
        })
        
        collectionView?.register(
            UINib.init(nibName: kImageCellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: kImageCellIdentifier        )
        collectionView?.register(
            UINib.init(nibName: kGoodsCellIdentifier, bundle: nil),
            forCellWithReuseIdentifier: kGoodsCellIdentifier
        )
        
        SwiftEventBus.onMainThread(self, name: kLoginEvent) { (result: Notification?) in
            self.collectionView?.reloadData()
        }
        
        SwiftEventBus.onMainThread(self, name: kLogoutEvent) { (result: Notification?) in
            self.collectionView?.reloadData()
        }
        
        SwiftEventBus.onMainThread(self, name: kPaySuccessEvent) { (result: Notification?) in
            if result == nil || result?.object == nil {
                self.collectionView?.reloadData()
            }
        }
        
        SwiftEventBus.onMainThread(self, name: kConsumeEvent) { (result: Notification?) in
            self.collectionView?.reloadData()
        }
    }
    
    override func getData() {
        IndexViewModel.getData { (banners: [IndexBannerModel], goods: [IndexGoodsModel], notice: [String]) in
            self.banners = banners
            self.dataArray = goods
            self.notice = notice
            self.collectionView?.reloadData()
        }
    }
    
    private func addFreeGameBtn() {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "index_free_game"), for: .normal)
        btn.addTarget(self, action: #selector(IndexController.freeGameBtnClicked), for: .touchUpInside)
        view!.addSubview(btn)
        btn.mas_makeConstraints { (make: MASConstraintMaker?) in
            make?.width.height()?.mas_equalTo()(73)
            make?.right.equalTo()(collectionView?.mas_right)?.offset()(-15)
            make?.bottom.equalTo()(collectionView?.mas_bottom)?.offset()(-38)
        }
    }
    
    @objc private func freeGameBtnClicked() {
        let webController = WebController()
        webController.url = AppDelegate.getFreeGameUrl()
        navigationController?.pushViewController(webController, animated: true)
    }
}


extension IndexController:
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
IndexGoodsAlertDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dataArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImageCellIdentifier, for: indexPath)
            (cell as! IndexImageCollectionCell).setValue(models: banners)
            (cell as! IndexImageCollectionCell).setScrollText(notice: notice)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGoodsCellIdentifier, for: indexPath)
            (cell as! IndexGoodsCell).setValue(model: dataArray.count > indexPath.row ? dataArray![indexPath.row] as? IndexGoodsModel : nil)
        }
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize.init(
                width: kScreenWidth,
                height:getScal(height: 259)
            )
        }
        return CGSize.init(
            width: kScreenWidth/3-10*2,
            height: 229
        )
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return .zero
        } else {
            return UIEdgeInsets.init(top: 0, left: 15, bottom: 0, right: 15)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        
        if dataArray.count <= indexPath.row {
            return
        }
        
        let model = dataArray[indexPath.row] as! IndexGoodsModel

//        if !PreferenceTool.isTheLastVersion() {
//            IndexViewModel.startGame(gid: model.gid) { (gameUrl: String) in
//                self.startGame(gameUrl: gameUrl)
//                LogViewModel.productChallenge(item: "\(String(describing: model.gid))")
//            }
//            return
//        }
        
        let alert = IndexGoodsAlertView.share
        alert.delegate = self
        alert.setValue(model: model)
        alert.appear()
        LogViewModel.indexItemClick(item: "\(model.gid)")
    }
    
    //    MARK: IndexGoodsAlertDelegate
    func startGame(gameUrl: String) {
        let webController = WebController()
        webController.url = gameUrl
        navigationController?.pushViewController(webController, animated: true)
        SwiftEventBus.post(kConsumeEvent)
    }
}
