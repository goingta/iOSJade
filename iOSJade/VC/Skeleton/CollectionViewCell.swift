//
//  CollectionViewCell.swift
//  iOSJade
//
//  Created by goingta on 2019/8/6.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit
import SkeletonView

class CollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        isSkeletonable = true
        createLabel()
        
        addSubview(img)
        img.isSkeletonable = true
        
        NSLayoutConstraint.activate([
            img.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            img.centerYAnchor.constraint(equalTo: centerYAnchor),
            img.heightAnchor.constraint(equalToConstant: 50),
            img.widthAnchor.constraint(equalToConstant: 50)
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel() {
        label = UILabel()
        label.isSkeletonable = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.widthAnchor.constraint(equalToConstant: 80)
            ])
    }
    
}
