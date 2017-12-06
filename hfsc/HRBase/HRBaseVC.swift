//
//  HRBaseVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRBaseVC: UIViewController {
    
    var navTitle:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = HR_BG_COLOR
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = true
        // Do any additional setup after loading the view.
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back")
        self.navigationItem.backBarButtonItem = backItem
    }
    //MARK:有内容，占位
    lazy var placeholderView:UIView = {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 0.0001))
        return tempView
    }()
    //MARK:无内容
    lazy var noContentView:UIView = {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_FULL_FRAME.height))
        tempView.backgroundColor = HR_BG_COLOR
        
        let iconIV = UIImageView(frame: CGRect(x: HR_SCREEN_WIDTH/4, y: (HR_FULL_FRAME.height-HR_SCREEN_WIDTH/2*0.8)/2-100, width: HR_SCREEN_WIDTH/2, height: HR_SCREEN_WIDTH/2*0.8))
        iconIV.center = tempView.center
        iconIV.image = UIImage(named:"no_content")
        iconIV.contentMode = .scaleAspectFit
        tempView.addSubview(iconIV)
        
        let alertLab = UILabel(frame: CGRect(x: 0, y: iconIV.frame.maxY, width: HR_SCREEN_WIDTH, height: 30))
        alertLab.text = "暂无内容哦!"
        alertLab.textColor = HR_GRAY_COLOR
        alertLab.font = HR_NORMAL_FONT
        alertLab.textAlignment = .center
        tempView.addSubview(alertLab)
        return tempView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = navTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.clearAllNotice()
    }
    
    func setNavTitle(title: String) {
        navTitle = title
    }
    func setBarButton(title:String,event:Selector) -> UIBarButtonItem{
        let reportBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        reportBtn.setTitle(title, for: .normal)
        reportBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        reportBtn.titleLabel?.font = HR_NORMAL_FONT
        reportBtn.addTarget(self, action: event, for: .touchUpInside)
        return UIBarButtonItem(customView: reportBtn)
    }
    
    //MARK:返回
    func goBackPop(){
         let _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goBackDismiss(){
        self.dismiss(animated: true, completion: nil)
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
