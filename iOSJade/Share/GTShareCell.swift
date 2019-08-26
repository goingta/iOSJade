//
//  GTShareCell.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import Foundation

class GTShareCell: UICollectionViewCell {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    var model: GTShareItemModel? {
        didSet {
            if let model = self.model {
                self.titleLabel.text = model.name
                self.iconImageView.image = UIImage.init(named: model.icon)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    private func setupUI() {
        iconImageView.do {
            contentView.addSubview($0)
            
            $0.snp.makeConstraints({ (make) in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(Adapt(40))
            })
        }
        
        titleLabel.do {
            contentView.addSubview($0)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.font = UIFont.systemFont(ofSize: 10)
            
            $0.snp.makeConstraints({ (make) in
                make.top.equalTo(iconImageView.snp_bottom).offset(Adapt(3))
                make.left.right.bottom.equalToSuperview()
            })
        }
    }
}
