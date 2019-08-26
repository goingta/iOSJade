//
//  GTCoverFlowLayout.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import UIKit

class GTCoverFlowLayout: UICollectionViewFlowLayout {
    
    //    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    ////        var offsetAdjustment = CGFloat(MAXFLOAT)   //当前处理器能处理的最大浮点数
    ////        let horizontalCenter = proposedContentOffset.x + (self.collectionView!.bounds.width / 2.0)//collectionView落在屏幕中点的x坐标
    ////        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width:  self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
    ////        let array = super.layoutAttributesForElements(in: targetRect) as [UICollectionViewLayoutAttributes]? //目标区域中包含的cell
    ////        for layoutAttributes in array!{
    ////            let itemHorizontalCenter = layoutAttributes.center.x
    ////            if(abs(itemHorizontalCenter-horizontalCenter) < abs(offsetAdjustment)){   //ABS求绝对值
    ////                offsetAdjustment = itemHorizontalCenter-horizontalCenter     //比较谁离中心点更近
    ////            }
    ////        }
    ////        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)  //返回collectionView最终停留的位置
    //
    //        guard let cvBounds = self.collectionView?.bounds else { return proposedContentOffset }
    //
    //        guard let attributesArray = self.layoutAttributesForElements(in: cvBounds) else { return proposedContentOffset }
    //
    //        let halfWidth = cvBounds.size.width * 0.5
    //        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
    //
    //        var candidateAttributes: UICollectionViewLayoutAttributes!
    //        for attributes in attributesArray {
    //            if (attributes.representedElementCategory != UICollectionView.ElementCategory.cell) {
    //                continue
    //            }
    //
    //            if let canAttributes = candidateAttributes {
    //                if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(canAttributes.center.x - proposedContentOffsetCenterX) {
    //                    candidateAttributes = attributes
    //                }
    //            } else {
    //                candidateAttributes = attributes
    //            }
    //
    //
    //
    //        }
    //        return CGPoint(x: candidateAttributes.center.x - halfWidth, y: proposedContentOffset.y)
    //    }
    
    let ActiveDistance : CGFloat = 350 //垂直缩放除以系数
    let ScaleFactor : CGFloat = 0.25     //缩放系数  越大缩放越大
    
    //    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    //        //rect范围内的cell视图
    //        let array = super.layoutAttributesForElements(in: rect)
    //        var visibleRect = CGRect()
    //        visibleRect.origin = self.collectionView!.contentOffset
    //        visibleRect.size = self.collectionView!.bounds.size
    //        for attributes in array!{
    //            let distance = visibleRect.midX - attributes.center.x
    //            let normalizedDistance = distance/ActiveDistance
    //            let zoom = 1 - ScaleFactor*(abs(normalizedDistance))
    //            let alpha = 1 - abs(normalizedDistance)
    //            attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0)   //SX：X轴缩放   SY：Y轴缩放
    //            attributes.alpha = alpha
    //            attributes.zIndex = 1
    //        }
    //        return array
    //        let array = super.layoutAttributesForElements(in: rect)
    //        //屏幕中线
    //        let centerX = self.collectionView?.contentOffset.x + self.collectionView?.bounds.size.width/2
    //
    //    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        //滑动放大缩小  需要实时刷新layout
        return true
    }
}
