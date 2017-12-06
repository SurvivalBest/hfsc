//
//  HRSelectAddressView.swift
//  hfsc
//
//  Created by innket on 17/11/25.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRSelectAddressView: UIView ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    typealias CALL_BACK = (String,Int)->()
    var selectAddress:CALL_BACK?
    
    static let shared = HRSelectAddressView.init()
    private let pickerH:CGFloat = 200
    private let btnH:CGFloat = 40
    private let btnW:CGFloat = 60
    private var startIndex = 0
    private var endIndex = 0
    private var startLab:UILabel!
    private var endLab:UILabel!
    
    //地址ID
    var addressID:Int = 0
    //上次选择的省份ID
    var lastSelectP:Int = 0
    //上次选择的城市ID
    var lastSelectC:Int = 0
    //性别
    var sexTag:Int = 0
    //上次选择的省
    var lastPName:String = ""
    //上次选择的城市
    var lastCName:String = ""
    //上次的区名
    var lastRName:String = ""
    
    var proviceList:[HRAreaInfoModel] = []
    var cityList:[HRAreaInfoModel] = []
    var regionList:[HRAreaInfoModel] = []
    private var picker:UIPickerView!
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT))
        UIApplication.shared.keyWindow?.addSubview(self)
        self.getAddress(type: 1, id: 0) { (list) in
            self.proviceList = list
            self.picker.reloadAllComponents()
        }
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:选择操作按钮
    func selectInfoHandleView()->UIView{
        let handleView = UIView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: btnH))
        handleView.backgroundColor = HR_WHITE_COLOR;
        
        let cancelBtn = UIButton(frame: CGRect(x: HR_MARGIN, y: 0, width: btnW, height: handleView.frame.height))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(HR_GRAY_COLOR, for: .normal)
        cancelBtn.titleLabel?.font = HR_NORMAL_FONT
        cancelBtn.addTarget(self, action: #selector(cancelSelect), for: .touchUpInside)
        cancelBtn.backgroundColor = .white
        handleView.addSubview(cancelBtn)
        
        let titleLab = UILabel(frame: CGRect(x: btnW+HR_MARGIN, y: 0, width: HR_SCREEN_WIDTH-btnW*2-HR_MARGIN*2, height: btnH))
        titleLab.font = HR_BIG_FONT
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.textAlignment = .center
        titleLab.text = ""
        handleView.addSubview(titleLab)
        
        let sureBtn = UIButton(frame: CGRect(x: HR_SCREEN_WIDTH-btnW-HR_MARGIN, y: 0, width: btnW, height: handleView.frame.height))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(HR_THEME_COLOR, for: .normal)
        sureBtn.titleLabel?.font = HR_NORMAL_FONT
        sureBtn.backgroundColor = .white
        sureBtn.addTarget(self, action: #selector(sureSelect), for: .touchUpInside)
        handleView.addSubview(sureBtn)
        return handleView
    }
    //MARK:确认选择
    func sureSelect(){
        self.isHidden = true
        if self.selectAddress != nil {
            self.selectAddress!("\(self.lastPName)\(self.lastCName)\(self.lastRName)",self.lastSelectC)
        }
    }
    
    //取消选择
    func cancelSelect(){
        self.isHidden = true
    }
    func setUI() {
        self.backgroundColor = HR_BLACK_COLOR.withAlphaComponent(0.3)
        
        let bodyView = UIView(frame: CGRect(x: 0, y: HR_SCREEN_HEIGHT-pickerH-btnH, width: HR_SCREEN_WIDTH, height: pickerH+btnH))
        bodyView.backgroundColor = HR_WHITE_COLOR
        bodyView.addSubview(selectInfoHandleView())
        
        let picker = UIPickerView(frame:CGRect(x: 0, y: btnH, width: HR_SCREEN_WIDTH, height: pickerH))
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = HR_WHITE_COLOR
        self.picker = picker
        bodyView.addSubview(self.picker)
        self.addSubview(bodyView)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.proviceList.count
        }else if component == 1 {
            return self.cityList.count
        }else {
            return self.regionList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var info:HRAreaInfoModel? = nil
        if component == 0 {
            if self.proviceList.count > row {
                info = self.proviceList[row]
            }
        }else if component == 1 {
            if self.cityList.count > row {
                info = self.cityList[row]
            }
        }else {
            if self.regionList.count > row {
                info = self.regionList[row]
            }
        }
        if (info != nil) {
            return EmptyCheck(str: info?.name)
        }
        return  ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var info = HRAreaInfoModel()
        if component == 0 {
            if self.proviceList.count > row {
                info = self.proviceList[row]
                self.lastPName = (EmptyCheck(str: info.name))
                self.addressID = info.id
            }
            if row != lastSelectP {
                lastSelectP = row
                self.getAddress(type: 2, id: info.id, success: { (cList) in
                    self.cityList = cList
                    if self.cityList.count > 0 {
                        self.lastCName  = EmptyCheck(str: self.cityList[0].name)
                        self.addressID = self.cityList[0].id
                    }else{
                        self.lastCName = ""
                    }
                    self.picker.reloadComponent(1)
                    self.picker.selectRow(0, inComponent: 1, animated: true)
                    if self.cityList.count > 0 {
                        let model = self.cityList[0]
                        self.getAddress(type: 3, id: model.id, success: { (regionList) in
                            self.regionList = regionList
                            if self.regionList.count > 0 {
                                self.lastRName  = EmptyCheck(str: self.regionList[0].name)
                                self.addressID = self.regionList[0].id
                            }else{
                                self.lastRName = ""
                            }
                            self.picker.reloadComponent(2)
                            self.picker.selectRow(0, inComponent: 2, animated: true)
                        })
                    }
                })
            }
        }else if component == 1 {
            if self.cityList.count > row {
                info = self.cityList[row]
                self.lastCName = (EmptyCheck(str: info.name))
                self.addressID = info.id
            }
            if row != lastSelectC {
                lastSelectC = row
                getAddress(type: 3, id: info.id,  success: { (cList) in
                    self.regionList = cList
                    if self.regionList.count > 0 {
                        self.lastRName  = EmptyCheck(str: self.regionList[0].name)
                        self.addressID = self.regionList[0].id
                    }else{
                        self.lastRName = ""
                    }
                    self.picker.reloadComponent(2)
                    self.picker.selectRow(0, inComponent: 2, animated: true)
                })
            }
        }else {
            if self.regionList.count > row {
                info = self.regionList[row]
                self.lastRName = (EmptyCheck(str: info.name))
                self.addressID = info.id
            }
        }
    }
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        let titleLab = UILabel()
//        titleLab.font = HR_NORMAL_FONT
//        titleLab.textColor = HR_BLACK_COLOR
//        titleLab.textAlignment = .center
//        if self.timeArr.count > row {
//            titleLab.text = self.timeArr[row]
//        }
//        if component == 0 {
//            if row == startIndex {
//                titleLab.font = HR_BIG_FONT
//                titleLab.textColor = HR_THEME_COLOR
//                self.startLab = titleLab
//            }
//        }else {
//            if row == endIndex {
//                titleLab.font = HR_BIG_FONT
//                titleLab.textColor = HR_THEME_COLOR
//                self.endLab = titleLab
//            }
//        }
//        return titleLab
//    }
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 35
//    }
    
    func getAddress(type:Int,id:Int,success:@escaping (_ list:[HRAreaInfoModel])->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        param["id"] = "\(id)"
        param["type"] = "\(type)"
        HRNetwork.shared.hr_getData(cmd: "getArea", params: param, success: { (result) in
            var infoList:[HRAreaInfoModel] = []
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRAreaInfoModel.deserialize(from: subJson.rawString()!)
                infoList.append(model!)
            }
            success(infoList)
            }) { (error) in
                let infoList:[HRAreaInfoModel] = []
                success(infoList)
        }
        
    }
    
    func show(getAddress:@escaping CALL_BACK){
        self.selectAddress = getAddress
        self.isHidden = false
        self.picker.reloadAllComponents()
    }
}
