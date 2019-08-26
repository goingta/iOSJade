//
//  ATPlayerLoading.m
//  Avatar
//
//  Created by goingta on 2019/8/16.
//  Copyright © 2019 Pinguo Inc. All rights reserved.
//

#import "ATPlayerLoading.h"


@interface ATPlayerLoading ()

@property (nonatomic,strong) UIImageView *loadingView;
@property (nonatomic) BOOL animating;

@end

@implementation ATPlayerLoading

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _animating = NO;
        [self addSubview:self.loadingView];
    }
    return self;
}

- (void)startAnimating {
    if (self.animating) return;
    self.animating = YES;
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnim.toValue = [NSNumber numberWithFloat:2 * M_PI];
    rotationAnim.duration = 1;
    rotationAnim.repeatCount = CGFLOAT_MAX;
    rotationAnim.removedOnCompletion = NO;
    [self.loadingView.layer addAnimation:rotationAnim forKey:@"rotation"];
    self.hidden = NO;
}

- (void)stopAnimating {
    if (!self.animating) return;
    self.animating = NO;
    [self.loadingView.layer removeAllAnimations];
    self.hidden = YES;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[UIImageView alloc] initWithFrame:self.bounds];
        _loadingView.image = [UIImage imageNamed:@"player_icon_loading"];
    }
    return _loadingView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.loadingView.frame = self.bounds;
}

@end
