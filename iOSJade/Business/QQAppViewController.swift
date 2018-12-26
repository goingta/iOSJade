//
//  QQAppViewController.swift
//  iOSJade
//
//  Created by goingta on 2018/12/25.
//  Copyright © 2018 goingta. All rights reserved.
//

import Foundation
import UIKit

private let NAVBAR_COLORCHANGE_POINT:CGFloat = -80
private let IMG_HEIGHT:CGFloat = 260
private let SCROLL_DOWN_LIMIT:CGFloat = 100
private let LIMIT_OFFSET_Y:CGFloat = -(IMG_HEIGHT + SCROLL_DOWN_LIMIT)

class QQAppViewController: UIViewController {
    
    var tableView: UITableView!
    var imgView: UIImageView!
    let NAVBAR_COLORCHANGE_POINT = CGFloat(80.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        self.title = "仿QQApp"
        self.initUI()
        navBarBackgroundAlpha = 0
    }
    
    func initUI() {
        imgView = UIImageView.init(frame: CGRect(x: 0, y: -IMG_HEIGHT, width: self.view.frame.size.width, height: IMG_HEIGHT))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage.init(named: "headerBg.jpg")
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.contentInset = UIEdgeInsets(top: IMG_HEIGHT - CGFloat(self.navBarBottom()), left: 0, bottom: 0, right: 0)
        
        tableView.addSubview(imgView)
        self.view.addSubview(tableView)
    }
    
    func isIphoneX() -> Bool {
        return UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812))
    }
    
    func navBarBottom() -> Int {
        return self.isIphoneX() ? 88 : 64;
    }
}

extension QQAppViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = "item \(indexPath.row)"
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if (offsetY > NAVBAR_COLORCHANGE_POINT) {
            changeNavBarAnimateWithIsClear(isClear: false)
        } else {
            changeNavBarAnimateWithIsClear(isClear: true)
        }
        
        // 限制下拉距离
        if (offsetY < LIMIT_OFFSET_Y) {
            scrollView.contentOffset = CGPoint.init(x: 0, y: LIMIT_OFFSET_Y)
        }
        
        // 改变图片框的大小 (上滑的时候不改变)
        // 这里不能使用offsetY，因为当（offsetY < LIMIT_OFFSET_Y）的时候，y = LIMIT_OFFSET_Y 不等于 offsetY
        let newOffsetY = scrollView.contentOffset.y
        if (newOffsetY < -IMG_HEIGHT)
        {
            imgView.frame = CGRect(x: 0, y: newOffsetY, width: self.view.frame.size.width, height: -newOffsetY)
        }
    }
    
    // private
    private func changeNavBarAnimateWithIsClear(isClear:Bool)
    {
        UIView.animate(withDuration: 0.8, animations: { [weak self] in
            if let weakSelf = self
            {
                if (isClear == true) {
                    weakSelf.navBarBackgroundAlpha = 0
                }
                else {
                    weakSelf.navBarBackgroundAlpha = 1.0
                }
            }
        })
    }
}
