//
//  HRSettingVC.swift
//  hfsc
//
//  Created by innket on 17/11/16.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRSettingVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
        cacheSize = hr_fileSizeOfCache()
        setNavTitle(title: "设置")
        // Do any additional setup after loading the view.
        self.setUI()
    }
    var cacheSize:Float = 0.0
    var phone = ""
    lazy private var nameList = {
        return ["消息管理","账号安全","修改密码","清空缓存","给我评分","关于我们"]
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
    
    lazy var logoutBtn:UIButton = {
        let tempBtn = UIButton(frame: CGRect(x: 0, y: HR_SCREEN_HEIGHT-HR_FOOTER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_FOOTER_HEIGHT))
        tempBtn.setTitle("退出登录", for: .normal)
        tempBtn.backgroundColor = HR_GOLD_COLOR
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return tempBtn
    }()
    func logout(){
        print("退出登录")
        HRDataSave.hr_saveUserid(userid: "0")
        self.goBackPop()
    }
    
    func setUI(){
        self.view.addSubview(self.mainTV)
        if HRDataSave.hr_isLogin() {
            self.view.addSubview(self.logoutBtn)
            self.mainTV.frame = HR_FIRST_FRAME
        }else{
            self.mainTV.frame = HR_FULL_FRAME
        }
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
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
        }
        cell?.textLabel?.textColor  = HR_BLACK_COLOR
        cell?.textLabel?.font = HR_NORMAL_FONT
        cell?.textLabel?.text = self.nameList[row]
        cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
        
        cell?.detailTextLabel?.textColor = HR_GRAY_COLOR
        cell?.detailTextLabel?.font = HR_SMALL_FONT
        if row == 1 {
            cell?.accessoryType = .none
            if HRDataSave.hr_isLogin() {
                cell?.detailTextLabel?.text = self.phone
            }else {
                cell?.detailTextLabel?.text = "去绑定"
            }
        } else if row == 3 {
            cell?.detailTextLabel?.text = String(format: "%.2fM", cacheSize)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        switch row {
        case 0:
            //消息管理
            goNext(VC: HRMsgManagerVC())
        break
        case 1:
            //账号安全
            if !HRDataSave.hr_isLogin() {
                goNext(VC: HRLoginVC())
            }
            break
        case 2:
            //修改密码
            goNext(VC: HRChangePwdVC())
            break
        case 3:
            //清空缓存
            NSLog("清除缓存");
            let alertView = UIAlertController(title: "提示", message: "是否清除缓存?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (cancelView) in
                
            }))
            alertView.addAction(UIAlertAction(title: "确认", style: .default, handler: { (otherView) in
                hr_clearCache()
                self.cacheSize = 0.00
                self.mainTV.reloadData()
            }))
            self.present(alertView, animated: true, completion: nil)
            break
        case 4:
            //给我评分
            hr_gotoAppStore()
            break
        default:
            //关于我们
            let VC = HRShowHtmlVC()
            VC.type = 1
            goNext(VC: VC)
            break
            
        }
    }
    func goNext(VC:UIViewController){
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
