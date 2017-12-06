//
//  HRChooseWayVC.swift
//  hfsc
//
//  Created by innket on 17/11/24.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRChooseWayVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavTitle(title: "配送方式")
        self.setUI()
    }
    private let infoList:[String] = ["快递配送（免费）","门店配送（免费）","到店自提（免费）"]
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FULL_FRAME, style: .grouped)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.separatorColor = HR_LINE_COLOR
        tempTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    
    func setUI(){
        self.view.addSubview(self.mainTV)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        tableView.rowHeight = 45
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
        }
        cell?.textLabel?.textColor  = HR_BLACK_COLOR
        cell?.textLabel?.font = HR_NORMAL_FONT
        cell?.textLabel?.text = self.infoList[row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HR_NOTIFICATION.post(name: kChangeWay, object: nil, userInfo: ["index":indexPath.row])
        self.goBackPop()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
