//
//  HRDataSave.swift
//  hfsc
//
//  Created by innket on 17/11/17.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

public let kChangeAvatar = NSNotification.Name(rawValue: "CHANGE_AVATAR")
public let kChangeName = NSNotification.Name(rawValue: "CHANGE_NAME")
public let kChangeVipNum = NSNotification.Name(rawValue: "CHANGE_VIP_NUMBER")
public let kChangeWay = NSNotification.Name(rawValue: "CHANGE_WAY")
public let kChangeAddress = NSNotification.Name(rawValue: "CHANGE_ADDRESS")
public let kChangeShop = NSNotification.Name(rawValue: "CHANGE_SHOP")

class HRDataSave: NSObject {
    
    
    static let shared = HRDataSave.init()
    
    //MARK:保存userid
    static public func hr_saveUserid(userid:String){
        HR_USER_DEFA.set(userid, forKey: "userid")
        HR_USER_DEFA.synchronize()
    }
    //MARK:获取userid
    static public func hr_getUserid()->String{
        if (HR_USER_DEFA.string(forKey: "userid") != nil){
            return HR_USER_DEFA.string(forKey: "userid")!
        }
        return "0"
    }
    //MARK:删除userid
    static public func hr_removeUserid(){
        HR_USER_DEFA.removeObject(forKey: "userid")
        HR_USER_DEFA.synchronize()
    }
    
    //MARK:保存areaid
    static public func hr_saveAreaid(areaid:String){
        HR_USER_DEFA.set(areaid, forKey: "areaid")
        HR_USER_DEFA.synchronize()
    }
    //MARK:获取areaid
    static public func hr_getAreaid()->String{
        if (HR_USER_DEFA.string(forKey: "areaid") != nil){
            return HR_USER_DEFA.string(forKey: "areaid")!
        }
        return "0"
    }
    //MARK:删除areaid
    static public func hr_removeAreaid(){
        HR_USER_DEFA.removeObject(forKey: "areaid")
        HR_USER_DEFA.synchronize()
    }
    
    //MARK:保存userType
    static public func hr_saveUserType(userid:String){
        HR_USER_DEFA.set(userid, forKey: "userType")
        HR_USER_DEFA.synchronize()
    }
    //MARK:删除userType
    static public func hr_removeUserType(){
        HR_USER_DEFA.removeObject(forKey: "userType")
        HR_USER_DEFA.synchronize()
    }
    
    //MARK:判断是否登录
    static public func hr_isLogin() -> Bool{
        let userid = HR_USER_DEFA.string(forKey: "userid")
        if StringToInt(str: userid) > 0 {
            return true
        }else{
           return false
        }
    }
    
    
    //MARK:跳转登录页面
    static public func hr_goLogin(VC:UIViewController){
        let loginVC = HRLoginVC()
        loginVC.hidesBottomBarWhenPushed = true
        VC.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    //MARK:保存搜索历史
    static public func hr_saveSearchHistory(keyword:String){
        let searchHistory = HR_USER_DEFA.array(forKey: "search-history")
        var historyArr:[String] = []
        if searchHistory != nil {
            historyArr = searchHistory as! [String]
        }
        if historyArr.count > 20 {
            historyArr.removeLast()
        }
        if historyArr.contains(keyword){
            historyArr.remove(at: historyArr.index(of: keyword)!)
        }
        historyArr.insert(keyword, at: 0)
        HR_USER_DEFA.set(historyArr, forKey: "search-history")
        HR_USER_DEFA.synchronize()
    }
    
    //MARK:获取搜索历史记录
    static public func hr_getSearchHistory() -> [String]{
        let searchHistory = HR_USER_DEFA.array(forKey: "search-history")
        if searchHistory != nil {
            return searchHistory as! [String]
        }else{
            return []
        }
    }
    
    //MARK:删除所有的历史记录
    static public func hr_removeSearchHistory(){
        HR_USER_DEFA.removeObject(forKey: "search-history")
        HR_USER_DEFA.synchronize()
    }
    
}
