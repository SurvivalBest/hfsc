//
//  HRGeneralInfo.swift
//  BigFish
//
//  Created by innket on 17/7/6.
//  Copyright © 2017年 黄冉. All rights reserved.
//

import Foundation
import UIKit

/*--------------颜色--------------*/
/*
 *  RGB颜色转换
 */
func RGB(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
/*
 *  色值
 */
func RGBCOLOR_HEX(h:Int) ->UIColor {
    return RGB(r: CGFloat(((h)>>16) & 0xFF), g:   CGFloat(((h)>>8) & 0xFF), b:  CGFloat((h) & 0xFF), a:1)
}
/*
 *  主题颜色
 */
public let HR_THEME_COLOR = RGB(r:11, g:201, b:11, a:1)
/*
 *  随机颜色
 */
public let HR_RANDOM_COLOR = RGB(r: CGFloat(arc4random_uniform(255)),g: CGFloat(arc4random_uniform(255)),b: CGFloat(arc4random_uniform(255)),a: 1)
/*
 *  背景颜色
 */
//public let HR_BG_COLOR = RGB(r: 250,g: 250,b: 250,a: 1)
public let HR_BG_COLOR = RGB(r: 238,g: 238,b: 238,a: 1)


/*
 *  不可选颜色
 */
public let HR_DISABLE_COLOR = RGB(r: 220,g: 220,b: 220,a: 1)
/*
 *  黑色字体颜色
 */
public let HR_BLACK_COLOR = RGB(r: 51,g: 51,b: 51,a: 1)
/*
 *  灰色字体颜色
 */
public let HR_GRAY_COLOR = RGB(r: 153,g: 153,b: 153,a: 1)
/*
 *  深灰色
 */
public let HR_DARK_GRAY = RGB(r: 102,g: 102,b: 102,a: 1)
/*
 *  红色字体颜色
 */
public let HR_RED_COLOR = RGB(r: 236,g: 0,b: 0,a: 1)

/*
 *  蓝色字体颜色
 */
public let HR_BLUE_COLOR = RGB(r: 115,g: 181,b: 255,a: 1)
/*
 *  灰蓝色字体颜色
 */
public let HR_GRAY_BLUE_COLOR = RGB(r: 171,g: 199,b: 209,a: 1)
/*
 *  黄色色字体颜色
 */
public let HR_GOLD_COLOR = RGB(r: 255,g: 169,b: 86,a: 1)

/*
 *  白色
 */
public let HR_WHITE_COLOR = UIColor.white
/*
 *  分割线颜色
 */
public let HR_LINE_COLOR = RGB(r: 238,g: 238,b: 238,a: 1)
/*
 *  tableView分割线颜色
 */
public let HR_SEPARATOR_COLOR = RGB(r: 234,g: 236,b: 238,a: 1)
/*
 *  搜索框背景
 */
public let HR_SEARCH_BG = RGB(r: 238,g: 238,b: 238,a: 1)
/*
 *  半透明颜色
 */
public let HR_POP_COLOR = UIColor.black.withAlphaComponent(0.3)

/*--------------尺寸--------------*/
/*
 *  屏幕尺寸
 */
public let HR_SCREEN_WIDTH = UIScreen.main.bounds.width
public let HR_SCREEN_HEIGHT = UIScreen.main.bounds.height

public let HR_FOOTER_HEIGHT = CGFloat(49.0)
public let HR_HEADER_HEIGHT = CGFloat(64.0)

public let HR_TOP_HEIGHT = CGFloat(45.0)

public let HR_STATUS_HEIGHT = CGFloat(20.0)
public let HR_FIRST_FRAME = CGRect(x: 0, y: HR_HEADER_HEIGHT, width: HR_SCREEN_WIDTH, height: HR_SCREEN_HEIGHT-HR_FOOTER_HEIGHT-HR_HEADER_HEIGHT)
public let HR_FULL_FRAME = CGRect(x: 0, y: HR_HEADER_HEIGHT, width: HR_SCREEN_WIDTH, height:HR_SCREEN_HEIGHT-HR_HEADER_HEIGHT)

public let HR_FOOTER_FRAME = CGRect(x: 0, y: HR_SCREEN_HEIGHT-HR_FOOTER_HEIGHT, width: HR_SCREEN_WIDTH, height:HR_FOOTER_HEIGHT)

public let HR_MAX_MARGIN = CGFloat(20.0)

public let HR_MARGIN = CGFloat(13.0)

public let HR_MIN_MARGIN = CGFloat(10.0)

public let HR_RADIUS = CGFloat(5.0)

public let HR_STAR_WIDTH = CGFloat(15.0)

public let HR_BALANCE_HEIGHT = 80+HR_MARGIN*2


/*--------------字体大小--------------*/
/*
 *  正常大小
 */
public let HR_NORMAL_FONT = UIFont.systemFont(ofSize: 15.0)
/*
 *  大字体
 */
public let HR_BIG_FONT = UIFont.systemFont(ofSize: 17.0)
/*
 *  小字体
 */
public let HR_SMALL_FONT = UIFont.systemFont(ofSize: 13.0)
/*
 *  最新小字体
 */
public let HR_MORE_SMALL_FONT = UIFont.systemFont(ofSize: 11.0)
/*
 *  粗字体
 */
public let HR_BOLD_FONT = UIFont.boldSystemFont(ofSize: 17.0)
/*
 *  价格字体
 */
public let HR_PRICE_FONT = UIFont.boldSystemFont(ofSize: 22.0)
/*
 *  余额字体
 */
public let HR_BALANCE_FONT = UIFont.boldSystemFont(ofSize: 25.0)

/*
 *  小粗字体
 */
public let HR_SMALL_BOLD = UIFont.boldSystemFont(ofSize: 15.0)

/*
 *  自定义字体
 */
public let HR_FONT_NAME = "Futura-CondensedMedium"


/*--------------默认图片--------------*/
public let HR_DEFAULT_IMG = UIImage(named: "placeholder")
public let HR_DEFAULT_AVATAR = UIImage(named: "default_avatar")

public let HR_IMAGE_SCALE = CGFloat(9.0/16.0)


/*--------------userdefault--------------*/
public let HR_USER_DEFA = UserDefaults.standard

/*--------------notification--------------*/
public let HR_NOTIFICATION = NotificationCenter.default


/*--------------客服电话--------------*/
public let HR_SERVICE_PHONE = "021-56180799"

/*--------------是否是假数据--------------*/
public let TEST_TAG = 1

/*--------------第三方数据--------------*/
//友盟的Key
public let UM_KEY = "598e63a8aed1791ff000120e"
//微信的Key:
public let WX_KEY = "wxf4f03a24ec4b5900"
//微信的Secret
public let WX_SECRET = "bb815f30586d04f339234985c87fdeb4"
//QQ的Key
public let QQ_KEY = "1106314086"

//微博
public let WB_KEY = "2040752704"
public let WB_SECRET = "33db61f71003c9c1696a458dee988788"
//
public let REDIRECT_URL = "http://www.flksh.com"

/*--------------高德--------------*/
public let AMAP_KEY = "e61854977c066ee4f7f487d3b480a661"

/*--------------极光--------------*/
//极光的Key
public let JG_KEY = "74d8fc8ca2e594bd6d11b2da"
//极光的Secret
public let JG_SECRET = "09e1854b0f507eb4fa3860dd"


/*--------------分享默认数据--------------*/
public let SHARE_URL = "http://www.flksh.com"
public let SHARE_ICON = "鸿福家园"
public let SHARE_TITLE = "鸿福家园"
public let SHARE_DETAIL = "鸿福家园"


/*--------------应用信息--------------*/
public let APP_ID = "444934666"




