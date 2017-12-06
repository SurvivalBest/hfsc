//
//  HRFourthVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRFourthVC: HRBaseVC,UITableViewDelegate,UITableViewDataSource,HRMyHeaderViewDelegate{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HR_NOTIFICATION.addObserver(self, selector: #selector(changeName(noti:)), name: kChangeName, object: nil)
        HR_NOTIFICATION.addObserver(self, selector: #selector(changeAvatar(noti:)), name: kChangeAvatar, object: nil)
        if !HRDataSave.hr_isLogin() {
            self.userInfo = HRUserInfoModel()
            self.headerView.setInfo(info: self.userInfo)
        }else{
            self.getUserInfo()
        }
    }
    func changeName(noti:Notification){
        let info = noti.userInfo
        let name = info?["name"] as! String
        self.userInfo.nickname = name
        self.headerView.setInfo(info: self.userInfo)
    }
    func changeAvatar(noti:Notification){
        let info = noti.userInfo
        let name = info?["avatar"] as! String
        self.userInfo.avatar = name
        self.headerView.setInfo(info: self.userInfo)
    }
    deinit {
        HR_NOTIFICATION.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNav()
        self.setUI()
    }
    private var userInfo = HRUserInfoModel()
    private func setNav(){
        setNavTitle(title: "")
        self.navigationController?.navigationBar.hideBottomHairline()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"my_setting"), style: .done, target: self, action: #selector(goSetting))
    }
    //MARK:跳转设置
    func goSetting(){
        let VC = HRSettingVC();
        VC.phone = self.userInfo.phone
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    lazy private var headerView:HRMyHeaderView = {
        let tempView = HRMyHeaderView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 100+HR_SCREEN_WIDTH/4))
        tempView.delegate = self
        return tempView
    }()
    //MARK:头部
    func showUserInfo() {
        if HRDataSave.hr_isLogin() {
            let VC = HRUserInfoVC()
            VC.userInfo = self.userInfo
            goNext(VC: VC)
        }else{
            HRDataSave.hr_goLogin(VC: self)
        }
        
    }
    func showDetail(type: Int) {
        if HRDataSave.hr_isLogin() {
            let VC = HRMyOrderVC()
            if type != 3 {
                VC.currentType = type+2
            }else{
                VC.currentType = 1
            }
            self.goNext(VC: VC)
        }else{
            HRDataSave.hr_goLogin(VC: self)
        }
    }
    lazy private var nameList = {
        return [["我的钱包","我的活动","收货地址"],["客服热线","邀请有礼","我要加盟"]]
    }()
    private var curPage = 1
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
    func getUserInfo(){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getUserInfo", params: param, success: { (result) in
            let info = HRUserInfoModel.deserialize(from: result["body"].rawString()!)
            if info != nil {
                self.userInfo = info!
            }else{
                self.userInfo = HRUserInfoModel()
            }
            self.headerView.setInfo(info: self.userInfo)
        }) { (error) in
            
        }
    }
    
    func setUI(){
        self.mainTV.tableHeaderView = self.headerView
        self.headerView.setInfo(info: self.userInfo)
        self.view.addSubview(self.mainTV)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.nameList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameList[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        tableView.rowHeight = 45
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
        }
        cell?.textLabel?.textColor  = HR_BLACK_COLOR
        cell?.textLabel?.font = HR_NORMAL_FONT
        cell?.textLabel?.text = self.nameList[section][row]
        cell?.imageView?.image = UIImage(named: "my_\(section)\(row)")
        if section == 1 && row == 0 {
            cell?.accessoryType = .none
            cell?.detailTextLabel?.text = HR_SERVICE_PHONE
            cell?.detailTextLabel?.font = HR_NORMAL_FONT
        }else {
            cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
            cell?.detailTextLabel?.text = ""
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if HRDataSave.hr_isLogin() {
            if section == 0 {
                if row == 0 {
                    let VC = HRMyPurseVC()
                    VC.userInfo = self.userInfo
                    self.goNext(VC: VC)
                }else if  row == 1 {
                    let VC = HRMyActivityVC()
                    self.goNext(VC: VC)
                }else {
                    let VC = HRAddressListVC()
                    self.goNext(VC: VC)
                }
            }else{
                if row == 0 {
                    self.contactService()
                }else if  row == 1 {
                    let VC = HRInviteVC()
                    self.goNext(VC: VC)
                }else {
                    let VC = HRJoinInVC()
                    self.goNext(VC: VC)
                }
            }
        }else{
            if section == 1 && row == 0 {
                self.contactService()
                return
            }
            HRDataSave.hr_goLogin(VC: self)
        }
    }
    //MARK:联系客服
    func contactService(){
        let alertView = UIAlertController(title: HR_SERVICE_PHONE, message: "", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (cancelView) in
            
        }))
        alertView.addAction(UIAlertAction(title: "呼叫", style: .default, handler: { (otherView) in
            //拨打客服电话
            UIApplication.shared.openURL(URL(string: "tel://\(HR_SERVICE_PHONE)")!)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HR_MARGIN
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func goNext(VC:UIViewController){
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
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
