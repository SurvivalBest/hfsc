//
//  HRBalanceHistoryTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRBalanceHistoryTVCell: UITableViewCell {

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
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .right
        return tempLab
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        self.bodyView.addSubview(self.nameLab)
        self.bodyView.addSubview(self.timeLab)
        self.bodyView.addSubview(self.detailLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.left.top.equalTo(HR_MARGIN)
            make.bottom.right.equalTo(-HR_MARGIN)
        }
        self.nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(-HR_SCREEN_WIDTH/2)
            make.top.equalTo(0)
            make.height.equalTo(labH)
        }
        self.timeLab.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(-HR_SCREEN_WIDTH/2)
            make.bottom.equalTo(0)
            make.height.equalTo(labH)
        }
        self.detailLab.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(100)
        }
    }
    
    func setInfo(type:Int,info:HRBalanceHistoryModel){
        self.nameLab.text = EmptyCheck(str: info.title)
        self.timeLab.text = EmptyCheck(str: info.time)
        var typeStr = ""
        if type == 1 {
            typeStr = "元"
        }else{
            typeStr = "积分"
        }
        if StringToInt(str: info.type) == 1 {
            self.detailLab.text = "+\(EmptyCheck(str: info.count))\(typeStr)"
        }else{
            self.detailLab.text = "-\(EmptyCheck(str: info.count))\(typeStr)"
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
