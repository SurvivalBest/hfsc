//
//  HRMyBalanceVC.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRMyBalanceVC: HRBaseVC ,UITableViewDelegate,UITableViewDataSource,HRBalanceTVCellDelegate{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    var balance = "0"
    var payWay = 0
    var payBtn:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setNav()
        self.setUI()
    }
    private func setNav(){
        setNavTitle(title: "余额")
        self.navigationItem.rightBarButtonItem = self.setBarButton(title: "明细", event: #selector(goDetail))
    }
    //MARK:跳转设置
    func goDetail(){
        let VC = HRBalanceDetailVC();
        self.navigationController?.pushViewController(VC, animated: true)
    }
    lazy private var nameList = {
        return [["余额：0元"],[""],["支付宝支付","微信支付"]]
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
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    
    func setUI(){
        self.mainTV.tableFooterView = self.footerView
        self.view.addSubview(self.mainTV)
    }
    lazy private var footerView:UIView = {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_FOOTER_HEIGHT+HR_MARGIN*4))
        tempView.backgroundColor = HR_BG_COLOR
        
        let tempBtn = UIButton(frame: CGRect(x: HR_MARGIN, y: HR_MARGIN*2, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: HR_FOOTER_HEIGHT))
        tempBtn.setTitle("立即充值", for: .normal)
        tempBtn.titleLabel?.font = HR_BIG_FONT
        //        tempBtn.backgroundColor = HR_THEME_COLOR
        tempBtn.setBackgroundImage(UIImage(named:"login_btn_bg"), for: .normal)
        tempBtn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        tempBtn.titleLabel?.textColor = HR_WHITE_COLOR
        tempBtn.layer.cornerRadius = inputH/2
        tempBtn.layer.masksToBounds = true
        tempBtn.layer.rasterizationScale = UIScreen.main.scale
        tempBtn.layer.shouldRasterize = true
        tempBtn.addTarget(self, action: #selector(recharge), for: .touchUpInside)
        tempView.addSubview(tempBtn)
        return tempView
    }()
    //MARK:立即充值
    func recharge(){
        
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
        if section != 1 {
            tableView.rowHeight = 60
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1")
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: "CELL1")
            }
            cell?.textLabel?.textColor  = HR_BLACK_COLOR
            cell?.textLabel?.font = HR_NORMAL_FONT
            cell?.textLabel?.text = self.nameList[section][row]
            if section == 0 {
                cell?.accessoryType = .none
                cell?.detailTextLabel?.text = "余额说明"
                cell?.detailTextLabel?.font = HR_SMALL_FONT
                cell?.detailTextLabel?.textColor = HR_BLUE_COLOR
                cell?.textLabel?.font = HR_BIG_FONT
                cell?.textLabel?.textColor = HR_GOLD_COLOR
                cell?.textLabel?.text = "余额：\(StringToInt(str: self.balance))元"
            }else {
                if row == 0 {
                    cell?.imageView?.image = UIImage(named: "alipay_icon")
                }else{
                    cell?.imageView?.image = UIImage(named: "wxpay_icon")
                }
                cell?.detailTextLabel?.text = ""
                let defaultBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                defaultBtn.setImage(UIImage(named:"default_no"), for: .normal)
                defaultBtn.setImage(UIImage(named:"sex_yes"), for: .selected)
                defaultBtn.addTarget(self, action: #selector(chooseWay(btn:)), for: .touchUpInside)
                defaultBtn.tag = 100+row
                if payWay == 0 {
                    if row == 0 {
                        defaultBtn.isSelected = true
                        self.payBtn = defaultBtn
                    }else{
                        defaultBtn.isSelected = false
                    }
                }else{
                    if row == 1 {
                        defaultBtn.isSelected = true
                        self.payBtn = defaultBtn
                    }else{
                        defaultBtn.isSelected = false
                    }
                }
                cell?.accessoryView =  defaultBtn
            }
            cell?.selectionStyle = .none
            return cell!
        }else{
            tableView.rowHeight = (HR_SCREEN_WIDTH-HR_MARGIN*6)/3+HR_MARGIN*7
            var cell:HRBalanceTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRBalanceTVCell
            if cell == nil {
                cell = HRBalanceTVCell(style: .value1, reuseIdentifier: "CELL1")
            }
            cell?.delegate = self
            cell?.selectionStyle = .none
            return cell!
        }
        
    }
    //MARK:选择充值金额
    func selectAmount(index: Int) {
        let titleArr = ["10元","50元","100元","500元","1000元","其他"]
        if index == 5 {
            HROtherAmountView.shared.show()
            HROtherAmountView.shared.callBack(block: { (value) in
                print("其他金额：\(value)")
            })
        }else{
            print("充值金额：\(titleArr[index])")
        }
    }
    //MARK:选择支付方式
    func chooseWay(btn:UIButton){
        if btn != self.payBtn {
            btn.isSelected = true
            self.payBtn.isSelected = false
            self.payBtn = btn
            self.payWay = self.payBtn.tag-100
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 && row == 0 {
            let VC = HRShowHtmlVC()
            VC.type = 2
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 40))
        headView.backgroundColor = HR_WHITE_COLOR
        let titleLab = UILabel(frame: CGRect(x: HR_MARGIN, y: 0, width: HR_SCREEN_WIDTH-HR_MARGIN*2, height: 40))
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.font = HR_NORMAL_FONT
        if section == 1 {
            titleLab.text = "请选择充值金额"
        }else if section == 2{
            titleLab.text = "请选择充值方式"
        }
        headView.addSubview(titleLab)
        return headView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
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
