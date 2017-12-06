//
//  HRNavigationController.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRNavigationController: UINavigationController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = HR_BG_COLOR
        //修改导航栏的背景颜色
        self.navigationBar.barTintColor = HR_WHITE_COLOR
        
        //修改导航栏标题属性
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:HR_BLACK_COLOR,NSFontAttributeName:UIFont.systemFont(ofSize:19)]
        
        //修改导航栏按钮颜色
        self.navigationBar.tintColor = HR_BLACK_COLOR
        self.navigationBar.shadowImage = imageFromColor(color: HR_SEPARATOR_COLOR)
        
        //设置返回按钮为自定义的图片
//        let backImg = UIImage(named:"sex_yes")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
//        let appear = UIBarButtonItem.appearance()
//        appear.setBackButtonBackgroundImage(backImg, for: .normal, barMetrics: .default)
        
        
        
        //设置导航栏的背景图片
        //        self.navigationBar.setBackgroundImage(UIImage(named:""), for: .default)
        //设置导航栏背景透明
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
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

extension UINavigationBar {
    
    func hideBottomHairline() {
        self.shadowImage = imageFromColor(color: UIColor.clear)
        let navigationBarImageView = hairlineImageViewInNavigationBar(view: self)
        navigationBarImageView!.isHidden = true
    }
    
    func showBottomHairline() {
        self.shadowImage = imageFromColor(color: HR_SEPARATOR_COLOR)
        let navigationBarImageView = hairlineImageViewInNavigationBar(view: self)
        navigationBarImageView!.isHidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInNavigationBar(view: subview) {
                return imageView
            }
        }
        return nil
    }
    
}
