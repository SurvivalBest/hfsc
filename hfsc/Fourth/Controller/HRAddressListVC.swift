//
//  HRAddressListVC.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRAddressListVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRAddressTVCellDelegate{
    var type = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavTitle(title: "收货地址")
        // Do any additional setup after loading the view.
        self.setUI()
    }
    private var infoList:[HRAddressInfoModel] = []
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FIRST_FRAME, style: .grouped)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.separatorStyle = .none
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()

    func getData(){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getAddressList", params: param, success: { (result) in
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRAddressInfoModel.deserialize(from: subJson.rawString()!)
                self.infoList.append(model!)
            }
            self.mainTV.reloadData()
        }) { (error) in
        }
    }
    //MARK:没有地址
    lazy var noAddressView:UIView = {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_FIRST_FRAME.height))
        tempView.backgroundColor = HR_BG_COLOR
        
        let iconIV = UIImageView(frame: CGRect(x: HR_SCREEN_WIDTH/4, y: (HR_FIRST_FRAME.height-HR_SCREEN_WIDTH/4)/2, width: HR_SCREEN_WIDTH/2, height: HR_SCREEN_WIDTH/4))
        iconIV.center = tempView.center
        iconIV.image = UIImage(named:"no_address")
        iconIV.contentMode = .scaleAspectFit
        tempView.addSubview(iconIV)
        
        let alertLab = UILabel(frame: CGRect(x: 0, y: iconIV.frame.maxY, width: HR_SCREEN_WIDTH, height: 30))
        alertLab.text = "您还没有添加收货地址"
        alertLab.textColor = HR_GRAY_COLOR
        alertLab.font = HR_NORMAL_FONT
        alertLab.textAlignment = .center
        tempView.addSubview(alertLab)
        return tempView
    }()
    
    
    lazy var addBtn:UIButton = {
        let tempBtn = UIButton(frame: CGRect(x: 0, y: HR_SCREEN_HEIGHT-HR_FOOTER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_FOOTER_HEIGHT))
        tempBtn.setTitle("添加新地址", for: .normal)
        tempBtn.backgroundColor = HR_GOLD_COLOR
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        return tempBtn
    }()
    func addAddress(){
        print("添加新地址")
        let VC = HRAddAddressVC()
        self.goNext(VC: VC)
    }
    func setUI(){
        self.view.addSubview(self.mainTV)
        self.view.addSubview(self.addBtn)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.infoList.count == 0 {
            tableView.tableHeaderView = self.noAddressView
        }else{
            tableView.tableHeaderView = self.placeholderView
        }
        return self.infoList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        tableView.rowHeight = HR_TOP_HEIGHT+90
        var cell:HRAddressTVCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRAddressTVCell
        if cell == nil {
            cell = HRAddressTVCell(style: .value1, reuseIdentifier: "CELL1")
        }
        if self.infoList.count > section {
            cell?.delegate = self
            cell?.setInfo(info: self.infoList[section])
        }
        return cell!
    }
    //MARK:地址操作
    func setDefault(btn: UIButton, cell: HRAddressTVCell) {
        let indexPath = self.mainTV.indexPath(for: cell)
        
        for info in self.infoList {
            info.isDefault = "0"
        }
        let info = self.infoList[(indexPath?.section)!]
        info.isDefault = "1"
        self.infoList[(indexPath?.section)!] = info
        self.mainTV.reloadData()
    }
    func editAddress(cell: HRAddressTVCell) {
        let indexPath = self.mainTV.indexPath(for: cell)
        let VC = HRAddAddressVC()
        VC.type = 1
        VC.addressInfo = self.infoList[(indexPath?.section)!]
        self.goNext(VC: VC)
    }
    func delAddress(cell: HRAddressTVCell) {
        let indexPath = self.mainTV.indexPath(for: cell)
        let alertView = UIAlertController(title: "提示", message: "是否删除该地址?", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (cancelView) in
            
        }))
        alertView.addAction(UIAlertAction(title: "确认", style: .default, handler: { (otherView) in
            if self.infoList.count > (indexPath?.section)! {
                self.infoList.remove(at: (indexPath?.section)!)
                self.mainTV.reloadData()
            }
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        if self.infoList.count > section {
            if self.type == 1 {
                //选择地址
                HR_NOTIFICATION.post(name: kChangeAddress, object: nil, userInfo: self.infoList[section].toJSON())
                self.goBackPop()
            }
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
