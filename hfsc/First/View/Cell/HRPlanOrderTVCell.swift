//
//  HRPlanOrderTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/24.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

protocol HRPlanOrderTVCellDelegate:NSObjectProtocol {
    func editCount(num:Int)
}

class HRPlanOrderTVCell: UITableViewCell,UITextFieldDelegate {

    var labH:CGFloat = 25
    var iconW:CGFloat = 130
    var delegate:HRPlanOrderTVCellDelegate!
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
        tempLab.numberOfLines = 2
        return tempLab
    }()
    lazy private var priceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_RED_COLOR
        tempLab.font = HR_PRICE_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    
    lazy var numView:UIView = {
        let tempView = UIView()
        tempView.layer.borderWidth = 1
        tempView.layer.borderColor = HR_LINE_COLOR.cgColor
        
        let subBtn = UIButton(frame: CGRect(x: 0, y: 0, width: handelBtnH, height: handelBtnH))
        subBtn.setTitle("-", for: .normal)
        subBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        subBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        subBtn.addTarget(self, action: #selector(subtractNum), for: .touchUpInside)
        tempView.addSubview(subBtn)
        
        let line1 = UIView(frame: CGRect(x: handelBtnH-1, y: 0, width: 1, height: handelBtnH))
        line1.backgroundColor = HR_LINE_COLOR
        tempView.addSubview(line1)
        
        let numTF = UITextField(frame: CGRect(x: handelBtnH, y: 0, width: handelBtnH*3/2, height: handelBtnH))
        numTF.textAlignment = .center
        numTF.keyboardType = .numberPad
        numTF.font = HR_BOLD_FONT
        numTF.textColor = HR_RED_COLOR
        numTF.text = "1"
        numTF.delegate = self
        numTF.tag = 100
        tempView.addSubview(numTF)
        
        let addBtn = UIButton(frame: CGRect(x: handelBtnH+handelBtnH*3/2, y: 0, width: handelBtnH, height: handelBtnH))
        addBtn.setTitle("+", for: .normal)
        addBtn.setTitleColor(HR_RED_COLOR, for: .normal)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        addBtn.addTarget(self, action: #selector(addNum), for: .touchUpInside)
        tempView.addSubview(addBtn)
        let line2 = UIView(frame: CGRect(x: handelBtnH+handelBtnH*3/2-1, y: 0, width: 1, height: handelBtnH))
        line2.backgroundColor = HR_LINE_COLOR
        tempView.addSubview(line2)
        
        return tempView
    }()
    var goodNum:Int = 1
    var goodInvNum:Int = 1
    //MARK:减少
    func subtractNum(){
        if self.goodNum > 1 {
            self.goodNum -= 1
            let textField = self.numView.viewWithTag(100) as!  UITextField
            textField.text = "\(self.goodNum)"
            if self.delegate != nil {
                self.delegate.editCount(num: self.goodNum)
            }
        }else{
            self.noticeOnlyText("不能再少了")
        }
    }
    //MARK:增加
    func addNum(){
        if self.goodNum < self.goodInvNum {
            self.goodNum += 1
            let textField = self.numView.viewWithTag(100) as!  UITextField
            textField.text = "\(self.goodNum)"
            if self.delegate != nil {
                self.delegate.editCount(num: self.goodNum)
            }
        }else{
            self.noticeOnlyText("超出库存了")
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        
        self.bodyView.addSubview(self.iconIV)
        self.bodyView.addSubview(self.titleLab)
        self.bodyView.addSubview(self.priceLab)
        self.bodyView.addSubview(self.numView)
        
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
        self.priceLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(self.iconIV.snp.right).offset(5)
            make.width.equalTo((HR_SCREEN_WIDTH-HR_MARGIN*3)/2)
            make.height.equalTo(35)
        }
        self.numView.snp.makeConstraints { (make) in
            make.bottom.right.equalTo(0)
            make.width.equalTo(handelBtnH*3+handelBtnH/2)
            make.height.equalTo(handelBtnH)
        }
    }
    
    func setInfo(info:HRGoodInfoModel){
        let textField = self.numView.viewWithTag(100) as!  UITextField
        textField.text = "\(info.selectCount)"
        self.goodNum = info.selectCount
        self.goodInvNum = StringToInt(str: info.inventory)
        self.iconIV.hr_setImage(name: EmptyCheck(str: info.icon))
        self.titleLab.text = EmptyCheck(str: info.title)
        let titleSize = calculateMoreLineStringSize(str: EmptyCheck(str: info.title), font: HR_BOLD_FONT, maxSize: CGSize(width: HR_SCREEN_WIDTH-iconW-HR_MARGIN*2, height: HR_SCREEN_HEIGHT))
        if titleSize.height > labH {
            self.titleLab.snp.updateConstraints { (make) in
                make.height.equalTo(labH*2)
            }
        }else{
            self.titleLab.snp.updateConstraints { (make) in
                make.height.equalTo(labH)
            }
        }
        
        let priceStr = "\(EmptyCheck(str: info.price))元"
        let attriStr = NSMutableAttributedString(string: priceStr)
        attriStr.addAttribute(NSFontAttributeName, value: HR_SMALL_FONT, range: NSRange(location: priceStr.characters.count-1, length: 1))
        self.priceLab.attributedText = attriStr
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
