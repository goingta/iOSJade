//
//  TableViewController.swift
//  iOSJade
//
//  Created by goingta on 2018/12/25.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation
import UIKit


enum ListData:Int {
    //研发类
    case 打开WebView
    case 透明导航栏
    case 网络请求
    case CALayer相关
    case 测试循环引用
    case 骨骼图
    case 自定义UI分享
    case 自带UI分享
    
    func toString() -> String {
        switch self {
        case .打开WebView:
            return "打开WebView"
        case .透明导航栏:
            return "透明导航栏"
        case .网络请求:
            return "网络请求"
        case .CALayer相关:
            return "CALayer相关"
        case .测试循环引用:
            return "测试循环引用"
        case .骨骼图:
            return "骨骼图"
        case .自定义UI分享:
            return "自定义UI分享"
        case .自带UI分享:
            return "自带UI分享"
        default:
            return ""
        }
    }
    
    static let count: Int = {
        var max: Int = 0
        while let _ = ListData(rawValue: max) { max += 1 }
        return max
    }()
}

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        self.title = "首页"
        navBarBarTintColor = UIColor.init(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
        self.view.backgroundColor = UIColor.init(red: 0/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
        navBarBackgroundAlpha = 0
    }
}

extension TableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let type = ListData.init(rawValue: indexPath.row) {
            
            switch type {
                case .打开WebView:
                    let webVC = WKWebViewController()
                    webVC.webUrlString = "https://www.baidu.com/"
                    self.navigationController?.pushViewController(webVC, animated: true)
                case .透明导航栏:
                    let vc = QQAppViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .网络请求:
                    let vc = NetworkViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .CALayer相关:
                    let vc = CALayerViewContoller()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .测试循环引用:
                    let vc = TestViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .骨骼图:
                    let vc = SkeletonTableViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .自定义UI分享:
                    let title = "来自GTShare"
                    let text = "GTShare"
//                    let image = UIImage(named: "headerBg")
                    let thumbImage = UIImage(named: "headerBg")
                    let url = URL.init(string: "http://www.goingta.cn")
                    let shareParams = NSMutableDictionary()
                    
                    
                    //通用
                    shareParams.ssdkSetupShareParams(byText: text, images: thumbImage, url: url, title: title, type: .auto)
                    //微信
                    //                shareParams.ssdkSetupWeChatParams(byText: text, title: title, url: videoPath, thumbImage: thumbImage, image: image, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, sourceFileExtension: "mp4", sourceFileData: nil, type: .video, forPlatformSubType: .subTypeWechatSession)
                    //QQ
                    //                shareParams.ssdkSetupQQParams(byText: text, title: title, url: videoPath, audioFlash: nil, videoFlash: nil, thumbImage: thumbImage, images: image, type: .video, forPlatformSubType: .subTypeQQFriend)
                    //微博
//                    var latitude: Double = 0
//                    var longitude: Double = 0
//
//                    shareParams.ssdkSetupSinaWeiboShareParams(byText: text, title: title, images: image,
//                                                              video: url.absoluteString, url: url,
//                                                              latitude: latitude, longitude: longitude,
//                                                              objectID: nil, isShareToStory: true, type: .video)
                    
                    GTShare.share(withShareParams: shareParams)
                case .自带UI分享:
                    let title = "来自GTShare"
                    let text = "GTShare"
                    //                    let image = UIImage(named: "headerBg")
                    let thumbImage = UIImage(named: "headerBg")
                    let url = URL.init(string: "http://www.goingta.cn")
                    let shareParams = NSMutableDictionary()
                    
                    
                    //通用
                    shareParams.ssdkSetupShareParams(byText: text, images: thumbImage, url: url, title: title, type: .auto)
                    ShareSDK.showShareActionSheet(nil, items: nil, shareParams: shareParams) { (state, platformType, userData, contentEntity, error, end) in
                        switch state {
                        case .success:
                            print("分享成功")
                        case .cancel:
                            print("取消")
                        case .fail:
                            GTPopup.showHint("分享失败")
                        case .begin:
                            print("begin")
                        case .upload:
                            print("upload")
                        @unknown default:
                            print("其他")
                        }
                    }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if let text = ListData.init(rawValue: indexPath.row) {
            cell?.textLabel?.text = text.toString()
        }
        return cell!
    }
}
