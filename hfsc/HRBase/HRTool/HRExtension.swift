//
//  HRExtension.swift
//  hfsc
//
//  Created by innket on 17/12/4.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import UIKit
import WebKit

//MARK:--------------------
//MARK:=========扩展===========
//MARK:--------------------


extension WKWebView {
    
    //MARK:加载HTML代码短或者字符串
    func hr_loadHtml(content:String){
        if (content.hasPrefix("http://")) || (content.hasPrefix("https://")){
            let ulrStr =  content.replacingOccurrences(of: " ", with: "")
            let currentURL = URL(string: ulrStr)
            let _ = self.load(URLRequest.init(url: currentURL!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30))
        }else{
            let _ = self.loadHTMLString(content, baseURL: Bundle.main.bundleURL)
        }
    }
    
    //MARK: 设置WebView中图片自适应宽度
    func hr_setImageWidth(){
        let js = "function imgAutoFit() {var imgs = document.getElementsByTagName('img');for (var i = 0; i < imgs.length; ++i) {var img = imgs[i];  img.style.maxWidth = \(UIScreen.main.bounds.size.width-20); } }"
        //    js = String(format: "%@",js,);
        self.evaluateJavaScript(js) { (result, error) in
            print("result:\(result)=====error:\(error)")
        }
        self.evaluateJavaScript("imgAutoFit()") { (result, error) in
            print("result:\(result)=====error:\(error)")
        }
    }
    
    //MARK:获取webView的高度
    func hr_getWebviewHeight(result:@escaping (_ height:CGFloat)->()){
        self.evaluateJavaScript("document.body.offsetHeight", completionHandler: { (height, error) in
            if error == nil{
                result(height as! CGFloat+20)
            }else{
                result(0)
            }
        })
    }
    
}






//MARK:UIView扩展
extension UIView {
    /*
     *  设置圆角
     */
    func hr_setCronerRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.layer.shouldRasterize = true
    }
    
    //MARK:删除所有子视图
    func hr_removeAllSubviews(){
        for sub in self.subviews {
            sub.removeFromSuperview()
        }
    }
    
    //MARK:转换为UIImage
    func hr_convertToImage()->UIImage{
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, self.layer.contentsScale)
        let ctx = UIGraphicsGetCurrentContext()
        self.layer.render(in: ctx!)
        let tImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tImg!
    }
}

//MARK:UIImageView扩展
extension UIImageView{
    //MARK:设置网络图片
    func hr_setImage(name:String){
        if name.hasPrefix("http://") || name.hasPrefix("https://"){
            var iconName = name
            if iconName.characters.count == 0 {
                iconName = "1234567890"
            }
            else{
                let imgArr = iconName.components(separatedBy: "|");
                if imgArr.count > 0 {
                    iconName = imgArr[0];
                }
            }
            let imgName =  iconName.replacingOccurrences(of: " ", with: "")
            self.af_setImage(withURL: URL(string:imgName)!, placeholderImage: HR_DEFAULT_IMG)
        }else{
            let img = UIImage(named: name)
            if (img != nil) {
                self.image = img
            }else{
                self.image = HR_DEFAULT_IMG
            }
        }
    }
}



//MARK:Int扩展
extension Int {
    func hexedString() -> String{
        return String(format: "%02x", self)
    }
}

//MARK:Data扩展
extension Data{
    //    func hexedString()->String{
    //        var string = String()
    //        let unsafePointer = UnsafeRawPointer.assumingMemoryBound(UInt8.self)
    //        for i in UnsafeBufferPointer<UInt8>(start:unsafePointer, count: count)
    //        {
    //            string += Int(i).hexedString()
    //        }
    //        return string
    //    }
    //    func MD5() -> NSData
    //    {
    //        let result = NSMutableData(length: 32)!
    //        let unsafePointer = result.mutableBytes.assumingMemoryBound(to: UInt8.self)
    //        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(unsafePointer))
    //        return NSData(data: result as Data)
    //    }
}


//MARK:String扩展
extension String {
    
    //MARK:字符串长度
    var length:Int{
        return self.characters.count
    }

    //MARK:MD5加密
    var md5 : String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
    
    //MARK:转换富文本
    func hr_getAttributedString(view:UIView)->NSMutableAttributedString{
        let mutAttStr = NSMutableAttributedString.init()
        let attch = NSTextAttachment.init()
        attch.image = view.hr_convertToImage()
        let attStr = NSAttributedString(string: self)
        let spaceStr = NSAttributedString(string: " ")
        let imgStr = NSAttributedString(attachment: attch)
        mutAttStr.append(attStr)
        mutAttStr.append(spaceStr)
        mutAttStr.append(imgStr)
        return mutAttStr
    }
    
    //MARK:限制中英文和数字
    /**
     小写a-z
     大写A-Z
     汉字\u4E00-\u9FA5
     数字\u0030-\u0039
     */
    var isRuleAndNumber:Bool{
        if self == "" || self == "\n" {
            return true
        }
        let pattern = "[a-zA-Z\\u4E00-\\u9FA5\\u0030-\\u0039]"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: self)
        return isMatch
    }
    
    //MARK:判断是否是Emoji
    var isEmoji:Bool{
        if self == "" || self == "\n" {
            return true
        }
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        let isMatch = pred.evaluate(with: self)
        return isMatch
    }
    
    //MARK:判断
    var disableEmoji:String {
        if self == "" || self == "\n" {
            
        }
        guard let regex = try? NSRegularExpression(pattern: "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]", options: .caseInsensitive) else {
            return self
        }
        let modifiedStr = regex.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: UInt(0)), range: NSRange(location: 0,length: self.characters.count), withTemplate: "")
        return modifiedStr
    }
    
    //MARK:判断是否是固定字符
    var isLetterAndNumber:Bool{
        if self == "" || self == "\n" {
            return true
        }
        let baseStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        if let range = baseStr.range(of: self) {
            if !range.isEmpty {
                return true
            }
        }
        return false
    }
}
