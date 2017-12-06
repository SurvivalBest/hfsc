//
//  Swift-Bridge-OC.h
//  hfsc
//
//  Created by innket on 17/11/13.
//  Copyright © 2017年 黄冉. All rights reserved.
//

#ifndef Swift_Bridge_OC_h
#define Swift_Bridge_OC_h

// U-Share核心SDK
#import <UMSocialCore/UMSocialCore.h>
// U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
#import <UShareUI/UShareUI.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//微信
#import "WXApi.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>

#import <CommonCrypto/CommonDigest.h>


//高德地图
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


#endif /* Swift_Bridge_OC_h */
