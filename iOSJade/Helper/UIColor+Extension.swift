//
//  UIColor+Extension.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit

extension UIColor {
    
    static let grayWhite = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    static let grayBg = #colorLiteral(red: 0.1176470588, green: 0.1176470588, blue: 0.1176470588, alpha: 1)
    static let sunYellow = #colorLiteral(red: 0.9882352941, green: 0.8117647059, blue: 0.168627451, alpha: 1)
    static let blackText = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
    static let grayText = #colorLiteral(red: 0.4911665916, green: 0.4911786318, blue: 0.4911721349, alpha: 1)
    static let purpleText = #colorLiteral(red: 1, green: 0.8431372549, blue: 1, alpha: 1)
    static let black20 = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    static let black30 = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
    static let black50 = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    static let black70 = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
    static let black90 = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
    static let black95 = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9490196078, alpha: 1)
    
    
    //通过十六进制获取颜色
    public class func colorWithHex(_ hex: String, alpha:CGFloat = 1) -> UIColor {
        let hexString = hex.trimmingCharacters(in: .whitespaces).uppercased()
        let nsHexString = hexString.replacingOccurrences(of: "#", with: "") as NSString
        if nsHexString.length == 6 {
            let rString = nsHexString.substring(with: NSMakeRange(0, 2)) as String
            let gString = nsHexString.substring(with: NSMakeRange(2, 2)) as String
            let bString = nsHexString.substring(with: NSMakeRange(4, 2)) as String
            
            var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
            Scanner(string: rString).scanHexInt32(&r)
            Scanner(string: gString).scanHexInt32(&g)
            Scanner(string: bString).scanHexInt32(&b)
            
            return UIColor(red: CGFloat(r)/CGFloat(UInt8.max),
                           green: CGFloat(g)/CGFloat(UInt8.max),
                           blue: CGFloat(b)/CGFloat(UInt8.max), alpha: alpha)
        }
        return .clear
    }
    
}

extension UIColor {
    class var c2F2929: UIColor {
        return .colorWithHex("2F2929")
    }
    
    class var a2F2929: UIColor { //默认透明度为0.5
        return .colorWithHex("2F2929", alpha: 0.5)
    }
    
    class var background: UIColor {
        return .colorWithHex("f5f5f5")
    }
    
    class var themeBlue: UIColor {
        return .colorWithHex("36afda")
    }
    
}
