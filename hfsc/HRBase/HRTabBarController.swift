//
//  HRTabBarController.swift
//  hfsc
//
//  Created by innket on 17/11/14.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit

class HRTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let NA1 = creatSubVC(vc: HRFirstVC(), name: "首页", imgName1: "first", imgName2: "first_ed")
        let NA2 = creatSubVC(vc: HRSecondVC(), name: "天下行", imgName1: "second", imgName2: "second_ed")
        let NA3 = creatSubVC(vc: HRThirdVC(), name: "发现", imgName1: "third", imgName2: "third_ed")
        let NA4 = creatSubVC(vc: HRFourthVC(), name: "我的", imgName1: "fourth", imgName2: "fourth_ed")
        self.viewControllers = [NA1,NA2,NA3,NA4]
        self.tabBar.tintColor = HR_THEME_COLOR
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:创建子窗口
    func creatSubVC(vc:UIViewController,name:String,imgName1:String,imgName2:String) -> HRNavigationController{
        let tempNa = HRNavigationController(rootViewController: vc)
        let normalImg = UIImage(named: imgName1)
        let selectImg = UIImage(named: imgName2)?.withRenderingMode(.alwaysOriginal)
        let item = UITabBarItem(title: name, image: normalImg, selectedImage: selectImg)
        tempNa.tabBarItem = item
        return tempNa
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

/*
 *  设置导航栏的线条
 */
extension UIToolbar {
    
    func hideHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(view: self)
        navigationBarImageView!.isHidden = true
    }
    
    func showHairline() {
        let navigationBarImageView = hairlineImageViewInToolbar(view: self)
        navigationBarImageView!.isHidden = false
    }
    
    private func hairlineImageViewInToolbar(view: UIView) -> UIImageView? {
        if view.isKind(of: UIImageView.self) && view.bounds.height <= 1.0 {
            return (view as! UIImageView)
        }
        let subviews = (view.subviews as [UIView])
        for subview: UIView in subviews {
            if let imageView: UIImageView = hairlineImageViewInToolbar(view: subview) {
                return imageView
            }
        }
        return nil
    }
}
