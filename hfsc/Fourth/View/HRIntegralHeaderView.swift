//
//  HRIntegralHeaderView.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

protocol HRIntegralHeaderViewDelegate:NSObjectProtocol {
    func showIntegralExplain()
    func sign(btn:UIButton)
}

class HRIntegralHeaderView: UICollectionReusableView {
    var viewH:CGFloat!
    var viewW:CGFloat!
    weak var delegate:HRIntegralHeaderViewDelegate!
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewH = frame.size.height
        viewW = frame.size.width
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var integralLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GOLD_COLOR
        tempLab.font = HR_BIG_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy var signBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("立即签到", for: .normal)
        tempBtn.setTitle("已签到", for: .disabled)
        tempBtn.setTitleColor(HR_GOLD_COLOR, for: .normal)
        tempBtn.setTitleColor(HR_GRAY_COLOR, for: .disabled)
        tempBtn.titleLabel?.font = HR_NORMAL_FONT
        tempBtn.layer.cornerRadius = 15
        tempBtn.layer.masksToBounds = true
        tempBtn.layer.borderWidth = 1
        tempBtn.layer.borderColor = HR_GOLD_COLOR.cgColor
        tempBtn.addTarget(self, action: #selector(sign), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:签到
    func sign(){
        if self.delegate != nil {
            self.delegate.sign(btn: self.signBtn)
        }
    }
    func setUI(){
        self.backgroundColor = HR_BG_COLOR
        let topView = UIView()
        topView.backgroundColor = HR_WHITE_COLOR
        self.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(60)
        }
        topView.addSubview(self.integralLab)
        self.integralLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
        }
        let detailBut = UIButton()
        detailBut.setTitleColor(HR_BLUE_COLOR, for: .normal)
        detailBut.setTitle("积分说明", for: .normal)
        detailBut.titleLabel?.font = HR_SMALL_FONT
        detailBut.addTarget(self, action: #selector(showDetail), for: .touchUpInside)
        topView.addSubview(detailBut)
        let size = calculateOneLineStringSize(str: "积分说明", font: HR_NORMAL_FONT)
        detailBut.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-HR_MARGIN)
            make.width.equalTo(size.width)
        }
        
        let signView = UIView()
        signView.backgroundColor = HR_WHITE_COLOR
        self.addSubview(signView)
        signView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(topView.snp.bottom).offset(HR_MARGIN)
            make.height.equalTo(60)
        }
        
        let titleLab = UILabel()
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.font = HR_NORMAL_FONT
        titleLab.text = "签到得积分"
        signView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
        }
        
        signView.addSubview(self.signBtn)
        self.signBtn.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(30)
            make.width.equalTo(size.width+HR_MARGIN*2)
        }
        
        let headerLable = UILabel()
        headerLable.textColor = HR_BLACK_COLOR
        headerLable.font = HR_BIG_FONT
        headerLable.text = "兑换商品"
        headerLable.textAlignment = .center
        self.addSubview(headerLable)
        headerLable.snp.makeConstraints { (make) in
            make.top.equalTo(signView.snp.bottom)
            make.height.equalTo(HR_TOP_HEIGHT)
            make.left.right.equalTo(0)
        }
    }

    func showDetail(){
        if self.delegate != nil {
            self.delegate.showIntegralExplain()
        }
    }
    func setInfo(amount:String,isSign:String){
        if StringToInt(str: isSign) == 1 {
            //已签到
            self.signBtn.layer.borderColor = HR_GRAY_COLOR.cgColor
            self.signBtn.isEnabled = false
        }else{
            //未签到
            self.signBtn.isEnabled = true
            self.signBtn.layer.borderColor = HR_GOLD_COLOR.cgColor
        }
        self.integralLab.text = "积分余额：\(amount)积分"
    }
    
}
