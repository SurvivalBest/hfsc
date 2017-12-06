//
//  HRMyPurseVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRMyPurseVC: HRBaseVC {

    var userInfo = HRUserInfoModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavTitle(title: "我的钱包")
        // Do any additional setup after loading the view.
        self.setUI()
    }
    
    lazy var balanceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.textAlignment = .center
        tempLab.font = UIFont.boldSystemFont(ofSize: 30.0)
        return tempLab
    }()
    
    lazy var integralLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.textAlignment = .center
        tempLab.font = UIFont.systemFont(ofSize: 20)
        return tempLab
    }()
    
    func setUI(){
        let balanceView = UIView()
        balanceView.backgroundColor = HR_THEME_COLOR
        self.view.addSubview(balanceView)
        balanceView.snp.makeConstraints { (make) in
            make.top.equalTo(HR_HEADER_HEIGHT)
            make.left.right.equalTo(0)
            make.height.equalTo(HR_BALANCE_HEIGHT)
        }
        
        let bTitleLab = UILabel()
        bTitleLab.textAlignment = .center
        bTitleLab.textColor = HR_WHITE_COLOR
        bTitleLab.font = HR_SMALL_FONT
        bTitleLab.text = "余额"
        balanceView.addSubview(bTitleLab)
        bTitleLab.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MARGIN)
            make.left.right.equalTo(0)
            make.height.equalTo(20)
        }
        
        balanceView.addSubview(self.balanceLab)
        self.balanceLab.text = EmptyCheck(str: self.userInfo.balance)
        self.balanceLab.snp.makeConstraints { (make) in
            make.top.equalTo(bTitleLab.snp.bottom)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-HR_MARGIN)
        }
        let detailIV = UIImageView()
        detailIV.image = UIImage(named: "go_detail_w")
        detailIV.contentMode = .scaleAspectFit
        balanceView.addSubview(detailIV)
        detailIV.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(HR_BALANCE_HEIGHT/2-7.5)
            make.width.height.equalTo(15)
        }
        
        let bBut = UIButton()
        bBut.addTarget(self, action: #selector(showBalance), for: .touchUpInside)
        balanceView.addSubview(bBut)
        bBut.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        
        let integralView = UIView()
        integralView.backgroundColor = HR_WHITE_COLOR
        self.view.addSubview(integralView)
        integralView.snp.makeConstraints { (make) in
            make.top.equalTo(balanceView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(HR_BALANCE_HEIGHT-HR_MARGIN*2)
        }
        
        let intTitle = UILabel()
        intTitle.text = "我的积分"
        intTitle.textAlignment = .center
        intTitle.font = HR_SMALL_FONT
        intTitle.textColor = HR_BLACK_COLOR
        integralView.addSubview(intTitle)
        intTitle.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MARGIN)
            make.left.right.equalTo(0)
            make.height.equalTo(20)
        }
        
        integralView.addSubview(self.integralLab)
        self.integralLab.text = "\(EmptyCheck(str: self.userInfo.integral))积分"
        self.integralLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-HR_MARGIN)
            make.left.right.equalTo(0)
            make.top.equalTo(intTitle.snp.bottom)
        }
        
        let intBut = UIButton()
        intBut.addTarget(self, action: #selector(showIntegral), for: .touchUpInside)
        integralView.addSubview(intBut)
        intBut.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
    }
    //MARK:查看余额
    func showBalance(){
        let VC = HRMyBalanceVC()
        VC.balance = self.userInfo.balance
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK:查看积分
    func showIntegral(){
        self.navigationController?.pushViewController(HRMyIntegralVC(), animated: true)
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
