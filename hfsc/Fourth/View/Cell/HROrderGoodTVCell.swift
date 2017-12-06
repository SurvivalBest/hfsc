//
//  HROrderGoodTVCell.swift
//  BigFish
//
//  Created by innket on 17/8/10.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit

class HROrderGoodTVCell: UITableViewCell {
    var type:Int = 0
    
    var viewH:CGFloat = 120
    var viewW:CGFloat = HR_SCREEN_WIDTH
    var bodyView:UIView!
    let handleH:CGFloat = 35
    let priceW:CGFloat = 80
    let labH:CGFloat = 20
    var iconIV:UIImageView!
    var nameLab:UILabel!
    var priceLab:UILabel!
    var unitLab:UILabel!
    var numLab:UILabel!
    var tagLab:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        self.contentView.backgroundColor = RGB(r: 249, g: 249, b: 249, a: 1)
        bodyView = UIView(frame: CGRect(x: HR_MARGIN, y: HR_MARGIN, width: viewW-HR_MARGIN*2, height: viewH-HR_MARGIN*2))
        self.contentView.addSubview(bodyView)
        
        iconIV = UIImageView()
        iconIV.contentMode = .scaleAspectFill
        iconIV.layer.masksToBounds = true
        bodyView.addSubview(iconIV)
        
        nameLab = UILabel()
        nameLab.textColor = HR_BLACK_COLOR
        nameLab.textAlignment = .left
        nameLab.font = HR_NORMAL_FONT
        bodyView.addSubview(nameLab)
        
        unitLab = UILabel()
        unitLab.textColor = HR_GRAY_COLOR
        unitLab.textAlignment = .left
        unitLab.font = HR_SMALL_FONT
        bodyView.addSubview(unitLab)
        
        priceLab = UILabel()
        priceLab.textColor = HR_RED_COLOR
        priceLab.textAlignment = .left
        priceLab.font = HR_BOLD_FONT
        bodyView.addSubview(priceLab)
        
        numLab = UILabel()
        numLab.textColor = HR_GRAY_COLOR
        numLab.textAlignment = .right
        numLab.font = HR_SMALL_FONT
        bodyView.addSubview(numLab)
        
        tagLab = UILabel()
        tagLab.textColor = HR_WHITE_COLOR
        tagLab.backgroundColor = HR_GOLD_COLOR
        tagLab.textAlignment = .center
        tagLab.font = HR_SMALL_FONT
        bodyView.addSubview(tagLab)
        
        self.layoutFrame()
    }
    
    //MARK:布局
    func layoutFrame(){
        let bodyH = bodyView.frame.height
        self.iconIV.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.bottom.equalTo(0)
            make.width.equalTo(bodyH+20)
        }
        self.nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(HR_MARGIN)
            make.right.equalTo(0)
            make.height.equalTo(labH)
        }
        self.unitLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom)
            make.left.equalTo(self.iconIV.snp.right).offset(HR_MARGIN)
            make.height.equalTo(labH)
            make.right.equalTo(0)
        }
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(HR_MARGIN)
            make.height.equalTo(labH)
            make.right.equalTo(0)
        }
        self.numLab.snp.makeConstraints { (make) in
            make.top.equalTo((bodyH-labH)/2)
            make.right.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(labH)
        }
        self.tagLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(30)
            make.right.equalTo(0)
            make.height.equalTo(labH)
        }
    }
    func setInfo(info:HRGoodInfoModel){
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        self.nameLab.text = EmptyCheck(str: info.title)
        self.unitLab.text = EmptyCheck(str: info.unit)
        self.numLab.text = EmptyCheck(str: info.count)
        if StringToInt(str: info.kind) == 2 {
            self.tagLab.text = "积分"
            self.tagLab.isHidden = false
            self.priceLab.text = "\(EmptyCheck(str: info.price))积分"
        }else{
            self.tagLab.text = ""
            self.tagLab.isHidden = true
            self.priceLab.text = "\(EmptyCheck(str: info.price))元"
        }
    }
}
