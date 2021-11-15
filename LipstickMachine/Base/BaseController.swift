//
//  LYSwiftBaseController.swift
//  PipixiaService
//
//  Created by admin on 2017/7/19.
//  Copyright © 2017年 liuyang. All rights reserved.
//

import UIKit
import SwiftEventBus

let kLYSwiftBaseTag = 1019355

class BaseController:
UIViewController,
UITableViewDelegate,
UITableViewDataSource
{
    public var dataArray: Array<Any>!           = []                                //数据源
    public var nextPageFlag: Int                = 1                                 //分页
    public var cellHeightDic                    = [String:String]()                 //存放cell高度字典
    public var tableView: UITableView           = UITableView.init()                //tableView
    public var cellArray: [String] {                                                //注册xib cell
        get {
            return []
        }
        
        set {
            for item: String in newValue {
                let nib = UINib.init(nibName: item,
                                     bundle: nil)
                self.tableView.register(nib,
                                        forCellReuseIdentifier: item)
            }
        }
    }
    
    deinit {
        SwiftEventBus.unregister(self)
    }
    
    //    MARK: --- viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    //    MARK: ---- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame:CGRect = CGRect(
            x: 0,
            y: StatusBarAndNavHeight,
            width: kScreenWidth,
            height: kScreenHeight - StatusBarAndNavHeight
        )
        tableView = UITableView (frame: frame, style: UITableView.Style.plain);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none;
        self.view.addSubview(tableView);
        self.navigationController?.view.backgroundColor = UIColor.white;
        self.view.backgroundColor = UIColor.white
        
        self.edgesForExtendedLayout = .all
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        self.modalPresentationCapturesStatusBarAppearance = false
        
        //        MARK: ios 11上边距
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
        }
        
    }
    
    //    MARk:返回
    
    @objc func leftBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }

//    MARK: 添加 MJ Header
    func addTableViewHeader() {
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.reFreshData()
        })
    }
    
//    MARK: 删除 MJ Header
    func deleteTableViewHeader() {
        self.tableView.mj_header = nil
    }
    
//    MARK: 添加 MJ Footer
    func addTableViewFootview() {
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.nextPageFlag += 1
            self.getData()
        })
    }
    
//    MARK: 删除 MJ Footer
    func deleteTableViewFootview() {
        self.tableView.mj_footer = nil
    }
    
//    MARK: 刷新
    func reFreshData() {
        self.nextPageFlag = 1;
        self.cellHeightDic.removeAll()
        self.dataArray.removeAll()
        if self.tableView.mj_footer != nil {
            self.tableView.mj_footer.resetNoMoreData()
        }
        self.tableView.reloadData()
        self.getData()
    }
    
//    MARK: 加载数据
    
    
//    MARK: 获取数据
    func getData() {
        
    }
    
//    MARK: 过滤数据 如果加载没有数据就endRefreshingWithNoMoreData
    func processData(datas: [Any], complate: @escaping () -> ()) {
        if self.tableView.mj_header != nil {
            self.tableView.mj_header.endRefreshing()
        }
        
        if self.tableView.mj_footer != nil {
            self.tableView.mj_footer.endRefreshing()
        }
        
        if datas.count == 0 && self.nextPageFlag > 1 {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            complate()
        }
    }
    
    
//    MARK get tag
    public func getTag(tag: Int, indexPath: IndexPath) -> String{
        let newTag = tag + indexPath.section*100 + indexPath.row;
        return "\(newTag)";
    }
    
    //    MARK get tag
    public func getTag(indexPath: IndexPath) -> String{
        return self.getTag(tag: kLYSwiftBaseTag, indexPath: indexPath)
    }
    
    
//    MARK: 更新cellHeightDic
    public func updateCellHeightDic(cellHeight: CGFloat, indexPath: IndexPath) {
        self.updateCellHeightDic(cellHeight: cellHeight, indexPath: indexPath, tag: kLYSwiftBaseTag)
    }
    
    public func updateCellHeightDic(cellHeight: CGFloat, indexPath: IndexPath, tag: Int) {
        self.cellHeightDic.updateValue("\(cellHeight)",forKey:self.getTag(
            tag: tag,
            indexPath: indexPath
        ))
    }
    
    
//    MARK: 根据tag取得高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath, tag: Int) -> CGFloat {
        let heightStr: String = self.cellHeightDic[self.getTag(
            tag: tag,
            indexPath: indexPath
        )] ?? "0"
        var height: CGFloat = heightStr.toFloat()
        if height == 0 {
            height = 0.1
        }
        return height
    }
    
//  MARK tableView delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath, tag: kLYSwiftBaseTag)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init();
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init()
    }
    

}
