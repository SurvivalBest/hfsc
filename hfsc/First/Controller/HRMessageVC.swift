//
//  HRMessageVC.swift
//  hfsc
//
//  Created by innket on 17/11/17.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SwiftyJSON

class HRMessageVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource{

    var infoList:[HRMessageInfoModel] = []
    private var curPage = 1
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "消息")
        self.setUI()
        self.getData()
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
        HRNetwork.shared.hr_getData(cmd: "getMessageList", params: param, success: { (result) in
            self.mainTV.es_footer?.stopRefreshing()
            self.mainTV.es_header?.stopRefreshing()
            if self.curPage == 1 {
                self.infoList.removeAll()
                let model = HRMessageInfoModel.deserialize(from: result["body"]["sysMsgInfo"].rawString()!)
                if model != nil{
                    self.infoList.append(model!)
                }else{
                    self.infoList.append(HRMessageInfoModel())
                }
            }
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRMessageInfoModel.deserialize(from: subJson.rawString()!)
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
        tableView.rowHeight = 80
        var cell:HRMessageTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRMessageTVCell
        if cell == nil {
            cell = HRMessageTVCell(style: .default, reuseIdentifier: "CELL1")
        }
        if self.infoList.count > row {
            cell?.setInfo(info: self.infoList[row])
            if row == 0 {
                cell?.isSysMsg(isSys: true)
            }else{
                cell?.isSysMsg(isSys: false)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(HRSysMsgVC(), animated: true)
        }else{
            
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
