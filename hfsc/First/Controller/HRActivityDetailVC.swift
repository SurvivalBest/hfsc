//
//  HRActivityDetailVC.swift
//  hfsc
//
//  Created by innket on 17/11/20.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
class HRActivityDetailVC: HRBaseVC,UITableViewDelegate,UITableViewDataSource,HRBannerViewDelegate,WKUIDelegate,WKNavigationDelegate {

    var activityID = "0"
    var detailInfo:HRActivityInfoModel = HRActivityInfoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "活动详情")
        // Do any additional setup after loading the view.
        self.getData{
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
        let tempTV = UITableView(frame: HR_FIRST_FRAME, style: .plain)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.separatorColor = HR_LINE_COLOR
        tempTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    lazy var detailWV:WKWebView = {
        let tempWV = WKWebView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 20), configuration: hr_setWKWebViewConfig())
        tempWV.uiDelegate = self
        tempWV.navigationDelegate = self
        return tempWV
    }()
    
    lazy var enrollBtn:UIButton = {
        let tempBtn = UIButton(frame: CGRect(x: 0, y: HR_SCREEN_HEIGHT-HR_FOOTER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_FOOTER_HEIGHT))
        tempBtn.setTitle("马上报名", for: .normal)
        tempBtn.backgroundColor = HR_GOLD_COLOR
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(enrollActivity), for: .touchUpInside)
        return tempBtn
    }()
    func enrollActivity(){
        if !HRDataSave.hr_isLogin() {
            HRDataSave.hr_goLogin(VC: self)
            return
        }
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = self.activityID
        HRNetwork.shared.hr_getData(cmd: "activityEnroll", params: param, success: { (result) in
            self.noticeOnlyText("报名成功")
        }) { (error) in
        }
    }
    
    func getData(success:@escaping ()->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = self.activityID
        HRNetwork.shared.hr_getData(cmd: "getActivityDetail", params: param, success: { (result) in
            let info = HRActivityInfoModel.deserialize(from: result["body"].rawString()!)
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
        self.detailWV.hr_loadHtml(content: self.detailInfo.detail)
        self.view.addSubview(self.mainTV)
        self.view.addSubview(self.enrollBtn)
        let status = StringToInt(str: self.detailInfo.status)
        let isEnroll = StringToInt(str: self.detailInfo.isEnroll)
        let count = StringToInt(str: self.detailInfo.count)
        let total = StringToInt(str: self.detailInfo.total)
        if status == 1 {
            //未开始
            if isEnroll == 1 {
                self.enrollBtn.setTitle("已报名", for: .normal)
                self.enrollBtn.backgroundColor = HR_GOLD_COLOR
                self.enrollBtn.isEnabled = false
            }else if (count == total){
                self.enrollBtn.setTitle("名额已满", for: .normal)
                self.enrollBtn.backgroundColor = HR_DISABLE_COLOR
                self.enrollBtn.isEnabled = false
            }else if (count + 5 > total){
                self.enrollBtn.setTitle("仅剩\(total-count)个名额", for: .normal)
                self.enrollBtn.backgroundColor = HR_GOLD_COLOR
                self.enrollBtn.isEnabled = true
            }else {
                self.enrollBtn.setTitle("马上报名", for: .normal)
                self.enrollBtn.backgroundColor = HR_GOLD_COLOR
                self.enrollBtn.isEnabled = true
            }
        }else if status == 2 {
            //进行中
            if isEnroll == 1 {
                self.enrollBtn.setTitle("已报名", for: .normal)
                self.enrollBtn.backgroundColor = HR_GOLD_COLOR
                self.enrollBtn.isEnabled = false
            }else {
                self.enrollBtn.setTitle("报名截止", for: .normal)
                self.enrollBtn.backgroundColor = HR_DISABLE_COLOR
                self.enrollBtn.isEnabled = false
            }
            
        }else if status == 3 {
            //已结束
            self.enrollBtn.setTitle("已结束", for: .normal)
            self.enrollBtn.backgroundColor = HR_DISABLE_COLOR
            self.enrollBtn.isEnabled = false
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
        cell?.detailTextLabel?.textColor = HR_GOLD_COLOR
        cell?.detailTextLabel?.font = HR_SMALL_FONT
        if row == 0 {
            cell?.textLabel?.font = HR_BOLD_FONT
            cell?.textLabel?.text = "\(EmptyCheck(str: self.detailInfo.title))"
            cell?.detailTextLabel?.text = "\(EmptyCheck(str: self.detailInfo.typeStr))"
            cell?.detailTextLabel?.backgroundColor = HR_GOLD_COLOR
            cell?.detailTextLabel?.textColor = HR_WHITE_COLOR
        }else if row == 1 {
            cell?.textLabel?.text = "\(EmptyCheck(str: self.detailInfo.startTime))至\(EmptyCheck(str: self.detailInfo.endTime))"
            cell?.imageView?.image = UIImage(named: "detail_time")
        }else if row == 2 {
            cell?.textLabel?.text = EmptyCheck(str: self.detailInfo.address)
            cell?.imageView?.image = UIImage(named: "detail_location")
        }else if row == 3 {
            cell?.textLabel?.text = "\(StringToInt(str: self.detailInfo.count))/\(StringToInt(str: self.detailInfo.total))人"
            cell?.imageView?.image = UIImage(named: "detail_people")
        }else if row == 4 {
            cell?.textLabel?.text = "\(EmptyCheck(str: self.detailInfo.price))元"
            cell?.imageView?.image = UIImage(named: "detail_price")
            cell?.detailTextLabel?.text = "担保交易"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == 0 {
            return 55
        }
        return 45
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return HR_TOP_HEIGHT
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
        view.backgroundColor = HR_BG_COLOR
        
        let labView = UIView(frame: CGRect(x: 0, y: HR_MARGIN, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT-HR_MARGIN))
        labView.backgroundColor = HR_WHITE_COLOR
        let lable = UILabel(frame: CGRect(x: HR_MARGIN, y: 5, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_TOP_HEIGHT-HR_MARGIN-5))
        lable.text = "活动详情"
        lable.textColor = HR_BLACK_COLOR
        lable.font = HR_BOLD_FONT
        labView.addSubview(lable)
        
        view.addSubview(labView)
        return view
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.hr_setImageWidth()
        print("加载完成")
        webView.hr_getWebviewHeight { (height) in
            let frame = webView.frame
            webView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: height)
            self.mainTV.tableFooterView = webView
            self.mainTV.reloadData()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
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
