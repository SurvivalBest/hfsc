//
//  AppDelegate.swift
//  hfsc
//
//  Created by innket on 17/11/13.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,JPUSHRegisterDelegate{
    var pageRotation:Bool = false
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        let tabBarVC = HRTabBarController()
        window?.rootViewController = tabBarVC
        //分享
        self.setShare()
        //定位
        self.setLocation()
        //推送
        self.setPush(options: launchOptions)
        return true
    }
    //MARK:分享
    func setShare(){
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = UM_KEY
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: WX_KEY, appSecret: WX_SECRET, redirectURL: REDIRECT_URL)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatTimeLine, appKey: WX_KEY, appSecret: WX_SECRET, redirectURL: REDIRECT_URL)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: QQ_KEY, appSecret: nil, redirectURL: REDIRECT_URL)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: WB_KEY, appSecret: WB_SECRET, redirectURL: REDIRECT_URL)
    }
    //MARK:定位
    func setLocation(){
        //高德地图
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = AMAP_KEY
    }
    //MARK:设置推送
    func setPush(options:[UIApplicationLaunchOptionsKey: Any]?){
        let entity = JPUSHRegisterEntity.init()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue)|Int(JPAuthorizationOptions.sound.rawValue)|Int(JPAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        JPUSHService.setup(withOption: options, appKey: JG_KEY, channel: "publish channer", apsForProduction: false)
        // 获取推送消息
        let remote = options?[UIApplicationLaunchOptionsKey.remoteNotification] as? Dictionary<String,Any>;
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
//            self.perform(#selector(receivePush), with: remote, afterDelay: 1.0);
        }
        JPUSHService.registrationIDCompletionHandler { (reCode, registID) in
            print("设备的标识：\(registID)")
            HR_USER_DEFA.set(EmptyCheck(str: registID), forKey: "DEVICE_TOKEN")
            HR_USER_DEFA.synchronize()
        }
        
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.pageRotation {
            return UIInterfaceOrientationMask.all
        }else{
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    
    //MARK:分享、登录代理
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result {
            if url.host == "safepay" {
                AlipaySDK.defaultService().processOrder(withPaymentResult: url as URL!, standbyCallback: {
                    (resultDic) -> Void in
                    //调起支付结果处理
                    print(resultDic)
                })
                return true
            }
            return WXApi.handleOpen(url, delegate: WXApiManager.shared)
        }
        return result
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        if !result {
            if url.host == "safepay" {
                AlipaySDK.defaultService().processOrder(withPaymentResult: url as URL!, standbyCallback: {
                    (resultDic) -> Void in
                    //调起支付结果处理
                    print(resultDic)
                })
                return true
            }
            return WXApi.handleOpen(url, delegate: WXApiManager.shared)
        }
        return result
    }
    
    //MARK:推送代理
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo;
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
            print("userInfo1：\(userInfo)")
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo;
        if response.notification.request.trigger is UNPushNotificationTrigger {
            print("userInfo2：\(userInfo)")
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler();
        // 应用打开的时候收到推送消息
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_ReceivePush), object: NotificationObject_Sueecess, userInfo: userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo3：\(userInfo)")
        JPUSHService.handleRemoteNotification(userInfo);
        completionHandler(UIBackgroundFetchResult.newData);
    }
    //MARK:上报DeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    //MARK:推送失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("推送失败：\(error)")
    }
    // 接收到推送实现的方法
    func receivePush(_ userInfo : Dictionary<String,Any>) {
        // 角标变0
        UIApplication.shared.applicationIconBadgeNumber = 0;
        print("userInfo4：\(userInfo)")
        // 剩下的根据需要自定义
        //        self.tabBarVC?.selectedIndex = 0;
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName_ReceivePush), object: NotificationObject_Sueecess, userInfo: userInfo)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

