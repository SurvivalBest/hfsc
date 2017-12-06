//
//  HRAddAddressVC.swift
//  hfsc
//
//  Created by innket on 17/11/22.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRAddAddressVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRInputTVCellDelegate{

    var addressInfo:HRAddressInfoModel!
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        // Do any additional setup after loading the view.
        self.setUI()
    }
    func setNav(){
        if self.type == 1 {
            self.setNavTitle(title: "编辑地址")
        }else{
            self.setNavTitle(title: "添加新地址")
        }
        self.navigationItem.rightBarButtonItem = self.setBarButton(title: "保存", event: #selector(saveAddress))
    }
    //MARK:保存地址
    func saveAddress(){
        self.goBackPop()
    }
    lazy private var nameList = {
        return [["姓名","电话"],["省市区","详细地址"],["设为默认地址"]]
    }()
    lazy private var placeList = {
        return [["请填写收货人姓名","请填写收货人电话号码"],["请选择","请填写详细地址"],[""]]
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
        if self.addressInfo == nil {
            self.addressInfo = HRAddressInfoModel()
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
        tableView.rowHeight = 45
        if (section == 1 && row == 0)  || (section == 2 && row == 0){
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
            }
            cell?.textLabel?.textColor  = HR_BLACK_COLOR
            cell?.textLabel?.font = HR_NORMAL_FONT
            cell?.textLabel?.text = self.nameList[section][row]
            cell?.detailTextLabel?.textColor = HR_GRAY_COLOR
            cell?.detailTextLabel?.font = HR_SMALL_FONT
            if section == 1 {
                cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
                if self.type == 1 {
                    cell?.detailTextLabel?.text = self.addressInfo.areaDetail
                }else{
                    cell?.detailTextLabel?.text = "请选择"
                }
            } else {
                cell?.detailTextLabel?.text = ""
                let defaultBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                defaultBtn.setImage(UIImage(named:"default_no"), for: .normal)
                defaultBtn.setImage(UIImage(named:"sex_yes"), for: .selected)
                defaultBtn.addTarget(self, action: #selector(chooseDefault(btn:)), for: .touchUpInside)
                cell?.accessoryView =  defaultBtn
                if self.type == 1 {
                    if StringToInt(str: self.addressInfo.isDefault) == 1 {
                        defaultBtn.isSelected = true
                    }
                }
            }
            return cell!
        }else{
            var cell:HRInputTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? HRInputTVCell
            if cell == nil {
                cell = HRInputTVCell(style: .default, reuseIdentifier: "CELL2")
            }
            cell?.delegate = self
            cell?.inputTF.textAlignment = .right
            cell?.setTitleAndPlaceholder(title: self.nameList[section][row], placeholder: self.placeList[section][row])
            if self.addressInfo != nil {
                if section == 0 {
                    if row == 0 {
                        cell?.setNowText(text: EmptyCheck(str: self.addressInfo.name))
                        cell?.setKeyboardType(type: .default)
                    }else if row == 1{
                        cell?.type = 2
                        cell?.setNowText(text: EmptyCheck(str: self.addressInfo.phone))
                        cell?.setKeyboardType(type: .numberPad)
                    }
                }else if section == 1 {
                    if row == 1 {
                        cell?.setNowText(text: EmptyCheck(str: self.addressInfo.address))
                        cell?.setKeyboardType(type: .default)
                    }
                }
            }
            return cell!
        }
    }
    //MARK:设置为默认地址
    func chooseDefault(btn:UIButton){
        btn.isSelected = !btn.isSelected
        if self.addressInfo != nil {
            if btn.isSelected {
                self.addressInfo.isDefault = "1"
            }else{
                self.addressInfo.isDefault = "0"
            }
        }
    }
    func inputValueChanged(value: String, cell: HRInputTVCell) {
        let indexPath = self.mainTV.indexPath(for: cell)
        let row = indexPath?.row
        print("第\(row)个输入框改变值：\(value)")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 0 {
            HRSelectAddressView.shared.show(getAddress: { (address, areaID) in
                self.addressInfo.areaDetail = address
                self.addressInfo.areaid = "\(areaID)"
                self.mainTV.reloadData()
            })
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
