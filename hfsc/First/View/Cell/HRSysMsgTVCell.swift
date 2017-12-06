//
//  HRSysMsgTVCell.swift
//  hfsc
//
//  Created by innket on 17/11/21.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

protocol HRSysMsgTVCellDelegate:NSObjectProtocol {
    func showDetail(id:String)
}

class HRSysMsgTVCell: UITableViewCell {

    weak var delegate:HRSysMsgTVCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var labH:CGFloat = 20

    lazy private var bodyView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_WHITE_COLOR
        return tempView
    }()
    lazy private var titleLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_NORMAL_FONT
        tempLab.textAlignment = .left
        tempLab.numberOfLines = 2
        return tempLab
    }()
    lazy private var detailBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.setTitle("立即查看", for: .normal)
        tempBtn.setTitleColor(HR_GOLD_COLOR, for: .normal)
        tempBtn.titleLabel?.font = HR_SMALL_FONT
        tempBtn.isHidden = true
        tempBtn.addTarget(self, action: #selector(showDetial), for: .touchUpInside)
        return tempBtn
    }()
    
    
    func showDetial(){
        if self.delegate != nil {
            self.delegate.showDetail(id: "\(self.detailBtn.tag)")
        }
    }
    lazy private var timeLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_GRAY_COLOR
        tempLab.font = HR_SMALL_FONT
        tempLab.textAlignment = .center
        return tempLab
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI();
    }
    
    private func setUI(){
        self.contentView.backgroundColor = HR_BG_COLOR
        self.contentView.addSubview(self.bodyView)
        self.contentView.addSubview(self.timeLab)
        
        self.bodyView.addSubview(self.titleLab)
        self.bodyView.addSubview(self.detailBtn)
        
        self.timeLab.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(40)
        }
        self.bodyView.snp.makeConstraints { (make) in
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.top.equalTo(self.timeLab.snp.bottom)
            make.height.equalTo(labH*2+HR_MARGIN*2+10)
        }
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(labH*2+10)
        }
        self.detailBtn.snp.makeConstraints { (make) in
            make.width.equalTo(55)
            make.left.equalTo(HR_MARGIN)
            make.bottom.equalTo(-HR_MARGIN)
            make.height.equalTo(labH)
        }
    }
    
    
    func setInfo(info:HRSysMsgInfoModel){
        self.titleLab.text = EmptyCheck(str: info.title)
        self.timeLab.text = "\(EmptyCheck(str: info.time))"
        if StringToInt(str: info.isHaveDetail) == 1 {
            self.detailBtn.isHidden = false
            self.detailBtn.tag = StringToInt(str: info.id)
            self.titleLab.snp.updateConstraints({ (make) in
                make.height.equalTo(labH)
            })
        }else {
            self.detailBtn.isHidden = true
            self.titleLab.snp.updateConstraints({ (make) in
                make.height.equalTo(labH*2+10)
            })
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
