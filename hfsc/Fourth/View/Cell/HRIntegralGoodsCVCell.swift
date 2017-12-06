//
//  HRIntegralGoodsCVCell.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRIntegralGoodsCVCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    var labH:CGFloat = 20
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var iconIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.contentMode = .scaleAspectFill
        tempIV.layer.masksToBounds = true
        tempIV.image = HR_DEFAULT_IMG
        return tempIV
    }()
    
    lazy var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.textAlignment = .left
        tempLab.font = HR_NORMAL_FONT
        return tempLab
    }()
    
    lazy var integralLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_RED_COLOR
        tempLab.textAlignment = .left
        tempLab.font = HR_NORMAL_FONT
        return tempLab
    }()
    
    func setUI(){
        self.contentView.backgroundColor = HR_WHITE_COLOR
        self.contentView.addSubview(self.iconIV)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.integralLab)
        
        self.iconIV.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-40-HR_MARGIN*2)
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.iconIV.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(labH)
        }
        self.integralLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(labH)
        }
    }
    
    func setInfo(info:HRGoodInfoModel){
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        self.titleLab.text = EmptyCheck(str: info.title)
        self.integralLab.text = "\(StringToInt(str: info.integral))积分"
    }
}
