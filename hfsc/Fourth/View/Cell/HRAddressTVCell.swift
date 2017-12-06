//
//  HRAddressTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/22.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

protocol HRAddressTVCellDelegate:NSObjectProtocol {
    func delAddress(cell:HRAddressTVCell)
    func editAddress(cell:HRAddressTVCell)
    func setDefault(btn:UIButton,cell:HRAddressTVCell)
}

class HRAddressTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    weak var delegate:HRAddressTVCellDelegate!
    var labH:CGFloat = 20
    var btnW:CGFloat = 65
    lazy var topView:UIView = {
        let tempView = UIView()
        
        let lineView = UIView(frame: CGRect(x: 0, y: HR_TOP_HEIGHT-1, width: HR_SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempView.addSubview(lineView)
        return tempView
    }()
    lazy private var chooseBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle(" 设为默认", for: .normal)
        tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        tempBtn.setImage(UIImage(named:"default_no"), for: .normal)

        tempBtn.setTitle(" 默认地址", for: .selected)
        tempBtn.setTitleColor(HR_BLUE_COLOR, for: .selected)
        tempBtn.setImage(UIImage(named:"sex_yes"), for: .selected)
    
        tempBtn.titleLabel?.font = HR_NORMAL_FONT
        tempBtn.addTarget(self, action: #selector(chooseDefault), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:选择默认地址
    func chooseDefault(){
        if self.delegate != nil {
            self.delegate.setDefault(btn: self.chooseBtn, cell: self)
        }
    }
    
    lazy private var editBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle(" 编辑", for: .normal)
        tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        tempBtn.setImage(UIImage(named:"edit_icon"), for: .normal)
        
        tempBtn.titleLabel?.font = HR_SMALL_FONT
        tempBtn.addTarget(self, action: #selector(editAddress), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:编辑地址
    func editAddress(){
        if self.delegate != nil {
            self.delegate.editAddress(cell: self)
        }
    }
    
    lazy private var deleteBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle(" 删除", for: .normal)
        tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        tempBtn.setImage(UIImage(named:"delete_icon"), for: .normal)
        
        tempBtn.titleLabel?.font = HR_SMALL_FONT
        tempBtn.addTarget(self, action: #selector(delAddress), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:删除地址
    func delAddress(){
        if self.delegate != nil {
            self.delegate.delAddress(cell: self)
        }
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
        self.contentView.addSubview(self.topView)
        self.topView.addSubview(self.chooseBtn)
        self.topView.addSubview(self.editBtn)
        self.topView.addSubview(self.deleteBtn)
        
        self.contentView.addSubview(self.bodyView)
        self.bodyView.addSubview(self.nameLab)
        self.bodyView.addSubview(self.addressLab)
        
        self.topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(HR_TOP_HEIGHT)
        }
        self.chooseBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(100)
        }
        self.editBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-btnW)
            make.width.equalTo(btnW)
        }
        self.deleteBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(0)
            make.width.equalTo(btnW)
        }
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.bottom.equalTo(0)
            make.right.equalTo(-HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
        }
        self.nameLab.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(labH*2)
        }
        self.addressLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.left.right.equalTo(0)
            make.height.equalTo(labH*2)
        }
    }
    
    func setInfo(info:HRAddressInfoModel){
        if StringToInt(str: info.isDefault) == 1 {
            self.chooseBtn.isSelected = true
        }else{
            self.chooseBtn.isSelected = false
        }
        self.nameLab.text = "\(EmptyCheck(str: info.name))       \(EmptyCheck(str: info.phone))"
        self.addressLab.text = "\(EmptyCheck(str: info.areaDetail))\(EmptyCheck(str: info.address))"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
