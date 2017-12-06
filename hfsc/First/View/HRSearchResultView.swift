//
//  HRSearchResultView.swift
//  hfsc
//
//  Created by innket on 17/11/17.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit
var searchResultTypeBtn:UIButton!
protocol HRSearchResultViewDelegate:NSObjectProtocol {
    //点击图片
    func showDetail(type:Int,id:String)
}

class HRSearchResultView: UIView,UITableViewDelegate,UITableViewDataSource {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(){
        self.backgroundColor = HR_BG_COLOR
        self.addSubview(self.topView)
        self.addSubview(self.mainTV)
        
        self.topView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(HR_TOP_HEIGHT)
        }
        self.mainTV.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    weak var delegate:HRSearchResultViewDelegate!
    
    var goodList:[HRGoodInfoModel] = []
    var shopList:[HRShopInfoModel] = []
    var isShop = false
    lazy var topView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_WHITE_COLOR
        let nameArr = ["商品","商家"]
        for i in 0..<nameArr.count{
            let firstBtn = UIButton(frame: CGRect(x: HR_SCREEN_WIDTH/2*CGFloat(i), y: 0, width: HR_SCREEN_WIDTH/2, height: HR_TOP_HEIGHT))
            firstBtn.setTitle(nameArr[i], for: .normal)
            firstBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
            firstBtn.setTitleColor(HR_THEME_COLOR, for: .selected)
            firstBtn.titleLabel?.font = HR_NORMAL_FONT
            firstBtn.tag = 10 + i
            firstBtn.addTarget(self, action: #selector(chooseType(btn:)), for: .touchUpInside)
            tempView.addSubview(firstBtn)
            if i == 0 {
                firstBtn.isSelected = true
                searchResultTypeBtn = firstBtn
            }
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: HR_TOP_HEIGHT-1, width: HR_SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        tempView.addSubview(lineView)
        return tempView
    }()
    lazy private var mainTV:UITableView = {
        let tempTV = UITableView(frame: HR_FULL_FRAME, style: .plain)
        tempTV.delegate = self
        tempTV.dataSource = self
        tempTV.showsHorizontalScrollIndicator = false
        tempTV.tableFooterView = UIView(frame: CGRect.zero)
//        tempTV.separatorStyle = .none
        tempTV.separatorColor = HR_LINE_COLOR
        tempTV.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tempTV.backgroundColor = HR_BG_COLOR
        return tempTV
    }()
    
    func chooseType(btn:UIButton){
        if searchResultTypeBtn == btn {
            return
        }
        if searchResultTypeBtn != nil {
            searchResultTypeBtn.isSelected = false
        }
        btn.isSelected = true
        searchResultTypeBtn = btn
        if btn.tag == 11 {
            isShop = true
        }else{
            isShop = false
        }
        self.mainTV.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShop {
            return self.shopList.count
        }else{
            return self.goodList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        tableView.rowHeight = 120
        if isShop {
            var cell:HRShopTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL1") as? HRShopTVCell
            if cell == nil {
                cell = HRShopTVCell(style: .default, reuseIdentifier: "CELL1")
            }
            if self.shopList.count > row {
                let info = self.shopList[row]
                cell?.setInfo(info: info)
            }
            return cell!
        }else{
            var cell:HRHomeGoodTVCell?
            cell = tableView.dequeueReusableCell(withIdentifier: "CELL2") as? HRHomeGoodTVCell
            if cell == nil {
                cell = HRHomeGoodTVCell(style: .default, reuseIdentifier: "CELL2")
            }
            if self.goodList.count > row {
                let info = self.goodList[row]
                cell?.setInfo(info: info)
            }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.delegate != nil{
            if isShop {
                if self.shopList.count > indexPath.row {
                    let info = self.shopList[indexPath.row]
                    self.delegate.showDetail(type: 2, id: info.id)
                }
            }else{
                if self.goodList.count > indexPath.row {
                    let info = self.goodList[indexPath.row]
                    self.delegate.showDetail(type: 1, id: info.id)
                }
            }
        }
    }

    func reloadResult(goodList:[HRGoodInfoModel],shopList:[HRShopInfoModel]){
        self.shopList = shopList
        self.goodList = goodList
        self.mainTV.reloadData()
    }

}
