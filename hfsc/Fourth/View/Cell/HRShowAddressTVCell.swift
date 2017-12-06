//
//  HRShowAddressTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/24.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRShowAddressTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    lazy private var bodyView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy private var nameLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_BOLD_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy private var alertLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GOLD_COLOR
        tempLab.font = HR_BIG_FONT
        tempLab.textAlignment = .left
        tempLab.text = "请添加收货地址"
        return tempLab
    }()
    lazy private var addressLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        tempLab.numberOfLines = 2
        return tempLab
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        self.bodyView.addSubview(self.nameLab)
        self.bodyView.addSubview(self.addressLab)
        self.bodyView.addSubview(self.alertLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.left.equalTo(HR_MARGIN)
            make.right.bottom.equalTo(-HR_MARGIN)
        }
        
        self.nameLab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(25)
        }
        self.addressLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameLab.snp.bottom)
            make.left.right.bottom.equalTo(0)
        }
        self.alertLab.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
    }
    
    func setInfo(info:HRAddressInfoModel){
        if EmptyCheck(str: info.name).characters.count > 0 {
            self.nameLab.text = "\(EmptyCheck(str: info.name))        \(EmptyCheck(str: info.phone))"
            self.addressLab.text = "\(EmptyCheck(str: info.areaDetail))\(EmptyCheck(str: info.address))"
            self.alertLab.isHidden = true
        }else{
            self.alertLab.isHidden = false
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
