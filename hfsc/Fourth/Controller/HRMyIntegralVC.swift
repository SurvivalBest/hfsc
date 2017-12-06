//
//  HRMyIntegralVC.swift
//  hfsc
//
//  Created by innket on 17/11/23.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import SwiftyJSON

class HRMyIntegralVC: HRBaseVC ,UICollectionViewDelegate,UICollectionViewDataSource,HRIntegralHeaderViewDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNav()
        self.getData {
            self.setUI()
        }
        // Do any additional setup after loading the view.
    }

    var isSign = 0
    var integral = "0"
    var infoList:[HRGoodInfoModel] = []
    private func setNav(){
        setNavTitle(title: "我的积分")
        self.navigationItem.rightBarButtonItem = self.setBarButton(title: "明细", event: #selector(goDetail))
    }
    //MARK:跳转设置
    func goDetail(){
        let VC = HRIntegralDetailVC();
        self.navigationController?.pushViewController(VC, animated: true)
    }
    lazy var mainCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (HR_SCREEN_WIDTH-HR_MARGIN*3)/2, height: (HR_SCREEN_WIDTH-HR_MARGIN*3)/2+40+HR_MARGIN*2)
        layout.minimumLineSpacing = HR_MARGIN
        layout.minimumInteritemSpacing = HR_MARGIN
        layout.sectionInset = UIEdgeInsetsMake(0, HR_MARGIN, 0, HR_MARGIN)
        
        let tempCV = UICollectionView(frame: HR_FULL_FRAME, collectionViewLayout: layout)
        tempCV.delegate = self
        tempCV.dataSource = self
        tempCV.backgroundColor = HR_BG_COLOR
        tempCV.showsHorizontalScrollIndicator = false
        tempCV.register(HRIntegralGoodsCVCell.self, forCellWithReuseIdentifier: "CELL")
        tempCV.register(HRIntegralHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        return tempCV
    }()
    func getData(success:@escaping ()->()){
        var param:[String:String] = [:]
        param["userid"] = HRDataSave.hr_getUserid()
        HRNetwork.shared.hr_getData(cmd: "getMyIntegral", params: param, success: { (result) in
            self.integral = result["body"]["integral"].stringValue
            self.isSign = result["body"]["isSign"].intValue
            for (_,subJson):(String,JSON) in result["body"]["list"] {
                let model = HRGoodInfoModel.deserialize(from: subJson.rawString()!)
                self.infoList.append(model!)
            }
            success()
        }) { (error) in
        }
    }
    func setUI(){
        self.view.addSubview(self.mainCV)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.infoList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell:HRIntegralGoodsCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! HRIntegralGoodsCVCell
        if self.infoList.count > item {
            cell.setInfo(info: self.infoList[item])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = indexPath.item
        if self.infoList.count > item {
            let VC = HRGoodsDetailVC()
            VC.goodsID = self.infoList[item].id
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as! HRIntegralHeaderView
        if kind == UICollectionElementKindSectionHeader {
            headerView.setInfo(amount: self.integral, isSign: "\(self.isSign)")
            headerView.delegate = self
            return headerView
        }
        return headerView
    }
    //MARK:积分说明
    func showIntegralExplain() {
        let VC = HRShowHtmlVC()
        VC.type = 3
        self.navigationController?.pushViewController(VC, animated: true)
    }
    //MARK:签到
    func sign(btn: UIButton) {
        btn.isEnabled = false
        btn.layer.borderColor = HR_GRAY_COLOR.cgColor
        self.isSign = 1
        HRSignSuccessView.shared.setInfo(integral: "5", num: "10")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: HR_SCREEN_WIDTH, height: 60*2+HR_TOP_HEIGHT+HR_MARGIN)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
