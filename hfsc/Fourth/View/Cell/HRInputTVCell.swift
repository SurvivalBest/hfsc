//
//  HRInputTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

protocol HRInputTVCellDelegate:NSObjectProtocol {
    func inputValueChanged(value:String,cell:HRInputTVCell)
}

class HRInputTVCell: UITableViewCell,UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var type = 0 //0:正常输入框，1:密码输入框，2:手机号码输入框
    weak var delegate:HRInputTVCellDelegate!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    lazy var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.textAlignment = .center
        tempLab.font = HR_NORMAL_FONT
        return tempLab
    }()
    
    lazy var inputTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.textAlignment = .left
        tempTF.delegate = self
        tempTF.leftViewMode = .always
        tempTF.keyboardType = .default
        tempTF.returnKeyType = .done
        tempTF.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
        return tempTF
    }()
    
    //MARK:改变输入内容
    func valueChanged(){
        if self.delegate != nil {
            self.delegate.inputValueChanged(value: self.inputTF.text!, cell: self)
        }
    }
    
    private func setUI(){
        self.contentView.addSubview(self.inputTF)
        self.inputTF.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
        }
        if self.type == 1 {
            self.inputTF.keyboardType = .numbersAndPunctuation
        }else if self.type == 2{
            self.inputTF.keyboardType = .numberPad
        }
    }
    
    func setTitleAndPlaceholder(title:String,placeholder:String){
        self.inputTF.placeholder = placeholder
        self.titleLab.text = title
        let titleSize = calculateOneLineStringSize(str: title, font: HR_NORMAL_FONT)
        self.titleLab.frame = CGRect(x: 0, y: 0, width: titleSize.width+5, height: 45)
        self.inputTF.leftView = self.titleLab
    }

    func setNowText(text:String){
        self.inputTF.text = text
    }
    func setKeyboardType(type:UIKeyboardType){
        self.inputTF.keyboardType = type
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) ->Bool {
        let currentStr = String(format:"%@%@",textField.text!,string)
        if self.type == 1 {
            if !string.isLetterAndNumber{
                return false
            }
            if currentStr.characters.count > 16 {
                return false
            }
        }else if self.type == 2{
            if currentStr.characters.count > 11 {
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
