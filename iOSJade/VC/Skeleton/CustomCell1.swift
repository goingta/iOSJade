//
//  CustomCell.swift
//  iOSJade
//
//  Created by goingta on 2019/8/7.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit
import Then

class CustomCell1: UITableViewCell {
    let iconImage = UIImageView()
    
    let subLabel = UILabel()
    let titleLabel = UILabel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.isSkeletonable = true
        self.contentView.isSkeletonable = true
        iconImage.do {
            self.addSubview($0)
            $0.image = UIImage(named: "经典")
            $0.isSkeletonable = true
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = self.iconImage.frame.width/2
            
            $0.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        }
    
        titleLabel.do {
            self.addSubview($0)
            $0.text = "主标题"
            $0.isSkeletonable = true
            $0.frame = CGRect(x: 80, y: 10, width: 285, height: 21)
        }
        
        subLabel.do {
            self.addSubview($0)
            $0.isSkeletonable = true
            $0.text = "详情介绍，这是一条详细信息介绍，不够长吗，那我就给它加长加长"
            $0.frame = CGRect(x: 80, y: 35.5, width: 285, height: 33.5)
        }
    }
    
}
