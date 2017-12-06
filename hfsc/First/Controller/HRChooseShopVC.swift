//
//  HRChooseShopVC.swift
//  hfsc
//
//  Created by innket on 17/11/24.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRChooseShopVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource {
    var shopList:[HRShopInfoModel] = []
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
        self.setNavTitle(title: "选择门店")
        self.setUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUI(){
        self.view.addSubview(self.mainTV)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return shopList.count-1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        tableView.rowHeight = 120
        var cell:HRShopTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRShopTVCell
        if cell == nil {
            cell = HRShopTVCell(style: .default, reuseIdentifier: "CELL1")
        }
        cell?.type = 2
        if section == 0 {
            let info = self.shopList[0]
            cell?.setInfo(info: info)
        }else{
            if self.shopList.count > row+1 {
                let info = self.shopList[row+1]
                cell?.setInfo(info: info)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        if self.shopList.count > indexPath.row {
//            let VC = HRShopDetailVC()
//            VC.shopID = self.shopList[indexPath.row].id
//            self.navigationController?.pushViewController(VC, animated: true)
//        }
        var row = 0
        if indexPath.section == 0 {
            row = 0
        }else{
            row = indexPath.row+1
        }
        HR_NOTIFICATION.post(name: kChangeShop, object: nil, userInfo: ["index":row])
        self.goBackPop()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HR_TOP_HEIGHT
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleArr = ["所属门店","离你最近"]
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
        let titleLab = UILabel(frame: CGRect(x: HR_MARGIN, y: 0, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_TOP_HEIGHT))
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.font = HR_NORMAL_FONT
        titleLab.text = titleArr[section]
        headerView.addSubview(titleLab)
//        if section == 0 {
//            headerView.backgroundColor = HR_WHITE_COLOR
//        }else{
            headerView.backgroundColor = HR_BG_COLOR
//        }
        return headerView
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
