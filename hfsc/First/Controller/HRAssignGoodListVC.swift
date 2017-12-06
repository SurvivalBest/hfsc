//
//  HRAssignGoodListVC.swift
//  hfsc
//
//  Created by innket on 17/11/20.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRAssignGoodListVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRFilterViewDelegate {
    
    var type:Int = 1
    private var curSort = 0
    private var curType = 0
    private var curKind = 0
    private var curPage = 1
    var infoList:[HRGoodInfoModel] = []
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FULL_FRAME, style: .plain)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.separatorColor = HR_LINE_COLOR
        tempTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    lazy private var headerView:HRFilterView = {
        let tempView = HRFilterView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
        tempView.type = 5
        tempView.setFilterCount(titleArr: ["全部","综合排序"])
        tempView.delegate = self
        return tempView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == 1 {
            self.setNavTitle(title: "鸿福商城")
            self.curKind = 1
        }else if type == 2{
            self.setNavTitle(title: "返利商城")
            self.curKind = 4
        }else {
            self.setNavTitle(title: "积分商城")
            self.curKind = 2
        }
        
        self.setUI()
        self.getData()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.headerView.curBtn != nil {
            self.headerView.selectView.isHidden = true
        }
    }
    
    func setUI(){
        self.mainTV.es_addPullToRefresh {
            [unowned self] in
            //下拉刷新
            self.curPage = 1
            self.getData()
        }
        self.mainTV.es_addInfiniteScrolling {
            [unowned self] in
            //上拉加载
            self.curPage += 1
            self.getData()
        }
        self.view.addSubview(self.mainTV)
    }
    deinit {
        if self.headerView.curBtn != nil {
            self.headerView.selectView.removeFromSuperview()
        }
        mainTV.es_removeRefreshHeader()
        mainTV.es_removeRefreshFooter()
    }
    func getData(){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["areaid"] = HRDataSave.hr_getAreaid()
        param["sort"] = "\(self.curSort)"
        param["type"] = "\(self.curType)"
        param["kind"] = "\(self.curKind)"
        param["page"] = "\(self.curPage)"
        param["num"] = "10"
        HRNetwork.shared.hr_getData(cmd: "getGoodsList", params: param, success: { (result) in
            self.mainTV.es_footer?.stopRefreshing()
            self.mainTV.es_header?.stopRefreshing()
            if self.curPage == 1 {
                self.infoList.removeAll()
            }
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRGoodInfoModel.deserialize(from: subJson.rawString()!)
                self.infoList.append(model!)
            }
            self.mainTV.reloadData()
            
        }) { (error) in
            self.mainTV.es_footer?.stopRefreshing()
            self.mainTV.es_header?.stopRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        tableView.rowHeight = 120
        var cell:HRHomeGoodTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? HRHomeGoodTVCell
        if cell == nil {
            cell = HRHomeGoodTVCell(style: .default, reuseIdentifier: "CELL2")
        }
        if self.infoList.count > row {
            let info = self.infoList[row]
            cell?.setInfo(info: info)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.infoList.count > indexPath.row {
            let VC = HRGoodsDetailVC()
            VC.goodsID = self.infoList[indexPath.row].id
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HR_TOP_HEIGHT
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    //MARK:筛选
    func refreshInfo(type: Int, index: Int) {
        print("第\(type)个按钮，选择第\(index)个")
        if type == 0 {
            //商品类型，type
            if goodsTypeList.count > index {
                self.curType = index
                self.curPage = 1
                self.getData()
            }
        }else{
            //筛选条件
            self.curSort = index
            self.curPage = 1
            self.getData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
