//
//  HROrdersVC.swift
//  hfsc
//
//  Created by innket on 17/11/24.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HROrdersVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRInputTVCellDelegate,HRPlanOrderTVCellDelegate{
    var orderID = "0"
    var goodInfo:HRGoodInfoModel = HRGoodInfoModel()
    var addressInfo:HRAddressInfoModel = HRAddressInfoModel()
    var shopList:[HRShopInfoModel] = []
    var shopIndex = 0
    var sendWay = "门店配送（免费）"
    var mainTV:UITableView!
    var isTakeTheir = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        self.test()
        self.setUI()
        self.getData()
        HR_NOTIFICATION.addObserver(self, selector: #selector(changeWay(noti:)), name: kChangeWay, object: nil)
        HR_NOTIFICATION.addObserver(self, selector: #selector(changeAddress(noti:)), name: kChangeAddress, object: nil)
        HR_NOTIFICATION.addObserver(self, selector: #selector(changeShop(noti:)), name: kChangeShop, object: nil)
    }
    //MARK:选择配送方式
    func changeWay(noti:Notification){
        let info = noti.userInfo
        let index:Int = info?["index"] as! Int
        let infoList  = ["快递配送（免费）","门店配送（免费）","到店自提（免费）"]
        self.sendWay = infoList[index]
        if index == 2 {
            self.isTakeTheir = true
        }else{
            self.isTakeTheir = false
        }
        self.mainTV.reloadData()
    }
    //MARK:选择收货地址
    func changeAddress(noti:Notification){
        let info = noti.userInfo as! [String:Any]
        let addressInfo = HRAddressInfoModel.deserialize(from: info as? NSDictionary)
        self.addressInfo = addressInfo!
        self.mainTV.reloadData()
    }
    //MARK:选择门店
    func changeShop(noti:Notification){
        let info = noti.userInfo
        let index:Int = info?["index"] as! Int
        
        let shop = self.shopList[self.shopIndex]
        shop.isSelected = 0
        self.shopList[self.shopIndex] = shop
        
        let shop1 = self.shopList[index]
        shop1.isSelected = 1
        self.shopList[index] = shop1
        
        self.shopIndex = index
        self.mainTV.reloadData()
    }
    deinit {
        HR_NOTIFICATION.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setNav(){
        self.setNavTitle(title: "确认订单")
    }
    func test(){
//        self.addressInfo.name = "HR"
//        self.addressInfo.phone = "17705652385"
//        self.addressInfo.areaDetail = "上海上海市"
//        self.addressInfo.address = "武宁智慧园武宁智慧园武宁智慧园武宁智慧园武宁智慧园武宁智慧园"
        for i in 0..<5 {
            let shop = HRShopInfoModel()
            shop.id = "\(i)"
            shop.title = "安慕希牛奶\(i+1)"
            shop.address = "上海市普陀区武宁智慧园"
            shop.distance = "200m"
            shop.level = "4.4"
            if i==0 {
                shop.isSelected = 1
            }
            self.shopList.append(shop)
        }
    }
    func setUI(){
        mainTV = UITableView(frame: HR_FIRST_FRAME, style: .grouped)
        mainTV.delegate = self
        mainTV.dataSource = self
        mainTV.tableFooterView = UIView(frame: CGRect.zero)
        mainTV.separatorColor = HR_LINE_COLOR
        mainTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        mainTV.backgroundColor = HR_BG_COLOR
        self.view.addSubview(mainTV!)
        
        self.view.addSubview(self.footerView)
        self.footerView.addSubview(self.totalLab)
        self.editCount(num: self.goodInfo.selectCount)
        self.footerView.addSubview(self.payBtn)
    }
    lazy var footerView:UIView = {
        let tempView = UIView(frame: HR_FOOTER_FRAME)
        tempView.backgroundColor = HR_WHITE_COLOR
        return tempView
    }()
    lazy var totalLab:UILabel = {
        let tempLab = UILabel(frame: CGRect(x: HR_MARGIN, y: HR_MARGIN, width: HR_SCREEN_WIDTH/3*2-HR_MARGIN, height: HR_FOOTER_HEIGHT-HR_MARGIN))
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        tempLab.text = "应付款 0 元"
        return tempLab
    }()
    lazy var payBtn:UIButton = {
        let tempBtn = UIButton(frame: CGRect(x: HR_SCREEN_WIDTH/3*2, y: 0, width: HR_SCREEN_WIDTH/3, height: HR_FOOTER_HEIGHT))
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.setTitle("立即付款", for: .normal)
        tempBtn.backgroundColor = HR_GOLD_COLOR
        tempBtn.titleLabel?.font = HR_BIG_FONT
        tempBtn.addTarget(self, action: #selector(payNow), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:立即付款
    func payNow(){
        
    }
    //MARK:获取订单列表
    func getData(){
    }
    
    //MARK:tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 0 {
            tableView.rowHeight = 120
            var cell:HRPlanOrderTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as? HRPlanOrderTVCell
            if cell == nil {
                cell = HRPlanOrderTVCell(style: .default, reuseIdentifier: "CELL")
            }
            cell?.delegate = self
            cell?.setInfo(info: self.goodInfo)
            cell?.accessoryType = .none
            cell?.selectionStyle = .none
            return cell!
        }else if section == 0 && row == 1{
            tableView.rowHeight = 45
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
            }
            cell?.textLabel?.textColor  = HR_BLACK_COLOR
            cell?.textLabel?.font = HR_NORMAL_FONT
            cell?.detailTextLabel?.textColor = HR_GRAY_COLOR
            cell?.detailTextLabel?.font = HR_SMALL_FONT
            cell?.textLabel?.text = "配送方式"
            cell?.detailTextLabel?.text = self.sendWay
            cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
            return cell!
        }else if section == 1 && row == 0 {
            if self.isTakeTheir {
                tableView.rowHeight = 120
                var cell:HRShopTVCell?
                cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRShopTVCell
                if cell == nil {
                    cell = HRShopTVCell(style: .default, reuseIdentifier: "CELL1")
                }
                let info = self.shopList[shopIndex]
                cell?.type = 1
                cell?.setInfo(info: info)
                cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
                return cell!
            }else{
                tableView.rowHeight = 90
                var cell:HRShowAddressTVCell?
                cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? HRShowAddressTVCell
                if cell == nil {
                    cell = HRShowAddressTVCell(style: .default, reuseIdentifier: "CELL2")
                }
                cell?.setInfo(info: self.addressInfo)
                cell?.accessoryView = UIImageView(image: UIImage(named: "go_detail"))
                return cell!
            }
        }else {
            tableView.rowHeight = 45
            var cell:HRInputTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL3") as? HRInputTVCell
            if cell == nil {
                cell = HRInputTVCell(style: .default, reuseIdentifier: "CELL3")
            }
            cell?.delegate = self
            cell?.setTitleAndPlaceholder(title: "备注", placeholder: "如有特殊要求，请给商家留言")
            cell?.setKeyboardType(type: .default)
            cell?.accessoryType = .none
            return cell!
        }
        
    }
    //MARK:输入内容
    func inputValueChanged(value: String, cell: HRInputTVCell) {
        
    }
    //MARK:改变数量
    func editCount(num: Int) {
        self.goodInfo.selectCount = num
        let totalPrice = StringToInt(str: self.goodInfo.price)*num
        let totalStr = "应付款 \(totalPrice)元"
        let attriStr = NSMutableAttributedString(string: totalStr)
        attriStr.addAttribute(NSFontAttributeName, value: HR_PRICE_FONT, range: NSRange(location: 4, length: "\(totalPrice)".characters.count))
        attriStr.addAttribute(NSForegroundColorAttributeName, value: HR_RED_COLOR, range: NSRange(location: 4, length: "\(totalPrice)".characters.count+2))
        self.totalLab.attributedText = attriStr
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let VC  = HRChooseWayVC()
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }else if indexPath.section == 1{
            if self.isTakeTheir {
                let VC  = HRChooseShopVC()
                VC.shopList = self.shopList
                self.navigationController?.pushViewController(VC, animated: true)
            }else{
                let VC  = HRAddressListVC()
                VC.type = 1
                self.navigationController?.pushViewController(VC, animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
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
