//
//  HRSearchHistoryView.swift
//  hfsc
//
//  Created by innket on 17/11/17.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SnapKit
protocol HRSearchHistoryViewDelegate:NSObjectProtocol {
    //点击图片
    func searchHistory(keyword:String)
    func deleteHistory()
}
class HRSearchHistoryView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
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
        self.backgroundColor = HR_BG_COLOR
        
        self.historyArr = HRDataSave.hr_getSearchHistory()
        self.addSubview(self.topView)
        self.topView.addSubview(self.deleteBtn)
        self.addSubview(self.mainCV)

        self.topView.snp.makeConstraints { (make) in
            make.top.equalTo(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.height.equalTo(30)
        }
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.width.equalTo(20)
            make.right.equalTo(-5)
            make.bottom.equalTo(-5)
        }
        self.mainCV.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(HR_MARGIN)
            make.left.equalTo(HR_MARGIN)
            make.right.equalTo(-HR_MARGIN)
            make.bottom.equalTo(0)
        }
    }
    weak var delegate:HRSearchHistoryViewDelegate!
    private var historyArr:[String] = []
    lazy var topView:UIView = {
        let tempView = UIView()
        tempView.backgroundColor = HR_BG_COLOR
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 0, width: HR_SCREEN_WIDTH/2, height: 30))
        titleLab.text = "历史搜索"
        titleLab.textColor = HR_BLACK_COLOR
        titleLab.font = HR_BIG_FONT
        tempView.addSubview(titleLab)
        return tempView
    }()
    lazy var deleteBtn:UIButton = {
        let tempBtn = UIButton()
//        tempBtn.backgroundColor = HR_RED_COLOR
        tempBtn.setImage(UIImage(named:"delete_icon"), for: .normal)
        tempBtn.addTarget(self, action: #selector(deleteHistory), for: .touchUpInside)
        return tempBtn
    }()
    lazy var mainCV:UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = HR_MARGIN
        flow.minimumInteritemSpacing = HR_MARGIN
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let tempCV = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flow)
        tempCV.delegate = self
        tempCV.dataSource = self
        tempCV.backgroundColor = HR_BG_COLOR
        tempCV.showsVerticalScrollIndicator = false
        tempCV.showsHorizontalScrollIndicator = false
        tempCV.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "HISTORY-CELL")
        return tempCV
    }()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.historyArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HISTORY-CELL", for: indexPath)
        cell.contentView.hr_removeAllSubviews()
        if self.historyArr.count > item {
//            print("======\(cell.frame)")
//            print("------\(cell.contentView.frame)")
            let tempLab = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            tempLab.textColor = HR_GRAY_COLOR
            tempLab.font = HR_NORMAL_FONT
            tempLab.text = self.historyArr[item]
            tempLab.textAlignment = .left
            cell.contentView.addSubview(tempLab)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.delegate != nil {
            if self.historyArr.count > indexPath.item {
                self.delegate.searchHistory(keyword: self.historyArr[indexPath.item])
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if self.historyArr.count > indexPath.item {
            let value = self.historyArr[indexPath.item]
            let valueSize = calculateOneLineStringSize(str: value, font: HR_NORMAL_FONT)
            return CGSize(width: valueSize.width+HR_MARGIN, height: valueSize.height+HR_MARGIN)
        }
        return CGSize.zero
    }
    
    
    func deleteHistory(){
        if self.delegate != nil {
            self.delegate.deleteHistory()
        }
    }
    
    func reloadHistory(){
        self.historyArr = HRDataSave.hr_getSearchHistory()
        self.mainCV.reloadData()
    }
}
