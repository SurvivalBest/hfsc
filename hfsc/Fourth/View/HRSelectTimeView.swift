//
//  HRSelectTimeView.swift
//  hfsc
//
//  Created by innket on 17/11/25.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRSelectTimeView: UIView{
    
    typealias CALL_BACK  = (String)->()
    var block:CALL_BACK?
    
    static let shared = HRSelectTimeView.init()
    private let pickerH:CGFloat = 200
    private let btnH:CGFloat = 40
    private let btnW:CGFloat = 60
    private var currentDate = Date()
    private var picker:UIDatePicker!
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT))
        UIApplication.shared.keyWindow?.addSubview(self)
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
        if let block = self.block {
            block(self.getTime(date: self.currentDate))
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
        
        let tempPicker = UIDatePicker(frame:CGRect(x: 0, y: btnH, width: HR_SCREEN_WIDTH, height: pickerH))
        tempPicker.locale = NSLocale(localeIdentifier: "zh_CN") as Locale
        tempPicker.backgroundColor = UIColor.white
        tempPicker.datePickerMode = .date
        tempPicker.maximumDate = Date()
        tempPicker.minimumDate = Date(timeIntervalSince1970: 0)
        tempPicker.addTarget(self, action: #selector(changeDate(picker:)), for: .valueChanged)
        self.picker = tempPicker
        bodyView.addSubview(self.picker)
        self.addSubview(bodyView)
    }
    //MARK:切换时间
    func changeDate(picker:UIDatePicker){
        //获取当前选中的时间
        self.currentDate = picker.date
    }
    //获取时间
    func getTime(date:Date) -> String{
        let formatterR = DateFormatter();
        formatterR.dateFormat = "yyyy-MM-dd";
        let dateStr = formatterR.string(from: date);
        return dateStr
    }
    
    func show(block:@escaping CALL_BACK){
        self.block = block
        self.isHidden = false
    }
}
