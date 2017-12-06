//
//  HRShopDetailVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import WebKit

class HRShopDetailVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRBannerViewDelegate {
    
    var shopID = "0"
    var shopTitle = "商家详情"
    var nameArr:[String]  = {
        return ["类型","电话","地址","营业时间","营业资质"]
    }()
    var detailInfo:HRShopInfoModel = HRShopInfoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: self.shopTitle)
        // Do any additional setup after loading the view.
        self.getData {
            self.setUI()
        }
    }
    lazy var bannerView:HRBannerView = {
        let tempBanner = HRBannerView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_WIDTH*HR_IMAGE_SCALE))
        tempBanner.delegate = self
        return tempBanner
    }()
    
    func tapImage(index: Int) {
        
    }
    
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FULL_FRAME, style: .plain)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.separatorColor = HR_LINE_COLOR
        tempTV.backgroundColor = HR_BG_COLOR
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    
    func getData(success:@escaping ()->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = self.shopID
        HRNetwork.shared.hr_getData(cmd: "getShopDetail", params: param, success: { (result) in
            let info = HRShopInfoModel.deserialize(from: result["body"].rawString()!)
            if info != nil {
                self.detailInfo = info!
            }
            success()
        }) { (error) in
        }
    }
    
    func setUI(){
        if EmptyCheck(str: self.detailInfo.icon).characters.count > 0 {
            let iconArr = EmptyCheck(str: self.detailInfo.icon).components(separatedBy: "|")
            self.bannerView.setImages(imgArr: iconArr)
            self.mainTV.tableHeaderView = self.bannerView
        }
        self.setNavTitle(title: EmptyCheck(str: self.detailInfo.name))
        self.navigationItem.rightBarButtonItem = self.setBarButton(title: "举报", event: #selector(report))
        self.view.addSubview(self.mainTV)
    }
    
    //MARK:举报
    func report(){
        if !HRDataSave.hr_isLogin() {
            HRDataSave.hr_goLogin(VC: self)
            return
        }
        print("举报")
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = self.shopID
        HRNetwork.shared.hr_getData(cmd: "reportShop", params: param, success: { (result) in
            self.noticeOnlyText("举报成功")
        }) { (error) in
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nameArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL")
        }
        let row = indexPath.row
        cell?.textLabel?.font = HR_NORMAL_FONT
        cell?.textLabel?.textColor = HR_BLACK_COLOR
        cell?.textLabel?.text = self.nameArr[row]
        cell?.detailTextLabel?.textColor = HR_GRAY_COLOR
        cell?.detailTextLabel?.font = HR_SMALL_FONT
        cell?.accessoryType = .none
//        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
//        tempView.backgroundColor = HR_GOLD_COLOR
//        cell?.accessoryView = tempView
        if row == 0 {
            cell?.detailTextLabel?.text = "\(EmptyCheck(str: self.detailInfo.typeStr))"
        }else if row == 1 {
            cell?.detailTextLabel?.text = "\(EmptyCheck(str: self.detailInfo.phone))"
        }else if row == 2 {
            cell?.detailTextLabel?.text = "\(EmptyCheck(str: self.detailInfo.address))"
        }else if row == 3 {
            cell?.detailTextLabel?.text = "\(EmptyCheck(str: self.detailInfo.time))"
        }else if row == 4 {
            cell?.detailTextLabel?.text = ""
            cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let detailSize = calculateMoreLineStringSize(str: EmptyCheck(str: self.detailInfo.detail), font: HR_NORMAL_FONT, maxSize: CGSize(width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_SCREEN_HEIGHT))
        
        return detailSize.height+HR_TOP_HEIGHT+HR_MARGIN+10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let detailSize = calculateMoreLineStringSize(str: EmptyCheck(str: self.detailInfo.detail), font: HR_NORMAL_FONT, maxSize: CGSize(width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_SCREEN_HEIGHT))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: detailSize.height+HR_TOP_HEIGHT+HR_MARGIN+10))
        view.backgroundColor = HR_BG_COLOR
        
        let labView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: detailSize.height+HR_TOP_HEIGHT+HR_MARGIN+5))
        labView.backgroundColor = HR_WHITE_COLOR
        view.addSubview(labView)
        
        let titleLab = UILabel(frame: CGRect(x: HR_MARGIN, y: 0, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_TOP_HEIGHT))
        titleLab.text = "商家介绍"
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.font = HR_BOLD_FONT
        labView.addSubview(titleLab)
        
        let detailLab = UILabel(frame: CGRect(x: HR_MARGIN, y: HR_TOP_HEIGHT, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: detailSize.height+5))
        detailLab.text = EmptyCheck(str: self.detailInfo.detail)
        detailLab.numberOfLines = 0
        detailLab.textColor = HR_GRAY_COLOR
        detailLab.font = HR_NORMAL_FONT
        
        labView.addSubview(detailLab)
        return view
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
