//
//  HRJoinInVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRJoinInVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRInputTVCellDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTitle(title: "我要加盟")
        self.navigationItem.rightBarButtonItem = self.setBarButton(title: "提交", event: #selector(finish))
        // Do any additional setup after loading the view.
        self.setUI()
        HR_NOTIFICATION.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        HR_NOTIFICATION.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //MARK:显示键盘
    func keyboardShow(_ notification:NSNotification){
        let info = notification.userInfo
        let keyboardH = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        self.mainTV.frame = CGRect(x: 0, y: HR_HEADER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT-HR_HEADER_HEIGHT-keyboardH)
    }
    //MARK:隐藏键盘
    func keyboardHide(_ notification:NSNotification){
        self.mainTV.frame = HR_FULL_FRAME
    }
    deinit {
        HR_NOTIFICATION.removeObserver(self)
    }
    //MARK:修改密码
    func finish(){
        print("提交")
        let _ = self.navigationController?.popViewController(animated: true)
    }
    var phone = ""
    lazy private var nameList = {
        return [["商家名称"],["上传商家图片(首张为封面)"],["商家简介"],["类型","电话","地址","营业时间"],["营业资质"],]
    }()
    lazy private var placeList = {
        return [["请输入商家名称"],["上传商家图片(首张为封面)"],["请填写商家介绍"],["选择商家类型","请输入电话号码","请输入商家地址","00:00-00:00"],["营业资质"],]
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
        if section==0 || section==3&&row==1 || section==3&&row==2 {
            tableView.rowHeight = 45
            var cell:HRInputTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRInputTVCell
            if cell == nil {
                cell = HRInputTVCell(style: .default, reuseIdentifier: "CELL1")
            }
            cell?.delegate = self
            cell?.inputTF.textAlignment = .right
            cell?.inputTF.font = HR_SMALL_FONT
            cell?.setTitleAndPlaceholder(title: self.nameList[section][row], placeholder: self.placeList[section][row])
            cell?.selectionStyle = .none
            return cell!
        }else if section==3&&row==0 || section==3&&row==3{
            tableView.rowHeight = 45
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL2")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL2")
            }
            cell?.textLabel?.textColor  = HR_BLACK_COLOR
            cell?.textLabel?.font = HR_NORMAL_FONT
            cell?.detailTextLabel?.textColor = HR_GRAY_COLOR
            cell?.detailTextLabel?.font = HR_SMALL_FONT
            cell?.textLabel?.text = self.nameList[section][row]
            cell?.detailTextLabel?.text = self.placeList[section][row]
            cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
            return cell!
        }else if section==1&&row==0 || section==4&&row==0{
            tableView.rowHeight = (HR_SCREEN_WIDTH-HR_MARGIN*4)/3*2+HR_MARGIN*3
            var cell:HRUploadImgTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL3") as? HRUploadImgTVCell
            if cell == nil {
                cell = HRUploadImgTVCell(style: .value1, reuseIdentifier: "CELL3")
            }
            if section == 4 {
                cell?.hideAlert()
            }
            cell?.selectionStyle = .none
            return cell!
        }else {
            tableView.rowHeight = 150
            var cell:HRTextViewTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL4") as? HRTextViewTVCell
            if cell == nil {
                cell = HRTextViewTVCell(style: .value1, reuseIdentifier: "CELL4")
            }
            cell?.selectionStyle = .none
            return cell!
        }
        
    }
    func inputValueChanged(value: String, cell: HRInputTVCell) {
        let indexPath = self.mainTV.indexPath(for: cell)
        let row = indexPath?.row
        print("第\(row)个输入框改变值：\(value)")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 3 && row == 3 {
            //选择时间
            HRSeclectOpenTimeView.shared.show(block: { (time) in
                self.placeList[3][3] = time
                self.mainTV.reloadData()
            })
        }
    }
    func goNext(VC:UIViewController){
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 || section == 3 || section == 4  {
            return HR_TOP_HEIGHT
        }
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 || section == 3 {
            return 5
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 2 || section == 3 || section == 4 {
            var titleArr = ["商家简介","商家信息","营业资质"]
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
            let titleLab = UILabel(frame: CGRect(x: HR_MARGIN, y: 0, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_TOP_HEIGHT))
            titleLab.textColor = HR_BLACK_COLOR
            titleLab.font = HR_BOLD_FONT
            titleLab.text = titleArr[section-2]
            headerView.addSubview(titleLab)
            headerView.backgroundColor = HR_WHITE_COLOR
            return headerView
        }
        return nil
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
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
