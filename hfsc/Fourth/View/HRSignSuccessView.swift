//
//  HRSignSuccessView.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRSignSuccessView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    static let shared = HRSignSuccessView.init()
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT))
        self.setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var bodyView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_WHITE_COLOR
        tempView.layer.cornerRadius = 10
        tempView.layer.masksToBounds = true
        return tempView
    }()
    lazy var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .center
        tempLab.text = "签到成功"
        return tempLab
    }()
    lazy var iconIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.image = UIImage(named:"sign_suc")
        tempIV.contentMode = .scaleAspectFit
        return tempIV
    }()
    lazy var integralLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GOLD_COLOR
        tempLab.font = HR_BALANCE_FONT
        tempLab.textAlignment = .center
        tempLab.text = "获得5积分"
        return tempLab
    }()
    lazy var numLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GOLD_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .center
        tempLab.text = "已连续签到1天"
        return tempLab
    }()
    lazy var delBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage(named:"pop_delete"), for: .normal)
        tempBtn.addTarget(self, action: #selector(closePop), for: .touchUpInside)
        return tempBtn
    }()
    func closePop(){
        self.isHidden = true
    }
    
    func setUI(){
        self.backgroundColor = HR_BLACK_COLOR.withAlphaComponent(0.3)
        self.addSubview(self.bodyView)
        self.bodyView.snp.makeConstraints { (make) in
            make.left.equalTo(HR_SCREEN_WIDTH*0.2)
            make.right.equalTo(-HR_SCREEN_WIDTH*0.2)
            make.top.equalTo(HR_SCREEN_HEIGHT*2/7)
            make.bottom.equalTo(-HR_SCREEN_HEIGHT*2/7)
        }
        self.addSubview(self.delBtn)
        self.delBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.bodyView.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo((HR_SCREEN_WIDTH-HR_TOP_HEIGHT)/2)
            make.width.height.equalTo(HR_TOP_HEIGHT)
        }
        
        self.bodyView.addSubview(self.titleLab)
        self.bodyView.addSubview(self.iconIV)
        self.bodyView.addSubview(self.integralLab)
        self.bodyView.addSubview(self.numLab)
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MARGIN*2)
            make.left.right.equalTo(0)
            make.height.equalTo(20)
        }
        self.iconIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.bottom.equalTo(-HR_MARGIN*2-20-45)
        }
        self.integralLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-HR_MARGIN*2-20)
            make.left.right.equalTo(0)
            make.height.equalTo(35)
        }
        self.numLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-HR_MARGIN*2)
            make.left.right.equalTo(0)
            make.height.equalTo(20)
        }
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    func setInfo(integral:String,num:String){
        self.isHidden = false
        self.integralLab.text = "获得\(StringToInt(str: integral))积分"
        self.numLab.text = "已连续签到\(StringToInt(str: num))天"
    }
}
