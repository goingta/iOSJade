//
//  GTVerticalLabel.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import Foundation
class GTVerticalLabel: UILabel {
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }
    
    override init(frame: CGRect) {
        self.verticalAlignment = .middle
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.verticalAlignment = .middle
        super.init(coder: aDecoder)
    }
    
    var verticalAlignment: VerticalAlignment {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch self.verticalAlignment {
        case .top:
            textRect.origin.y = bounds.origin.y
        case .bottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
        case .middle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
        }
        return textRect
    }
    
    override func drawText(in rect: CGRect) {
        let actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: numberOfLines)
        super.drawText(in: actualRect)
    }
}
