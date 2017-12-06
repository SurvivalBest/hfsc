//
//  HRPayManager.swift
//  BigFish
//
//  Created by innket on 17/8/12.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit

class HRWXPayInfoModel:HRBaseModel{
    var AppID:String = ""
    var PrepayID:String = ""
    var NonceStr:String = ""
    var Package:String = ""
    var Timestamp:String = ""
    var PartnerID:String = ""
    var Sign:String = ""
}
class WXApiManager: NSObject, WXApiDelegate {
    static let shared = WXApiManager()
    open class func payWithInfo(info:HRWXPayInfoModel){
        let request = PayReq()
        request.nonceStr = EmptyCheck(str: info.NonceStr)    // 随机字符串
        request.package = EmptyCheck(str: info.Package)
        request.partnerId = EmptyCheck(str: info.PartnerID) // 商户号
        request.prepayId = EmptyCheck(str: info.PrepayID)  // 预支付订单
        request.timeStamp = UInt32(StringToInt(str: info.Timestamp))   // 时间戳
        request.sign = EmptyCheck(str: info.Sign)
        WXApi.send(request)
    }
}

extension WXApiManager {
    // 从微信应用程序返回到我们自己的APP时的回调方法，回调支付的结果信息。
    // 从左上角或其他方式返回到自己的 App，不会走这里的回调。
    func onResp(_ resp: BaseResp!) {
        if resp is PayResp {
            var strMsg: String
            switch resp.errCode {
            case 0:
                
                strMsg = "支付结果：成功！"
                HR_NOTIFICATION.post(name: NSNotification.Name(rawValue: "PAY_SUCCESS"), object: nil)
            default:
                strMsg = "支付结果：失败！retcode = \(resp.errCode), retstr = \(resp.errStr)"
                HR_NOTIFICATION.post(name: NSNotification.Name(rawValue: "PAY_ERROR"), object: nil)
            }
            
            
        }
    }
}

extension WXApiManager {
    // 检查用户是否已经安装微信并且有支付功能
    fileprivate func checkWXInstallAndSupport() {
        if !WXApi.isWXAppInstalled() {
             print("微信未安装")
        }
        if !WXApi.isWXAppSupport() {
            print("当前微信版本不支持支付")
        }
    }
}
