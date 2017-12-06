//
//  HRHomeHeaderView.swift
//  hfsc
//
//  Created by innket on 17/11/15.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit
var noticeH:CGFloat = 35

protocol HRHomeHeaderViewDelegate:NSObjectProtocol {
    //点击图片
    func showBannerDetail(info:HRBannerInfoModel)
    func showNoticeDetail(info:HRNoticeInfoModel)
    func showDetail(type:Int)
}

class HRHomeHeaderView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,HRBannerViewDelegate{

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
        self.addSubview(self.bannerView)
        self.addSubview(self.adView)
        self.addSubview(self.mainCV)
        
        self.bannerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(HR_SCREEN_WIDTH*HR_IMAGE_SCALE)
        }
        self.adView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bannerView.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(noticeH)
        }
        self.mainCV.snp.makeConstraints { (make) in
            make.top.equalTo(self.adView.snp.bottom).offset(5)
            make.left.right.equalTo(0)
            make.height.equalTo(HR_SCREEN_WIDTH/4)
        }
    }
    weak var delegate:HRHomeHeaderViewDelegate!
    private var nameArr = ["旅游专区","活动专区","商城专区","异业联盟"]
    private var iconArr = ["home_travel","home_activity","home_store","home_merchant"]
    lazy var bannerView:HRBannerView = {
        let tempView = HRBannerView(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH, height: HR_SCREEN_WIDTH*HR_IMAGE_SCALE))
        tempView.delegate = self
        return tempView
    }()
    lazy var adView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_WHITE_COLOR
        
        let iconIV = UIImageView(frame: CGRect(x: 10, y: 10, width: noticeH-20, height: noticeH-20))
        iconIV.image = UIImage(named: "home_notice")
        tempView.addSubview(iconIV)
        return tempView
    }()
    
    lazy var adScroll:UIScrollView = {
        let tempScroll = UIScrollView(frame: CGRect(x: noticeH, y: 0, width: HR_SCREEN_WIDTH-noticeH-HR_MARGIN, height: noticeH))
        tempScroll.showsHorizontalScrollIndicator = false
        tempScroll.showsVerticalScrollIndicator = false
        tempScroll.isPagingEnabled = true
        return tempScroll
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
        return 4
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
    
    //MARK:点击banner
    func tapImage(index: Int) {
        if index >= 0 {
            if self.delegate != nil {
                self.delegate.showBannerDetail(info: self.bannerList[index])
            }
        }
    }
    
    var bannerList:[HRBannerInfoModel] = []
    var noticeList:[HRNoticeInfoModel] = []
    
    func setInfo(bannerList:[HRBannerInfoModel],noticeList:[HRNoticeInfoModel]){
        self.bannerList = bannerList
        self.noticeList = noticeList
        if bannerList.count == 0 {
            self.bannerView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
        }else{
            var nameArr:[String] = []
            for i in 0..<bannerList.count {
                let info = bannerList[i]
                nameArr.append(EmptyCheck(str: info.icon))
            }
            self.bannerView.setImages(imgArr: nameArr)
            self.bannerView.snp.updateConstraints({ (make) in
                make.height.equalTo(HR_SCREEN_WIDTH*HR_IMAGE_SCALE)
            })
        }
        if noticeList.count == 0 {
            self.adView.snp.updateConstraints({ (make) in
                make.height.equalTo(0)
            })
            self.mainCV.snp.updateConstraints({ (make) in
                make.top.equalTo(self.adView.snp.bottom)
            })
        }else{
            self.adView.addSubview(self.adScroll)
            for i in 0..<noticeList.count {
                let info = noticeList[i]
                let tempLab = UILabel(frame: CGRect(x: 0, y: noticeH*CGFloat(i), width: self.adScroll.frame.width, height: self.adScroll.frame.height))
                tempLab.text = info.title
                tempLab.textColor = HR_GRAY_COLOR
                tempLab.font = HR_NORMAL_FONT
                tempLab.isUserInteractionEnabled = true
                tempLab.tag = 10 + i
                let tap = UITapGestureRecognizer(target: self, action: #selector(clickNotice(tap:)))
                tempLab.addGestureRecognizer(tap)
                self.adScroll.addSubview(tempLab)
            }
            self.adScroll.contentSize = CGSize(width: self.adScroll.frame.width, height: noticeH*CGFloat(noticeList.count))
        }
        
    }
    
    func clickNotice(tap:UITapGestureRecognizer){
        if self.delegate != nil {
            self.delegate.showNoticeDetail(info: self.noticeList[(tap.view?.tag)!-10])
        }
    }
}
