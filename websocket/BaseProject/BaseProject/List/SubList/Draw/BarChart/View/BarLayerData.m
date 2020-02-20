//
//  BarLayerData.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/24.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "BarLayerData.h"

@implementation BarLayerData


- (UIBezierPath *)fill{
    CGFloat width = self.width * self.percent;
    CGFloat height = self.height;
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.y, width, height)];
    return path;
}

- (UIBezierPath *)noFill{
    CGFloat height = self.height;
    UIBezierPath * bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.y, 0, height)];
    return bezier;
}

- (CAShapeLayer *)shapeLayer{
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor colorWithRed:67/255.0 green:160/255.0 blue:1 alpha:1].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.path = [self fill].CGPath;
//    layer.opacity = _opacity;
    
//    if (_isShadow) {
//        layer.shadowOpacity = 0.5f;
//        layer.shadowColor = _shadowColor.CGColor;
//        layer.shadowOffset = CGSizeMake(2, 1);
//    }
    
//    if (_isAnimated) {
        CABasicAnimation * animation = [self animation];
        [layer addAnimation:animation forKey:nil];
//    }
    
    return layer;
}

#pragma mark - 动画

/**
 *  填充动画过程
 *
 *  @return CABasicAnimation
 */
- (CABasicAnimation *)animation{
    CABasicAnimation * fillAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    fillAnimation.duration = 0.25;
    fillAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fillAnimation.fillMode = kCAFillModeForwards;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fromValue = (__bridge id)([self noFill].CGPath);
    fillAnimation.toValue = (__bridge id)([self fill].CGPath);
    
    return fillAnimation;
}

@end
