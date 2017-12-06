//
//  HRBannerView.swift
//  BigFish
//
//  Created by innket on 17/7/13.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit

class HRBannerView: UIView ,UIScrollViewDelegate{
    weak var delegate:HRBannerViewDelegate?
    let pageControlH:CGFloat = 30
    
    var viewW:CGFloat?
    var viewH:CGFloat?
    
    var timer:Timer!
    var imageScroll:UIScrollView?
    var imageArr:[String] = []
    var pageControl:UIPageControl?
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
        
    }
    deinit {
        if timer != nil {
            timer.invalidate()
        }
    }
    func setImages(imgArr:[String]){
        if imgArr.count > 0 {
            if imgArr.count > 1 {
                //多张图片
                imageArr = imgArr
                setMoreImg()
            }else{
                //一张图片
                setOneImg(imageName: imgArr[0])
            }
        }
    }
    
    private func setOneImg(imageName:String){
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        let tempIV = UIImageView(frame: CGRect(x: 0, y: 0, width: viewW!, height: viewH!))
        tempIV.isUserInteractionEnabled = true
        tempIV.tag = 10;
        tempIV.contentMode = .scaleAspectFill
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(clickImage(tap:)))
        tempIV.addGestureRecognizer(imgTap)
        self.addSubview(tempIV);
        tempIV.hr_setImage(name: imageName)
    }
    
    private func setMoreImg(){
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        imageScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: viewW!, height: viewH!))
        imageScroll?.delegate = self
        imageScroll?.showsHorizontalScrollIndicator = false
        imageScroll?.showsVerticalScrollIndicator = false
        imageScroll?.isPagingEnabled = true
        self.addSubview(imageScroll!);
        
        for i in 0 ..< (imageArr.count) {
            let tempIV = UIImageView(frame: CGRect(x: viewW!*CGFloat(i), y: 0, width: viewW!, height: viewH!))
            tempIV.isUserInteractionEnabled = true
            tempIV.contentMode = .scaleAspectFill
            tempIV.layer.masksToBounds = true
            tempIV.tag = 10+i;
            let imgTap = UITapGestureRecognizer(target: self, action: #selector(clickImage(tap:)))
            tempIV.addGestureRecognizer(imgTap)
            imageScroll?.addSubview(tempIV);
            tempIV.hr_setImage(name: (imageArr[i]))
        }
        imageScroll?.contentSize = CGSize(width: viewW!*CGFloat((imageArr.count)), height: viewH!)
        pageControl = UIPageControl(frame: CGRect(x: 0, y: viewH!-pageControlH, width: viewW!, height: pageControlH))
        pageControl?.numberOfPages = (imageArr.count)
        pageControl?.currentPage = 0
        pageControl?.currentPageIndicatorTintColor = HR_THEME_COLOR
        pageControl?.tintColor = HR_THEME_COLOR
        pageControl?.pageIndicatorTintColor = HR_WHITE_COLOR
        pageControl?.isUserInteractionEnabled = false
        pageControl?.setValue(UIImage(named: "normal_page"), forKey: "_pageImage")
        pageControl?.setValue(UIImage(named: "select_page"), forKey: "_currentPageImage")
        self.addSubview(pageControl!)
    }
    
    func clickImage(tap:UITapGestureRecognizer){
        let tempIV = tap.view as! UIImageView
        let index = tempIV.tag-10
        delegate?.tapImage(index: index)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        pageControl?.currentPage = Int(offsetX/viewW!)
//        if self.timer != nil {
//            self.timer.fireDate = Date.distantFuture
//        }
//        self.perform(#selector(timeBegain), with: self, afterDelay: 4)
    }
    func timeBegain(){
        if self.timer != nil {
            self.timer.fireDate = Date.distantPast;
        }
    }
    
    func setAutoScroll(){
        if self.timer != nil{
            self.timer.invalidate()
            self.timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(scrollImg), userInfo: nil, repeats: true)
    }
    
    func scrollImg(){
        if (self.imageArr != nil) {
            if (self.imageArr.count) > 0 {
                var offset = self.imageScroll?.contentOffset
                if (offset?.x)! >= viewW!*(CGFloat((self.imageArr.count))-1) {
                    offset?.x = 0
                }else{
                    offset?.x += viewW!
                }
                self.imageScroll?.setContentOffset(offset!, animated: true)
                pageControl?.currentPage = Int((offset?.x)!/viewW!)
            }
        }
    }
}

protocol HRBannerViewDelegate:NSObjectProtocol {
    func tapImage(index:Int)
}
