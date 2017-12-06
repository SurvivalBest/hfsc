//
//  HRFilterView.swift
//  hfsc
//
//  Created by innket on 17/11/18.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
protocol HRFilterViewDelegate:NSObjectProtocol {
    func refreshInfo(type:Int,index:Int)
}
class HRFilterView: UIView,HRSelectItemViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    deinit {
//        if curBtn != nil {
//            self.selectView.removeFromSuperview()
//        }
    }
    public var type = 0
    public var index = 0
    
    weak var delegate:HRFilterViewDelegate!
    var itemArr:[String] = []
    
    //MARK:获取旅游专区分类
    func getTravelType(success:(_ nameArr:[String])->()){
        HRNetwork.shared.hr_test {
            let arr = ["全部","跟团游","自助游","邮轮游"]
            success(arr)
        }
    }
    //MARK:获取活动分类
    func getActivityType(success:(_ nameArr:[String])->()){
        HRNetwork.shared.hr_test {
            let arr = ["全部","门店活动","合作商家活动"]
            success(arr)
        }
    }
    //MARK:获取商品种类
    func getGoodsType(success:(_ nameArr:[String])->()){
        HRNetwork.shared.hr_test {
            let arr = ["全部","健康养生","粮油副食"]
            success(arr)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HR_WHITE_COLOR
    }
    
    func setFilterCount(titleArr:[String]){
        self.hr_removeAllSubviews()
        let btnW = HR_SCREEN_WIDTH/CGFloat(titleArr.count)
        for i in 0..<titleArr.count {
            let tempBtn = UIButton(frame:CGRect(x: btnW*CGFloat(i), y: 0, width: btnW, height: HR_TOP_HEIGHT))
            tempBtn.setTitle(titleArr[i], for: .normal)
            tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
            tempBtn.titleLabel?.font = HR_NORMAL_FONT
            tempBtn.setTitleColor(HR_THEME_COLOR, for: .selected)
            tempBtn.setImage(UIImage(named:"detail_down"), for: .normal)
            tempBtn.setImage(UIImage(named:"detail_up"), for: .selected)
            setBtnImgRight(btn: tempBtn)
            tempBtn.tag = 100 + i
            tempBtn.addTarget(self, action: #selector(showSelect(btn:)), for: .touchUpInside)
            self.addSubview(tempBtn)
        }
        
        let lineView = UIView(frame: CGRect(x: 0, y: HR_TOP_HEIGHT-1, width: HR_SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = HR_LINE_COLOR
        self.addSubview(lineView)
    }
    lazy var selectView:HRSelectItemView = {
        let view = HRSelectItemView()
        view.delegate = self
        view.isHidden = true
        UIApplication.shared.keyWindow?.addSubview(view)
        return view
    }()
    //当前选择标签
    var curBtn:UIButton!
    
    func setBtnImgRight(btn:UIButton){
        let imageW = UIImage(named: "detail_down")?.size.width
        btn.titleLabel?.sizeToFit()
        let titleW = btn.titleLabel?.frame.size.width
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, titleW!, 0, -titleW!)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageW!, 0, imageW!)
    }
    
    func showSelect(btn:UIButton){
        if self.selectView.isHidden {
            btn.isSelected = true
            curBtn = btn
            index = curBtn.tag - 100
            self.selectView.isHidden = false
            if type == 1 {
                //旅游专区
                if index == 0 {
                    //旅游专区->分类
//                    self.getTravelType(success: { (nameArr) in
//                        self.itemArr = nameArr
//                        self.selectView.setItems(itemArr: nameArr)
//                    })
                    HRNetwork.shared.hr_getTourType(success: { (list) in
                        var nameArr:[String] = []
                        for info in list {
                            nameArr.append(EmptyCheck(str: info.name))
                        }
                        self.itemArr = nameArr
                        self.selectView.setItems(itemArr: nameArr)
                    })
                }else if index == 1 {
                    //旅游专区->排序
                    self.itemArr =  ["销量最高","好评优先","价格最低","价格最高"]
                }else {
                    self.itemArr =  ["全部"]
                }
            }else if type == 2 {
                //活动专区
                if index == 0 {
                    //分类
                    self.getActivityType(success: { (nameArr) in
                        self.itemArr = nameArr
                        self.selectView.setItems(itemArr: nameArr)
                    })
                }else if index == 1 {
                    //状态
                    self.itemArr =  ["全部","未开始","进行中","已结束"]
                }else if index == 2 {
                    //费用
                    self.itemArr =  ["全部","免费","付费"]
                }else{
                    self.itemArr =  ["全部"]
                }
            }else if type == 3 {
                //商城专区
                if index == 0 {
                    //分类
                    self.itemArr =  ["全部","鸿福商品","积分商品","返利商品"]
                }else if index == 1 {
                    //种类
                    HRNetwork.shared.hr_getGoodsType(success: { (list) in
                        var nameArr:[String] = []
                        for info in list {
                            nameArr.append(EmptyCheck(str: info.name))
                        }
                        self.itemArr = nameArr
                        self.selectView.setItems(itemArr: nameArr)
                    })
//                    self.getGoodsType(success: { (nameArr) in
//                        self.itemArr = nameArr
//                        self.selectView.setItems(itemArr: nameArr)
//                    })
                }else if index == 2 {
                    //排序
                    self.itemArr =  ["销量最高","好评优先","价格最低","价格最高"]
                }else{
                    self.itemArr =  ["全部"]
                }
            }else if type == 4 {
                //异业联盟
                if index == 0 {
                    //种类
                    HRNetwork.shared.hr_getGoodsType(success: { (list) in
                        var nameArr:[String] = []
                        for info in list {
                            nameArr.append(EmptyCheck(str: info.name))
                        }
                        self.itemArr = nameArr
                        self.selectView.setItems(itemArr: nameArr)
                    })
//                    self.getGoodsType(success: { (nameArr) in
//                        self.itemArr = nameArr
//                        self.selectView.setItems(itemArr: nameArr)
//                    })
                }else if index == 1 {
                    //条件
                    self.itemArr =  ["距离最近","好评优先"]
                }else{
                    self.itemArr =  ["全部"]
                }
            }else if type == 5 {
                //鸿富商城、返利商城、积分商城
                if index == 0 {
                    //种类
                    HRNetwork.shared.hr_getGoodsType(success: { (list) in
                        var nameArr:[String] = []
                        for info in list {
                            nameArr.append(EmptyCheck(str: info.name))
                        }
                        self.itemArr = nameArr
                        self.selectView.setItems(itemArr: nameArr)
                    })
//                    self.getGoodsType(success: { (nameArr) in
//                        self.itemArr = nameArr
//                        self.selectView.setItems(itemArr: nameArr)
//                    })
                }else if index == 1 {
                    //条件
                    self.itemArr =  ["销量最高","好评优先","价格最低","价格最高"]
                }else{
                    self.itemArr =  ["全部"]
                }
            }else {
                self.itemArr = ["全部"]
            }
            self.selectView.setItems(itemArr: self.itemArr)
        }else {
            self.selectView.isHidden = true
            curBtn.isSelected = false
        }
    }
    
    func selectItem(index: Int) {
        self.selectView.isHidden = true
        curBtn.isSelected = false
        if index == -1 {
            return
        }
        curBtn.setTitle(self.itemArr[index], for: .normal)
        setBtnImgRight(btn: curBtn)
        if self.delegate != nil {
            self.delegate.refreshInfo(type: curBtn.tag-100, index: index)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
