//
//  HRPerfectInfoVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit
var iconH:CGFloat = 60
var InputTitleH:CGFloat = 70
var sexChooseBtn:UIButton!
class HRPerfectInfoVC: HRBaseVC,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    public var platformInfo = HRThirdPlatformInfo()
    var curPhone = ""
    var curCode = ""
    var curType = 0 //0：注册，1：第三方登录
    var platformType = "" //0：QQ，1：微信，2：微博
    var sexTag:Int = 0
    var userAvatar = ""
    lazy private var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.text = "完善资料和密码"
        tempLab.textAlignment = .left
        tempLab.font = UIFont.boldSystemFont(ofSize: 30)
        tempLab.textColor = HR_BLACK_COLOR
        return tempLab
    }()
    lazy var photoPicker:UIImagePickerController = {
        let tempPP = UIImagePickerController()
        tempPP.delegate = self
        tempPP.allowsEditing = true
        return tempPP
    }()
    lazy private var avatarIV:UIImageView = {
        let tempIV = UIImageView(frame: CGRect(x: 0, y: 0, width: iconH, height: iconH))
        tempIV.layer.cornerRadius = iconH/2
        tempIV.layer.masksToBounds = true
        tempIV.layer.shouldRasterize = true
        tempIV.layer.rasterizationScale = UIScreen.main.scale
        tempIV.contentMode = .scaleAspectFill
        tempIV.image = UIImage(named:"default_avatar")
        tempIV.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseIcon))
        tempIV.addGestureRecognizer(tap)
        return tempIV
    }()
    lazy private var notiLab:UILabel = {
        let tempLab = UILabel()
        tempLab.text = "请上传头像"
        tempLab.textAlignment = .left
        tempLab.font = HR_NORMAL_FONT
        tempLab.textColor = HR_GRAY_COLOR
        return tempLab
    }()
    lazy private var nameTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.placeholder = "昵称长度2-18个字符，支持中英文、数字"
        tempTF.keyboardType = .default
        tempTF.returnKeyType = .next
        tempTF.delegate = self
        
        let leftLab = UILabel(frame: CGRect(x: 0, y: 0, width: InputTitleH, height: inputH))
        leftLab.text = "昵称："
        leftLab.textColor = HR_BLACK_COLOR
        leftLab.font = HR_BIG_FONT
        tempTF.leftView = leftLab
        tempTF.leftViewMode = .always
        
        let lineView = UIView(frame: CGRect(x: 0, y: inputH-1, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        tempTF.addTarget(self, action: #selector(changeValue(_:)), for: .editingChanged)
        return tempTF
    }()
    lazy private var sexTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.keyboardType = .numberPad
        tempTF.returnKeyType = .next
        tempTF.delegate = self
        
        let leftLab = UILabel(frame: CGRect(x: 0, y: 0, width: InputTitleH, height: inputH))
        leftLab.text = "性别："
        leftLab.textColor = HR_BLACK_COLOR
        leftLab.font = HR_BIG_FONT
        leftLab.isUserInteractionEnabled = true
        tempTF.leftView = leftLab
        tempTF.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: InputTitleH, y: 0, width: HR_SCREEN_WIDTH-HR_MARGIN*2-InputTitleH, height: inputH))
        rightView.isUserInteractionEnabled = true
        tempTF.rightView = rightView
        tempTF.rightViewMode = .always
        
        let iconArr = ["man_icon","woman_icon"];
        let nameArr = ["男","女"]
        let sexH:CGFloat = 35
        let contH:CGFloat = 90
        for i in 0..<2 {
            let contView = UIView(frame: CGRect(x: (contH+20)*CGFloat(i), y: 0, width: contH, height: inputH))
            let sexImg = UIButton(frame: CGRect(x: 0, y: (inputH-sexH)/2, width: sexH, height: sexH))
            sexImg.setImage(UIImage(named:iconArr[i]), for: .normal)
            sexImg.setImage(UIImage(named:iconArr[i]), for: .selected)
            contView.addSubview(sexImg)
            
            let tagLab = UILabel(frame: CGRect(x: sexImg.frame.maxX, y: 0, width: contH-sexH*2+(inputH-sexH)/2, height: inputH))
            tagLab.text = nameArr[i]
            tagLab.textColor = HR_GRAY_COLOR
            tagLab.font = HR_NORMAL_FONT
            tagLab.textAlignment = .center
            contView.addSubview(tagLab)
            
            let chooseBtn = UIButton(frame: CGRect(x: tagLab.frame.maxX, y: (inputH-sexH)/2, width: sexH, height: sexH))
            chooseBtn.setImage(UIImage(named:"sex_no"), for: .normal)
            chooseBtn.setImage(UIImage(named:"sex_yes"), for: .selected)
            chooseBtn.addTarget(self, action: #selector(chooseSex(btn:)), for: .touchUpInside)
            chooseBtn.tag = 10 + i
            if i == 0 {
                chooseBtn.isSelected = true
                sexChooseBtn = chooseBtn
            }
            contView.addSubview(chooseBtn)
            
            rightView.addSubview(contView)
        }
        
        
        let lineView = UIView(frame: CGRect(x: 0, y: inputH-1, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        return tempTF
    }()
    lazy private var pwdTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.placeholder = "请设置6-18位密码"
        tempTF.keyboardType = .numbersAndPunctuation
        tempTF.returnKeyType = .next
        tempTF.isSecureTextEntry = true
        tempTF.delegate = self
        
        let leftLab = UILabel(frame: CGRect(x: 0, y: 0, width: InputTitleH, height: inputH))
        leftLab.text = "新密码："
        leftLab.textColor = HR_BLACK_COLOR
        leftLab.font = HR_BIG_FONT
        tempTF.leftView = leftLab
        tempTF.leftViewMode = .always
        
        let lineView = UIView(frame: CGRect(x: 0, y: inputH-1, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        tempTF.addTarget(self, action: #selector(changeValue(_:)), for: .editingChanged)
        return tempTF
    }()
    lazy private var inviteTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.placeholder = "可不填"
        tempTF.keyboardType = .numbersAndPunctuation
        tempTF.returnKeyType = .done
        tempTF.delegate = self
        
        let leftLab = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: inputH))
        leftLab.text = "邀请码(选填)："
        leftLab.textColor = HR_BLACK_COLOR
        leftLab.font = HR_BIG_FONT
        tempTF.leftView = leftLab
        tempTF.leftViewMode = .always
        
        let lineView = UIView(frame: CGRect(x: 0, y: inputH-1, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempTF.addSubview(lineView)
        return tempTF
    }()
    lazy private var loginBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("完成注册", for: .normal)
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setBackgroundImage(UIImage(named:"disable_bg"), for: .normal)
        tempBtn.isEnabled = false
//        tempBtn.setBackgroundImage(UIImage(named:"login_btn_bg"), for: .normal)
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.titleLabel?.textColor = HR_WHITE_COLOR
        tempBtn.layer.cornerRadius = inputH/2
        tempBtn.layer.masksToBounds = true
        tempBtn.layer.rasterizationScale = UIScreen.main.scale
        tempBtn.layer.shouldRasterize = true
        tempBtn.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
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
        self.view.addSubview(self.avatarIV)
        self.view.addSubview(self.notiLab)
        self.view.addSubview(self.nameTF)
        self.view.addSubview(self.sexTF)
        self.view.addSubview(self.pwdTF)
        self.view.addSubview(self.inviteTF)
        self.view.addSubview(self.loginBtn)
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(74)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(60)
        }
        self.avatarIV.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(HR_MARGIN)
            make.width.equalTo(iconH)
            make.height.equalTo(iconH)
        }
        self.notiLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom)
            make.left.equalTo(self.avatarIV.snp.right).offset(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(iconH)
        }
        self.nameTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.avatarIV.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.sexTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameTF.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.pwdTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.sexTF.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.inviteTF.snp.makeConstraints { (make) in
            make.top.equalTo(self.pwdTF.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        self.loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.inviteTF.snp.bottom).offset(HR_MAX_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        }
        if self.curType == 1{
            self.nameTF.text = self.platformInfo.nickname
            self.avatarIV.hr_setImage(name: EmptyCheck(str: self.platformInfo.avatar))
            
        }
    }
    
    //MARK:
    func nextStep(){
        
        var param:[String:String] = [:]
        param["phone"] = self.curPhone
        param["code"] = self.curCode
        param["password"] = self.pwdTF.text!
        param["avatar"] = self.userAvatar
        param["nickname"] = self.nameTF.text!
        param["sex"] = "\(self.sexTag)"
        param["inviteCode"] = self.inviteTF.text!
        var cmd = ""
        if curType == 0 {
            cmd = "register"
        }else{
            param["type"] = "\(self.platformType)"
            param["opendid"] = self.platformInfo.openid
            cmd = "bindPhone"
        }
        HRNetwork.shared.hr_getData(cmd: cmd, params: param, success: { (result) in
            if self.curType == 1{
                HRDataSave.hr_saveUserid(userid: result["body"]["userid"].stringValue)
            }
            let vcArr = self.navigationController?.viewControllers
            if (vcArr?.count)! > 2+self.curType{
                let VC = vcArr?[(vcArr?.count)!-3-self.curType]
                let _ = self.navigationController?.popToViewController(VC!, animated: true)
            }else{
                let _ = self.navigationController?.popViewController(animated: true)
            }
        }) { (error) in
        }
        
    }
    //MARK:选择头像
    func chooseIcon(){
        let actionSheet = UIAlertController(title: "选择头像", message: nil, preferredStyle: .actionSheet)
        let firstAction = UIAlertAction(title: "拍照", style: .default
            , handler: { (action) in
                self.photoPicker.sourceType = .camera
                self.present(self.photoPicker, animated: true, completion: nil)
        })
        let secondAction = UIAlertAction(title: "从相册中选择", style: .default, handler: { (action) in
            self.photoPicker.sourceType = .photoLibrary
            self.present(self.photoPicker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        })
        actionSheet.addAction(firstAction)
        actionSheet.addAction(secondAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    //MARK:选择性别
    func chooseSex(btn:UIButton){
        if sexChooseBtn == btn {
            return
        }
        if sexChooseBtn != nil {
            sexChooseBtn.isSelected = false
        }
        btn.isSelected = true
        sexChooseBtn = btn
        sexTag = sexChooseBtn.tag-10
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) ->Bool {
        let currentStr = String(format:"%@%@",textField.text!,string)
        if textField == nameTF {
            if string.isRuleAndNumber {
                return true
            }
            if currentStr.characters.count > 18 {
                return false
            }
        }else if textField == pwdTF {
            if !string.isLetterAndNumber{
                return false
            }
            if currentStr.characters.count > 16 {
                return false
            }
        }else {
            if !string.isLetterAndNumber{
                return false
            }
            if currentStr.characters.count > 10 {
                return false
            }
        }
        return true
    }
    func changeValue(_ sender:UITextField){
        if sender == self.nameTF {
            let toBeStr = sender.text!
            var lastStr = ""
            if toBeStr.characters.count > 0 {
                lastStr = toBeStr.substring(from: toBeStr.index(toBeStr.endIndex, offsetBy: -1))
            }
            if !toBeStr.isRuleAndNumber && lastStr.isEmoji {
                sender.text = toBeStr.disableEmoji
                return
            }
            let lang = sender.textInputMode
            let startIndex = toBeStr.startIndex
            var endIndex:String.Index!
            if toBeStr.characters.count > 18 {
                endIndex = toBeStr.index(startIndex, offsetBy: 18)
            }else{
                endIndex = toBeStr.endIndex
            }
            
            if lang?.primaryLanguage == "zh-Hans"{
                let selectRange = sender.markedTextRange
//                let position = sender.position(from: (selectRange?.start)!, offset: 0)
                if (selectRange == nil) {
                    let getStr = toBeStr.substring(with: startIndex..<endIndex)
                    if getStr != nil && getStr.characters.count > 0 {
                        sender.text = getStr
                    }
                }
            }else {
                let getStr = toBeStr.substring(with: startIndex..<endIndex)
                if getStr != nil && getStr.characters.count > 0 {
                    sender.text = getStr
                }
            }
        }
        if (self.nameTF.text?.characters.count)! > 2 && (self.pwdTF.text?.characters.count)! > 5{
            self.loginBtn.isEnabled = true
            self.loginBtn.setBackgroundImage(UIImage(named:"login_btn_bg"), for: .normal)
        }else{
            self.loginBtn.isEnabled = false
            self.loginBtn.setBackgroundImage(UIImage(named:"disable_bg"), for: .normal)
        }
    }

    
    //MARK:选择图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获得照片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let param:[String:String] = [:]
        HRNetwork.shared.hr_uploadImage(img: image, params: param, success: { (result) in
            let imageUrl = result["body"]["info"].stringValue
            self.avatarIV.image = image
        }) { (error) in
            
        }
        self.dismiss(animated: true) {}
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
