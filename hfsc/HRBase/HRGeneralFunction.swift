//
//  HRGeneralFunction.swift
//  BigFish
//
//  Created by innket on 17/7/7.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import ReachabilitySwift
import AVKit
import MediaPlayer
import AlamofireImage

func runtime() {
    
    // 1, 利用runtime 遍历出pageControl的所有属性
    var count : UInt32 = 0
    let ivars = class_copyIvarList(UIPageControl.self, &count)
    for i in 0..<count {
        
        let ivar = ivars?[Int(i)]
        let name = ivar_getName(ivar)
        print(String(cString: name!))
        
        /* 打印出来的所有属性
         _lastUserInterfaceIdiom
         _indicators
         _curPage
         _displayedPage
         _pageControlFlags
         _curPageImage // 图片样式
         _pageImage // 图片样式
         _curPageImages
         _pageImages
         _backgroundVisualEffectView
         _curPageIndicatorTintColor
         _pageIndicatorTintColor
         _legibilitySettings
         _numberOfPages
         */
    }
    
    // 2, 利用kvc修改图片
//    pageControl.setValue(UIImage(named: "page"), forKey: "_pageImage")
//    pageControl.setValue(UIImage(named: "curPage"), forKey: "_curPageImage")
}

/*
 *  根据颜色生成图片
 */
public func imageFromColor(color:UIColor)->UIImage{
    let rect  = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext();
    context!.setFillColor(color.cgColor);
    context!.fill(rect);
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image!;
}

/*
 *  计算多行字符串的宽高
 */
public func calculateMoreLineStringSize(str:String,font:UIFont,maxSize:CGSize) ->CGSize{
    let attributes = [NSFontAttributeName: font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect:CGRect = str.boundingRect(with: maxSize, options: option, attributes: attributes, context: nil)
    return rect.size
}

/*
 *  计算单行字符串的宽高
 */
public func calculateOneLineStringSize(str:String,font:UIFont) ->CGSize{
    let attributes = [NSFontAttributeName: font]
    let maxSize = CGSize(width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT)
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect:CGRect = str.boundingRect(with: maxSize, options: option, attributes: attributes, context: nil)
    return rect.size
}

/*
 *  正则表达式判断
 */
enum ValidatedType {
    case Email
    case PhoneNumber
}
func ValidateText(validatedType type: ValidatedType, validateString: String) -> Bool {
    do {
        let pattern: String
        if type == ValidatedType.Email {
            pattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        }
        else {
            pattern = "^1[0-9]{10}$"
        }
        
        let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
        return matches.count > 0
    }
    catch {
        return false
    }
}
/*
 *  邮箱
 */
func EmailIsValidated(vStr: String) -> Bool {
    return ValidateText(validatedType: ValidatedType.Email, validateString: vStr)
}
/*
 *  手机号码
 */
func PhoneNumberIsValidated(vStr: String) -> Bool {
    return ValidateText(validatedType: ValidatedType.PhoneNumber, validateString: vStr)
}


/*
 *  判断是不是网络图片
 */
func isNetworkImage(imgStr:String) -> Bool{
    if imgStr.hasPrefix("http://") || imgStr.hasPrefix("https://") {
        return true
    }
    return false
}

/*
 *  判断字符串是否为空
 */
func EmptyCheck(str:String?) ->String{
    if str != nil {
        return str!
    }else{
        return ""
    }
}

/*
 *  判断整形是否为空
 */
func NumberCheck(number:Int?) ->Int{
    if number != nil {
        return number!
    }else{
        return 0
    }
}

/*
 *  字符串转整形
 */
func StringToInt(str:String?)->(Int){
    var int: Int?
    if str != nil {
        let nsstr = str! as NSString
        if nsstr.intValue > 0 {
            int = nsstr.integerValue
        }
        if int == nil
        {
            return 0
        }
        return int!
    }
    return 0
}

/*
 *  字符串转浮点型
 */
func StringToFloat(str:String?)->(Float){
    var float: Float?
    if str != nil {
        let nsstr = str! as NSString
        if nsstr.floatValue > 0.00 {
            float = nsstr.floatValue
        }
        if float == nil
        {
            return 0.00
        }
        return float!
    }
    return 0.00
}

/*
 *  获取价格
 */
func GetPrice(str:String?)->String{
    return String(format: "￥%.2f", StringToFloat(str: str))
}


/*
 *  显示webview中图片的大小
 */
func LimitImgSize(maxWidth:CGFloat,webView:WKWebView){
    let limitImg = "var script = document.createElement('script');"+"script.type = 'text/javascript';"+"script.text = \"function ResizeImages() { "+"var myimg,oldwidth;"+"var maxwidth = \(maxWidth)px;var imgs = document.getElementsByTagName('img');"+"for(i=0;i <imgs.length;i++){"+"myimg = imgs[i];"+"if(myimg.width > maxwidth){"+"oldwidth = myimg.width;"+"myimg.width = \(maxWidth)px;"+"}"+"}"+"}\";"+"document.getElementsByTagName('head')[0].appendChild(script);";
    webView.evaluateJavaScript(limitImg) { (result, error) in
        
    }
//    webView.evaluateJavaScript("console.log(document.images.length)") { (result, error) in
//        print("\(result)-----\(error)")
//    }
//    webView.evaluateJavaScript("document.getElementsByTagName('img')") { (result, error) in
//        print("\(result)-----\(error)")
//    }
    webView.evaluateJavaScript("ResizeImages") { (result, error) in
        
    }
    webView.evaluateJavaScript("var t = document.getElementsByTagName('p');"+"for(i = 0; i < t.length; i++){t.item(i).style.fontSize = '30px';;}"
    ) { (result, error) in
        print("\(result)-----\(error)")
    }
}

/*
 *  控制webView大小和是否允许放大缩小
 */
func LimitSizeAndMode(maxWidth:CGFloat,isCanEdit:Bool,webView:WKWebView){
    var scalable = "yes"
    if !isCanEdit {
        scalable = "no"
    }
    let limitMove = "var script = document.createElement('meta');"+"script.name = 'viewport';"+"script.content=\"width=\(maxWidth)px, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=\(scalable)\";"+"document.getElementsByTagName('head')[0].appendChild(script);";
    
    webView.evaluateJavaScript(limitMove) { (result, error) in
        
    }
}

/*
 *  设置导航栏返回按钮的图片
 */
func SetNavBackIcon(imageName:String){
//    let backImg = UIImage(named:imageName)?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
//    let appear = UIBarButtonItem.appearance()
//    appear.setBackButtonBackgroundImage(backImg, for: .normal, barMetrics: .default)
}

/*
 *  设置背景图片
 */
func setNavBackImg(imgName:String,VC:UIViewController){
//    let backImg = UIImage(named:imgName)?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0))
//    VC.navigationItem.backBarButtonItem?.setBackgroundImage(backImg, for: .normal, barMetrics: .default)
}

/*
 *  获取当前网络状态
 */
func GetNetworkStatus()->Int{
    let reachability = Reachability()!
    if reachability.isReachableViaWiFi {
        //wifi
        return 1
    }else if reachability.isReachableViaWWAN{
        //4g
        return 2
    }else{
        //无网络
        return 0
    }
}

/*
 *  监听网络变化
 */
//func ObserveNetworkChange(change:@escaping (_ type:Int)->()){
//    let reachability = Reachability()!
//    reachability.whenReachable = { reachability in
//        DispatchQueue.main.async {
//            if reachability.isReachableViaWiFi{
//                print("Reachable via WiFi")
//                change(1)
//            }else{
//                print("Reachable via Cellular")
//                change(2)
//            }
//        }
//    }
//    reachability.whenUnreachable = { reachability in
//        DispatchQueue.main.async {
//            print("Not reachable")
//            change(0)
//        }
//    }
//    do {
//        try reachability.startNotifier()
//    } catch {
//        print("Unable to start notifier")
//    }
//}

func ShowAllFonts()
{
    let familyNames = UIFont.familyNames
    
    var index:Int = 0
    
    for familyName in familyNames
    {
        let fontNames = UIFont.fontNames(forFamilyName: familyName as String)
        for fontName in fontNames
        {
            index += 1
            print("第 \(index) 个字体，字体font名称：\(fontName)")
        }
    }
}

/*
 *  获取时间
 */
func GetFormatPlayTime(secounds:TimeInterval)->String{
    if secounds.isNaN{
        return "00:00"
    }
    var Min = Int(secounds / 60)
    let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
    var Hour = 0
    if Min>=60 {
        Hour = Int(Min / 60)
        Min = Min - Hour*60
        return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
    }
    return String(format: "%02d:%02d", Min, Sec)
}


/*
 *  获取课程秒杀时间时间
 */
func GetCourseSeckillTime(seconds:Int)->String{
    if seconds == 0{
        return "00:00"
    }
    let day = seconds/3600/24
    let hour = (seconds-3600*24*day)/3600
    let minute = (seconds-3600*24*day-3600*hour)/60
    let second = (seconds-3600*24*day-3600*hour-60*minute)
    if day > 0 {
        return String(format: "%02d天:%02d:%02d:%02d",day, hour, minute, second)
    }else if hour > 0{
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }else{
        return String(format: "%02d:%02d", minute, second)
    }
}

/*
 *  计算缓存大小
 */
func hr_fileSizeOfCache()-> Float {
    
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    //缓存目录路径
    print(cachePath)
    
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    
    //快速枚举出所有文件名 计算文件大小
    var size = 0
    for file in fileArr! {
        
        // 把文件名拼接到路径中
        let path = cachePath?.appending("/\(file)")
        // 取出文件属性
        let floder = try! FileManager.default.attributesOfItem(atPath: path!)
        // 用元组取出文件大小属性
        for (abc, bcd) in floder {
            // 累加文件大小
            if abc == FileAttributeKey.size {
                size += (bcd as AnyObject).integerValue
            }
        }
    }
    let mm = Float(size) / 1024.0 / 1024.0
    return mm
}

func hr_clearCache() {
    
    // 取出cache文件夹目录 缓存文件都在这个目录下
    let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
    
    // 取出文件夹下所有文件数组
    let fileArr = FileManager.default.subpaths(atPath: cachePath!)
    
    // 遍历删除
    for file in fileArr! {
        
        let path = cachePath?.appending("/\(file)")
        if FileManager.default.fileExists(atPath: path!) {
            
            do {
                try FileManager.default.removeItem(atPath: path!)
            } catch {
                
            }
        }
    }
}


//设置系统亮度
func SetSysBright(vale:CGFloat){
    UIScreen.main.brightness = vale
}

//获取系统亮度
func GetSysBright() -> CGFloat{
    return UIScreen.main.brightness
}


//MARK:改变系统音量
public func SetSysVolume(value:Float) {
    let volumeBig = MPVolumeView()
    var slider: UISlider?
    for view: UIView in volumeBig.subviews {
        print(view.self.description)
        print(view.classForCoder.description())
        let className = view.classForCoder.description()
        if className == "MPVolumeSlider" {
            slider = view as? UISlider
            break
        }
    }
    slider?.setValue(value, animated: true)
    slider?.sendActions(for: .touchUpInside)
}
//MARK:获取系统音量
func GetSysVolume() -> Float{
    do{
        try AVAudioSession.sharedInstance().setActive(true)
    }catch let error as NSError{
        print("\(error)")
    }
    //获取并赋值
    return AVAudioSession.sharedInstance().outputVolume
}

//MARK:移除前一个VC
func RemoveLastVC(VC:UIViewController){
    let vcArr = VC.navigationController?.viewControllers
    var newArr:[UIViewController] = []
    if (vcArr?.count)! > 2{
        let lastVC = vcArr?[(vcArr?.count)!-2]
        for i in 0..<(vcArr?.count)! {
            if i != (vcArr?.count)!-2 {
                newArr.append((vcArr?[i])!)
            }
        }
        VC.navigationController?.viewControllers = newArr
    }
    
//    if (vcArr?.count)! > 2{
//        let lastVC = vcArr?[(vcArr?.count)!-2]
//        lastVC?.removeFromParentViewController()
//    }
}

// 相机权限
//func isRightCamera() -> Bool {
//    let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
//    return authStatus != .restricted && authStatus != .denied
//}

// 相册权限
//func isRightPhoto() -> Bool {
//    let authStatus = ALAssetsLibrary.authorizationStatus()
//    return authStatus != .restricted && authStatus != .denied
//}


/*
 *  设置WKWebView的配置
 */
// meta.setAttribute('content', 'initial-scale=1.0');  meta.setAttribute('content', 'maximum-scale=1.0'); meta.setAttribute('content', 'user-scalable=no'); 
//MARK: 设置WebView
func hr_setWKWebViewConfig()->WKWebViewConfiguration{
    let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width');   document.getElementsByTagName('head')[0].appendChild(meta);";
    
    let wkUScript = WKUserScript.init(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    let wkUController = WKUserContentController();
    wkUController.addUserScript(wkUScript)
    
    let wkWebConfig = WKWebViewConfiguration()
    wkWebConfig.userContentController = wkUController;
    return wkWebConfig
}


//跳转到应用的AppStore页页面
func hr_gotoAppStore() {
    let urlString = "itms-apps://itunes.apple.com/app/id\(APP_ID)"
    if let url = URL(string: urlString) {
        //根据iOS系统版本，分别处理
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: {
                                        (success) in
            })
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
//获取当前app版本
func hr_getAppVersion() -> String {
    let infoDictionary = Bundle.main.infoDictionary
    let oldVersion:AnyObject? = infoDictionary! ["CFBundleShortVersionString"] as AnyObject?
    return oldVersion as! String
}

//获取当前时间的时间戳
func hr_getTimeStamp() -> String{
    let timeInterval:TimeInterval = Date().timeIntervalSince1970
    let timeStamp = Int(timeInterval)
//    print("当前时间的时间戳：\(timeStamp)")
    return "\(timeStamp)"
}

//获取定位信息
func hr_getLocation(success:@escaping (_ location:CLLocation?,_ reGeocode:AMapLocationReGeocode?)->(),failure:@escaping (_ des:String)->()){
    let locationManager = AMapLocationManager()
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.locationTimeout = 2
    locationManager.reGeocodeTimeout = 2
    locationManager.requestLocation(withReGeocode: false, completionBlock: { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
        
        if let error = error {
            let error = error as NSError
            
            if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                failure("定位错误:{\(error.code) - \(error.localizedDescription)};")
                return
            }
            else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                || error.code == AMapLocationErrorCode.timeOut.rawValue
                || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                || error.code == AMapLocationErrorCode.badURL.rawValue
                || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                
                //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
            }
            else {
                //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
            }
        }
        
        if let location = location {
            NSLog("location:%@", location)
        }
        
        if let reGeocode = reGeocode {
            NSLog("reGeocode:%@", reGeocode)
        }
        success(location,reGeocode)
    })
}






