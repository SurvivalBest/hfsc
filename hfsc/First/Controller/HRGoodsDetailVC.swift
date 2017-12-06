//
//  HRGoodsDetailVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class HRGoodsDetailVC: HRBaseVC,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate {

    
    var headerH:CGFloat = 0
    public var goodsID = "0"
    var detailInfo:HRGoodInfoModel = HRGoodInfoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "商品详情")
        self.getData {
            self.setUI()
        }
        // Do any additional setup after loading the view.
    }
    lazy private var mainSV:UIScrollView = {
        let tempSV = UIScrollView(frame: HR_FIRST_FRAME)
        tempSV.delegate = self
        tempSV.showsHorizontalScrollIndicator = false
        return tempSV
    }()
    lazy var headerView:HRGoodDetailHeaderView = {
        let tempView = HRGoodDetailHeaderView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 100))
        return tempView
    }()
    
    lazy var detailWV:WKWebView = {
        let tempWV = WKWebView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 20), configuration: hr_setWKWebViewConfig())
        tempWV.backgroundColor = HR_WHITE_COLOR
        tempWV.uiDelegate = self
        tempWV.navigationDelegate = self
        tempWV.scrollView.isScrollEnabled = false
        
        let titleView = UIView(frame: CGRect(x: 0, y: -HR_TOP_HEIGHT-5, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT+5))
        titleView.backgroundColor = HR_BG_COLOR
        
        let lineView = UIView(frame: CGRect(x: 0, y: 5, width: 5, height: HR_TOP_HEIGHT))
        lineView.backgroundColor = HR_RED_COLOR
        titleView.addSubview(lineView)
        
        let titleLab = UILabel(frame: CGRect(x: 5, y: 5, width: HR_SCREEN_WIDTH-5, height: HR_TOP_HEIGHT))
        titleLab.text = "  商品详情"
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.font = HR_BIG_FONT
        titleLab.backgroundColor = HR_WHITE_COLOR
        titleView.addSubview(titleLab)
        
        tempWV.scrollView.addSubview(titleView)
        tempWV.scrollView.contentInset = UIEdgeInsetsMake(HR_TOP_HEIGHT+5, 0, 0, 0)
        return tempWV
    }()
    
    lazy var buyBtn:UIButton = {
        let tempBtn = UIButton(frame: CGRect(x: 0, y: HR_SCREEN_HEIGHT-HR_FOOTER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_FOOTER_HEIGHT))
        tempBtn.setTitle("立即购买", for: .normal)
        tempBtn.backgroundColor = HR_GOLD_COLOR
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(buyNow), for: .touchUpInside)
        return tempBtn
    }()
    func buyNow(){
        if !HRDataSave.hr_isLogin() {
            HRDataSave.hr_goLogin(VC: self)
            return
        }
        print("立即购买:\(self.headerView.goodNum)")
        let VC = HROrdersVC()
        self.detailInfo.selectCount = self.headerView.goodNum
        VC.goodInfo = self.detailInfo
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func getData(success:@escaping ()->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = self.goodsID
        HRNetwork.shared.hr_getData(cmd: "getGoodsDetail", params: param, success: { (result) in
            let info = HRGoodInfoModel.deserialize(from: result["body"].rawString()!)
            if info != nil {
                self.detailInfo = info!
            }
            success()
        }) { (error) in
        }
    }
    func setUI(){
        self.view.addSubview(self.mainSV)
        self.mainSV.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(HR_HEADER_HEIGHT)
            make.bottom.equalTo(-HR_FOOTER_HEIGHT)
        }
        self.headerView.setInfo(info: self.detailInfo)
        self.mainSV.addSubview(self.headerView)
        self.mainSV.addSubview(self.detailWV)
        let titleStr = EmptyCheck(str: self.detailInfo.title)
        let titleSize = calculateMoreLineStringSize(str: titleStr, font: HR_BOLD_FONT, maxSize: CGSize(width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_SCREEN_HEIGHT))
        self.headerH = HR_SCREEN_WIDTH*HR_IMAGE_SCALE+titleSize.height+HR_MARGIN*2+30*2+20
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(HR_SCREEN_WIDTH)
            make.height.equalTo(self.headerH)
        }
        self.detailWV.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.equalTo(0)
            make.width.equalTo(HR_SCREEN_WIDTH)
            make.height.equalTo(25+HR_TOP_HEIGHT)
        }
        self.mainSV.contentSize = CGSize(width: HR_SCREEN_WIDTH, height: self.headerH+20)
        self.detailWV.hr_loadHtml(content: EmptyCheck(str: self.detailInfo.detail))
        
        self.view.addSubview(self.buyBtn)
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
            self.detailWV.snp.updateConstraints({ (make) in
                make.height.equalTo(height+5+HR_TOP_HEIGHT)
            })
            self.mainSV.contentSize = CGSize(width: HR_SCREEN_WIDTH, height: self.headerH+height)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
