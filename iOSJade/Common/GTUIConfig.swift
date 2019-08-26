//
//  GTUIConfig.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit

// 全屏高宽
let kScreenW: CGFloat = UIScreen.main.bounds.size.width
let kScreenH: CGFloat = UIScreen.main.bounds.size.height
//let kScreenW: CGFloat = UIApplication.shared.getKeyWindowRootController()?.view.bounds.width ?? UIScreen.main.bounds.size.width
//let kScreenH: CGFloat = UIApplication.shared.getKeyWindowRootController()?.view.bounds.height ?? UIScreen.main.bounds.size.height
//var kScreenW: CGFloat {
//    get {
//        if let width = UIApplication.shared.getKeyWindowRootController()?.view.bounds.width {
//            return width
//        } else {
//            return UIScreen.main.bounds.size.width
//        }
//    }
//}
//var kScreenH: CGFloat {
//    get {
//        if let height = UIApplication.shared.getKeyWindowRootController()?.view.bounds.height {
//            return height
//        } else {
//            return UIScreen.main.bounds.size.height
//        }
//    }
//}



//边距
let kMargin: CGFloat = Adapt(16.0)

// 判断是否为 iPhone X
let isIphoneX = kScreenH >= 812 ? true : false
// 判断是否为 Plus系列
let isIphonePlus = kScreenH == 736 ? true : false

// 状态栏高度
let kStatusHeight: CGFloat = isIphoneX ? 44 : 20

// 导航栏高度
let kNavigationBarHeight: CGFloat = 44

let kSafeAreaBottom: CGFloat = isIphoneX ? 34 : 0
let kSafeAreaTop: CGFloat = isIphoneX ? 30 : 0

// TabBar高度
let kTabBarHeight: CGFloat = isIphoneX ? 49 + 34 : 49
let CateItemHeight = kScreenW / 4
let kCateTitleH: CGFloat = 42

// 隐藏导航栏
let kNavBarHidden: [String:String] = ["isHidden":"true"]

// 显示 导航栏
let kNavBarNotHidden: [String:String] = ["isHidden":"false"]

//通用动画时间
let kAnimationTime = 0.3
let kAnimationLongTime = 0.5

// 宽度比
let kWidthRatio = kScreenW / 375.0

// 高度比
let kHeightRatio = kScreenH / 667.0

let kPlayerW = kScreenW
let kPlayerH = kScreenW / 16.0 * 9.0

// 自适应
func Adapt(_ value: CGFloat) -> CGFloat {
    
    return AdaptW(value)
}

// 自适应宽度
func AdaptW(_ value: CGFloat) -> CGFloat {
    
    return ceil(value) * kWidthRatio
}

// 自适应高度
func AdaptH(_ value: CGFloat) -> CGFloat {
    
    return ceil(value) * kHeightRatio
}

// 自适应
func AdaptSafeBottom(_ value: CGFloat) -> CGFloat {
    
    return AdaptW(value) + kSafeAreaBottom
}

// 常规字体
func FontSize(_ size: CGFloat) -> UIFont {
    
    return UIFont.systemFont(ofSize: AdaptW(size))
}

// 加粗字体
func BoldFontSize(_ size: CGFloat) -> UIFont {
    
    return UIFont.boldSystemFont(ofSize: AdaptW(size))
}
