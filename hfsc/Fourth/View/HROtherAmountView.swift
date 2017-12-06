//
//  HROtherAmountView.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HROtherAmountView: UIView,UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var btnW:CGFloat = 60
    var bodyBot:CGFloat = 0
    typealias BLOCK = (String)->()
    var block:BLOCK?
    
    func callBack(block:@escaping BLOCK){
        self.block = block
    }
    static let shared = HROtherAmountView.init()
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT))
        self.setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var bodyView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_WHITE_COLOR
        return tempView
    }()
    lazy var inputTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_BIG_FONT
        tempTF.textAlignment = .center
        tempTF.delegate = self
        tempTF.keyboardType = .numberPad
        
        let leftLab = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 35))
        leftLab.text = "￥"
        leftLab.textColor = HR_BLACK_COLOR
        leftLab.font = HR_NORMAL_FONT
        tempTF.leftViewMode = .always
        tempTF.leftView = leftLab
        tempTF.placeholder = "请输入需要充值的金额"
        
        let lineView = UIView(frame: CGRect(x: 0, y: 34, width: HR_SCREEN_WIDTH-60*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        return tempTF
    }()
    
    lazy var cancelBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("取消", for: .normal)
        tempBtn.setTitleColor(HR_BLUE_COLOR, for: .normal)
        tempBtn.titleLabel?.font = HR_NORMAL_FONT
        tempBtn.addTarget(self, action: #selector(closePop), for: .touchUpInside)
        return tempBtn
    }()
    func closePop(){
        self.inputTF.resignFirstResponder()
        self.isHidden = true
    }
    
    lazy var sureBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("确定", for: .normal)
        tempBtn.setTitleColor(HR_BLUE_COLOR, for: .normal)
        tempBtn.titleLabel?.font = HR_NORMAL_FONT
        tempBtn.addTarget(self, action: #selector(confirmAmount), for: .touchUpInside)
        return tempBtn
    }()
    func confirmAmount(){
        self.inputTF.resignFirstResponder()
        self.isHidden = true
        if StringToInt(str: self.inputTF.text) > 0 {
            if let block = self.block {
                block(self.inputTF.text!)
            }
        }else{
            self.noticeOnlyText("请输入大于0的金额")
        }
    }
    
    func setUI(){
        self.backgroundColor = HR_BLACK_COLOR.withAlphaComponent(0.3)
        self.addSubview(self.bodyView)
//        self.bodyView.snp.makeConstraints { (make) in
//            make.left.right.equalTo(0)
//            make.height.equalTo(100)
//            make.bottom.equalTo(-bodyBot)
//        }
        self.bodyView.frame = CGRect(x: 0, y: self.frame.height-100-bodyBot, width: HR_SCREEN_WIDTH, height: 100)
        self.bodyView.addSubview(self.cancelBtn)
        self.cancelBtn.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.equalTo(btnW)
            make.height.equalTo(HR_TOP_HEIGHT)
        }
        
        self.bodyView.addSubview(self.sureBtn)
        self.sureBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.equalTo(btnW)
            make.height.equalTo(HR_TOP_HEIGHT)
        }
        self.bodyView.addSubview(self.inputTF)
        self.inputTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancelBtn.snp.bottom)
            make.left.equalTo(btnW)
            make.right.equalTo(-btnW)
            make.height.equalTo(35)
        }
        UIApplication.shared.keyWindow?.addSubview(self)
        HR_NOTIFICATION.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        HR_NOTIFICATION.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //MARK:显示键盘
    func keyboardShow(_ notification:NSNotification){
        let info = notification.userInfo
        //键盘高度
        let keyboardH = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        self.bodyBot = keyboardH
        //弹出时间
        let duration = info?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        self.setNeedsUpdateConstraints()
        UIView.animate(withDuration: duration) {
            self.bodyView.frame = CGRect(x: 0, y: self.frame.height-100-self.bodyBot, width: HR_SCREEN_WIDTH, height: 100)
        }
    }
    //MARK:隐藏键盘
    func keyboardHide(_ notification:NSNotification){
        self.bodyBot = 0
        self.bodyView.frame = CGRect(x: 0, y: self.frame.height-100-self.bodyBot, width: HR_SCREEN_WIDTH, height: 100)
    }
    deinit {
        HR_NOTIFICATION.removeObserver(self)
    }
    
    func show(){
        self.isHidden = false
        self.inputTF.becomeFirstResponder()
    }

}
