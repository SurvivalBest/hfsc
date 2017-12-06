//
//  HRUserInfoVC.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRUserInfoVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HR_NOTIFICATION.addObserver(self, selector: #selector(changeName(noti:)), name: kChangeName, object: nil)
        HR_NOTIFICATION.addObserver(self, selector: #selector(changeVipNum(noti:)), name: kChangeVipNum, object: nil)
    }
    func changeName(noti:Notification){
        let info = noti.userInfo
        let name = info?["name"] as! String
        self.changeInfo(type: 2, value: name) {
            self.userInfo.nickname = name
            self.mainTV.reloadData()
        }
    }
    func changeVipNum(noti:Notification){
        let info = noti.userInfo
        let name = info?["number"] as! String
        self.changeInfo(type: 7, value: name) {
            self.userInfo.vipNum = name
            self.mainTV.reloadData()
        }
    }
    deinit {
        HR_NOTIFICATION.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cacheSize = hr_fileSizeOfCache()
        setNavTitle(title: "个人信息")
        // Do any additional setup after loading the view.
        self.setUI()
    }
    private let iconH:CGFloat = 100
    var userInfo:HRUserInfoModel!
    var cacheSize:Float = 0.0
    var phone = ""
    lazy private var nameList = {
        return [["头像","昵称","地区","生日"],["绑定线下会员卡"]]
    }()
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FULL_FRAME, style: .grouped)
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
    private var iconIV:UIImageView!
    lazy var photoPicker:UIImagePickerController = {
        let tempPP = UIImagePickerController()
        tempPP.delegate = self
        tempPP.allowsEditing = true
        return tempPP
    }()
    func setUI(){
        if self.userInfo == nil {
            self.userInfo = HRUserInfoModel()
        }
        self.view.addSubview(self.mainTV)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.nameList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.nameList[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 0{
            tableView.rowHeight = 100
        }else{
            tableView.rowHeight = 45
        }
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
        }
        cell?.textLabel?.textColor  = HR_BLACK_COLOR
        cell?.textLabel?.font = HR_NORMAL_FONT
        cell?.textLabel?.text = self.nameList[section][row]
        cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
        
        cell?.detailTextLabel?.textColor = HR_GRAY_COLOR
        cell?.detailTextLabel?.font = HR_SMALL_FONT
        cell?.detailTextLabel?.text = "未设置"
        if section == 0 {
            if row == 0 {
                cell?.contentView.hr_removeAllSubviews()
                cell?.detailTextLabel?.text = ""
                let iconIV = UIImageView(frame: CGRect(x: HR_SCREEN_WIDTH-iconH-20, y: HR_MARGIN, width: iconH-HR_MARGIN*2, height: iconH-HR_MARGIN*2))
                iconIV.image = HR_DEFAULT_AVATAR
                iconIV.hr_setCronerRadius(radius: iconH/2-HR_MARGIN)
                cell?.contentView.addSubview(iconIV)
                if !self.userInfo.avatar.isEmpty {
                    iconIV.af_setImage(withURL: URL(string:self.userInfo.avatar)!, placeholderImage: HR_DEFAULT_AVATAR)
                }
                self.iconIV = iconIV
            }else if row == 1 {
                if !self.userInfo.nickname.isEmpty {
                    cell?.detailTextLabel?.text = self.userInfo.nickname
                }
            }else if row == 2 {
                if !self.userInfo.address.isEmpty {
                    cell?.detailTextLabel?.text = self.userInfo.address
                }
            }else if row == 3{
                if !self.userInfo.birthday.isEmpty {
                    cell?.detailTextLabel?.text = self.userInfo.birthday
                }
            }
        } else if section == 1 {
            if !self.userInfo.vipNum.isEmpty {
                cell?.detailTextLabel?.text = self.userInfo.vipNum
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            switch row {
            case 0:
                //头像
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
                break
            case 1:
                //昵称
                let VC = HRChangeInfoVC()
                VC.type = 1
                VC.value = self.userInfo.nickname
                self.goNext(VC: VC)
                break
            case 2:
                //地区
                HRSelectAddressView.shared.show(getAddress: { (address, areaID) in
                    self.changeInfo(type: 5, value: "\(areaID)", success: {
                        self.userInfo.address = address
                        self.userInfo.areaID = areaID
                        self.mainTV.reloadData()
                    })
                })
                break
            case 3:
                //生日
                HRSelectTimeView.shared.show(block: { (time) in
                    self.changeInfo(type: 6, value: time, success: { 
                        self.userInfo.birthday = time
                        self.mainTV.reloadData()
                    })
                })
                break
            default:
                //
                break
            }
        }else{
            //绑定会员卡
            let VC = HRChangeInfoVC()
            VC.type = 2
            VC.value = self.userInfo.vipNum
            self.goNext(VC: VC)
        }
        
    }
    //MARK:选择图片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //获得照片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let param:[String:String] = [:]
        HRNetwork.shared.hr_uploadImage(img: image, params: param, success: { (result) in
            let imageUrl = result["body"]["info"].stringValue
            self.changeInfo(type: 1, value: imageUrl) {
                self.iconIV.image = image
                HR_NOTIFICATION.post(name: kChangeAvatar, object: nil, userInfo: ["avatar":imageUrl])
            }
        }) { (error) in
            
        }
        self.dismiss(animated: true) {}
    }
    func goNext(VC:UIViewController){
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func changeInfo(type:Int,value:String,success:@escaping ()->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["type"] = "\(type)"
        param["new"] = value
        HRNetwork.shared.hr_getData(cmd: "updateUserInfo", params: param, success: { (result) in
            self.noticeOnlyText("更新成功")
            success()
        }) { (error) in
            
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
