//
//  HRRegisterVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit

class HRRegisterVC: HRBaseVC,UITextFieldDelegate {

    private var isSelect = false
    private var timer:Timer!
    private var second:Int = 60
    deinit {
        if self.timer != nil {
            self.timer?.invalidate()
        }
    }
    lazy private var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.text = "注册"
        tempLab.textAlignment = .left
        tempLab.font = UIFont.boldSystemFont(ofSize: 30)
        tempLab.textColor = HR_BLACK_COLOR
        return tempLab
    }()
    lazy private var phoneTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.placeholder = "请输入您的手机号"
        tempTF.keyboardType = .numberPad
        tempTF.returnKeyType = .next
        tempTF.delegate = self
        let lineView = UIView(frame: CGRect(x: 0, y: inputH-1, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        tempTF.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        return tempTF
    }()
    lazy private var codeTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.placeholder = "请输入短信验证码"
        tempTF.keyboardType = .numberPad
        tempTF.returnKeyType = .done
        tempTF.delegate = self
        
        let lineView = UIView(frame: CGRect(x: 0, y: inputH-1, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        tempTF.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        return tempTF
    }()
    lazy private var loginBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("下一步", for: .normal)
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setBackgroundImage(UIImage(named:"disable_bg"), for: .normal)
        tempBtn.isEnabled = false
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.titleLabel?.textColor = HR_WHITE_COLOR
        tempBtn.layer.cornerRadius = inputH/2
        tempBtn.layer.masksToBounds = true
        tempBtn.layer.rasterizationScale = UIScreen.main.scale
        tempBtn.layer.shouldRasterize = true
        tempBtn.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return tempBtn
    }()
    lazy private var getCodeBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("获取验证码", for: .normal)
        tempBtn.titleLabel?.font = HR_NORMAL_FONT
        tempBtn.setTitleColor(HR_THEME_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        
        let lineView = UIView(frame: CGRect(x: 0, y: inputH/4, width: 1, height: inputH/2))
        lineView.backgroundColor = HR_LINE_COLOR
        tempBtn.addSubview(lineView)
        return tempBtn
    }()
    lazy private var selectBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage(named:"select_no"), for: .normal)
        tempBtn.setImage(UIImage(named:"select_yes"), for: .selected)
        tempBtn.addTarget(self, action: #selector(selectProtocol), for: .touchUpInside)
        return tempBtn
    }()
    lazy private var protocolLab:UILabel = {
        let tempLab = UILabel()
        tempLab.text = "       您已阅读并同意《鸿福家园用户注册协议》"
        tempLab.textAlignment = .left
        tempLab.font = HR_SMALL_FONT
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(showProtocol))
        tempLab.addGestureRecognizer(tap)
        return tempLab
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTitle(title: "")
        self.view.backgroundColor = HR_WHITE_COLOR
        
        // Do any additional setup after loading the view.
        self.setUI()
        self.navigationController?.navigationBar.hideBottomHairline()
    }
    //MARK:设置UI
    func setUI(){
        self.view.addSubview(self.titleLab)
        self.view.addSubview(self.phoneTF)
        self.view.addSubview(self.codeTF)
        self.codeTF.addSubview(self.getCodeBtn)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.protocolLab)
        self.protocolLab.addSubview(self.selectBtn)
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(74)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(60)
        }
        self.phoneTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.codeTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneTF.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.codeTF.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.getCodeBtn.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(100)
        }
        self.protocolLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginBtn.snp.bottom)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(30)
        }
        self.selectBtn.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(0)
            make.width.equalTo(30)
        }
    }
    
    //MARK:
    func nextStep(){
//        if !PhoneNumberIsValidated(vStr: self.phoneTF.text!) {
//            self.noticeOnlyText("请输入正确的手机号码")
//            return
//        }
//        if (self.codeTF.text?.characters.count)! < 4 {
//            self.noticeOnlyText("请输入正确的验证码")
//            return
//        }
        let VC = HRPerfectInfoVC()
        VC.curPhone = self.phoneTF.text!
        VC.curCode = self.codeTF.text!
        VC.curType = 0
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK:获取验证码
    func getCode(btn:UIButton){
        print("获取验证码")
        if !PhoneNumberIsValidated(vStr: self.phoneTF.text!) {
            self.noticeOnlyText("请输入正确的手机号码")
            return
        }
        var param:[String:String] = [:]
        param["phone"] = self.phoneTF.text!
        param["type"] = "1"
        HRNetwork.shared.hr_getData(cmd: "getCode", params: param, success: { (result) in
            self.second = 60
            self.getCodeBtn.isEnabled = false
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.keepTime), userInfo: nil, repeats: true)
            }) { (error) in
        }
    }
    
    //计时
    func keepTime(){
        second -= 1
        if second == 0 {
            getCodeBtn.setTitle("获取验证码", for: .normal)
            self.getCodeBtn.isEnabled = true
            timer?.invalidate()
        }else{
            getCodeBtn.setTitle(String(format:"%d s",second), for: .normal)
        }
    }
    //MARK:选择协议
    func selectProtocol(){
        self.selectBtn.isSelected = !self.selectBtn.isSelected
        self.isSelect = self.selectBtn.isSelected
        self.changeValue()
    }
    
    //MARK:查看协议
    func showProtocol(){
        print("查看协议")
        self.navigationController?.pushViewController(HRShowHtmlVC(), animated: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) ->Bool {
        let currentStr = String(format:"%@%@",textField.text!,string)
        if textField == phoneTF{
            if currentStr.characters.count > 11 {
                return false
            }
        }else {
            if currentStr.characters.count > 6 {
                return false
            }
        }
        return true
    }
    func changeValue(){
        if PhoneNumberIsValidated(vStr: self.phoneTF.text!) && (self.codeTF.text?.characters.count)! > 3 && self.isSelect {
            self.loginBtn.isEnabled = true
            self.loginBtn.setBackgroundImage(UIImage(named:"login_btn_bg"), for: .normal)
        }else{
            self.loginBtn.isEnabled = false
            self.loginBtn.setBackgroundImage(UIImage(named:"disable_bg"), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
