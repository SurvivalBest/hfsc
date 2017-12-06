//
//  HRInviteHistoryVC.swift
//  hfsc
//
//  Created by innket on 17/11/22.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
var awardTypeBtn:UIButton!
class HRInviteHistoryVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource {
    
    var infoList:[HRInviteListModel] = []
    var inviteInfo:HRInviteHistoryModel = HRInviteHistoryModel()
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
    var isObj = true
    //MARK:选择类型
    lazy var topView:UIView = {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
        tempView.backgroundColor = HR_WHITE_COLOR
        let nameArr = ["邀请对象","奖励记录"]
        for i in 0..<nameArr.count{
            let firstBtn = UIButton(frame: CGRect(x: HR_SCREEN_WIDTH/2*CGFloat(i), y: 0, width: HR_SCREEN_WIDTH/2, height: HR_TOP_HEIGHT))
            firstBtn.setTitle(nameArr[i], for: .normal)
            firstBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
            firstBtn.setTitleColor(HR_THEME_COLOR, for: .selected)
            firstBtn.titleLabel?.font = HR_NORMAL_FONT
            firstBtn.tag = 10 + i
            firstBtn.addTarget(self, action: #selector(chooseType(btn:)), for: .touchUpInside)
            tempView.addSubview(firstBtn)
            if i == 0 {
                firstBtn.isSelected = true
                awardTypeBtn = firstBtn
            }
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: HR_TOP_HEIGHT-1, width: HR_SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempView.addSubview(lineView)
        return tempView
    }()
    func chooseType(btn:UIButton){
        if awardTypeBtn == btn {
            return
        }
        if awardTypeBtn != nil {
            awardTypeBtn.isSelected = false
        }
        btn.isSelected = true
        awardTypeBtn = btn
        if btn.tag == 11 {
            isObj = false
        }else{
            isObj = true
        }
        self.mainTV.reloadData()
    }
    //MARK:头部
    lazy private var headerView:HRInviteHistoryHeaderView = {
        let tempView = HRInviteHistoryHeaderView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_BALANCE_HEIGHT))
        return tempView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "奖励记录")
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
        self.headerView.setInfo(info: self.inviteInfo)
        self.mainTV.tableHeaderView = self.headerView
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
        self.inviteInfo.totalPrice = "100"
        self.inviteInfo.totalCount = "66"
        self.inviteInfo.totalIntegral = "55"
        self.inviteInfo.isHavePrice = "\(arc4random_uniform(2))"
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
            if isObj == true {
                cell?.setInfo(type: 1, info: info)
            }else{
                cell?.setInfo(type: 2, info: info)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if self.infoList.count > row {
            let info = self.infoList[row]
            if isObj {
                let VC = HROtherInviteListVC()
                VC.userid = info.userid
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HR_TOP_HEIGHT
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.topView
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
