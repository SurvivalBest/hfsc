//
//  HRChangePwdVC.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRChangePwdVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRInputTVCellDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavTitle(title: "修改密码")
        self.navigationItem.rightBarButtonItem = self.setBarButton(title: "完成", event: #selector(finish))
        // Do any additional setup after loading the view.
        self.setUI()
    }
    var oldPwd = ""
    var newPwd1 = ""
    var newPwd2 = ""
    //MARK:修改密码
    func finish(){
        if self.oldPwd.length < 6 {
            self.noticeOnlyText("你输入的旧密码错误！")
            return
        }else if self.newPwd1.length < 6 {
            self.noticeOnlyText("请输入6~16位密码哦！")
            return
        }else if self.newPwd1 != self.newPwd2 {
            self.noticeOnlyText("两次输入的密码不一致")
            return
        }
        print("修改密码")
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["old"] = self.oldPwd
        param["news"] = self.newPwd1
        HRNetwork.shared.hr_getData(cmd: "changePwd", params: param, success: { (result) in
            self.goBackPop()
        }) { (error) in
        }
    }
    var phone = ""
    lazy private var nameList = {
        return ["旧密码  ","新密码  ","重复新密码  "]
    }()
    lazy private var placeList = {
        return ["请填旧密码","请设置6~16位新密码","请确认新密码"]
    }()
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FIRST_FRAME, style: .grouped)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.separatorColor = HR_LINE_COLOR
        tempTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tempTV.backgroundColor = HR_BG_COLOR
        //        tempTV.separatorStyle = .singleLineEtched
        return tempTV
    }()
    
    func setUI(){
        self.view.addSubview(self.mainTV)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        tableView.rowHeight = 45
        var cell:HRInputTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRInputTVCell
        if cell == nil {
            cell = HRInputTVCell(style: .default, reuseIdentifier: "CELL1")
        }
        cell?.type = 1
        cell?.delegate = self
        cell?.setKeyboardType(type: .numbersAndPunctuation)
        cell?.setTitleAndPlaceholder(title: self.nameList[row], placeholder: self.placeList[row])
        return cell!
    }
    func inputValueChanged(value: String, cell: HRInputTVCell) {
        let indexPath = self.mainTV.indexPath(for: cell)
        let row = indexPath?.row
        print("第\(row)个输入框改变值：\(value)")
        if row == 0 {
            self.oldPwd = value
        }else if row == 1 {
            self.newPwd1 = value
        }else if row == 2 {
            self.newPwd2 = value
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func goNext(VC:UIViewController){
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
