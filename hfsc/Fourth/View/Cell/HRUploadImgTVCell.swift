//
//  HRUploadImgTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/24.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRUploadImgTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var imgArr:[String] = ["hr_alert"]

    var isHaveAlert = true
    let btnW:CGFloat = (HR_SCREEN_WIDTH-HR_MARGIN*4)/3
    lazy private var bodyView:UIView = {
        let tempView = UIView()
        return tempView
    }()
    lazy private var alertLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .left
        tempLab.numberOfLines = 2
        tempLab.text = "上传商家图片\n(首张为封面)"
        return tempLab
    }()
    lazy private var addBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage(named:"img_add"), for: .normal)
        tempBtn.addTarget(self, action: #selector(addImg), for: .touchUpInside)
        return tempBtn
    }()
    //MARK:添加图片
    func addImg(){
        self.imgArr.append("888")
        if self.imgArr.count <= 6 {
            let newView = self.creatNewView()
            newView.tag = self.imgArr.count+99
            self.bodyView.addSubview(newView)
            newView.frame = self.addBtn.frame
            if self.imgArr.count == 6 {
                self.addBtn.isHidden = true
            }else{
                self.addBtn.isHidden = false
                if self.imgArr.count != 3 {
                    var count = 0
                    if self.imgArr.count > 3 {
                        count = self.imgArr.count - 3
                    }else{
                        count = self.imgArr.count
                    }
                    self.addBtn.snp.updateConstraints({ (make) in
                        make.left.equalTo(self.alertLab.snp.right).offset(self.fitOffset(CGFloat(count)*(btnW+HR_MARGIN)+HR_MARGIN))
                    })
                }else{
                    self.addBtn.snp.updateConstraints({ (make) in
                        make.top.equalTo(btnW+HR_MARGIN)
                        make.left.equalTo(self.alertLab.snp.right).offset(self.fitOffset(HR_MARGIN))
                    })
                }
            }
        }
    }
    func creatNewView()->UIView{
        let view = UIView()
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        imgView.hr_setImage(name: self.imgArr[self.imgArr.count-1])
        view.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
        
        let delBtn = UIButton()
        delBtn.setImage(UIImage(named:"img_del"), for: .normal)
        delBtn.addTarget(self, action: #selector(deleteImg(btn:)), for: .touchUpInside)
        view.addSubview(delBtn)
        delBtn.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.width.height.equalTo(20)
        }
        return view
    }
    //MARK:删除图片
    func deleteImg(btn:UIButton){
        self.addBtn.isHidden = false
        let view = btn.superview
        let tag = view?.tag
        self.imgArr.remove(at: tag!-100)
        view?.removeFromSuperview()
        for subView in self.bodyView.subviews {
            if subView.tag > 99 {
                subView.removeFromSuperview()
            }
        }
        //行数
        var row = 0
        if self.imgArr.count == 0 {
            row = 0
        }
        else if self.imgArr.count%3 == 0 {
            row = self.imgArr.count/3
        }else{
            row = self.imgArr.count/3+1
        }
        if row == 2 {
            let count = self.imgArr.count-3
            self.addBtn.snp.updateConstraints({ (make) in
                make.top.equalTo(btnW+HR_MARGIN)
                make.left.equalTo(self.alertLab.snp.right).offset(self.fitOffset(CGFloat(count)*(btnW+HR_MARGIN)+HR_MARGIN))
            })
        }else{
            if self.imgArr.count == 3 {
                self.addBtn.snp.updateConstraints({ (make) in
                    make.top.equalTo(btnW+HR_MARGIN)
                    make.left.equalTo(self.alertLab.snp.right).offset(self.fitOffset(0))
                })
            }else{
                let count = self.imgArr.count
                self.addBtn.snp.updateConstraints({ (make) in
                    make.top.equalTo(0)
                    make.left.equalTo(self.alertLab.snp.right).offset(self.fitOffset(CGFloat(count)*(btnW+HR_MARGIN)+HR_MARGIN))
                })
            }
        }
        
        
        for i in 0..<row {
            //每行个数
            var count = 0
            if self.imgArr.count >= (i+1)*3 {
                count = 3
            }else{
                count = self.imgArr.count-3*i
            }
            var num = 0
            if i == 0 {
                if self.isHaveAlert {
                    num = 1
                }
            }
            for j in num..<count {
                let view = self.creatNewView()
                view.tag = 100 + i*3+j
                view.frame = CGRect(x: (btnW+HR_MARGIN)*CGFloat(j), y: (btnW+HR_MARGIN)*CGFloat(i), width: btnW, height: btnW)
                self.bodyView.addSubview(view)
            }
        }
    }
    func fitOffset(_ offset:CGFloat)->CGFloat{
        if self.isHaveAlert {
            return offset-btnW-HR_MARGIN
        }else{
            return offset-HR_MARGIN
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.addSubview(self.bodyView)
        self.bodyView.addSubview(self.alertLab)
        self.bodyView.addSubview(self.addBtn)
        
        self.bodyView.snp.makeConstraints { (make) in
            make.top.left.equalTo(HR_MARGIN)
            make.right.bottom.equalTo(-HR_MARGIN)
        }
        self.alertLab.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.width.height.equalTo(btnW)
        }
        
        self.addBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.alertLab.snp.right).offset(HR_MARGIN)
            make.top.equalTo(0)
            make.width.height.equalTo(btnW)
        }
        
    }
    
    func setInfo(info:HRAddressInfoModel){
        
        
    }
    
    func hideAlert(){
        self.isHaveAlert = false
        if self.imgArr.contains("hr_alert") {
            self.imgArr.removeFirst()
        }
        self.alertLab.snp.updateConstraints { (make) in
            make.width.height.equalTo(0)
        }
        self.addBtn.snp.updateConstraints { (make) in
            make.left.equalTo(self.alertLab.snp.right)
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
