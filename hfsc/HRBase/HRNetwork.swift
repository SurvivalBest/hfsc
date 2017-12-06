//
//  HRNetwork.swift
//  hfsc
//
//  Created by innket on 17/11/20.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

import Alamofire
public let HR_BASE_URL = "http://139.196.20.81:8080/shop-cloud-api/api/"

//旅游类型
public var tourTypeList:[HRTypeModel] = []
//商家分类
public var shopTypeList:[HRTypeModel] = []
//商品分类
public var goodsTypeList:[HRTypeModel] = []


class HRNetwork: NSObject {
    
    /*
     *  获取数据
     */
    func getData(params:Parameters,success:@escaping (_ result:JSON)->(),failure:@escaping (_ error:Any)->()){
        let headers: HTTPHeaders = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json",
            "Content-Type":"application/json"
        ]
        
        Alamofire.request("\(HR_BASE_URL)\(params["cmd"]!)", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print("请求参数：\(params)")
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                if(json["result"].intValue == 0){
                    print("请求结果:\(json)")
                    success(json)
                }else{
                    print("请求失败:\(json)")
                    failure(json["resultMsg"].stringValue)
                    UIApplication.shared.keyWindow?.noticeOnlyText(json["resultMsg"].stringValue)
                }
            case .failure(let error):
                print("错误原因：\(error)")
                failure(error)
                UIApplication.shared.keyWindow?.noticeOnlyText("连接出错!")
            }
        }
    }
    
    static let shared = HRNetwork.init()
    
    func hr_test(suc:()->()){
        suc()
    }

    func hr_login(success:(_ result:JSON)->()){
        
    }
    
    //MARK:获取验证字符串
    private func getVerify(cmd:String,ts:String,param:Parameters)->String{
        
        var verifyStr = cmd + ts
        
        //print("排序前：\(param)")
        //按照键升序排列
        let keyArr = param.keys.sorted { (key1, key2) -> Bool in
            return key1 < key2 ? true:false
        }
        //print("排序后：\(keyArr)")
        for key in keyArr {
            let value = param[key]
            if value != nil {
                if value is String {
                    //print("值为：\(value as! String)")
                    verifyStr += value as! String
                }
            }
        }
        print("\(verifyStr)=========\(verifyStr.md5)")
        return verifyStr.md5
    }
    
    //MARK:获取完整参数
    private func getParams(cmd:String,param:Parameters)->Parameters{
        
        var allParams:Parameters = [:]
        allParams["cmd"] = cmd
        allParams["app"] = "ios"
        allParams["version"] = hr_getAppVersion()
        allParams["ts"] = hr_getTimeStamp()
        
        var tempParams:Parameters = param
        tempParams["verify"] = getVerify(cmd: cmd, ts: allParams["ts"] as! String, param: param)
        
        allParams["params"] = tempParams
        return allParams
        
//        var allParams:Parameters = [:]
//        allParams["cmd"] = cmd
//        allParams["ts"] = hr_getTimeStamp()
//        allParams["app"] = "ios"
//        allParams["version"] = hr_getAppVersion()
//        allParams["params"] = param
//        return allParams
    }
    
    //MARK:获取数据
    func hr_getData(cmd:String,params:Parameters,success:@escaping (_ result:JSON)->(),failure:@escaping (_ failure:Any)->()){
        UIApplication.shared.keyWindow?.pleaseWait()
        HRNetwork.shared.getData(params: getParams(cmd: cmd, param: params), success: { (reuslt) in
            UIApplication.shared.keyWindow?.clearAllNotice()
            success(reuslt)
        }) { (error) in
            UIApplication.shared.keyWindow?.clearAllNotice()
            failure(error)
        }
    }
    //MARK: - 照片上传
    ///
    /// - Parameters:
    ///   - urlString: 服务器地址
    ///   - params: ["flag":"","userId":""] - flag,userId 为必传参数
    ///        flag - 666 信息上传多张  －999 服务单上传  －000 头像上传
    ///   - data: image转换成Data
    ///   - name: fileName
    ///   - success:
    ///   - failture:
    func hr_uploadImage(img : UIImage, params:[String:String],success : @escaping (_ result:JSON)->(), failure : @escaping (_ failure:Any)->()){
        
        let headers = ["content-type":"multipart/form-data"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                //666多张图片上传
//                let flag = params["flag"]
//                let userId = params["userId"]
//                
//                multipartFormData.append((flag?.data(using: String.Encoding.utf8)!)!, withName: "flag")
//                multipartFormData.append( (userId?.data(using: String.Encoding.utf8)!)!, withName: "userId")
//                for i in 0..<(data?.count)! {
                      //上传多张图片
//                    multipartFormData.append(data, withName: "photo", fileName: "icon.png", mimeType: "image/png")
//                }
                let data = UIImagePNGRepresentation(img)
                multipartFormData.append(data!, withName: "photo", fileName: "icon.png", mimeType: "image/png")
            },
            to: String(format:"%@%@",HR_BASE_URL,"upload"),
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: AnyObject]{
                            let json = JSON(value)
                            if(json["result"].intValue == 0){
                                print("请求结果:\(json)")
                                success(json)
                            }else{
                                print("请求失败:\(json)")
                                failure(json["resultMsg"].stringValue)
                                UIApplication.shared.keyWindow?.noticeOnlyText(json["resultMsg"].stringValue)
                            }
                        }
                    }
                case .failure(let encodingError):
                    failure(encodingError)
                    UIApplication.shared.keyWindow?.noticeOnlyText("上传失败!")
                }
            }
        )
    }

    //MARK:旅游分类
    func hr_getTourType(success:@escaping (_ typeList:[HRTypeModel])->()){
        if (tourTypeList.count != 0) {
            success(tourTypeList)
            return
        }
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getTourType", params: param, success: { (result) in
            var infoList:[HRTypeModel] = []
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRTypeModel.deserialize(from: subJson.rawString()!)
                infoList.append(model!)
            }
            tourTypeList = infoList
            success(infoList)
        }) { (error) in
        }
    }
    
    //MARK：商家分类
    func hr_getShopType(success:@escaping (_ typeList:[HRTypeModel])->()){
        if (shopTypeList.count != 0) {
            success(shopTypeList)
            return
        }
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getShopType", params: param, success: { (result) in
            var infoList:[HRTypeModel] = []
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRTypeModel.deserialize(from: subJson.rawString()!)
                infoList.append(model!)
            }
            shopTypeList = infoList
            success(infoList)
        }) { (error) in
        }
    }
    
    
    //MARK：商品分类
    func hr_getGoodsType(success:@escaping (_ typeList:[HRTypeModel])->()){
        if (goodsTypeList.count != 0) {
            success(goodsTypeList)
            return
        }
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getGoodsType", params: param, success: { (result) in
            var infoList:[HRTypeModel] = []
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRTypeModel.deserialize(from: subJson.rawString()!)
                infoList.append(model!)
            }
            goodsTypeList = infoList
            success(infoList)
        }) { (error) in
        }
    }
    
    //MARK：获取地区列表
    func hr_getArea(id:String,success:@escaping (_ areaList:[HRTypeModel])->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = id
        HRNetwork.shared.hr_getData(cmd: "getArea", params: param, success: { (result) in
            var infoList:[HRTypeModel] = []
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRTypeModel.deserialize(from: subJson.rawString()!)
                infoList.append(model!)
            }
            success(infoList)
        }) { (error) in
        }
    }
    
}
