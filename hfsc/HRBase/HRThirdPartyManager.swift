//
//  HRThirdPartyManager.swift
//  BigFish
//
//  Created by innket on 17/8/12.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation

class HRThirdPartyManager {
    
    //MARK:第三方分享
    open class func shareToPlatform(platform:UMSocialPlatformType,info:HRInviteInfoModel,VC:UIViewController){
        let msgObj:UMSocialMessageObject = UMSocialMessageObject.init()
        let shareObj = UMShareWebpageObject.init()
        if EmptyCheck(str: info.shareTitle).characters.count > 0 {
            shareObj.title = info.shareTitle
        }else {
            shareObj.title = SHARE_TITLE
        }
        if EmptyCheck(str: info.shareDetail).characters.count > 0 {
            shareObj.descr = info.shareDetail
        }else {
            shareObj.descr = SHARE_DETAIL
        }
        if EmptyCheck(str: info.shareIcon).characters.count > 0 {
            shareObj.thumbImage = info.shareIcon
        }else {
            shareObj.thumbImage = SHARE_ICON
        }
        if EmptyCheck(str: info.shareUrl).characters.count > 0 {
            shareObj.webpageUrl = info.shareUrl
        }else {
            shareObj.webpageUrl = SHARE_URL
        }
        msgObj.shareObject = shareObj
        UMSocialManager.default().share(to: platform, messageObject: msgObj, currentViewController: VC) { (result, error) in
            if error != nil {
                print("share Fail with error \(error)")
            }else{
                print("share successed")
            }
        }
    }
    
    //MARK:第三方登录
    open class func loginToPlatform(platform:UMSocialPlatformType,success:@escaping (_ name:String,_ openID:String,_ poster:String)->()){
        UMSocialManager.default().getUserInfo(with: platform, currentViewController: nil, completion: { (result, error) in
            if ((error) != nil) {
                print("login Fail with error \(error)")
            } else {
                let resp:UMSocialUserInfoResponse = result as! UMSocialUserInfoResponse;
                
                // 授权信息
                print("uid: \(resp.uid)");
                print("openid: \(resp.openid)");
                print("unionid: \(resp.unionId)");
                print("accessToken: \(resp.accessToken)");
                
                print("Wechat refreshToken: \(resp.refreshToken)" );
                print("expiration: \(resp.expiration)");

                
                // 用户信息
                print("name: \(resp.name)");
                print("iconurl: \(resp.iconurl)");
                print("unionGender: \(resp.unionGender)");
                
                // 第三方平台SDK源数据
                print("QQ originalResponse: \(resp.originalResponse)");
                
                success(resp.name!,resp.uid!,resp.iconurl!);
            }
        })
    }
    
    
    open class func payToPlatform(type:Int){
        if type == 1 {
            //微信
        }else{
            //支付宝
            
        }
        
    }
    
}
