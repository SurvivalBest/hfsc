//
//  HRMyActivityVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRMyActivityVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "我的活动")
        self.setUI()
        self.getData()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUI(){
        self.view.addSubview(self.mainTV)
    }
    func getData(){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getMyActivityList", params: param, success: { (result) in
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRActivityInfoModel.deserialize(from: subJson.rawString()!)
                self.infoList.append(model!)
            }
            self.mainTV.reloadData()
        }) { (error) in
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
        return 0.0001
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
