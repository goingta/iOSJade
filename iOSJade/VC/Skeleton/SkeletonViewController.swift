//
//  SkeletonViewController.swift
//  iOSJade
//
//  Created by goingta on 2019/8/6.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit

class SkeletonViewController: UIViewController {
    var collectionView: UICollectionView! {
        didSet {
            collectionView.isSkeletonable = true
            collectionView.backgroundColor = .clear
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            
            collectionView.dataSource = self
            collectionView.delegate = self
            
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.isSkeletonable = true
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: 100)
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.prepareSkeleton(completion: { done in
            self.view.showAnimatedSkeleton()
        })
        self.view.addSubview(collectionView)
        self.view.showSkeleton(usingColor: .red)
    }
}

extension SkeletonViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        return cell
    }
}
