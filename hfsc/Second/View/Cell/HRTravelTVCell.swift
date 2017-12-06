//
//  HRTravelTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/16.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit

class HRTravelTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var labH:CGFloat = 25
    
    lazy private var bodyView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy private var iconIV:UIImageView = {
        let tempView = UIImageView()
        tempView.contentMode = .scaleAspectFill
        tempView.layer.masksToBounds = true
        tempView.layer.cornerRadius = HR_RADIUS
        tempView.layer.shouldRasterize = true
        tempView.layer.contentsScale = UIScreen.main.scale
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
        tempLab.textAlignment = .right
        return tempLab
    }()
    lazy private var priceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_RED_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    
    lazy private var lineView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_LINE_COLOR
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
        self.bodyView.addSubview(self.detailLab)
        self.bodyView.addSubview(self.priceLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(0)
            make.right.equalTo(-10)
            make.left.equalTo(5)
        }
        self.iconIV.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-labH*2-5)
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(self.iconIV.snp.bottom).offset(5)
            make.height.equalTo(labH)
        }
        self.detailLab.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(labH)
        }
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(labH)
        }
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(1)
        }
    }
    
    func setInfo(info:HRTravelInfoModel){
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        self.titleLab.text = info.title
        self.detailLab.text = "销量\(info.count)"
        self.priceLab.text = "￥\(info.price)"
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
