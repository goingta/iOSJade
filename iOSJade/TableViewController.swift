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
