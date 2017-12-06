//
//  HRNewsDetailVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import WebKit

class HRNewsDetailVC: HRBaseVC ,WKNavigationDelegate,WKUIDelegate{
    public var newsID = "0"
    private var newsDetail:HRNewsDetailModel = HRNewsDetailModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "资讯详情")
        self.getData { 
            self.setUI()
        }
        // Do any additional setup after loading the view.
    }
    func getData(success:@escaping ()->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = self.newsID
        HRNetwork.shared.hr_getData(cmd: "getNewsDetail", params: param, success: { (result) in
            let info = HRNewsDetailModel.deserialize(from: result["body"].rawString()!)
            if info != nil {
                self.newsDetail = info!
            }
            success()
            }) { (error) in
        }
    }
    lazy var headerView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_BOLD_FONT
        tempLab.textAlignment = .left
        tempLab.numberOfLines = 0
        return tempLab
    }()
    
    lazy var iconIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.contentMode = .scaleAspectFit
        tempIV.layer.cornerRadius = 25
        tempIV.layer.masksToBounds = true
        tempIV.image = HR_DEFAULT_AVATAR
        return tempIV
    }()
    
    lazy var nameLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_THEME_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy var typeLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy var tagLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_MORE_SMALL_FONT
        tempLab.backgroundColor = HR_THEME_COLOR
        tempLab.textAlignment = .center
        tempLab.layer.cornerRadius = 10
        tempLab.layer.masksToBounds = true
        return tempLab
    }()
    lazy var timeLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .right
        return tempLab
    }()
    lazy var detailWV:WKWebView = {
        let tempWV = WKWebView(frame: HR_FULL_FRAME, configuration: hr_setWKWebViewConfig())
        tempWV.uiDelegate = self
        tempWV.navigationDelegate = self
        return tempWV
    }()
    
    private func setUI(){
        self.setHeaderView()
        self.view.addSubview(self.detailWV)
        self.detailWV.hr_loadHtml(content: self.newsDetail.detail)
    }
    private func setHeaderView(){
        
        
        self.detailWV.scrollView.addSubview(self.headerView)

        let titleSize = calculateMoreLineStringSize(str: self.newsDetail.title, font: HR_BOLD_FONT, maxSize: CGSize(width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_SCREEN_WIDTH))
        self.detailWV.scrollView.contentInset = UIEdgeInsetsMake((titleSize.height+HR_MARGIN+50), 0, 0, 0)
        self.headerView.frame = CGRect(x: HR_MARGIN, y: -(titleSize.height+HR_MARGIN+50), width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: titleSize.height+HR_MARGIN+50)
        
        self.headerView.addSubview(self.titleLab)
        self.headerView.addSubview(self.iconIV)
        self.headerView.addSubview(self.nameLab)
        self.headerView.addSubview(self.typeLab)
        self.headerView.addSubview(self.tagLab)
        self.headerView.addSubview(self.timeLab)
        self.titleLab.text = EmptyCheck(str: self.newsDetail.title)
        let imgUrl = URL(string: EmptyCheck(str: self.newsDetail.avatar))
        if imgUrl != nil{
            self.iconIV.af_setImage(withURL: imgUrl!, placeholderImage: HR_DEFAULT_AVATAR)
        }
        self.nameLab.text = EmptyCheck(str: self.newsDetail.name)
        self.typeLab.text = EmptyCheck(str: self.newsDetail.type)
        if StringToInt(str: self.newsDetail.isSelf) == 1 {
            self.tagLab.text = "官方"
        }else {
            self.tagLab.isHidden = true
        }
        self.timeLab.text = EmptyCheck(str: self.newsDetail.time)
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(titleSize.height+HR_MARGIN)
        }
        self.iconIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(0)
            make.width.height.equalTo(50)
        }
        let nameSize = calculateOneLineStringSize(str: self.newsDetail.name, font: HR_SMALL_FONT)
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.width.equalTo(nameSize.width+HR_MARGIN)
            make.height.equalTo(20)
        }
        let typeSize = calculateOneLineStringSize(str: self.newsDetail.type, font: HR_SMALL_FONT)
        self.typeLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.width.equalTo(typeSize.width+HR_MARGIN)
            make.height.equalTo(20)
        }
        self.tagLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(self.nameLab.snp.right)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        self.timeLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-15)
            make.left.equalTo(self.typeLab.snp.right)
            make.right.equalTo(0)
            make.height.equalTo(20)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.hr_setImageWidth()
        print("加载完成")
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
