//
//  HRTextViewTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/25.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRTextViewTVCell: UITableViewCell,UITextViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    let btnW:CGFloat = (HR_SCREEN_WIDTH-HR_MARGIN*4)/3
    lazy private var bodyView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_BG_COLOR
        tempView.layer.cornerRadius = 10
        tempView.layer.masksToBounds = true
        return tempView
    }()
    lazy private var alertLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .left
        tempLab.text = "请填写商家介绍"
        return tempLab
    }()
    lazy private var numLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .right
        tempLab.text = "0/100"
        return tempLab
    }()
    lazy private var textView:UITextView = {
        let tempTV = UITextView()
        tempTV.backgroundColor = HR_BG_COLOR
        tempTV.delegate = self
        tempTV.textColor = HR_BLACK_COLOR
        tempTV.font = HR_SMALL_FONT
        tempTV.returnKeyType = .done
        tempTV.contentInset = UIEdgeInsetsMake(5, 5, 5, 5)
        return tempTV
    }()
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let str = textView.text + text
        if str.characters.count > 100{
            return false
        }
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        self.numLab.text = "\(textView.text.characters.count)/100"
        if textView.text.characters.count > 0 {
            self.alertLab.isHidden = true
        }else{
            self.alertLab.isHidden = false
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        self.bodyView.addSubview(self.textView)
        self.textView.addSubview(self.alertLab)
        self.bodyView.addSubview(self.numLab)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(HR_MARGIN)
            make.right.bottom.equalTo(-HR_MARGIN)
        }
        self.textView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        self.alertLab.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(5)
            make.right.equalTo(0)
            make.height.equalTo(13)
        }
        self.numLab.snp.makeConstraints { (make) in
            make.right.equalTo(-HR_MARGIN-5)
            make.bottom.equalTo(-HR_MARGIN)
            make.width.equalTo(80)
            make.height.equalTo(13)
        }
        
    }
    
    func setInfo(info:HRAddressInfoModel){
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
