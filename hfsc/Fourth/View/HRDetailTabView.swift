//
//  HRDetailTabView.swift
//  BigFish
//
//  Created by innket on 17/7/17.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit

class HRDetailTabView: UIView,UIScrollViewDelegate {
    var viewW:CGFloat?
    var viewH:CGFloat?
    
    var lineView:UIView?
    let lineW:CGFloat = 60
    var lastBtn:UIButton?
    var itemCount:CGFloat = 0
    private var scrollView:UIScrollView!
    weak var delegate:HRDetailTabViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewH = frame.size.height
        viewW = frame.size.width
        self.setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI() {
        lineView = UIView()
        lineView?.backgroundColor = HR_THEME_COLOR
    }
    func setTitle(titleArr:[String]){
        if titleArr.count > 5 {
            itemCount = CGFloat(titleArr.count)
            self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: viewH!))
            self.scrollView.delegate = self
            self.scrollView.showsVerticalScrollIndicator = false
            self.scrollView.showsHorizontalScrollIndicator = false
            self.addSubview(self.scrollView)
            let btnW = viewW!/5
            for i in 0..<titleArr.count {
                let tempBtn = UIButton(frame:CGRect(x: btnW*CGFloat(i), y: 0, width: btnW, height: viewH!))
                tempBtn.setTitle(titleArr[i], for: .normal)
                tempBtn.setTitleColor(HR_THEME_COLOR, for: .selected)
                tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
                tempBtn.titleLabel?.font = HR_NORMAL_FONT
                tempBtn.tag = i+100
                tempBtn.addTarget(self, action: #selector(selectItem(btn:)), for: .touchUpInside)
                self.scrollView.addSubview(tempBtn)
                if i==0 {
                    lineView?.frame = CGRect(x: (btnW-lineW)/2, y: viewH!-3, width: lineW, height: 3)
                    tempBtn.isSelected = true
                    lastBtn = tempBtn
                }
            }
            self.scrollView.contentSize = CGSize(width: btnW*CGFloat(titleArr.count), height: viewH!)
            self.scrollView.addSubview(lineView!)
        }else{
            let btnW = viewW!/CGFloat(titleArr.count)
            for i in 0..<titleArr.count {
                let tempBtn = UIButton(frame:CGRect(x: btnW*CGFloat(i), y: 0, width: btnW, height: viewH!))
                tempBtn.setTitle(titleArr[i], for: .normal)
                tempBtn.setTitleColor(HR_THEME_COLOR, for: .selected)
                tempBtn.setTitleColor(HR_BLACK_COLOR, for: .normal)
                tempBtn.titleLabel?.font = HR_NORMAL_FONT
                tempBtn.tag = i+100
                tempBtn.addTarget(self, action: #selector(selectItem(btn:)), for: .touchUpInside)
                self.addSubview(tempBtn)
                if i==0 {
                    lineView?.frame = CGRect(x: (btnW-lineW)/2, y: viewH!-3, width: lineW, height: 3)
                    tempBtn.isSelected = true
                    lastBtn = tempBtn
                }
            }
            self.addSubview(lineView!)
        }
        let bottomLine = UIView(frame: CGRect(x: 0, y: viewH!-0.5, width: viewW!, height: 0.5))
        bottomLine.backgroundColor = HR_SEPARATOR_COLOR
        self.addSubview(bottomLine)
        
    }
    func selectItem(btn:UIButton) {
        if btn != lastBtn {
            lastBtn?.isSelected = false
            btn.isSelected = true
            lineView?.frame = CGRect(x: (btn.frame.width-lineW)/2+btn.frame.minX, y: viewH!-3, width: lineW, height: 3)
            lastBtn = btn
            delegate?.selectTab(index: btn.tag-100)
        }
    }
    
    func setTag(index:Int){
        
        var btn:UIButton!
        if self.scrollView == nil {
            btn = self.viewWithTag(index+100) as! UIButton
        }else{
            btn = self.scrollView.viewWithTag(index+100) as! UIButton
            if index > 4 {
                self.scrollView.contentOffset = CGPoint(x: btn.frame.width*(itemCount-CGFloat(index)), y: 0)
            }
        }
        if btn != lastBtn {
            lastBtn?.isSelected = false
            btn.isSelected = true
            lineView?.frame = CGRect(x: (btn.frame.width-lineW)/2+btn.frame.minX, y: viewH!-3, width: lineW, height: 3)
            lastBtn = btn
        }
    }
}

protocol HRDetailTabViewDelegate:NSObjectProtocol {
    func selectTab(index:Int)
}
