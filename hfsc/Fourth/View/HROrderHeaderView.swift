//
//  HROrderHeaderView.swift
//  BigFish
//
//  Created by innket on 17/8/10.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HROrderHeaderView: UIView {
    var viewW:CGFloat!
    var viewH:CGFloat!
    
    var orderNoLab:UILabel!
    var statusLab:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewH = frame.size.height
        viewW = frame.size.width
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        self.backgroundColor = HR_BG_COLOR
        let contentView = UIView()
        contentView.backgroundColor = HR_WHITE_COLOR
        self.addSubview(contentView)
        if viewH > HR_TOP_HEIGHT {
            contentView.snp.makeConstraints { (make) in
                make.top.equalTo(5)
                make.bottom.left.right.equalTo(0)
            }
        }else{
            contentView.snp.makeConstraints { (make) in
                make.top.equalTo(0)
                make.bottom.left.right.equalTo(0)
            }
        }
        orderNoLab = UILabel()
        orderNoLab.textColor = HR_BLACK_COLOR
        orderNoLab.textAlignment = .left
        orderNoLab.font = HR_NORMAL_FONT
        orderNoLab.text = "订单编号："
        contentView.addSubview(orderNoLab)
        
        self.orderNoLab.snp.makeConstraints { (make) in
            make.left.equalTo(HR_MARGIN)
            make.top.bottom.equalTo(0)
            make.width.equalTo(viewW/3*2-HR_MARGIN)
        }
        
        statusLab = UILabel()
        statusLab.textColor = HR_THEME_COLOR
        statusLab.textAlignment = .right
        statusLab.font = HR_SMALL_FONT
        contentView.addSubview(statusLab)
        
        self.statusLab.snp.makeConstraints { (make) in
            make.right.equalTo(-HR_MARGIN)
            make.top.bottom.equalTo(0)
            make.left.equalTo(viewW/3-HR_MARGIN)
        }
    }
    
    func setInfo(orderNo:String,status:Int,type:Int){
        self.orderNoLab.text = "订单号：\(orderNo)"
        if type == 1 {
            //正常订单
            switch status {
            case 1:
                //等待买家付款
                self.statusLab.text = "等待卖家发货"
                self.statusLab.textColor = HR_GOLD_COLOR
            case 2:
                //待收货
                self.statusLab.text = "等待收货"
                self.statusLab.textColor = HR_GOLD_COLOR
            default:
                //交易失败
                self.statusLab.text = "已完成"
                self.statusLab.textColor = HR_GOLD_COLOR
            }
        }else {
            //售后
//            1：换货中 2：退货中，未填退货单 3：退货中，已查收 4：退货完成 5：换货完成
            switch status {
            case 1:
                //换货中
                self.statusLab.text = "待处理"
            case 2:
                //退货中，未填退货单
                self.statusLab.text = "同意申请"
            case 3:
                //退货中，已查收
                self.statusLab.text = "已查收"
            case 4:
                //退货完成
                self.statusLab.text = "已完成"
            case 5:
                //换货完成
                self.statusLab.text = "已拒绝"
                self.statusLab.textColor = HR_RED_COLOR
            default:
                //
                self.statusLab.text = ""
            }
        }
        
    }
}
