//
//  HRGoodDetailHeaderView.swift
//  hfsc
//
//  Created by innket on 17/11/20.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

let handelBtnH:CGFloat = 30

class HRGoodDetailHeaderView: UIView,HRBannerViewDelegate,UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bannerView:HRBannerView = {
        let view = HRBannerView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_WIDTH*HR_IMAGE_SCALE))
        view.delegate = self
        return view
    }()
    func tapImage(index: Int) {
        
    }
    
    lazy var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_BOLD_FONT
        tempLab.textAlignment = .left
        tempLab.numberOfLines = 0
        return tempLab
    }()
    lazy var priceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_RED_COLOR
        tempLab.font = HR_PRICE_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    lazy var oldPriceLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    
    lazy var countLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    
    lazy var reviewLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .center
        return tempLab
    }()
    
    lazy var inventoryLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .right
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
        }else{
            self.noticeOnlyText("超出库存了")
        }
    }
    
    private func setUI(){
        self.backgroundColor = HR_WHITE_COLOR
        self.addSubview(self.bannerView)
        self.addSubview(self.titleLab)
        self.addSubview(self.priceLab)
        self.addSubview(self.oldPriceLab)
        self.addSubview(self.countLab)
        self.addSubview(self.reviewLab)
        self.addSubview(self.inventoryLab)
        self.addSubview(self.numView)
        
        self.bannerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(HR_SCREEN_WIDTH*HR_IMAGE_SCALE)
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH-HR_MARGIN*2)
            make.top.equalTo(self.bannerView.snp.bottom)
            make.height.equalTo(25)
        }
        self.priceLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.height.equalTo(30)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH-HR_MARGIN*2)
        }
        self.oldPriceLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceLab.snp.bottom)
            make.height.equalTo(handelBtnH)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(20)
        }
        self.numView.snp.makeConstraints { (make) in
            make.top.equalTo(self.priceLab.snp.bottom).offset(-10)
            make.height.equalTo(handelBtnH)
            make.right.equalTo(-HR_MARGIN)
            make.width.equalTo(handelBtnH*3+handelBtnH/2)
        }
        self.countLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.oldPriceLab.snp.bottom)
            make.height.equalTo(20)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/3)
        }
        self.reviewLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.oldPriceLab.snp.bottom)
            make.height.equalTo(20)
            make.left.equalTo(HR_SCREEN_WIDTH/3)
            make.width.equalTo(HR_SCREEN_WIDTH/3)
        }
        self.inventoryLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.oldPriceLab.snp.bottom)
            make.height.equalTo(20)
            make.right.equalTo(-HR_MARGIN)
            make.width.equalTo(HR_SCREEN_WIDTH/3)
        }
        
    }
    
    
    func setInfo(info:HRGoodInfoModel){
        self.goodInvNum = StringToInt(str: info.inventory)
        if EmptyCheck(str: info.icon).characters.count >= 0 {
            let iconArr = EmptyCheck(str: info.icon).components(separatedBy: "|")
            self.bannerView.setImages(imgArr: iconArr)
        }
        self.countLab.text = "销量:\(EmptyCheck(str: info.count))"
        self.reviewLab.text = "好评:\(EmptyCheck(str: info.review))%"
        self.inventoryLab.text = "库存:\(EmptyCheck(str: info.inventory))"
        
        let titleStr = "\(EmptyCheck(str: info.title))"
        let titleSize = calculateMoreLineStringSize(str: titleStr, font: HR_BOLD_FONT, maxSize: CGSize(width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_SCREEN_HEIGHT))
        self.titleLab.snp.updateConstraints { (make) in
            make.height.equalTo(titleSize.height+HR_MARGIN)
        }
        self.titleLab.text = titleStr
        
        let priceStr = "\(EmptyCheck(str: info.price))元"
        let attriStr = NSMutableAttributedString(string: priceStr)
        attriStr.addAttribute(NSFontAttributeName, value: HR_NORMAL_FONT, range: NSRange(location: priceStr.characters.count-1, length: 1))
        self.priceLab.attributedText = attriStr
        
        let oldStr = "市场价：￥\(EmptyCheck(str: info.oriPrice))"
        let attrStr:NSMutableAttributedString = NSMutableAttributedString(string: oldStr)
        attrStr.addAttribute(NSStrikethroughStyleAttributeName, value: NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue), range: NSRange(location: 0,length:oldStr.characters.count))
        attrStr.addAttribute(NSBaselineOffsetAttributeName, value:0 , range: NSRange(location: 0,length:oldStr.characters.count))
        let priceSize:CGSize = calculateOneLineStringSize(str: oldStr, font: HR_SMALL_FONT)
        self.oldPriceLab.snp.updateConstraints { (make) in
            make.width.equalTo(priceSize.width+HR_MARGIN+10)
        }
        self.oldPriceLab.attributedText = attrStr
    }
}
