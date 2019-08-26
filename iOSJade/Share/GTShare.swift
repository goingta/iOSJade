//
//  GTShare.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit
import RxSwift

private let kShareViewHeight:CGFloat = Adapt(253)
private let kItemHeight:CGFloat = Adapt(60)
private let kMaxAlertConfirmCount = 5
private let kSNSColumnCount:Int = 5

class GTShare: NSObject {
    private var _shareParams: NSMutableDictionary!
    private let contentView = UIView()
    private let shareView = UIView()
    private let disposeBag = DisposeBag()
    private var collectionView: UICollectionView!
    
    //    GTShareItemModel(name: "更多", icon: "sns_more",type: .typeAny)
    private let sns = [GTShareItemModel(name: "朋友圈", icon: "sns_wechat_timeline",type: .subTypeWechatTimeline),
                       GTShareItemModel(name: "微信好友", icon: "sns_wechat",type: .subTypeWechatSession),
                       GTShareItemModel(name: "抖音", icon: "sns_tiktok",type: .typeDouyin),
                       GTShareItemModel(name: "微博", icon: "sns_weibo",type: .typeSinaWeibo),
                       GTShareItemModel(name: "QQ", icon: "sns_qq",type: .subTypeQQFriend)]
    
    private var installedSNS = [GTShareItemModel]()
    private static var shared:GTShare!
    //有点击空白区域自动收起功能
    static func share(withShareParams shareParams: NSMutableDictionary) {
        GTShare.shared = GTShare.init(shareParams: shareParams, needTapBlankHide: true)
    }
    //根据需要有无点击空白区域自动收起功能，目前预览渲染页在用
    static func share(withShareParams shareParams: NSMutableDictionary,needTapBlankHide: Bool) {
        GTShare.shared = GTShare.init(shareParams: shareParams, needTapBlankHide: needTapBlankHide)
    }
    
    //隐藏视图
    static func dismiss(isAnimation: Bool = true) {
        GTShare.shared.dismiss(isAnimation: isAnimation)
    }
    
    @objc private func viewDidTap(tap: GTShareGestureRecognizer) {
        dismiss(isAnimation: tap.isAnimation)
    }
    
    //MARK: - UI相关
    private func show() {
        self.shareView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kShareViewHeight)
        self.contentView.alpha = 0
        UIView.animate(withDuration: kAnimationTime, animations: {
            self.shareView.frame = CGRect(x: 0, y: kScreenH - kShareViewHeight, width: kScreenW, height: kShareViewHeight)
            self.contentView.alpha = 1
        })
    }
    
    private func dismiss(isAnimation: Bool) {
        if isAnimation {
            UIView.animate(withDuration: kAnimationTime, animations: {
                self.shareView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kShareViewHeight)
                self.contentView.alpha = 0
            }) { _ in
                self.shareView.removeFromSuperview()
                self.contentView.removeFromSuperview()
            }
        } else {
            self.shareView.frame = CGRect(x: 0, y: kScreenH, width: kScreenW, height: kShareViewHeight)
            self.contentView.alpha = 0
            self.shareView.removeFromSuperview()
            self.contentView.removeFromSuperview()
        }
    }
    
    convenience init(shareParams: NSMutableDictionary) {
        self.init(shareParams: shareParams, needTapBlankHide: true)
    }
    
    init(shareParams: NSMutableDictionary, needTapBlankHide: Bool) {
        super.init()
        _shareParams = shareParams
        self.handleInstalledSNS()
        self.setupUI(needTapBlankHide: needTapBlankHide)
        self.show()
    }
    
    private func setupUI(needTapBlankHide: Bool) {
        let window = UIApplication.shared.keyWindow
        
        if needTapBlankHide {
            contentView.do {
                $0.frame = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH)
                $0.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                window?.addSubview($0)
                
                let tap = GTShareGestureRecognizer.init(target: self, action: #selector(viewDidTap(tap:))).then {
                    $0.isAnimation = true
                }
                
                $0.addGestureRecognizer(tap)
            }
        }
        
        shareView.do {
            $0.frame = CGRect(x: 0, y: kScreenH - kShareViewHeight, width: kScreenW, height: kShareViewHeight)
            $0.backgroundColor = .black
            window?.addSubview($0)
        }
        
        
        //小于5个时需要居中
        let itemSize = kScreenW/CGFloat(kSNSColumnCount)
        var margin:CGFloat = 0
        if self.installedSNS.count < kSNSColumnCount {
            margin = (kScreenW - (itemSize*CGFloat(self.installedSNS.count)))/2
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize, height: kItemHeight)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.do {
            self.shareView.addSubview($0)
            $0.register(GTShareCell.self, forCellWithReuseIdentifier: "shareCell")
            $0.delegate = self
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            
            $0.snp.makeConstraints({ (make) in
                make.left.equalToSuperview().offset(margin)
                make.right.equalToSuperview().offset(-margin)
                make.center.equalToSuperview()
                make.height.equalTo(kItemHeight)
            })
        }
    }
    
    //MARK: - 分享相关
    private func handleInstalledSNS() {
        for model in self.sns {
            if ShareSDK.isClientInstalled(model.type) || model.type == .typeAny {
                self.installedSNS.append(model)
            }
        }
    }
    
    private func share(withModel model: GTShareItemModel) {
        if model.type == .typeAny {
            GTShare.shared.dismiss(isAnimation: true)
            ///  applicationActivities 可以没有元素，系统会自动选择合适的平台
            var videoPath: NSURL = NSURL.init()
            if let dic = _shareParams["@platform(1)"] as? Dictionary<String, AnyObject>,let videoUrl = dic["video"] as? String {
                videoPath = NSURL.init(fileURLWithPath: videoUrl)
            } else {
                if let url = _shareParams["url"] as? NSURL {
                    videoPath = url
                }
            }
            if videoPath.absoluteString?.count == 0 {
                GTPopup.showHint("没有获取到视频")
                return
            }
            let activityController = UIActivityViewController(activityItems: [videoPath], applicationActivities: [])
            
            /// 可以排除一些不希望的平台 UIActivityType
            activityController.excludedActivityTypes = [.airDrop, .openInIBooks, .postToVimeo, .postToFlickr, .addToReadingList, .saveToCameraRoll, .assignToContact, .copyToPasteboard, .print, .mail,.message]
            
            activityController.completionWithItemsHandler = {
                (type, flag, array, error) -> Swift.Void in
                print(type ?? "")
            }
//            let rootVC = AppDelegate.
//            rootVC?.present(activityController, animated: true) { }
        } else {

            self.openSNS(withModel: model)
        }
    }
    
    private func openSNS(withModel model: GTShareItemModel) {
        ShareSDK.share(model.type, parameters: _shareParams) { (state, userData, contentEntity, error) in
            switch state {
            case .success:
                print("分享成功")
            case .cancel:
                print("取消")
            case .fail:
                if let error = error as? NSError {
                    print("失败，原因：",error.userInfo)
                    DispatchQueue.main.async {
                        GTPopup.showHint("分享失败")
                    }
                    /*
                     错误
                     
                     - SSDKErrorTypeUninitPlatform: 未初始化平台
                     - SSDKErrorTypeParams: 参数错误
                     - SSDKErrorTypeUnsupportContentType: 不支持的分享类型
                     - SSDKErrorTypeUnsetURLScheme: 尚未设置URL Scheme
                     - SSDKErrorTypeClientNotInstall: 尚未安装客户端
                     - SSDKErrorTypeUnsupportFeature: 不支持的功能
                     - SSDKErrorTypeSDKNotInstall: SDK集成错误，缺少必要文件
                     - SSDKErrorTypeSDKsApi: 第三方SDK Api返回错误
                     - SSDKErrorTypeSDKsCallback: 第三方SDK 回调错误
                     - SSDKErrorTypeAPIRequestFail: API请求失败
                     - SSDKErrorTypeMethodException: try块捕捉到异常
                     - SSDKErrorTypePermissionDenied: 权限拒绝
                     - SSDKErrorTypeUserUnauth: 用户尚未授权
                     typedef NS_ENUM(NSUInteger, SSDKErrorType) {
                     SSDKErrorUnknown = 0,
                     SSDKErrorTypeUninitPlatform = 100,
                     SSDKErrorTypeParams = 101,
                     SSDKErrorTypeUnsupportContentType = 102,
                     SSDKErrorTypeUnsetURLScheme = 103,
                     SSDKErrorTypeClientNotInstall = 104,
                     SSDKErrorTypeUnsupportFeature = 105,
                     SSDKErrorTypeSDKNotInstall = 201,
                     SSDKErrorTypeTokenExpired = 204,
                     SSDKErrorTypeUserUnauth = 205,
                     SSDKErrorTypeSDKsApi = 300,
                     SSDKErrorTypeSDKsCallback = 301,
                     SSDKErrorTypeAPIRequestFail = 302,
                     SSDKErrorTypeMethodException = 303,
                     SSDKErrorTypePermissionDenied = 500
                     };
                     
                     */
                }
            case .begin:
                print("begin")
            case .upload:
                print("upload")
            @unknown default:
                print("其他")
            }
        }
    }
    
    private func openWeixin(subChannel: String) {
        let result = WXApi.openWXApp()
        let status = (result ? "success" : "failed")
    }
}

//MARK: - 存储
extension GTShare {
    private func needShowConfirm(type: SSDKPlatformType) -> Bool {
        var count = UserDefaults.standard.integer(forKey: "ShareConfirm_\(type.rawValue)")
        if count < kMaxAlertConfirmCount {
            count += 1
            UserDefaults.standard.set(count, forKey: "ShareConfirm_\(type.rawValue)")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }
}

//MARK: - 协议
extension GTShare: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return installedSNS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shareCell", for: indexPath) as! GTShareCell
        cell.model = self.installedSNS[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.share(withModel: self.installedSNS[indexPath.item])
    }
}


struct GTShareItemModel {
    let name: String
    let icon: String
    let type: SSDKPlatformType
}
