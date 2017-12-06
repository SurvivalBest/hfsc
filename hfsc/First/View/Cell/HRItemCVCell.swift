//
//  HRItemCVCell.swift
//  BigFish
//
//  Created by innket on 17/7/11.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit

class HRItemCVCell: UICollectionViewCell {
    var margin:CGFloat = 15
    let nameH:CGFloat = 20
    let lineW:CGFloat = 0.5
    
    
    var viewH:CGFloat?
    var viewW:CGFloat?
    var iconIV:UIImageView?
    var nameLab:UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewW = frame.size.width
        viewH = frame.size.height
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        iconIV = UIImageView()
        iconIV?.contentMode = .scaleAspectFit
        self.contentView.addSubview(iconIV!)
        
        nameLab = UILabel()
        nameLab?.font = HR_NORMAL_FONT
        nameLab?.textColor = HR_BLACK_COLOR
        nameLab?.textAlignment = .center
        self.contentView.addSubview(nameLab!)
    }
    
    func setIconAndName(icon:String,name:String){
        if name.isEmpty {
            iconIV?.frame = CGRect(x: margin, y: margin, width: viewW!-margin*2, height: viewH!-margin*2)
            iconIV?.image = UIImage(named: icon)
        }else{
            if viewH! == viewW! {
                margin = 10
                let iconW = (viewW!-margin*2-nameH*2-margin/2)
                iconIV?.frame = CGRect(x: (viewW!-iconW)/2, y: (viewW!-iconW-nameH)/2, width: iconW, height: iconW)
                iconIV?.image = UIImage(named: icon)
                nameLab?.frame = CGRect(x: margin, y: (iconIV?.frame.maxY)!+margin/2, width: viewW!-margin*2, height: nameH)
                nameLab?.text = name
            }else
            if  viewH! < viewW! {
                iconIV?.frame = CGRect(x: (viewW!-(viewH!-margin*2-nameH))/2, y: margin, width: viewH!-margin*2-nameH, height: viewH!-margin*2-nameH)
                iconIV?.image = UIImage(named: icon)
                nameLab?.frame = CGRect(x: margin, y: (iconIV?.frame.maxY)!, width: viewW!-margin*2, height: nameH)
                nameLab?.text = name
            }else{
                iconIV?.frame = CGRect(x: margin, y: margin, width: viewW!-margin*2, height: viewW!-margin*2)
                iconIV?.image = UIImage(named: icon)
                nameLab?.frame = CGRect(x: 0, y: (iconIV?.frame.maxY)!+margin, width: viewW!, height: nameH-margin)
                nameLab?.text = name
            }
        }
    }
}
