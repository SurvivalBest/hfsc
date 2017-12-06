//
//  HRSecondVC.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON
private var conditionBtn:UIButton!
class HRSecondVC: HRBaseVC,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var curSort = 0
    var curPage = 1
    var curType = "0"
    var typeList:[HRTypeModel] = []
    var infoList:[HRTravelInfoModel] = []
    var currentCell:UITableViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavTitle(title: "")
        // Do any additional setup after loading the view.
        self.setNav()
        self.setUI()
        HRNetwork.shared.hr_getTourType { (list) in
            self.typeList = tourTypeList
            if self.typeList.count > 0 {
                self.curType = self.typeList[0].id
            }
            self.leftTV.reloadData()
            self.getData()
        }
    }
    deinit {
        mainTV.es_removeRefreshHeader()
        mainTV.es_removeRefreshFooter()
    }
    func getData(){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["areaid"] = HRDataSave.hr_getAreaid()
        param["sort"] = "\(self.curSort)"
        param["type"] = "\(self.curType)"
        param["page"] = "\(self.curPage)"
        param["num"] = "10"
        HRNetwork.shared.hr_getData(cmd: "getTourList", params: param, success: { (result) in
            self.mainTV.es_footer?.stopRefreshing()
            self.mainTV.es_header?.stopRefreshing()
            if self.curPage == 1 {
                self.infoList.removeAll()
            }
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRTravelInfoModel.deserialize(from: subJson.rawString()!)
                self.infoList.append(model!)
            }
            self.mainTV.reloadData()
            
        }) { (error) in
            self.mainTV.es_footer?.stopRefreshing()
            self.mainTV.es_header?.stopRefreshing()
        }
    }
    private func setNav(){
        //左边按钮
        let addressBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        addressBtn.setImage(UIImage(named:"home_location"), for: .normal)
        addressBtn.setTitle("上海", for: .normal)
        addressBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        addressBtn.titleLabel?.font = HR_NORMAL_FONT
        addressBtn.addTarget(self, action: #selector(changeLocationAddress), for: .touchUpInside)
        let leftFixed = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftFixed.width = -15
        self.navigationItem.leftBarButtonItems = [leftFixed,UIBarButtonItem(customView: addressBtn)]
        
        //右边按钮
        let messageBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        self.navigationItem.rightBarButtonItems = [leftFixed,UIBarButtonItem(customView: messageBtn)]
        
        //搜索框
        let searchBtn = UIButton(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 34))
        searchBtn.backgroundColor = HR_SEARCH_BG
        searchBtn.setTitle("  输入商品/商家关键字", for: .normal)
        searchBtn.setTitleColor(HR_GRAY_COLOR, for: .normal)
        searchBtn.titleLabel?.font = HR_NORMAL_FONT
        searchBtn.setImage(UIImage(named:"search_icon"), for: .normal)
        searchBtn.addTarget(self, action: #selector(goSearch), for: .touchUpInside)
        searchBtn.hr_setCronerRadius(radius: 17)
        self.navigationItem.titleView = searchBtn
    }
    
    
    //MARK:选择定位地址
    func changeLocationAddress(){
        
    }
    
    //MARK:跳转搜索界面
    func goSearch(){
        let VC = HRSearchVC()
        let NA = HRNavigationController(rootViewController: VC)
        self.present(NA, animated: true, completion: nil)
    }
    
    //MARK:头部筛选
    lazy private var sortScrollView:UIScrollView = {
        let tempScroll = UIScrollView()
        tempScroll.delegate = self
        tempScroll.showsVerticalScrollIndicator = false
        tempScroll.showsHorizontalScrollIndicator = false
        tempScroll.isPagingEnabled = false
        tempScroll.backgroundColor = HR_WHITE_COLOR
        let sortNameArr = ["综合排序","人气最旺","价格最低","精选路线"]
        let btnW = HR_SCREEN_WIDTH/4
        for i in 0..<sortNameArr.count{
            let tempButton = UIButton(frame: CGRect(x: btnW*CGFloat(i), y: 0, width: btnW, height: HR_TOP_HEIGHT))
            tempButton.setTitle(sortNameArr[i], for: .normal)
            tempButton.setTitleColor(HR_BLACK_COLOR, for: .normal)
            tempButton.setTitleColor(HR_THEME_COLOR, for: .selected)
            tempButton.titleLabel?.font = HR_NORMAL_FONT
            tempButton.addTarget(self, action: #selector(chooseCondition(btn:)), for: .touchUpInside)
            tempButton.tag = 10 + i
            tempScroll.addSubview(tempButton)
            if i == 0 {
                conditionBtn = tempButton
                conditionBtn.isSelected = true
            }
        }
        tempScroll.contentSize = CGSize(width: btnW*CGFloat(sortNameArr.count), height: HR_TOP_HEIGHT)
        return tempScroll
    }()
    //MARK:头部筛选
    func chooseCondition(btn:UIButton){
        if conditionBtn == btn {
            return
        }
        if conditionBtn != nil {
            conditionBtn.isSelected = false
        }
        btn.isSelected = true
        conditionBtn = btn
        curSort = btn.tag-10
        self.curPage = 1
        self.getData()
    }
    
    
    //MARK:左侧分类
//    lazy private var leftTV:UITableView = {
//        let tempTV = UITableView()
//        tempTV.delegate = self
//        tempTV.dataSource = self
//        tempTV.showsHorizontalScrollIndicator = false
//        tempTV.showsVerticalScrollIndicator = false
//        tempTV.tableFooterView = UIView(frame: CGRect.zero)
//        tempTV.separatorStyle = .none
//        tempTV.backgroundColor = HR_BG_COLOR
//        print("左侧分类")
//        return tempTV
//    }()
    var leftTV:UITableView!
    //MARK:右侧结果
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView()
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
        tempTV.separatorStyle = .none
        tempTV.backgroundColor = HR_BG_COLOR
        tempTV.backgroundColor = HR_BG_COLOR
        print("右侧结果")
        return tempTV
    }()
    
    private func setUI(){
        self.view.addSubview(self.sortScrollView)
        self.leftTV = UITableView()
        self.leftTV.delegate = self
        self.leftTV.dataSource = self
        self.leftTV.showsHorizontalScrollIndicator = false
        self.leftTV.showsVerticalScrollIndicator = false
        self.leftTV.tableFooterView = UIView(frame: CGRect.zero)
        self.leftTV.separatorStyle = .none
        self.leftTV.backgroundColor = HR_BG_COLOR
        self.view.addSubview(self.leftTV)
        self.view.addSubview(self.mainTV)
        self.sortScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(HR_HEADER_HEIGHT)
            make.left.right.equalTo(0)
            make.height.equalTo(HR_TOP_HEIGHT)
        }
        self.leftTV.snp.makeConstraints { (make) in
            make.top.equalTo(self.sortScrollView.snp.bottom)
            make.left.equalTo(0)
            make.bottom.equalTo(-HR_FOOTER_HEIGHT)
            make.width.equalTo(HR_SCREEN_WIDTH/4)
        }
        self.mainTV.snp.makeConstraints { (make) in
            make.top.equalTo(self.sortScrollView.snp.bottom)
            make.left.equalTo(self.leftTV.snp.right)
            make.bottom.equalTo(-HR_FOOTER_HEIGHT)
            make.right.equalTo(0)
        }
        
        self.mainTV.es_addPullToRefresh {
            [unowned self] in
            //下拉刷新
            self.curPage = 1
            self.getData()
        }
        self.mainTV.es_addInfiniteScrolling {
            [unowned self] in
            //上拉加载
            self.curPage += 1
            self.getData()
        }
    }
    
    func test(){
        for i in 0..<5 {
            let item = HRTravelInfoModel()
            item.title = "[元旦]海南三亚双飞5日游\(i+1)"
            item.price = "\((i+i)*25)"
            item.count = "\((i+i)*20)"
            self.infoList.append(item)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTV {
            return self.typeList.count
        }else{
            return self.infoList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.leftTV {
            tableView.rowHeight = 45
            var cell:UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
            }
            if self.typeList.count > indexPath.row {
                let info = self.typeList[indexPath.row]
                cell?.textLabel?.text = info.name
                cell?.textLabel?.textColor = HR_BLACK_COLOR
                cell?.textLabel?.font = HR_NORMAL_FONT
            }
            if indexPath.row == 0 {
                self.currentCell = cell
                self.currentCell?.backgroundColor = HR_SEARCH_BG
            }
            return cell!
        }else {
            tableView.rowHeight = HR_SCREEN_WIDTH/4*3/2+70
            var cell:HRTravelTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as! HRTravelTVCell?
            if cell == nil {
                cell = HRTravelTVCell(style: .default, reuseIdentifier: "CELL2")
            }
            if self.infoList.count > indexPath.row {
                let info = self.infoList[indexPath.row]
                cell?.setInfo(info: info)
            }
            if self.infoList.count == indexPath.row+1 {
                cell?.showLine(isShow: false)
            }else{
                cell?.showLine(isShow: true)
            }
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.leftTV {
            if self.currentCell != nil {
                self.currentCell?.backgroundColor = HR_WHITE_COLOR
            }
            let cell = tableView.cellForRow(at: indexPath)
            self.currentCell = cell
            self.currentCell?.backgroundColor = HR_SEARCH_BG
            self.curType = self.typeList[indexPath.row].id
            self.curPage = 1
            self.getData()
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
            if self.infoList.count > indexPath.row {
                let VC = HRGoodsDetailVC()
                VC.goodsID = self.infoList[indexPath.row].id
                VC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(VC, animated: true)
            }
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
