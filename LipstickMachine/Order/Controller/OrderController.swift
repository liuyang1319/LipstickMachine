//
//  OrderController.swift
//  LipstickMachine
//
//  Created by easyto on 2019/3/6.
//  Copyright © 2019年 easyto. All rights reserved.
//

import UIKit

let kOrderCell = "OrderCell"

class OrderController: BaseController {

    let emptyView = OrderEmptyView.instanceView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的订单"
        cellArray = [kOrderCell]
        addTableViewHeader()
        addTableViewFootview()
        addEmptyView()
        getData()
    }
    
    override func getData() {
        OrderViewModel.getData(page: nextPageFlag) { (results: [OrderModel]) in
            self.processData(datas: results, complate: {
                if self.nextPageFlag == 1 {
                    self.setEmptyViewHidden(result: results)
                }
                
                self.dataArray.addFromArray(array: results)
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrderCell.getHeight(model: dataArray!.count > indexPath.row ? (dataArray[indexPath.row] as! OrderModel) : nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kOrderCell)
        (cell  as! OrderCell).setValue(model: dataArray.count > indexPath.row ? dataArray![indexPath.row] as? OrderModel : nil)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray.count <= indexPath.row {
            return
        }
        let model = dataArray![indexPath.row] as? OrderModel
        if model?.orderStatus != 0 {
            return
        }
        let controller = OrderContactInfoController.init(nibName: "OrderContactInfoController", bundle: nil)
        controller.model = model
        navigationController?.pushViewController(controller, animated: true)
    }

    fileprivate func addEmptyView() {
        emptyView.frame = view.frame
        emptyView.delegate = self
        view.addSubview(emptyView)
    }
    
    fileprivate func setEmptyViewHidden(result: [OrderModel]) {
        emptyView.isHidden = (result.count != 0)
    }
}

extension OrderController: OrderEmptyViewDelegate {
    func orderEmptyClicked() {
        
    }
}
