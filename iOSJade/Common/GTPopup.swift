//
//  GTPopup.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxGesture
import RxCocoa
import SnapKit

//FIXME @tl 这个类，目前之花了半天时间写的，有很多不合理的地方，后续有时间再来优化
private let kAutoDissmissTime: Double = 3.0

class GTPopup: NSObject {
    
    //通用
    static var disposed = DisposeBag()
    static var maskView: UIView?
    //loading
    static var loadingView: AnimationView?
    static var loadingTitleLabel: UILabel?
    //tips提示
    static var tipsView: UIView?
    //确认框相关
    static var contentView: UIView?
    static var titleLabel: UILabel?
    static var detailsLabel: GTVerticalLabel?
    static var actionButton: UIButton?
    static var cancelButton: UIButton?
    
    static var rootWindow: UIWindow? = {
        let windows = UIApplication.shared.windows
        for window in windows {
            if let rootVC = window.rootViewController,(rootVC.isKind(of: UINavigationController.self) || rootVC.isKind(of:UITabBarController.self)){
                return window
            }
        }
        return nil
    }()
    
    static func dismiss(delay: Float = 0) {
        if delay == 0 {
            self.loadingView?.removeFromSuperview()
            self.loadingTitleLabel?.removeFromSuperview()
            self.maskView?.removeFromSuperview()
            self.tipsView?.removeFromSuperview()
            self.loadingView = nil
            self.loadingTitleLabel = nil
            self.maskView = nil
            self.tipsView = nil
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(delay))) {
                //FIXME @tl 这里应该用个队列来搞，加了动画的视图，都应该动画消失
                if let loadingView = self.loadingView {
                    self.hideWithFadeAnimation(view: loadingView, completion: nil)
                }
                if let loadingTitleLabel = self.loadingTitleLabel {
                    self.hideWithFadeAnimation(view: loadingTitleLabel, completion: nil)
                }
                
                if let maskView = self.maskView {
                    self.hideWithFadeAnimation(view: maskView, completion: { (finish) in
                        self.loadingView?.removeFromSuperview()
                        self.loadingTitleLabel?.removeFromSuperview()
                        self.maskView?.removeFromSuperview()
                        self.tipsView?.removeFromSuperview()
                        self.loadingView = nil
                        self.loadingTitleLabel = nil
                        self.maskView = nil
                        self.tipsView = nil
                    })
                }
            }
        }
    }
    //MARK: - 公共
    static func addMask(superView: UIView,maskColor: UIColor? = nil) {
        if maskColor == nil {
            if self.maskView == nil {
                let blurEffect = UIBlurEffect(style: .dark)
                self.maskView = UIVisualEffectView(effect: blurEffect)
                guard let maskView = self.maskView else {return}
                superView.addSubview(maskView)
                maskView.snp.makeConstraints { (make) in
                    make.top.left.right.bottom.equalToSuperview()
                }
            }
        } else {
            if self.maskView == nil {
                self.maskView = UIView()
                guard let maskView = self.maskView else {return}
                maskView.backgroundColor = maskColor
                superView.addSubview(maskView)
                maskView.snp.makeConstraints { (make) in
                    make.top.left.right.bottom.equalToSuperview()
                }
            }
        }
    }
    
    //MARK: - loading相关
    static func loading() {
        self.loadingWith(title: "", onView: nil, mask: true, atYOffset: 0)
    }
    
    static func loading(mask: Bool) {
        self.loadingWith(title: "", onView: nil, mask: mask, atYOffset: 0)
    }
    
    static func loadingWith(title: String, mask: Bool = false) {
        self.loadingWith(title: title, onView: nil, mask: mask, atYOffset: 0)
    }
    
    static func loadingWith(title: String, onView superView: UIView?,mask: Bool,maskColor: UIColor? = UIColor.black.withAlphaComponent(0.4), atYOffset: CGFloat) {
        guard let superView = superView ?? self.rootWindow else {return}
        
        if mask {
            self.addMask(superView: superView,maskColor: maskColor)
        }
        
        if self.loadingView == nil {
            let animation = Animation.named("loading")
            self.loadingView = AnimationView(animation: animation)
            guard let loadingView = self.loadingView else {return}
            
            superView.addSubview(loadingView)
            loadingView.contentMode = .scaleAspectFill
            loadingView.loopMode = .loop
            loadingView.backgroundBehavior = .pauseAndRestore
            loadingView.snp.makeConstraints { (make) in
                make.width.height.equalTo(50)
                make.center.equalToSuperview()
            }
        }
        
        if title.count > 0 && self.loadingTitleLabel == nil {
            self.loadingTitleLabel = UILabel()
            guard let titleLabel = self.loadingTitleLabel else {return}
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = .white
            titleLabel.text = title
            titleLabel.textAlignment = .center
            
            superView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(2*kMargin)
                make.right.equalToSuperview().offset(-2*kMargin)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(50)
                make.height.equalTo(24)
            }
        }
        
        self.loadingView?.isHidden = false
        self.loadingView?.play()
    }
    
    //MARK: - 提示相关
    static func showHint(_ msg: String, mask: Bool = false, maskColor: UIColor? = nil) {
        let message = NSAttributedString(string: msg)
        self.showHint(msg: message, onView: nil, mask: mask, maskColor: maskColor, atYOffset: 0)
    }
    
    static func showHint(_ msg: NSAttributedString, mask: Bool = false, maskColor: UIColor? = nil) {
        self.showHint(msg: msg, onView: nil, mask: mask , maskColor: maskColor, atYOffset: 0)
    }
    
    static func showHint(msg: NSAttributedString, onView superView: UIView?, mask: Bool = false, maskColor: UIColor? = nil, atYOffset: CGFloat,showAnimationTime: Double = kAnimationTime,stayTime: Double = kAutoDissmissTime,hideAnimationTime: Double = kAnimationTime) {
        guard let superView = superView ?? self.rootWindow else {return}
        if mask {
            self.addMask(superView: superView,maskColor: maskColor)
            if maskColor == nil,let maskView = self.maskView as? UIVisualEffectView {
                //                self.showWithFadeAnimation(view: maskView, completion: nil)
                maskView.effect = nil
                UIView.animate(withDuration: kAnimationLongTime) {
                    maskView.effect = UIBlurEffect(style: .dark)
                }
            }
        }
        if self.tipsView == nil {
            self.tipsView = UIView()
            guard let tipsView = self.tipsView else {return}
            superView.addSubview(tipsView)
            tipsView.layer.cornerRadius = 10
            tipsView.clipsToBounds = true
            tipsView.snp.makeConstraints { (make) in
                make.width.equalTo(240)
                make.height.equalTo(115)
                make.center.equalToSuperview()
            }
            
            //加个模糊
            self.addBlureView(superView: tipsView)
            
            //文字内容
            let tipsLabel = UILabel()
            tipsLabel.textColor = UIColor.white
            tipsLabel.font = UIFont.systemFont(ofSize: 18)
            tipsLabel.textAlignment = .center
            //            tipsLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            tipsLabel.numberOfLines = 0
            tipsView.addSubview(tipsLabel)
            
            tipsLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.bottom.equalToSuperview().offset(-10)
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
            }
            
            tipsLabel.attributedText = msg
            
            self.showWithFadeAnimation(view: tipsView,animationTime: showAnimationTime, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(stayTime))) {
                self.hideWithFadeAnimation(view: tipsView,animationTime: hideAnimationTime, completion: { (finish) in
                    GTPopup.dismiss()
                })
            }
        }
    }
    
    //MARK: - 确认框相关
    static func close() {
        //由于，可能存在连续调用，所以先清理原有对象，动画用另一个对象接着做
        guard let contentView = self.contentView else {return}
        
        let contentViewCache = self.contentView
        let maskViewCache = self.maskView
        
        self.contentView = nil
        self.maskView = nil
        self.titleLabel = nil
        self.detailsLabel = nil
        self.actionButton = nil
        self.cancelButton = nil
        
        
        self.hideWithFadeAnimation(view: contentView) { (finish) in
            contentViewCache?.removeFromSuperview()
            maskViewCache?.removeFromSuperview()
        }
    }
    
    static func alert(details: String,buttonTitle: String,mask: Bool = false,maskColor: UIColor? = nil) {
        self.alert(title: "", details: details, cancelTitle: "", actionTitle: buttonTitle,actionCallback: nil,onView: nil, mask: false)
    }
    
    static func alert(title: String,details: String,cancelTitle: String = "",actionTitle: String,actionCallback:((Bool)->Void)?
        = nil,onView superView: UIView? = nil,mask: Bool = true,maskColor: UIColor? = UIColor.black.withAlphaComponent(0.4)) {
        
        guard let superView = superView ?? self.rootWindow else {return}
        GTPopup.close()
        if (mask) {
            self.addMask(superView: superView,maskColor: maskColor)
            //            if let mask = self.maskView {
            //                mask.rx.tapGesture().bind { _ in
            //                    GTPopup.close()
            //                }.disposed(by: disposed)
            //            }
        }
        
        self.contentView = UIView()
        
        let width:CGFloat = 270
        let height:CGFloat = 135
        let buttonHeight: CGFloat = 46
        guard let contentView = self.contentView else {return}
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        //模糊，先放这，以后移
        self.addBlureView(superView: contentView)
        
        superView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.width.equalTo(width)
            make.height.equalTo(height)
            make.center.equalToSuperview()
        }
        
        let hasTitle = title.count > 0
        let hasDetails = details.count > 0
        
        if hasDetails {
            self.detailsLabel = GTVerticalLabel()
            guard let detailsLabel = self.detailsLabel else {return}
            detailsLabel.font = UIFont.systemFont(ofSize: title.count == 0 ? 16 : 12)
            detailsLabel.textColor = .white
            detailsLabel.verticalAlignment = hasTitle ? .top : .middle
            detailsLabel.numberOfLines = 0
            detailsLabel.textAlignment = .center
            detailsLabel.text = details
            detailsLabel.adjustsFontSizeToFitWidth = true
            contentView.addSubview(detailsLabel)
            
            detailsLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(hasTitle ? buttonHeight : 0)
                make.left.equalToSuperview().offset(30)
                make.right.equalToSuperview().offset(-30)
                make.bottom.equalToSuperview().offset(-buttonHeight)
            }
        }
        
        let lineView = UIView()
        contentView.addSubview(lineView)
        lineView.backgroundColor = UIColor.colorWithHex("0x535353")
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-buttonHeight)
        }
        
        self.actionButton = UIButton()
        guard let actionButton = self.actionButton else {return}
        actionButton.setTitleColor(UIColor.purpleText, for: .normal)
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        actionButton.setTitle(actionTitle, for: .normal)
        
        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }
        
        actionButton.rx.tap.bind { _ in
            if let callback = actionCallback {
                callback(false)
            } else {
                GTPopup.close()
            }
            }.disposed(by: disposed)
        
        if cancelTitle.count > 0 {
            self.cancelButton = UIButton()
            guard let cancelButton = self.cancelButton else {return}
            cancelButton.setTitle(cancelTitle, for: .normal)
            cancelButton.setTitleColor(.white, for: .normal)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            
            contentView.addSubview(cancelButton)
            cancelButton.snp.makeConstraints { (make) in
                make.left.bottom.equalToSuperview()
                make.height.equalTo(buttonHeight)
                make.width.equalTo(width/2)
            }
            
            //竖线
            let varticalLine = UIView()
            contentView.addSubview(varticalLine)
            varticalLine.backgroundColor = UIColor.colorWithHex("0x535353")
            varticalLine.snp.makeConstraints { (make) in
                make.width.equalTo(1)
                make.height.equalTo(buttonHeight)
                make.centerX.bottom.equalToSuperview()
            }
            
            actionButton.snp.updateConstraints { (make) in
                make.left.equalToSuperview().offset(width/2)
            }
            
            cancelButton.rx.tap.bind { _ in
                if let callback = actionCallback {
                    callback(true)
                } else {
                    GTPopup.close()
                }
                }.disposed(by: disposed)
        }
        
        if hasTitle {
            self.titleLabel = UILabel()
            guard let titleLabel = self.titleLabel else {return}
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = UIColor.white
            titleLabel.textAlignment = .center
            titleLabel.text = title
            
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.height.equalTo(buttonHeight)
                make.top.left.right.equalToSuperview()
            }
        }
        
        self.showWithFadeAnimation(view: contentView, completion: nil)
    }
    
    //MARK: - 动画
    static func showWithFadeAnimation(view: UIView,animationTime: Double = kAnimationTime,completion: ((Bool)->Void)?) {
        view.alpha = 0
        UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 1
        }, completion: completion)
    }
    
    static func hideWithFadeAnimation(view: UIView,animationTime: Double = kAnimationTime,completion: ((Bool)->Void)?) {
        view.alpha = 1
        UIView.animate(withDuration: animationTime, delay: 0, options: .curveEaseOut, animations: {
            view.alpha = 0
        }, completion: completion)
    }
    
    static func showWithFadeInAnimation(view: UIView) {
        let moveAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        moveAnimation.fromValue = view.center.y - 100
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 0.3
        fadeAnimation.toValue = 1
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [moveAnimation,fadeAnimation]
        groupAnimation.duration = 0.4
        groupAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.0, 1)
        
        view.layer.add(groupAnimation, forKey: "fadeIn")
    }
    
    //MARK: - 模糊背景
    private static func addBlureView(superView: UIView) {
        //模糊，先放这，以后移
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        superView.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }
}
