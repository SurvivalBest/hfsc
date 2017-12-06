//
//  HRMsgManagerVC.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRMsgManagerVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTitle(title: "消息管理")
        // Do any additional setup after loading the view.
        self.setUI()
    }
    var phone = ""
    lazy private var nameList = {
        return [["系统消息通知"],["声音","震动"]]
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
    
    
    func setUI(){
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
        tableView.rowHeight = 45
        var cell:UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL1")
        }
        cell?.textLabel?.textColor  = HR_BLACK_COLOR
        cell?.textLabel?.font = HR_NORMAL_FONT
        cell?.textLabel?.text = self.nameList[section][row]
        
        cell?.accessoryView = UISwitch(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 5
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let alertLab = UILabel(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 35))
        alertLab.textColor = HR_GRAY_COLOR
        alertLab.font = HR_SMALL_FONT
        alertLab.textAlignment = .center
        if section == 0 {
            alertLab.text = "关闭后，当收到系统消息时，将不再进行通知提醒"
        }else {
            alertLab.text = "当APP在运行时，你可以设置是否需要声音或者震动"
        }
        return alertLab
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
