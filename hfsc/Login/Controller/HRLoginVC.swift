//
//  HRLoginVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

var inputH:CGFloat = 45

class HRLoginVC: HRBaseVC,UITextFieldDelegate {
    
    var imgH:CGFloat = 160
    lazy private var titleLab:UILabel = {
       let tempLab = UILabel()
        tempLab.text = "登录"
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
    lazy private var pwdTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.placeholder = "请输入密码"
        tempTF.keyboardType = .numbersAndPunctuation
        tempTF.returnKeyType = .done
        tempTF.isSecureTextEntry = true
        tempTF.delegate = self
        
        let lineView = UIView(frame: CGRect(x: 0, y: inputH-1, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        tempTF.addTarget(self, action: #selector(changeValue), for: .editingChanged)
        return tempTF
    }()
    lazy private var loginBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("登录", for: .normal)
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setBackgroundImage(UIImage(named:"disable_bg"), for: .normal)
        tempBtn.isEnabled = false
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.titleLabel?.textColor = HR_WHITE_COLOR
        tempBtn.layer.cornerRadius = inputH/2
        tempBtn.layer.masksToBounds = true
        tempBtn.layer.rasterizationScale = UIScreen.main.scale
        tempBtn.layer.shouldRasterize = true
        tempBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        return tempBtn
    }()
    lazy private var forgetBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("忘记密码", for: .normal)
        tempBtn.titleLabel?.font = HR_NORMAL_FONT
        tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(forgetPwd), for: .touchUpInside)
        return tempBtn
    }()
    lazy private var registerBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("注册", for: .normal)
        tempBtn.titleLabel?.font = HR_NORMAL_FONT
        tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        return tempBtn
    }()
    
    lazy private var otherLab:UILabel = {
        let tempLab = UILabel()
        tempLab.text = "其他登录"
        tempLab.textAlignment = .center
        tempLab.font = HR_SMALL_FONT
        tempLab.textColor = HR_GRAY_COLOR
        return tempLab
    }()
    lazy private var qqLoginBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage(named:"login_qq"), for: .normal)
        tempBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        tempBtn.tag = 11;
        tempBtn.addTarget(self, action: #selector(thirdLogin(btn:)), for: .touchUpInside)
        return tempBtn
    }()
    lazy private var wxLoginBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage(named:"login_wx"), for: .normal)
        tempBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        tempBtn.tag = 12;
        tempBtn.addTarget(self, action: #selector(thirdLogin(btn:)), for: .touchUpInside)
        return tempBtn
    }()
    lazy private var wbLoginBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage(named:"login_wb"), for: .normal)
        tempBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        tempBtn.tag = 13;
        tempBtn.addTarget(self, action: #selector(thirdLogin(btn:)), for: .touchUpInside)
        return tempBtn
    }()
    lazy private var footBgView:UIImageView = {
        let tempBtn = UIImageView()
        tempBtn.image = UIImage(named: "login_bg")
        tempBtn.contentMode = .scaleAspectFill
        return tempBtn
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
        self.view.addSubview(self.pwdTF)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.registerBtn)
        self.view.addSubview(self.forgetBtn)
        self.view.addSubview(self.otherLab)
        self.view.addSubview(self.qqLoginBtn)
        self.view.addSubview(self.wxLoginBtn)
        self.view.addSubview(self.wbLoginBtn)
        self.view.addSubview(self.footBgView)
        
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
        self.pwdTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneTF.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.pwdTF.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginBtn.snp.bottom)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        self.forgetBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginBtn.snp.bottom)
            make.right.equalTo(-HR_MARGIN)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        self.otherLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(-imgH-inputH-40)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(30)
        }
        self.qqLoginBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-imgH-inputH)
            make.left.equalTo((HR_SCREEN_WIDTH/3-inputH)/2)
            make.width.equalTo(inputH)
            make.height.equalTo(inputH)
        }
        self.wxLoginBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-imgH-inputH)
            make.left.equalTo((HR_SCREEN_WIDTH/3-inputH)/2+HR_SCREEN_WIDTH/3)
            make.width.equalTo(inputH)
            make.height.equalTo(inputH)
        }
        self.wbLoginBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-imgH-inputH)
            make.left.equalTo((HR_SCREEN_WIDTH/3-inputH)/2+HR_SCREEN_WIDTH/3*2)
            make.width.equalTo(inputH)
            make.height.equalTo(inputH)
        }
        self.footBgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(imgH)
        }
    }
    
    //MARK:登录
    func login(){
        var param:[String:String] = [:]
        param["phone"] = self.phoneTF.text!
        param["password"] = self.pwdTF.text!
        HRNetwork.shared.hr_getData(cmd: "login", params: param, success: { (result) in
            let body:JSON = result["body"]
            if body != nil{
                HRDataSave.hr_saveUserid(userid: body["userid"].stringValue)
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }) { (error) in
        }
    }
    //MARK:注册
    func register(){
        self.navigationController?.pushViewController(HRRegisterVC(), animated: true)
    }
    //MARK:忘记密码
    func forgetPwd(){
        self.navigationController?.pushViewController(HRForgetPwdVC(), animated: true)
    }
    //MARK:第三方登录
    func thirdLogin(btn:UIButton){
        //1：qq,2：微信，3：微博，
        var platform:UMSocialPlatformType = UMSocialPlatformType.QQ
        let tag = btn.tag-10
        if tag == 1{
            platform = UMSocialPlatformType.QQ
        }else if tag == 2{
            platform = UMSocialPlatformType.wechatSession
        }else {
            platform = UMSocialPlatformType.sina
        }
        HRThirdPartyManager.loginToPlatform(platform: platform) { (name, openID, poster) in
            var param:[String:String] = [:]
            param["type"] = "\(tag-1)"
            param["openid"] = openID
            param["nickname"] = name
            param["avatar"] = poster
            param["sex"] = "1"
            HRNetwork.shared.hr_getData(cmd: "thirdLogin", params: param, success: { (result) in
                if result["body"]["isUser"].intValue != 1{
                    //是用户
                    HRDataSave.hr_saveUserid(userid: result["body"]["userid"].stringValue)
                    self.goBackPop()
                }else{
                    //不是用户
                    let VC = HRBindPhoneVC()
                    let info = HRThirdPlatformInfo()
                    info.nickname = name
                    info.openid = openID
                    info.sex = "1"
                    info.avatar = poster
                    info.type = "\(tag-1)"
                    VC.platformInfo = info
                    self.navigationController?.pushViewController(VC, animated: true)
                }
                }, failure: { (error) in
                    
            })
        }
        
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
            if currentStr.characters.count > 18 {
                return false
            }
        }
        return true
    }
    func changeValue(){
        if PhoneNumberIsValidated(vStr: self.phoneTF.text!) && (self.pwdTF.text?.characters.count)! > 5 {
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
}
