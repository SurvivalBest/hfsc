//
//  HROrderDetailVC.swift
//  hfsc
//
//  Created by innket on 17/11/24.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HROrderDetailVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HROrderFooterViewDelegate{
    var orderID = "0"
    var orderInfo:HROrderInfoModel = HROrderInfoModel()
    var mainTV:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        self.test()
        self.setUI()
        self.getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func setNav(){
        self.setNavTitle(title: "订单详情")
    }
    func test(){
        for i in 0..<5 {
            let info = HROrderInfoModel()
            info.status = "\(arc4random_uniform(3))"
            info.orderNO = "1010101001"
            info.time = "2017-10-10 10:10"
            info.total = "200"
            info.deliveryStr = "到店自提(免费)"
            info.remark = "帮我用礼盒包装一下"
            info.type = "\(arc4random_uniform(3))"
            info.userInfo = ["name":"张三","phone":"17705652385","address":"上海上海市普陀区武宁智慧园"]
            let good = ["title":"安慕希牛奶","kind":info.type,"unit":"25瓶/箱","price":"100","count":"2"]
            info.goodsList = [good]
            self.orderInfo = info
        }
    }
    func setUI(){
        mainTV = UITableView(frame: HR_FIRST_FRAME, style: .grouped)
        mainTV.delegate = self
        mainTV.dataSource = self
        mainTV.tableFooterView = UIView(frame: CGRect.zero)
        mainTV.backgroundColor = HR_BG_COLOR
        mainTV.separatorStyle = .none
        self.view.addSubview(mainTV!)
        
        self.view.addSubview(self.footerView)
        switch StringToInt(str: self.orderInfo.status) {
        case 1:
            //等待买家发货
            self.handleBtn.setTitle("催单", for: .normal)
        case 2:
            //待收
            self.handleBtn.setTitle("确认收货", for: .normal)
        case 3:
            //结束
            self.handleBtn.setTitle("再来一单", for: .normal)
        default:
            //交易失败
            self.handleBtn.setTitle("再来一单", for: .normal)
        }
        self.footerView.addSubview(self.handleBtn)
    }
    lazy var footerView:UIView = {
        let tempView = UIView(frame: HR_FOOTER_FRAME)
        tempView.backgroundColor = HR_WHITE_COLOR
        
        return tempView
    }()
    lazy var handleBtn:UIButton = {
        let tempBtn = UIButton(frame: CGRect(x: HR_SCREEN_WIDTH-75-HR_MARGIN, y: (HR_FOOTER_HEIGHT-30)/2, width: 75, height: 30))
        tempBtn.setTitleColor(HR_GOLD_COLOR, for: .normal)
        tempBtn.layer.cornerRadius = 15
        tempBtn.layer.masksToBounds = true
        tempBtn.layer.borderWidth = 1
        tempBtn.layer.borderColor = HR_GOLD_COLOR.cgColor
        tempBtn.titleLabel?.font = HR_SMALL_FONT
        tempBtn.addTarget(self, action: #selector(orderHandle(btn:)), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:获取订单列表
    func getData(){
    }
    
    //MARK:tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.orderInfo.goodsList.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            tableView.rowHeight = 120
            var cell:HROrderGoodTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as? HROrderGoodTVCell
            if cell == nil {
                cell = HROrderGoodTVCell(style: .default, reuseIdentifier: "CELL")
            }
            let list = self.orderInfo.goodsList
            if list.count > row {
                let goodInfo = HRGoodInfoModel.deserialize(from: list[row] as? NSDictionary)
                cell?.type = StringToInt(str: self.orderInfo.type)
                cell?.setInfo(info: goodInfo!)
            }
            return cell!
        }else if section == 1 || section == 3{
            tableView.rowHeight = 45
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
            }
            cell?.textLabel?.textColor  = HR_BLACK_COLOR
            cell?.textLabel?.font = HR_NORMAL_FONT
            cell?.detailTextLabel?.textColor = HR_GRAY_COLOR
            if section == 1 {
                cell?.textLabel?.text = "配送方式"
                cell?.detailTextLabel?.text = EmptyCheck(str: self.orderInfo.deliveryStr)
                cell?.accessoryType = .none
                cell?.detailTextLabel?.text = HR_SERVICE_PHONE
                cell?.detailTextLabel?.font = HR_SMALL_FONT
            }else {
                cell?.textLabel?.text = "备注"
                cell?.detailTextLabel?.text = EmptyCheck(str: self.orderInfo.remark)
                cell?.detailTextLabel?.font = HR_NORMAL_FONT
                cell?.detailTextLabel?.textAlignment = .right
            }
            return cell!
        }else {
            tableView.rowHeight = 90
            var cell:HRShowAddressTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL") as? HRShowAddressTVCell
            if cell == nil {
                cell = HRShowAddressTVCell(style: .default, reuseIdentifier: "CELL")
            }
            let info = HRAddressInfoModel.deserialize(from: self.orderInfo.userInfo as? NSDictionary)
            cell?.setInfo(info: info!)
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            //            let info = self.sourceList[indexPath.section]
            //            let VC = HRMyOrderDetailVC()
            //            VC.orderID = info.ID
            //            VC.sourceInfo = info
            //            self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return HR_TOP_HEIGHT + 5
        }
        return 5
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = HROrderHeaderView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT+5))
            headerView.setInfo(orderNo: EmptyCheck(str: self.orderInfo.orderNO), status: StringToInt(str: self.orderInfo.status),type:1)
            return headerView
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return HR_TOP_HEIGHT
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = HROrderFooterView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_TOP_HEIGHT))
            footerView.delegate = self
            footerView.tag = section
            footerView.setInfo(info: self.orderInfo,type:2)
            return footerView
        }
        return nil
    }
    
    //MARK:订单操作
    func orderHandle(btn: UIButton) {
        let title:String = (btn.titleLabel?.text)!
        switch title {
        case "催单":
            print("催单：\(orderID)")
        case "确认收货":
            print("确认收货：\(orderID)")
        default:
            print("再来一单：\(orderID)")
        }
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
