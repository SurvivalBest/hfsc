//
//  HRThirdVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRThirdVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTitle(title: "发现")
        // Do any additional setup after loading the view.
        self.setUI()
    }
    lazy private var nameList = {
        return [["公司网点","热门活动"],["鸿福商城","返利特区","积分商城"],["慈善俱乐部","异业联盟"]]
    }()
    private var curPage = 1
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
        cell?.imageView?.image = UIImage(named: "discover_\(section)\(row)")
        cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            if row == 0 {
                //公司网点
                let VC = HRShopPrefectureVC()
                VC.type = 1
                self.goNext(VC: VC)
            }else{
                //热门活动
                let VC = HRActivityPrefectureVC()
                self.goNext(VC: VC)
            }
        }else if section == 1 {
            let VC = HRAssignGoodListVC()
            VC.type = row + 1
            self.goNext(VC: VC)
        }else if section == 2 {
            if row == 0 {
                //慈善俱乐部
            }else{
                //异业联盟
                let VC = HRShopPrefectureVC()
                self.goNext(VC: VC)
            }
        }
    }
    func goNext(VC:UIViewController){
        VC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HR_MARGIN
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
