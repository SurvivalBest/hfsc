//
//  HROtherInviteListVC.swift
//  hfsc
//
//  Created by innket on 17/11/22.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HROtherInviteListVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource {
    
    var userid = "0"
    var infoList:[HRInviteListModel] = []
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
        self.setNavTitle(title: "奖励明细")
        self.test()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        mainTV.es_removeRefreshHeader()
        mainTV.es_removeRefreshFooter()
    }
    func getData(){
        self.mainTV.es_footer?.stopRefreshing()
        self.mainTV.es_header?.stopRefreshing()
    }
    
    //MARK:测试数据
    func test(){
        for i in 0..<5 {
            let info = HRInviteListModel()
            info.name = "张三\(i)"
            info.time = "2017-10-10"
            info.detail = "注册登录成功"
            info.award = "100"
            info.isPrice = "\(arc4random_uniform(2))"
            info.statusStr = "注册登录成功"
            self.infoList.append(info)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.infoList.count == 0 {
            tableView.tableHeaderView = self.noContentView
        }else{
            tableView.tableHeaderView = self.placeholderView
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        tableView.rowHeight = 40+HR_MARGIN*2
        var cell:HRInviteHistoryTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRInviteHistoryTVCell
        if cell == nil {
            cell = HRInviteHistoryTVCell(style: .default, reuseIdentifier: "CELL1")
        }
        if self.infoList.count > row {
            let info = self.infoList[row]
            cell?.setInfo(type: 2, info: info)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
