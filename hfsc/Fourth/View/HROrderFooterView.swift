//
//  HROrderFooterView.swift
//  BigFish
//
//  Created by innket on 17/8/10.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol HROrderFooterViewDelegate:NSObjectProtocol {
    func orderHandle(btn:UIButton)
}
class HROrderFooterView: UIView {
    var viewW:CGFloat!
    var viewH:CGFloat!
    
    let btnW:CGFloat = 75
    let btnH:CGFloat = 30
    let radius:CGFloat = 3
    var totalLab:UILabel!
    var timeLab:UILabel!
    var firstBtn:UIButton!
    var secondBtn:UIButton!
    weak var delegate:HROrderFooterViewDelegate!
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewH = frame.size.height
        viewW = frame.size.width
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        self.backgroundColor = HR_WHITE_COLOR
        
        timeLab = UILabel()
        timeLab.textColor = HR_GRAY_COLOR
        timeLab.textAlignment = .left
        timeLab.font = HR_SMALL_FONT
        self.addSubview(timeLab)
        
        timeLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
            make.height.equalTo(HR_TOP_HEIGHT)
        }
        
        totalLab = UILabel()
        totalLab.textColor = HR_GRAY_COLOR
        totalLab.textAlignment = .right
        totalLab.font = HR_NORMAL_FONT
        totalLab.text = "共计：0元"
        self.addSubview(totalLab)
        
        totalLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.right.equalTo(-HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/2)
            make.height.equalTo(HR_TOP_HEIGHT)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = HR_LINE_COLOR
        self.addSubview(lineView)
        lineView.snp.makeConstraints { (make
            ) in
            make.top.equalTo(HR_TOP_HEIGHT-1)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        if viewH != HR_TOP_HEIGHT*2 {
            lineView.isHidden = true
        }else{
            lineView.isHidden = false
        }
        let margin:CGFloat = (HR_TOP_HEIGHT-btnH)/2
        
        firstBtn = UIButton()
        firstBtn.setTitleColor(HR_GOLD_COLOR, for: .normal)
        firstBtn.layer.cornerRadius = btnH/2
        firstBtn.layer.masksToBounds = true
        firstBtn.layer.borderWidth = 1
        firstBtn.layer.borderColor = HR_GOLD_COLOR.cgColor
        firstBtn.titleLabel?.font = HR_SMALL_FONT
        firstBtn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
        self.addSubview(firstBtn)
        firstBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-HR_MARGIN)
            make.bottom.equalTo(-margin)
            make.width.equalTo(btnW)
            make.height.equalTo(btnH)
        }
        
        secondBtn = UIButton()
        secondBtn.setTitleColor(HR_DARK_GRAY, for: .normal)
        secondBtn.layer.cornerRadius = btnH/2
        secondBtn.layer.masksToBounds = true
        secondBtn.layer.borderWidth = 1
        secondBtn.layer.borderColor = HR_DARK_GRAY.cgColor
        secondBtn.titleLabel?.font = HR_SMALL_FONT
        secondBtn.addTarget(self, action: #selector(clickBtn(_:)), for: .touchUpInside)
        self.addSubview(secondBtn)
        secondBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.firstBtn.snp.left).offset(-HR_MARGIN)
            make.bottom.equalTo(-margin)
            make.width.equalTo(btnW)
            make.height.equalTo(btnH)
        }
        
    }
    
    func clickBtn(_ btn:UIButton){
        if self.delegate != nil {
            self.delegate.orderHandle(btn: btn)
        }
    }
    
    func setInfo(info:HROrderInfoModel,type:Int){
        self.firstBtn.tag = StringToInt(str: info.id)
        self.secondBtn.tag = StringToInt(str: info.id)
        
        if type == 1 {
            self.secondBtn.isHidden = true
            self.firstBtn.isHidden = false
        }else{
            self.secondBtn.isHidden = true
            self.firstBtn.isHidden = true
        }
        var priceStr = ""
        if StringToInt(str: info.type) == 2 {
            priceStr = String(format: "%d积分",StringToInt(str: info.total))
        }else {
            priceStr = String(format: "%d元",StringToInt(str: info.total))
        }
        let orderInfo = "共计：\(priceStr)"
        
        let attriStr = NSMutableAttributedString(string: orderInfo)
        attriStr.addAttribute(NSFontAttributeName, value: HR_BOLD_FONT, range: NSRange(location: 3, length: orderInfo.characters.count-3))
        attriStr.addAttribute(NSForegroundColorAttributeName, value: HR_RED_COLOR, range: NSRange(location: 3, length: orderInfo.characters.count-3))
        self.totalLab.attributedText = attriStr
        self.timeLab.text = EmptyCheck(str: info.time)
        switch StringToInt(str: info.status) {
        case 1:
            //等待买家发货
            self.firstBtn.setTitle("催单", for: .normal)
        case 2:
            //待收
            self.firstBtn.setTitle("确认收货", for: .normal)
        case 3:
            //结束
            self.firstBtn.setTitle("再来一单", for: .normal)
        default:
            //交易失败
            self.firstBtn.setTitle("再来一单", for: .normal)
        }
        
    }
}
