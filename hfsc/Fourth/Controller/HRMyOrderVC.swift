//
//  HRMyOrderVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRMyOrderVC: HRBaseVC ,HRDetailTabViewDelegate,UITableViewDelegate,UITableViewDataSource,HROrderFooterViewDelegate{
    var titleTabView:HRDetailTabView!
    var sourceList:[HROrderInfoModel] = []
    var userIntegral:Int = 0
    var mainTV:UITableView!
    var curPage:Int = 1
    var currentType:Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        self.test()
        self.setUI()
        self.getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if mainTV != nil {
            self.curPage = 1;
            self.getData()
        }
    }
    func setNav(){
        self.setNavTitle(title: "我的订单")
    }
    func test(){
        for i in 0..<5 {
            let info = HROrderInfoModel()
            info.status = "\(arc4random_uniform(3))"
            info.orderNO = "1010101001"
            info.time = "2017-10-10 10:10"
            info.total = "200"
            info.type = "\(arc4random_uniform(3))"
            
            let good = ["title":"安慕希牛奶","kind":info.type,"unit":"25瓶/箱","price":"100","count":"2"]
            info.goodsList = [good]
            
            self.sourceList.append(info)
        }
    }
    func setUI(){
        titleTabView = HRDetailTabView(frame: CGRect(x: 0, y: HR_HEADER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
        titleTabView.delegate = self
        titleTabView.backgroundColor = HR_WHITE_COLOR
        titleTabView.setTitle(titleArr: ["全部","待发货","待收货","已结束"])
        titleTabView.setTag(index: currentType-1)
        self.view.addSubview(titleTabView)
        mainTV = UITableView(frame: CGRect(x: 0, y: titleTabView.frame.maxY, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT-titleTabView.frame.maxY), style: .grouped)
        mainTV.delegate = self
        mainTV.dataSource = self
        mainTV.tableFooterView = UIView(frame: CGRect.zero)
        mainTV.backgroundColor = HR_BG_COLOR
        mainTV.rowHeight = 120
        mainTV.separatorStyle = .none
        self.view.addSubview(mainTV!)
        mainTV.es_addPullToRefresh {
            [unowned self] in
            //下拉刷新
            self.curPage = 1
            self.getData()
        }
        mainTV.es_addInfiniteScrolling {
            [unowned self] in
            //上拉加载
            self.curPage += 1
            self.getData()
        }
    }
    deinit {
        if (mainTV != nil) {
            mainTV.es_removeRefreshHeader()
            mainTV.es_removeRefreshFooter()
        }
    }
    //MARK:选择哪个Tab
    func selectTab(index: Int) {
        currentType = index + 1
        curPage = 1
        getData()
    }
    
    //MARK:获取订单列表
    func getData(){
        self.mainTV.es_footer?.stopRefreshing()
        self.mainTV.es_header?.stopRefreshing()
//        HRNetwork.getOrderList(type: self.currentType-1, keyword: "", page: self.curPage, num: 10, success: { (result) in
//            if self.curPage == 1{
//                self.sourceList.removeAll()
//            }
//            for (_,subJson):(String,JSON) in result["List"]{
//                let model = HROrderInfoModel.deserialize(from: subJson.rawString()!)
//                self.sourceList.append(model!)
//            }
//            if self.sourceList.count == 0 {
//                let noOrderView = HREmptyView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT-HR_HEADER_HEIGHT-HR_TOP_HEIGHT))
//                noOrderView.setInfo(title: "暂无订单~", type: 1)
//                self.mainTV.tableHeaderView = noOrderView
//            }else{
//                self.mainTV.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 0.00001))
//            }
//            self.mainTV.reloadData()
//            self.mainTV.es_footer?.stopRefreshing()
//            self.mainTV.es_header?.stopRefreshing()
//        }) { (error) in
//            self.mainTV.es_footer?.stopRefreshing()
//            self.mainTV.es_header?.stopRefreshing()
//        }
    }
    
    //MARK:tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sourceList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = self.sourceList[section]
        return info.goodsList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:HROrderGoodTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as? HROrderGoodTVCell
        if cell == nil {
            cell = HROrderGoodTVCell(style: .default, reuseIdentifier: "CELL")
        }
        let section = indexPath.section
        let row = indexPath.row
        if self.sourceList.count > section {
            let info = self.sourceList[section]
            if info.goodsList.count > row {
                let list = info.goodsList
                let goodInfo = HRGoodInfoModel.deserialize(from: list[row] as? NSDictionary)
                cell?.type = StringToInt(str: info.type)
                cell?.setInfo(info: goodInfo!)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.sourceList.count > indexPath.section {
            let info = self.sourceList[indexPath.section]
            let VC = HROrderDetailVC()
            VC.orderID = info.id
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.sourceList.count > section {
            return HR_TOP_HEIGHT + 5
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.sourceList.count > section {
            let info = self.sourceList[section]
            let headerView = HROrderHeaderView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT+5))
            headerView.setInfo(orderNo: EmptyCheck(str: info.orderNO), status: StringToInt(str: info.status),type:1)
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.sourceList.count > section {
            let info = self.sourceList[section]
            return HR_TOP_HEIGHT*2
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.sourceList.count > section {
            let info = self.sourceList[section]
            let footerView = HROrderFooterView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT*2))
            footerView.delegate = self
            footerView.tag = section
            footerView.setInfo(info: info,type:1)
            return footerView
        }
        return nil
    }
    
    //MARK:订单操作
    func orderHandle(btn: UIButton) {
        let title:String = (btn.titleLabel?.text)!
        let orderID = btn.tag
        let index = btn.superview?.tag
        let info = self.sourceList[index!]
        switch title {
        case "催单":
            print("催单：\(orderID)")
        case "确认收货":
            print("确认收货：\(orderID)")
        default:
            print("再来一单：\(orderID)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
