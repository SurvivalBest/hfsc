//
//  HRSearchVC.swift
//  hfsc
//
//  Created by innket on 17/11/17.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRSearchVC: HRBaseVC,UITextFieldDelegate,HRSearchHistoryViewDelegate,HRSearchResultViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        self.setUI()
        // Do any additional setup after loading the view.
    }
    private var isShowKeyboard = true
    //MARK:创建导航栏
    private func setNav(){
        
        //间隙
        let leftFixed = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftFixed.width = -15
        
        //左边按钮
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 44))
        backBtn.setImage(UIImage(named:"nav_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        
        //右边按钮
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 44))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
        cancelBtn.titleLabel?.font = HR_NORMAL_FONT
        cancelBtn.addTarget(self, action: #selector(tapCancel), for: .touchUpInside)
        
        let fiexView = UIView(frame: CGRect(x: 0, y: 0, width: HR_MARGIN, height: 44))
        
        if isShowKeyboard {
            self.navigationItem.rightBarButtonItems = [leftFixed,UIBarButtonItem(customView: cancelBtn)]
            self.navigationItem.leftBarButtonItems = [leftFixed,UIBarButtonItem(customView: fiexView)]
        }else{
            self.navigationItem.leftBarButtonItems = [leftFixed,UIBarButtonItem(customView: backBtn)]
            self.navigationItem.rightBarButtonItems = [leftFixed,UIBarButtonItem(customView: fiexView)]
        }
        
        
        self.navigationItem.titleView = self.searchTF
    }
    //MARK://搜索框
    lazy var searchTF:UITextField = {
        let tempTF = UITextField(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: 34))
        tempTF.backgroundColor = HR_SEARCH_BG
        tempTF.placeholder = " 输入商品/商家关键字"
        tempTF.textColor = HR_BLACK_COLOR
        tempTF.font = HR_NORMAL_FONT
        tempTF.hr_setCronerRadius(radius: 17)
        
        let leftIV = UIImageView(frame: CGRect(x: 20, y: 7, width: 40, height: 20))
        leftIV.image = UIImage(named: "search_icon")
        leftIV.contentMode = .scaleAspectFit
        tempTF.leftView = leftIV
        tempTF.leftViewMode = .always
        tempTF.returnKeyType = .search
        tempTF.delegate = self
        tempTF.clearButtonMode = .whileEditing
        tempTF.becomeFirstResponder()
        return tempTF
    }()
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            self.isShowKeyboard = false
            self.setNav()
            textField.resignFirstResponder()
            HRDataSave.hr_saveSearchHistory(keyword: textField.text!)
            self.historyView.reloadHistory()
            self.showResult()
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.isShowKeyboard = true
        self.setNav()
        self.showHistory()
        return true
    }
    
    //MARK:取消按钮
    func tapCancel(){
        self.isShowKeyboard = false
        self.setNav()
        self.searchTF.resignFirstResponder()
        if (self.searchTF.text?.characters.count)! > 0 {
            self.showResult()
            return
        }
        self.goBack()
        
    }
    //MARK:返回上一页
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setUI(){
        self.view.addSubview(self.historyView)
        self.view.addSubview(self.resultView)
    }
    
    //MARK:搜索结果
    lazy var resultView:HRSearchResultView = {
        let tempView = HRSearchResultView(frame: HR_FULL_FRAME)
        tempView.isHidden = true
        tempView.delegate = self
        return tempView
    }()
    
    func showDetail(type: Int, id: String) {
        if type == 1 {
            print("商品详情\(id)")
            let VC = HRGoodsDetailVC()
            VC.goodsID = id
            self.navigationController?.pushViewController(VC, animated: true)
        }else{
            print("商家详情\(id)")
            let VC = HRShopDetailVC()
            VC.shopID = id
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func showResult(){
        var goodArr:[HRGoodInfoModel] = []
        var shopArr:[HRShopInfoModel] = []
        for i in 0..<5 {
            let good = HRGoodInfoModel()
            good.id = "\(i)"
            good.title = "安慕希牛奶"
            good.unit = "25瓶/箱"
            good.price = "200"
            good.count = "500"
            good.level = "85"
            goodArr.append(good)
            
            let shop = HRShopInfoModel()
            shop.id = "\(i)"
            shop.title = "安慕希牛奶"
            shop.address = "上海市普陀区武宁智慧园"
            shop.distance = "200m"
            shop.level = "4.4"
            shopArr.append(shop)
        }
        self.resultView.reloadResult(goodList: goodArr, shopList: shopArr)
        self.resultView.isHidden = false
        self.historyView.isHidden = true
    }
    
    func showHistory(){
        self.resultView.isHidden = true
        self.historyView.isHidden = false
    }
    
    //MARK:历史记录
    lazy private var historyView:HRSearchHistoryView = {
        let tempView = HRSearchHistoryView(frame: HR_FULL_FRAME)
        tempView.delegate = self
        return tempView
    }()
    
    //MARK:点击历史记录
    func searchHistory(keyword: String) {
        print("点击的：\(keyword)")
        self.searchTF.resignFirstResponder()
        self.isShowKeyboard = false
        self.setNav()
        HRDataSave.hr_saveSearchHistory(keyword: keyword)
        self.historyView.reloadHistory()
        self.showResult()
        
    }
    //MARK:删除历史记录
    func deleteHistory() {
        let alertView = UIAlertController(title: "提示", message: "确定要删除历史搜索记录吗？", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "删除", style: .default, handler: { (cancelView) in
            HRDataSave.hr_removeSearchHistory()
            self.historyView.reloadHistory()
        }))
        alertView.addAction(UIAlertAction(title: "取消", style: .default, handler: { (otherView) in
        }))
        self.present(alertView, animated: true, completion: nil)
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
