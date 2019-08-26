//
//  ATPlayerLoading.h
//  Avatar
//
//  Created by goingta on 2019/8/16.
//  Copyright © 2019 Pinguo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ATPlayerLoading : UIView

@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;

- (void)startAnimating;

- (void)stopAnimating;

@end

NS_ASSUME_NONNULL_END
