# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iOSJade' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  #MARK: -- 测试使用
  pod "Reveal-SDK","4", :configurations => ["Debug"]
  
  # Pods for iOSJade
  
  # ------ 第三方工具库 ------
  pod 'Alamofire'
  pod 'SnapKit','4.2.0'
  pod 'Then'
  pod 'ZipArchive', '1.3.0'
  pod 'ZFPlayer', '~> 3.0'
  pod 'ZFPlayer/ControlView', '~> 3.0'
  pod 'ZFPlayer/AVPlayer', '~> 3.0'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxGesture','~> 3.0.0'
  pod 'Hero'
  pod 'PullToRefreshKit'
  pod 'SkeletonView'
  pod 'pop', '~> 1.0'
  pod 'lottie-ios'
  
  # ------ 分享 -------
  # 主模块(必须)
  pod 'mob_sharesdk'
  # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
  pod 'mob_sharesdk/ShareSDKUI'
  # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
  pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
  pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'
  pod 'mob_sharesdk/ShareSDKPlatforms/Douyin'
  pod 'mob_sharesdk/ShareSDKExtension'

  target 'iOSJadeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'iOSJadeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
