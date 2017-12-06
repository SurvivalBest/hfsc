//
//  HRShowHtmlVC.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class HRShowHtmlVC: HRBaseVC ,WKUIDelegate,WKNavigationDelegate{

    
    var type = 0
    func setTitle(){
        if type == 0 {
            self.setNavTitle(title: "用户协议")
        }else if type == 1 {
            self.setNavTitle(title: "关于我们")
        }else if type == 2 {
            self.setNavTitle(title: "余额说明")
        }else if type == 3 {
            self.setNavTitle(title: "积分说明")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitle()
        self.getData()
        // Do any additional setup after loading the view.
    }
    lazy var detailWV:WKWebView = {
        let tempWV = WKWebView(frame: HR_FULL_FRAME, configuration: hr_setWKWebViewConfig())
        tempWV.backgroundColor = HR_WHITE_COLOR
        tempWV.uiDelegate = self
        tempWV.navigationDelegate = self
        return tempWV
    }()
    func getData(){
        var param:[String:String] = [:]
        param["type"] = "\(self.type)"
        HRNetwork.shared.hr_getData(cmd: "getConfigInfo", params: param, success: { (result) in
            let detail = result["body"]["detail"].stringValue
            if (detail.length > 0) {
                if (detail.hasPrefix("http://")) || (detail.hasPrefix("https://")){
                    let ulrStr =  detail.replacingOccurrences(of: " ", with: "")
                    let currentURL = URL(string: ulrStr)
                    let _ = self.detailWV.load(URLRequest.init(url: currentURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30))
                }else{
                    let _ = self.detailWV.loadHTMLString(detail, baseURL: Bundle.main.bundleURL)
                }
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }) { (error) in
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
