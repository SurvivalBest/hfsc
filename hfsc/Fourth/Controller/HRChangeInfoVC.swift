//
//  HRChangeInfoVC.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRChangeInfoVC: HRBaseVC,UITextFieldDelegate {

    let inputH:CGFloat = 35
    var type:Int = 1
    var value:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    //MARK:保存
    func saveInfo(){
        
        if type == 1 {
            //昵称
            if (self.inputTF.text?.characters.count)! < 2 {
                self.noticeOnlyText("昵称长度2-18个字符，支持中英文、数字")
                return
            }
            HR_NOTIFICATION.post(name: kChangeName, object: nil, userInfo: ["name":self.inputTF.text])
            
        }else if type == 2{
            HR_NOTIFICATION.post(name: kChangeVipNum, object: nil, userInfo: ["number":self.inputTF.text])
        }
        self.goBackPop()
    }
    lazy private var inputTF:UITextField = {
        let tempTF = UITextField()
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.delegate = self
        tempTF.textAlignment = .left
        tempTF.returnKeyType = .done
        return tempTF
    }()
    lazy private var lineView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_LINE_COLOR
        return tempView
    }()
    
    lazy private var detailLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        return tempLab
    }()
    
    func setUI(){
        self.view.backgroundColor = HR_WHITE_COLOR
        self.view.addSubview(self.inputTF)
        self.view.addSubview(self.lineView)
        self.inputTF.snp.makeConstraints({ (make) in
            make.top.equalTo(HR_HEADER_HEIGHT+HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(inputH)
        })
        self.lineView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.inputTF.snp.bottom)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(1)
        })
        self.inputTF.becomeFirstResponder()
        self.inputTF.text = self.value
        if type == 1 {
            self.setNavTitle(title: "我的昵称")
            self.navigationItem.rightBarButtonItem = self.setBarButton(title: "保存", event: #selector(saveInfo))
            self.view.addSubview(self.detailLab)
            self.detailLab.snp.makeConstraints({ (make) in
                make.top.equalTo(self.lineView.snp.bottom)
                make.left.equalTo(HR_MARGIN)
                make.right.equalTo(-HR_MARGIN)
                make.height.equalTo(30)
            })
            self.inputTF.placeholder = "请输入您的昵称"
            self.detailLab.text = "昵称长度2-18个字符，支持中英文、数字"
        }else if type == 2 {
            self.setNavTitle(title: "绑定线下会员卡")
            self.navigationItem.rightBarButtonItem = self.setBarButton(title: "绑定", event: #selector(saveInfo))
            self.inputTF.placeholder = "请输入线下会员卡号进行绑定"
        }else{
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.saveInfo()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = String(format: "%@%@", textField.text!,string)
        if self.type == 1 {
            if str.characters.count > 18 {
                return false
            }
        }
        return true
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
