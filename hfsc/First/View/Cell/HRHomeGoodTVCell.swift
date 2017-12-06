//
//  HRHomeGoodTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/15.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit

class HRHomeGoodTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var labH:CGFloat = 25
    var iconW:CGFloat = 130
    
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
    lazy private var unitLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var priceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_RED_COLOR
        tempLab.font = HR_PRICE_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var countLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .right
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
        self.bodyView.addSubview(self.titleLab)
        self.bodyView.addSubview(self.unitLab)
        self.bodyView.addSubview(self.priceLab)
        self.bodyView.addSubview(self.countLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.left.equalTo(HR_MARGIN)
            make.bottom.right.equalTo(-HR_MARGIN)
        }
        self.iconIV.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(iconW)
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.height.equalTo(labH)
        }
        self.unitLab.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.height.equalTo(labH)
        }
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.width.equalTo((HR_SCREEN_WIDTH-HR_MARGIN*3)/2)
            make.height.equalTo(35)
        }
        self.countLab.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.width.equalTo((HR_SCREEN_WIDTH-HR_MARGIN*3)/2)
            make.height.equalTo(labH)
        }
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(1)
        }
    }
    
    func setInfo(info:HRGoodInfoModel){
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        self.titleLab.text = info.title
        self.unitLab.text = info.unit
        self.countLab.text = "销量:\(info.count)"
        
        let priceStr = "\(EmptyCheck(str: info.price))元"
        let attriStr = NSMutableAttributedString(string: priceStr)
        attriStr.addAttribute(NSFontAttributeName, value: HR_SMALL_FONT, range: NSRange(location: priceStr.characters.count-1, length: 1))
        self.priceLab.attributedText = attriStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showLine(isShow:Bool){
        self.lineView.isHidden = !isShow
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
