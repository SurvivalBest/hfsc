//
//  HRShopTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit

class HRShopTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var type = 0
    //1:已选择门店
    //2:选择门店列表
    
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
        tempLab.backgroundColor = HR_WHITE_COLOR
        return tempLab
    }()
    lazy private var tagLab:UILabel = {
        let tempLab = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tempLab.layer.cornerRadius = 10
        tempLab.layer.masksToBounds = true
        tempLab.textColor = HR_WHITE_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.backgroundColor = HR_RED_COLOR
        tempLab.text = "官"
        tempLab.textAlignment = .center
        return tempLab
    }()
    lazy private var starView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy private var addressLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        tempLab.numberOfLines = 2
        return tempLab
    }()
    lazy private var distanceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .right
        return tempLab
    }()
    
    lazy private var lineView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_LINE_COLOR
        tempView.isHidden = true
        return tempView
    }()
    lazy var selectBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.isUserInteractionEnabled = false
        tempBtn.setImage(UIImage(named:"sex_no"), for: .normal)
        tempBtn.setImage(UIImage(named:"sex_yes"), for: .selected)
        tempBtn.addTarget(self, action: #selector(chooseItem(btn:)), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:选择
    func chooseItem(btn:UIButton){
//        if !btn.isSelected  {
//            btn.isSelected = true
//        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        self.contentView.addSubview(self.lineView)
        
        self.bodyView.addSubview(self.iconIV)
        self.bodyView.addSubview(self.titleLab)
        self.bodyView.addSubview(self.starView)
        self.bodyView.addSubview(self.addressLab)
        self.bodyView.addSubview(self.distanceLab)
        self.bodyView.addSubview(self.selectBtn)
        
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
        self.starView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(5)
            make.width.equalTo(starW*5)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.height.equalTo(starW)
        }
        self.addressLab.snp.makeConstraints { (make) in
            make.right.equalTo(-70)
            make.bottom.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.height.equalTo(starW)
        }
        self.distanceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(70)
            make.height.equalTo(starW)
        }
        self.lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(1)
        }
        self.selectBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.height.equalTo(35)
        }
    }
    func showLine(isShow:Bool){
        self.lineView.isHidden = !isShow
    }
    func setInfo(info:HRShopInfoModel){
        if self.type == 1 {
            self.distanceLab.isHidden = true
            self.selectBtn.isHidden = true
        }else if self.type == 2{
            if info.isSelected == 0 {
                self.selectBtn.isSelected = false
            }else{
                self.selectBtn.isSelected = true
            }
        }else{
            self.selectBtn.isHidden = true
        }
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        if StringToInt(str: info.isSelf) == 1 {
            self.titleLab.attributedText = EmptyCheck(str: info.title).hr_getAttributedString(view: self.tagLab)
        }else{
            self.titleLab.text = EmptyCheck(str: info.title)
        }
        self.addressLab.text = "地址：\(info.address)"
        self.distanceLab.text = "\(info.distance)"
        
        self.starView.hr_removeAllSubviews()
        let starW = CGFloat(15.0)
        let scoreStr = String(format: "%.1f", StringToFloat(str: info.level))
        let scoreArr = scoreStr.components(separatedBy: ".")
        let firstNum = Int(scoreArr.first!)!
        var secondNum = 0
        if scoreArr.count > 1 {
            secondNum = Int(scoreArr.last!)!
        }
        var goldNum = 0
        var grayNum = 5
        var midNum = 0
        if (secondNum == 0) {
            goldNum = firstNum
            grayNum = 5 - goldNum
        }else{
            goldNum = firstNum
            midNum = 1
            grayNum = 5 - goldNum - midNum
        }
        if goldNum > 5 {
            goldNum = 5
        }
        if grayNum < 0{
            grayNum = 0
        }
        
        for  i in 0..<goldNum {
            let goldIV = UIImageView(frame: CGRect(x: starW*CGFloat(i), y: 0, width: starW, height: starW))
            goldIV.image = UIImage(named: "star_gold")
            self.starView.addSubview(goldIV)
        }
        for j in 0..<midNum {
            let grayIV = UIImageView(frame: CGRect(x: starW*CGFloat(goldNum+j), y: 0, width: starW, height: starW))
            grayIV.image = UIImage(named: "star_center")
            self.starView.addSubview(grayIV)
        }
        for k in 0..<grayNum {
            let grayIV = UIImageView(frame: CGRect(x: starW*CGFloat(goldNum+midNum+k), y: 0, width: starW, height: starW))
            grayIV.image = UIImage(named: "star_gray")
            self.starView.addSubview(grayIV)
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
