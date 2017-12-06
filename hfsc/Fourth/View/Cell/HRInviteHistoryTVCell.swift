//
//  HRInviteHistoryTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/22.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRInviteHistoryTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var labH:CGFloat = 20
    let margin:CGFloat = 10
    lazy private var bodyView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy private var iconIV:UIImageView = {
        let tempView = UIImageView()
        tempView.contentMode = .scaleAspectFill
        tempView.layer.masksToBounds = true
        tempView.layer.cornerRadius = 20
        tempView.layer.shouldRasterize = true
        tempView.layer.contentsScale = UIScreen.main.scale
        return tempView
    }()
    lazy private var nameLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var timeLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var detailLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GOLD_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .right
        tempLab.numberOfLines = 2
        return tempLab
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        
        self.bodyView.addSubview(self.iconIV)
        self.bodyView.addSubview(self.nameLab)
        self.bodyView.addSubview(self.timeLab)
        self.bodyView.addSubview(self.detailLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.left.top.equalTo(HR_MARGIN)
            make.bottom.right.equalTo(-HR_MARGIN)
        }
        self.iconIV.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(40)
        }
        self.nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconIV.snp.right).offset(10)
            make.right.equalTo(-HR_SCREEN_WIDTH/2)
            make.top.equalTo(0)
            make.height.equalTo(labH)
        }
        self.timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.iconIV.snp.right).offset(10)
            make.right.equalTo(-HR_SCREEN_WIDTH/2)
            make.bottom.equalTo(0)
            make.height.equalTo(labH)
        }
        self.detailLab.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(0)
            make.height.equalTo(labH*2)
        }
    }
    
    func setInfo(type:Int,info:HRInviteListModel){
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        self.nameLab.text = EmptyCheck(str: info.name)
        self.timeLab.text = EmptyCheck(str: info.time)
        if type == 1 {
            //邀请记录
            self.detailLab.text = EmptyCheck(str: info.statusStr)
        }else{
            //奖励记录
            var priceStr = ""
            if StringToInt(str: info.isPrice) == 1 {
                //钱
                priceStr = "+\(EmptyCheck(str: info.award))元"
            }else{
                //积分
                priceStr = "+\(EmptyCheck(str: info.award))积分"
            }
            let detailStr = "\(priceStr)\n\(EmptyCheck(str: info.detail))"
            let attriStr = NSMutableAttributedString(string: detailStr)
            attriStr.addAttribute(NSFontAttributeName, value: HR_NORMAL_FONT, range: NSRange(location: 0, length: priceStr.characters.count))
            self.detailLab.attributedText = attriStr
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
