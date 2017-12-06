//
//  HROrderInfoModel.swift
//  BigFish
//
//  Created by innket on 17/8/10.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation

class HROrderInfoModel: HRBaseModel {
    var id = ""
    var orderNO = ""
    var status = ""
    var statusStr = ""
    var time = ""
    var total = ""
    var type = ""
    
    var delivery = ""
    var deliveryStr = ""
    var userInfo:[String:String] = [:]
    var goodsList:[Any] = []
    var remark = ""
}
