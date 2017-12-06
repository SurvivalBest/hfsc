//
//  HRTravelPreTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit

class HRTravelPreTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var labH:CGFloat = 25
    var iconW:CGFloat = 130
    var starW:CGFloat = 15
    
    lazy private var bodyView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy private var iconIV:UIImageView = {
        let tempView = UIImageView()
        tempView.contentMode = .scaleAspectFill
        tempView.layer.masksToBounds = true
        return tempView
    }()
    lazy private var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_BOLD_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var detailLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var priceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.backgroundColor = HR_GOLD_COLOR
        tempLab.font = UIFont.boldSystemFont(ofSize: 25)
        tempLab.textAlignment = .center
        return tempLab
    }()
    lazy private var sPriceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var countLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .right
        return tempLab
    }()
    lazy private var addressLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .center
        tempLab.layer.cornerRadius = 25/2
        tempLab.layer.masksToBounds = true
        tempLab.backgroundColor = HR_BLACK_COLOR.withAlphaComponent(0.3)
        return tempLab
    }()
    
    lazy private var lineView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_LINE_COLOR
        tempView.isHidden = true
        return tempView
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        self.contentView.addSubview(self.lineView)
        
        self.bodyView.addSubview(self.iconIV)
        self.iconIV.addSubview(self.addressLab)
        self.iconIV.addSubview(self.priceLab)
        self.iconIV.addSubview(self.sPriceLab)
        self.iconIV.addSubview(self.countLab)
        
        self.bodyView.addSubview(self.titleLab)
        self.bodyView.addSubview(self.detailLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MIN_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.bottom.equalTo(-HR_MIN_MARGIN)
            make.right.equalTo(-HR_MARGIN)
        }
        self.iconIV.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-labH*2)
        }
        self.addressLab.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MARGIN)
            make.width.equalTo(labH*2)
            make.left.equalTo(5)
            make.height.equalTo(labH)
        }
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-30)
            make.left.equalTo(0)
            make.width.equalTo(0)
            make.height.equalTo(35)
        }
        self.sPriceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(5)
            make.width.equalTo((HR_SCREEN_WIDTH-HR_MARGIN)/2)
            make.height.equalTo(30)
        }
        self.countLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(-5)
            make.width.equalTo((HR_SCREEN_WIDTH-HR_MARGIN)/2)
            make.height.equalTo(30)
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconIV.snp.bottom)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(labH)
        }
        self.detailLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(20)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
    }
    func showLine(isShow:Bool){
        self.lineView.isHidden = !isShow
    }
    func setInfo(info:HRTravelInfoModel){
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        self.titleLab.text = info.title
        let addressStr = "\(EmptyCheck(str: info.typeStr))  |  \(EmptyCheck(str: info.starting))出发"
        var strSize = calculateOneLineStringSize(str: addressStr, font: HR_SMALL_FONT)
        self.addressLab.text = addressStr
        self.addressLab.snp.updateConstraints { (make) in
            make.width.equalTo(strSize.width+HR_MARGIN)
        }
        
        let priceStr = "\(EmptyCheck(str: info.price))元"
        strSize = calculateOneLineStringSize(str: priceStr, font: UIFont.boldSystemFont(ofSize: 25))
        self.priceLab.snp.updateConstraints { (make) in
            make.width.equalTo(strSize.width)
        }
        let attriStr = NSMutableAttributedString(string: priceStr)
        attriStr.addAttribute(NSFontAttributeName, value: HR_SMALL_FONT, range: NSRange(location: priceStr.characters.count-1, length: 1))
        self.priceLab.attributedText = attriStr
        
        if StringToFloat(str: info.savePrice) > 0.0 {
            self.sPriceLab.text = "已省￥\(EmptyCheck(str: info.savePrice))"
        }
        self.countLab.text = "销量 \(EmptyCheck(str: info.count))  好评 \(EmptyCheck(str: info.review))%"
        
        self.titleLab.text = "\(EmptyCheck(str: info.title))"
        self.detailLab.text = "\(EmptyCheck(str: info.detail))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
