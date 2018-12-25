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
    
    func toString() -> String {
        switch self {
        case .打开WebView:
            return "打开WebView"
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
