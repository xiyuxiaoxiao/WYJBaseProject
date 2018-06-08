//
//  BezierPathView.h
//  BaseProject
//
//  Created by ZSXJ on 2018/4/23.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BezierPathView : UIView

@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat kMargin;
@property (nonatomic, assign) CGFloat padding;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat strokeEnd;

@property (nonatomic, assign) CGFloat fillColorAlpha;
@property (nonatomic, assign) CGFloat strokeColorAlpha;

- (void)refresh;
- (void)addMaskLayer;
@end
