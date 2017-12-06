//
//  HRInviteVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class HRInviteVC: HRBaseVC,WKUIDelegate,WKNavigationDelegate {

    var inviteInfo:HRInviteInfoModel = HRInviteInfoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "邀请有礼")
        self.navigationItem.rightBarButtonItem = self.setBarButton(title: "记录", event: #selector(inviteHistory))
        // Do any additional setup after loading the view.
        self.getData {
            self.setUI()
        }
    }
    //MARK:邀请记录
    func inviteHistory(){
        self.navigationController?.pushViewController(HRInviteHistoryVC(), animated: true)
    }
    lazy var iconIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.image = UIImage(named: "true")
        return tempIV
    }()
    lazy var detailWV:WKWebView = {
        let tempWV = WKWebView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 20), configuration: hr_setWKWebViewConfig())
        tempWV.uiDelegate = self
        tempWV.navigationDelegate = self
        return tempWV
    }()
    lazy var qrCodeIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.image = HR_DEFAULT_IMG
        return tempIV
    }()
    
    lazy var codeLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textAlignment = .center
        tempLab.font = HR_NORMAL_FONT
        tempLab.textColor = HR_BLACK_COLOR
        return tempLab
    }()
    
    lazy var addBtn:UIButton = {
        let tempBtn = UIButton(frame: CGRect(x: 0, y: HR_SCREEN_HEIGHT-HR_FOOTER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_FOOTER_HEIGHT))
        tempBtn.setTitle("邀请好友得奖励", for: .normal)
        tempBtn.backgroundColor = HR_GOLD_COLOR
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        return tempBtn
    }()
    func addAddress(){
        print("邀请好友得奖励")
    }
    func getData(success:@escaping ()->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getInviteInfo", params: param, success: { (result) in
            let info = HRInviteInfoModel.deserialize(from: result["body"].rawString()!)
            if info != nil {
                self.inviteInfo = info!
            }
            success()
        }) { (error) in
        }
    }
    private func setUI(){
        self.view.backgroundColor = HR_WHITE_COLOR
        self.view.addSubview(self.iconIV)
        self.view.addSubview(self.detailWV)
        self.view.addSubview(self.qrCodeIV)
        self.view.addSubview(self.codeLab)
        self.view.addSubview(self.addBtn)
        
        
        self.iconIV.snp.makeConstraints { (make) in
            make.top.equalTo(HR_HEADER_HEIGHT)
            make.left.right.equalTo(0)
            make.height.equalTo(HR_SCREEN_WIDTH*301/750)
        }
        self.detailWV.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconIV.snp.bottom)
            make.left.right.equalTo(0)
            make.bottom.equalTo(-HR_FOOTER_HEIGHT-30-80)
        }
        self.qrCodeIV.snp.makeConstraints { (make) in
            make.bottom.equalTo(-HR_FOOTER_HEIGHT-30)
            make.left.equalTo((HR_SCREEN_WIDTH-80)/2)
            make.width.height.equalTo(80)
        }
        self.codeLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-HR_FOOTER_HEIGHT)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
        }
        self.addBtn.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(HR_FOOTER_HEIGHT)
        }
        
        self.qrCodeIV.hr_setImage(name: EmptyCheck(str: self.inviteInfo.qrCode))
        self.detailWV.hr_loadHtml(content: EmptyCheck(str: self.inviteInfo.detail))
        self.codeLab.text = EmptyCheck(str: self.inviteInfo.code)
    }

    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.hr_setImageWidth()
        print("加载完成")
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
