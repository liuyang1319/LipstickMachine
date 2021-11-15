//
//  MarketController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/2/28.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

class MarketController: BaseController {

    let kMarketCellIdetifier = "MarketCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "每日资讯"
        initTableView()
        getData()
    }
    
    override func getData() {
        MarketViewModel.getData { (results: [MarketItemModel]) in
            self.dataArray = results
            self.tableView.reloadData()
        }
    }
    
    private func initTableView() {
        tableView.mj_h = kScreenHeight - TabBarHeight - StatusBarAndNavHeight
        cellArray = [kMarketCellIdetifier]
        addTableViewHeader()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MarketCell.getHeight()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kMarketCellIdetifier)
        (cell as! MarketCell).setValue(model: dataArray.count > indexPath.row ? dataArray?[indexPath.row] as? MarketItemModel : nil)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: MarketItemModel? = dataArray.count > indexPath.row ? dataArray![indexPath.row] as? MarketItemModel : nil
        if model == nil {
            return
        }
        MarketViewModel.action(model: model)
        let controller = WebController()
        controller.url = model!.dkUrl
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
