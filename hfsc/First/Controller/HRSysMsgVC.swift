//
//  HRSysMsgVC.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRSysMsgVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRSysMsgTVCellDelegate{
    
    var infoList:[HRSysMsgInfoModel] = []
    private var curPage = 1
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FULL_FRAME, style: .plain)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.separatorStyle = .none
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "系统消息")
        self.setUI()
        self.getData()
        // Do any additional setup after loading the view.
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
        print("消息页面释放")
        mainTV.es_removeRefreshHeader()
        mainTV.es_removeRefreshFooter()
    }
    func getData(){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["page"] = "\(self.curPage)"
        param["num"] = "10"
        HRNetwork.shared.hr_getData(cmd: "getSysMsgList", params: param, success: { (result) in
            self.mainTV.es_footer?.stopRefreshing()
            self.mainTV.es_header?.stopRefreshing()
            if self.curPage == 1 {
                self.infoList.removeAll()
            }
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRSysMsgInfoModel.deserialize(from: subJson.rawString()!)
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
        tableView.rowHeight = 55+40+HR_MARGIN*2
        var cell:HRSysMsgTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRSysMsgTVCell
        if cell == nil {
            cell = HRSysMsgTVCell(style: .default, reuseIdentifier: "CELL1")
        }
        if self.infoList.count > row {
            cell?.delegate = self
            cell?.setInfo(info: self.infoList[row])
        }
        cell?.selectionStyle = .none
        return cell!
    }
    //MARK:点击查看详情
    func showDetail(id: String) {
        print("点击查看详情---\(id)")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
