//
//  HRSeclectOpenTimeView.swift
//  hfsc
//
//  Created by innket on 17/11/25.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRSeclectOpenTimeView: UIView ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    typealias CALL_BACK = (String)->()
    var block:CALL_BACK?
    
    
    static let shared = HRSeclectOpenTimeView.init()
    private let pickerH:CGFloat = 200
    private let btnH:CGFloat = 40
    private let btnW:CGFloat = 60
    private var startIndex = 0
    private var endIndex = 0
    private var startLab:UILabel!
    private var endLab:UILabel!
    lazy private var timeArr:[String] = {
        return  [
        "00:00","00:30",
        "01:00","01:30",
        "02:00","02:30",
        "03:00","03:30",
        "04:00","04:30",
        "05:00","05:30",
        "06:00","06:30",
        "07:00","07:30",
        "08:00","08:30",
        "09:00","09:30",
        "10:00","10:30",
        "11:00","11:30",
        "12:00","12:30",
        "13:00","13:30",
        "14:00","14:30",
        "15:00","15:30",
        "16:00","16:30",
        "17:00","17:30",
        "18:00","18:30",
        "19:00","19:30",
        "20:00","20:30",
        "21:00","21:30",
        "22:00","22:30",
        "23:00","23:30"]
    }()
    private var picker:UIPickerView!
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
        titleLab.text = "开始时间-结束时间"
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
            block("\(self.timeArr[self.startIndex])~\(self.timeArr[self.endIndex])")
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
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.timeArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.timeArr.count > row {
            return self.timeArr[row]
        }
        return  ""
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let titleLab = UILabel()
        titleLab.font = HR_NORMAL_FONT
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.textAlignment = .center
        if self.timeArr.count > row {
            titleLab.text = self.timeArr[row]
        }
        if component == 0 {
            if row == startIndex {
                titleLab.font = HR_BIG_FONT
                titleLab.textColor = HR_THEME_COLOR
                self.startLab = titleLab
            }
        }else {
            if row == endIndex {
                titleLab.font = HR_BIG_FONT
                titleLab.textColor = HR_THEME_COLOR
                self.endLab = titleLab
            }
        }
        return titleLab
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            self.startLab.textColor = HR_BLACK_COLOR
            self.startLab.font = HR_NORMAL_FONT
            self.startIndex = row
        }else {
            self.endLab.textColor = HR_BLACK_COLOR
            self.endLab.font = HR_NORMAL_FONT
            self.endIndex = row
        }

        let lab1:UILabel!
        lab1 = pickerView.view(forRow: row, forComponent: component) as! UILabel!
        lab1.textColor = HR_THEME_COLOR
        lab1.font = HR_BIG_FONT
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func show(block:@escaping CALL_BACK){
        self.block = block
        self.isHidden = false
        self.picker.reloadAllComponents()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.isHidden = true
    }
}
