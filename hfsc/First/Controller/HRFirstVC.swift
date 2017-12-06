//
//  HRFirstVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import ESPullToRefresh
import SwiftyJSON

class HRFirstVC: HRBaseVC,UITableViewDelegate,UITableViewDataSource,HRHomeHeaderViewDelegate{
    var locationBtn = UIButton()
    lazy private var headerView:HRHomeHeaderView = {
        let tempView = HRHomeHeaderView()
        tempView.delegate = self
        return tempView
    }()
    
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FIRST_FRAME, style: .grouped)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.separatorStyle = .none
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    //banner列表
    private var bannerList:[HRBannerInfoModel] = []
    //公告列表
    private var noticeList:[HRNoticeInfoModel] = []
    //最新资讯
    lazy private var newsInfo:HRNewsInfoModel = {
        let tempInfo = HRNewsInfoModel()
        return tempInfo
    }()
    //今日特价
    private var firstList:[HRSaleInfoModel] = []
    //推荐活动
    private var secondList:[HRActivityInfoModel] = []
    //热卖商品
    private var thirdList:[HRGoodInfoModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setNav()
        self.view.addSubview(self.mainTV)
        self.getData()
        self.mainTV.es_addPullToRefresh {
            [unowned self] in
            //下拉刷新
            self.getData()
        }
    }
    deinit {
        mainTV.es_removeRefreshHeader()
    }
    func getData(){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["areaid"] = HRDataSave.hr_getAreaid()
        HRNetwork.shared.hr_getData(cmd: "getHomeInfo", params: param, success: { (result) in
            self.mainTV.es_header?.stopRefreshing()
            self.bannerList.removeAll()
            for (_,subJson):(String,JSON) in result["body"]["bannerList"] {
                let model = HRBannerInfoModel.deserialize(from: subJson.rawString()!)
                self.bannerList.append(model!)
            }
            let info = HRNewsInfoModel.deserialize(from: result["body"]["newsInfo"].rawString()!)
            if info != nil  {
                self.newsInfo = info!
            }else{
                self.newsInfo = HRNewsInfoModel()
            }
            self.noticeList.removeAll()
            for (_,subJson):(String,JSON) in result["body"]["noticeList"] {
                let model = HRNoticeInfoModel.deserialize(from: subJson.rawString()!)
                self.noticeList.append(model!)
            }
            self.firstList.removeAll()
            for (_,subJson):(String,JSON) in result["body"]["saleList"] {
                let model = HRSaleInfoModel.deserialize(from: subJson.rawString()!)
                self.firstList.append(model!)
            }
            self.secondList.removeAll()
            for (_,subJson):(String,JSON) in result["body"]["activityList"] {
                let model = HRActivityInfoModel.deserialize(from: subJson.rawString()!)
                self.secondList.append(model!)
            }
            self.thirdList.removeAll()
            for (_,subJson):(String,JSON) in result["body"]["hotList"] {
                let model = HRGoodInfoModel.deserialize(from: subJson.rawString()!)
                self.thirdList.append(model!)
            }
            
            //frame
            if self.bannerList.count == 0 && self.noticeList.count != 0 {
                self.headerView.frame = CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: noticeH+HR_SCREEN_WIDTH/4+10)
            }else if self.bannerList.count != 0 && self.noticeList.count == 0 {
                self.headerView.frame = CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_WIDTH*HR_IMAGE_SCALE+HR_SCREEN_WIDTH/4+10)
            }else if self.bannerList.count == 0 && self.noticeList.count == 0 {
                self.headerView.frame = CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_WIDTH/4+5)
            }else{
                self.headerView.frame = CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_WIDTH*HR_IMAGE_SCALE+noticeH+HR_SCREEN_WIDTH/4+10)
            }
            self.mainTV.tableHeaderView = self.headerView
            self.headerView.setInfo(bannerList: self.bannerList, noticeList: self.noticeList)
            self.mainTV.reloadData()
        }) { (error) in
            self.mainTV.es_header?.stopRefreshing()
        }
        
    }
    
    //MARK:创建导航栏
    private func setNav(){
        
        //左边按钮
        let addressBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        addressBtn.setImage(UIImage(named:"home_location"), for: .normal)
        addressBtn.setTitle("上海", for: .normal)
        addressBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        addressBtn.titleLabel?.font = HR_NORMAL_FONT
        addressBtn.addTarget(self, action: #selector(changeLocationAddress), for: .touchUpInside)
        self.locationBtn = addressBtn
        let leftFixed = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftFixed.width = -15
        self.navigationItem.leftBarButtonItems = [leftFixed,UIBarButtonItem(customView: addressBtn)]
        
        //右边按钮
        let messageBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        messageBtn.setImage(UIImage(named:"message_icon"), for: .normal)
        messageBtn.addTarget(self, action: #selector(goMessage), for: .touchUpInside)
        self.navigationItem.rightBarButtonItems = [leftFixed,UIBarButtonItem(customView: messageBtn)]
        
        //搜索框
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 34))
        searchBtn.backgroundColor = HR_SEARCH_BG
        searchBtn.setTitle("  输入商品/商家关键字", for: .normal)
        searchBtn.setTitleColor(HR_GRAY_COLOR, for: .normal)
        searchBtn.titleLabel?.font = HR_NORMAL_FONT
        searchBtn.setImage(UIImage(named:"search_icon"), for: .normal)
        searchBtn.addTarget(self, action: #selector(goSearch), for: .touchUpInside)
        searchBtn.hr_setCronerRadius(radius: 17)
        self.navigationItem.titleView = searchBtn
        
        hr_getLocation(success: { (location, reGeocode) in
            self.locationBtn.setTitle(reGeocode?.district, for: .normal)
        }) { (desc) in
            print(desc)
        }
    }
    
    
    //MARK:选择定位地址
    func changeLocationAddress(){
    
    }
    
    //MARK:跳转消息
    func goMessage(){
        let VC = HRMessageVC()
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK:跳转搜索界面
    func goSearch(){
        let VC = HRSearchVC()
        let NA = HRNavigationController(rootViewController: VC)
        self.present(NA, animated: true, completion: nil)
    }
    
    //MARK:头部代理
    func showBannerDetail(info: HRBannerInfoModel) {
        
    }
    func showNoticeDetail(info: HRNoticeInfoModel) {
        let VC = HRNoticeDetailVC()
        VC.noticeID = info.link
        self.goNext(VC: VC)
    }
    func showDetail(type: Int) {
        if type == 0 {
            self.goNext(VC: HRTravelPrefectureVC())
        }else if type == 1 {
            self.goNext(VC: HRActivityPrefectureVC())
        }else if type == 2 {
            self.goNext(VC: HRGoodPrefectureVC())
        }else if type == 3 {
            self.goNext(VC: HRShopPrefectureVC())
        }
    }
    func goNext(VC:UIViewController){
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if StringToInt(str: self.newsInfo.id)==0 {
                return 0
            }
            return 1
        }else if section == 1{
            return firstList.count
        }else if section == 2{
            return secondList.count
        }else{
            return thirdList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        tableView.rowHeight = 120
        if section == 0 {
            var cell:HRHomeNewsTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRHomeNewsTVCell
            if cell == nil {
                cell = HRHomeNewsTVCell(style: .default, reuseIdentifier: "CELL1")
            }
            cell?.setInfo(info: self.newsInfo)
            return cell!
        }else if section == 1{
            var cell:HRHomeSpecialOfferTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? HRHomeSpecialOfferTVCell
            if cell == nil {
                cell = HRHomeSpecialOfferTVCell(style: .default, reuseIdentifier: "CELL2")
            }
            if self.firstList.count > row {
                let info = self.firstList[row]
                cell?.setInfo(info: info)
            }
            if self.firstList.count == row+1 {
                cell?.showLine(isShow: false)
            }else{
                cell?.showLine(isShow: true)
            }
            return cell!
        }else if section == 2{
            var cell:HRHomeActivityTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL3") as? HRHomeActivityTVCell
            if cell == nil {
                cell = HRHomeActivityTVCell(style: .default, reuseIdentifier: "CELL3")
            }
            if self.secondList.count > row {
                let info = self.secondList[row]
                cell?.setInfo(info: info)
            }
            if self.secondList.count == row+1 {
                cell?.showLine(isShow: false)
            }else{
                cell?.showLine(isShow: true)
            }
            return cell!
        }else{
            var cell:HRHomeGoodTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL4") as? HRHomeGoodTVCell
            if cell == nil {
                cell = HRHomeGoodTVCell(style: .default, reuseIdentifier: "CELL4")
            }
            if self.thirdList.count > row {
                let info = self.thirdList[row]
                cell?.setInfo(info: info)
            }
            if self.thirdList.count == row+1 {
                cell?.showLine(isShow: false)
            }else{
                cell?.showLine(isShow: true)
            }
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if self.newsInfo.id.characters.count > 0 {
                let VC = HRNewsDetailVC()
                VC.hidesBottomBarWhenPushed = true
                VC.newsID = self.newsInfo.id
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else if section == 1 {
            if self.firstList.count > row {
                let info = self.firstList[row]
                let VC = HRGoodsDetailVC()
                VC.hidesBottomBarWhenPushed = true
                VC.goodsID = info.id
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else if section == 2 {
            if self.secondList.count > row {
                let info = self.secondList[row]
                let VC = HRActivityDetailVC()
                VC.hidesBottomBarWhenPushed = true
                VC.activityID = info.id
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else if section == 3 {
            if self.thirdList.count > row {
                let info = self.thirdList[row]
                let VC = HRGoodsDetailVC()
                VC.hidesBottomBarWhenPushed = true
                VC.goodsID = info.id
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if StringToInt(str: self.newsInfo.id)==0 && section == 0 {
            return  0.0001
        }else if self.firstList.count == 0 && section == 1 {
            return  0.0001
        }else if self.secondList.count == 0 && section == 2 {
            return  0.0001
        }else if self.thirdList.count == 0 && section == 3 {
            return  0.0001
        }
        return HR_TOP_HEIGHT
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return HR_MARGIN
    }
    var sectionTitleArr = ["新闻资讯","— 今日特价 —","推荐活动","热卖商品"]
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if StringToInt(str: self.newsInfo.id)==0 && section == 0 {
            return  nil
        }else if self.firstList.count == 0 && section == 1 {
            return  nil
        }else if self.secondList.count == 0 && section == 2 {
            return  nil
        }else if self.thirdList.count == 0 && section == 3 {
            return  nil
        }
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
        topView.backgroundColor = HR_WHITE_COLOR
        
        let titleLab = UILabel(frame: CGRect(x: HR_MARGIN, y: 0, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_TOP_HEIGHT))
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.font = HR_BOLD_FONT
        titleLab.text = sectionTitleArr[section]
        titleLab.textAlignment = .left
        topView.addSubview(titleLab)
        
        if section == 0 {
            let moreBtn = UIButton(frame: CGRect(x: HR_SCREEN_WIDTH-80, y: 0, width: 70, height: HR_TOP_HEIGHT))
            moreBtn.setTitle("更多", for: .normal)
            moreBtn.setTitleColor(HR_GRAY_COLOR, for: .normal)
            moreBtn.titleLabel?.font = HR_NORMAL_FONT
            moreBtn.setImage(UIImage(named:"go_detail"), for: .normal)
            moreBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 55, 0, 00)
            moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15)
            moreBtn.addTarget(self, action: #selector(showMore), for: .touchUpInside)
            topView.addSubview(moreBtn)
        }else if section == 1{
            titleLab.textAlignment = .center
            titleLab.textColor = HR_RED_COLOR
        }
        return topView
    }
    

    func showMore(){
        let VC = HRNewsListVC()
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
