//
//  HRInviteHistoryHeaderView.swift
//  hfsc
//
//  Created by innket on 17/11/22.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRInviteHistoryHeaderView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var labH:CGFloat = 25
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    lazy private var leftTitle:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .center
        tempLab.text = "累计成功邀请"
        return tempLab
    }()
    lazy private var rightTitle:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .center
        tempLab.text = "累计获得奖励"
        return tempLab
    }()
    lazy private var countLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_BALANCE_FONT
        tempLab.textAlignment = .center
        return tempLab
    }()
    lazy private var awardLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_BALANCE_FONT
        tempLab.textAlignment = .center
        tempLab.numberOfLines = 2
        return tempLab
    }()
    lazy private var lineView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_WHITE_COLOR
        return tempView
    }()
    func setUI(){
        self.backgroundColor = HR_THEME_COLOR
        self.addSubview(self.leftTitle)
        self.addSubview(self.rightTitle)
        self.addSubview(self.countLab)
        self.addSubview(self.awardLab)
        self.addSubview(self.lineView)
        
        self.leftTitle.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
            make.height.equalTo(labH)
        }
        
        self.rightTitle.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
            make.height.equalTo(labH)
        }
        
        self.countLab.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(self.leftTitle.snp.bottom)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
            make.height.equalTo(labH*2+10)
        }
        
        self.awardLab.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(self.leftTitle.snp.bottom)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
            make.height.equalTo(labH*2+10)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(HR_SCREEN_WIDTH/2-0.5)
            make.top.equalTo(HR_MARGIN*2)
            make.bottom.equalTo(-HR_MARGIN*2)
            make.width.equalTo(1)
        }
    }
    
    func setInfo(info:HRInviteHistoryModel){
        let countStr = "\(StringToInt(str: info.totalCount))人"
        let attriStr = NSMutableAttributedString(string: countStr)
        attriStr.addAttribute(NSFontAttributeName, value: HR_SMALL_FONT, range: NSRange(location: countStr.characters.count-1, length: 1))
        self.countLab.attributedText = attriStr
        if StringToInt(str: info.isHavePrice) == 1 {
            let integralStr = "\(StringToInt(str: info.totalIntegral))积分"
            let awardStr = "\(StringToInt(str: info.totalIntegral))积分\n\(StringToFloat(str: info.totalPrice))元"
            let attriStr = NSMutableAttributedString(string: awardStr)
            attriStr.addAttribute(NSFontAttributeName, value: HR_SMALL_FONT, range: NSRange(location: awardStr.characters.count-1, length: 1))
            attriStr.addAttribute(NSFontAttributeName, value: HR_SMALL_FONT, range: NSRange(location: integralStr.characters.count-2, length: 2))
            self.awardLab.attributedText = attriStr
        }else{
            let awardStr = "\(StringToInt(str: info.totalCount))积分"
            let attriStr = NSMutableAttributedString(string: awardStr)
            attriStr.addAttribute(NSFontAttributeName, value: HR_SMALL_FONT, range: NSRange(location: awardStr.characters.count-2, length: 2))
            self.awardLab.attributedText = attriStr
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
