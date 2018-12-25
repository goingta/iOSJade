//
//  QQAppViewController.swift
//  iOSJade
//
//  Created by goingta on 2018/12/25.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation
import UIKit

class QQAppViewController: UIViewController {
    
    var tableView: UITableView!
    var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        self.title = "仿QQApp"
        self.initUI()
        self.navigationController?.setNeedsNavigationBackground(alpha: 0)
    }
    
    func initUI() {
        imgView = UIImageView.init(frame: CGRect(x: 0, y: -260, width: self.view.frame.size.width, height: 260))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage.init(named: "headerBg.jpg")
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: 260 - 88, left: 0, bottom: 0, right: 0)
        
        tableView.addSubview(imgView)
        self.view.addSubview(tableView)
    }
}

extension QQAppViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "item \(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY > -120) {
            UIView.animate(withDuration: 0.6) {
                self.navigationController?.setNeedsNavigationBackground(alpha: 1)
            }
        } else {
            self.navigationController?.setNeedsNavigationBackground(alpha: 0)
        }
    }
}
