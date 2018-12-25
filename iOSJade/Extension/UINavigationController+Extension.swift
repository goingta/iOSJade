//
//  UINavigationController+Extension.swift
//  iOSJade
//
//  Created by goingta on 2018/12/25.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation

import UIKit

extension UINavigationController {
    //导航栏背景透明度设置
    func setNeedsNavigationBackground(alpha: CGFloat) {
        // 拿到_UIBarBackground
        let barBackgroundView = self.navigationBar.subviews.first
        
        if self.navigationBar.isTranslucent {
            // 拿到UIImageView
            if let backgroundImageView = barBackgroundView?.subviews.first as? UIImageView, backgroundImageView.image != nil {
                barBackgroundView?.alpha = alpha
            } else if let backgroundEffectView = barBackgroundView?.subviews[1] {
                // UIVisualEffectView
                backgroundEffectView.alpha = alpha
            }
        } else {
            barBackgroundView?.alpha = alpha
        }
        self.navigationBar.clipsToBounds = (alpha == 0.0)
    }
}
