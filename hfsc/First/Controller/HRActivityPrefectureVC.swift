//
//  HRActivityPrefectureVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRActivityPrefectureVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRFilterViewDelegate {
    
    private var curStatus = 0
    private var curType = 0
    private var curFee = 0
    private var curPage = 1
    var infoList:[HRActivityInfoModel] = []
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
        tempView.type = 2
        tempView.setFilterCount(titleArr: ["全部","状态","综合排序"])
        tempView.delegate = self
        return tempView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "活动专区")
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
        param["status"] = "\(self.curStatus)"
        param["type"] = "\(self.curType)"
        param["fee"] = "\(self.curFee)"
        param["page"] = "\(self.curPage)"
        param["num"] = "10"
        HRNetwork.shared.hr_getData(cmd: "getActivityList", params: param, success: { (result) in
            self.mainTV.es_footer?.stopRefreshing()
            self.mainTV.es_header?.stopRefreshing()
            if self.curPage == 1 {
                self.infoList.removeAll()
            }
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRActivityInfoModel.deserialize(from: subJson.rawString()!)
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
        var cell:HRHomeActivityTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRHomeActivityTVCell
        if cell == nil {
            cell = HRHomeActivityTVCell(style: .default, reuseIdentifier: "CELL1")
        }
        if self.infoList.count > row {
            cell?.isHaveEndTime = true
            cell?.setInfo(info: self.infoList[row])
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.infoList.count > indexPath.row {
            let VC = HRActivityDetailVC()
            VC.activityID = self.infoList[indexPath.row].id
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
            //活动种类，type
            self.curType = index
            self.curPage = 1
            self.getData()
        }else if type == 1 {
            //活动状态，status
            self.curStatus = index
            self.curPage = 1
            self.getData()
        }else{
            //筛选条件
            self.curFee = index
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
