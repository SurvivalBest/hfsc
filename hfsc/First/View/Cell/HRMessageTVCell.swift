//
//  HRMessageTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/17.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit

class HRMessageTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var labH:CGFloat = 25
    var iconW:CGFloat = 40
    
    lazy private var bodyView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy private var iconIV:UIImageView = {
        let tempView = UIImageView()
        tempView.contentMode = .scaleAspectFit
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
    lazy private var timeLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .right
        return tempLab
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        
        self.bodyView.addSubview(self.iconIV)
        self.bodyView.addSubview(self.titleLab)
        self.bodyView.addSubview(self.detailLab)
        self.bodyView.addSubview(self.timeLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.left.equalTo(HR_MARGIN)
            make.bottom.right.equalTo(-HR_MARGIN)
        }
        self.iconIV.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MARGIN)
            make.left.equalTo(0)
            make.bottom.equalTo(-HR_MARGIN)
            make.width.equalTo(iconW)
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.width.equalTo((HR_SCREEN_WIDTH-iconW-HR_MARGIN*2)/2)
            make.height.equalTo(labH)
        }
        self.detailLab.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.height.equalTo(labH)
        }
        self.timeLab.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.equalTo((HR_SCREEN_WIDTH-iconW-HR_MARGIN*2)/2)
            make.height.equalTo(labH)
        }
    }
    
    
    func setInfo(info:HRMessageInfoModel){
        self.titleLab.text = info.title
        self.detailLab.text = "\(info.detail)"
        self.timeLab.text = "\(info.time)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func isSysMsg(isSys:Bool){
        if isSys {
            self.iconIV.image = UIImage(named:"sys_message")
        }else{
            self.iconIV.image = UIImage(named:"other_message")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
