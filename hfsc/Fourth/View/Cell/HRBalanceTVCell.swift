//
//  HRBalanceTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

protocol HRBalanceTVCellDelegate:NSObjectProtocol {
    func selectAmount(index:Int)
}

class HRBalanceTVCell: UITableViewCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var selectedBtn:UIButton!
    var delegate:HRBalanceTVCellDelegate!
    var infoList:[String] = []
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUI()
    }
    private func setUI(){
        let titleArr = ["10元","50元","100元","500元","1000元","其他"]
        let detailArr = ["(10余额)","(50余额)","(100余额)","(500余额)","(1000余额)",""]
        let btnW = (HR_SCREEN_WIDTH-HR_MARGIN*6)/3
        let btnH = (HR_SCREEN_WIDTH-HR_MARGIN*6)/3/2
        for i in 0..<2 {
            for j in 0..<3 {
                let tempBtn = UIButton(frame: CGRect(x: CGFloat(j)*(HR_MARGIN*2+btnW)+HR_MARGIN, y: CGFloat(i)*(HR_MARGIN*2+btnH)+HR_MARGIN*2, width: btnW, height: btnH))
                tempBtn.layer.borderColor = HR_GOLD_COLOR.cgColor
                tempBtn.layer.borderWidth = 1
                tempBtn.tag = i*3+j+100
                tempBtn.addTarget(self, action: #selector(chooseCount(btn:)), for: .touchUpInside)
                
                let lab1 = UILabel()
                lab1.textColor = HR_BLACK_COLOR
                lab1.textAlignment = .center
                lab1.font = HR_NORMAL_FONT
                lab1.tag = 10
                lab1.text = titleArr[i*3+j]
                if i == 1 && j == 2 {
                    lab1.frame = CGRect(x: 0, y: 0, width: btnW, height: btnH)
                }else{
                    lab1.frame = CGRect(x: 0, y: 5, width: btnW, height: btnH/2-5)
                }
                tempBtn.addSubview(lab1)
                let lab2 = UILabel()
                lab2.textColor = HR_GOLD_COLOR
                lab2.font = HR_NORMAL_FONT
                lab2.textAlignment = .center
                lab2.tag = 20
                if i == 1 && j == 2 {
                    lab2.frame = CGRect.zero
                }else{
                    lab2.frame = CGRect(x: 0, y: btnH/2, width: btnW, height: btnH/2-5)
                    lab2.text = detailArr[i*3+j]
                }
                tempBtn.addSubview(lab2)
                self.contentView.addSubview(tempBtn)
                if i==0 && j==0 {
                    self.btnSelected(btn: tempBtn)
                    self.selectedBtn = tempBtn
                }else{
                    self.btnUnSelected(btn: tempBtn)
                }
            }
        }
    }
    //MARK:选择金额
    func chooseCount(btn:UIButton){
        if self.selectedBtn == btn {
            return
        }
        self.btnSelected(btn: btn)
        self.btnUnSelected(btn: self.selectedBtn)
        self.selectedBtn = btn
        if self.delegate != nil {
            self.delegate.selectAmount(index: btn.tag-100)
        }
    }
    //MARK:选中
    func btnSelected(btn:UIButton){
        btn.backgroundColor = HR_GOLD_COLOR
        btn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        for subView in btn.subviews {
            if subView is UILabel {
                let lab = subView as! UILabel
                lab.textColor = HR_WHITE_COLOR
            }
        }
    }
    //MARK:未选中
    func btnUnSelected(btn:UIButton){
        btn.backgroundColor = HR_WHITE_COLOR
        btn.setTitleColor(HR_WHITE_COLOR, for: .normal)
        for subView in btn.subviews {
            if subView is UILabel {
                let lab = subView as! UILabel
                if lab.tag == 10 {
                    lab.textColor = HR_BLACK_COLOR
                }else if lab.tag == 20 {
                    lab.textColor = HR_GOLD_COLOR
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
