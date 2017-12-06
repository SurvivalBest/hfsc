//
//  HRMyHeaderView.swift
//  hfsc
//
//  Created by innket on 17/11/16.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit
protocol HRMyHeaderViewDelegate:NSObjectProtocol {
    //点击图片
    func showUserInfo()
    func showDetail(type:Int)
}


class HRMyHeaderView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI(){
        self.backgroundColor = HR_WHITE_COLOR
        self.addSubview(self.userInfoView)
        self.userInfoView.addSubview(self.nameLab)
        self.userInfoView.addSubview(self.phoneIV)
        self.userInfoView.addSubview(self.phoneLab)
        self.userInfoView.addSubview(self.avatarIV)
        self.userInfoView.addSubview(self.detailIV)
        self.userInfoView.addSubview(self.infoBtn)
        self.addSubview(self.mainCV)
        self.addSubview(self.lineView)
        
        self.userInfoView.snp.makeConstraints { (make) in
            make.left.equalTo(HR_MARGIN)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-HR_STAR_WIDTH/4)
        }
        self.nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(-100)
            make.height.equalTo(40)
            make.top.equalTo(20)
        }
        self.phoneIV.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(self.nameLab.snp.bottom).offset(5)
            make.width.height.equalTo(15)
        }
        self.phoneLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.phoneIV.snp.right)
            make.right.equalTo(-100)
            make.height.equalTo(25)
            make.top.equalTo(self.nameLab.snp.bottom)
        }
        self.avatarIV.snp.makeConstraints { (make) in
            make.top.equalTo(20)
            make.right.equalTo(-HR_MARGIN-25)
            make.width.height.equalTo(60)
        }
        
        self.avatarIV.hr_setCronerRadius(radius: 30)
        self.detailIV.snp.makeConstraints { (make) in
            make.top.equalTo(45)
            make.right.equalTo(-HR_MARGIN)
            make.height.width.equalTo(15)
        }
        self.infoBtn.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
        self.mainCV.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(HR_SCREEN_WIDTH/4)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
            make.bottom.equalTo(-HR_SCREEN_WIDTH/4)
        }
    }
    weak var delegate:HRMyHeaderViewDelegate!
    private var nameArr = ["代发货","待收货","已结束","订单"]
    private var iconArr = ["my_1","my_2","my_3","my_4"]
    lazy var userInfoView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_WHITE_COLOR
        return tempView
    }()
    lazy var nameLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = UIFont.boldSystemFont(ofSize: 35)
        return tempLab
    }()
    lazy var phoneLab:UILabel = {
        let tempLab = UILabel()
        tempLab.textColor = HR_BLACK_COLOR
        tempLab.font = HR_SMALL_FONT
        return tempLab
    }()
    lazy var avatarIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.image = UIImage(named:"default_avatar")
        return tempIV
    }()
    lazy var phoneIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.image = UIImage(named:"my_phone")
        tempIV.contentMode = .scaleAspectFit
        return tempIV
    }()
    lazy var detailIV:UIImageView = {
        let tempIV = UIImageView()
        tempIV.image = UIImage(named:"go_detail")
        tempIV.contentMode = .scaleAspectFit
        return tempIV
    }()
    lazy var lineView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_LINE_COLOR
        return tempView
    }()
    lazy var infoBtn:UIButton = {
        let tempBtn = UIButton()
        tempBtn.addTarget(self, action: #selector(showInfo), for: .touchUpInside)
        return tempBtn
    }()
    
    lazy var mainCV:UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: HR_SCREEN_WIDTH/4, height: HR_SCREEN_WIDTH/4)
        flow.minimumLineSpacing = 0
        flow.minimumInteritemSpacing = 0
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let tempCV = UICollectionView(frame: CGRect(x: 0, y: 0, width: noticeH, height: noticeH), collectionViewLayout: flow)
        tempCV.delegate = self
        tempCV.dataSource = self
        tempCV.backgroundColor = HR_WHITE_COLOR
        tempCV.showsVerticalScrollIndicator = false
        tempCV.showsHorizontalScrollIndicator = false
        tempCV.register(HRItemCVCell.self, forCellWithReuseIdentifier: "ITEM-CELL")
        return tempCV
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nameArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell:HRItemCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ITEM-CELL", for: indexPath) as! HRItemCVCell
        cell.setIconAndName(icon: self.iconArr[item], name: self.nameArr[item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            self.delegate.showDetail(type: indexPath.item)
        }
    }
    //MARK:跳转个人信息
    func showInfo(){
        if self.delegate != nil {
            self.delegate.showUserInfo()
        }
    }

    func setInfo(info:HRUserInfoModel){
        if HRDataSave.hr_isLogin() {
            self.phoneLab.isHidden = false
            self.phoneIV.isHidden = false
        }else{
            self.nameLab.text = "您还未登录"
            self.phoneLab.isHidden = true
            self.phoneIV.isHidden = true
            self.avatarIV.image = HR_DEFAULT_AVATAR
            return
        }
        print(EmptyCheck(str: info.avatar))
        let imgUrl = URL(string: EmptyCheck(str: info.avatar))
        if imgUrl != nil{
            self.avatarIV.af_setImage(withURL: imgUrl!, placeholderImage: HR_DEFAULT_AVATAR)
        }
        self.nameLab.text = info.nickname
        
        if info.phone.characters.count > 4 {
            let phoneStar = info.phone.substring(to: info.phone.index(info.phone.startIndex, offsetBy: 3))
            let phoneEnd = info.phone.substring(from: info.phone.index(info.phone.endIndex, offsetBy: -4))
            self.phoneLab.text = "\(phoneStar)****\(phoneEnd)"
        }
    }

}
