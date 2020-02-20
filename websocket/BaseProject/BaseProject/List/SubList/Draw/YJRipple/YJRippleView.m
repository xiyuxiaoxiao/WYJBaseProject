//
//  YJRippleView.m
//  WYJNotePad
//
//  Created by ZSXJ on 16/7/11.
//  Copyright © 2016年 ShouXinTech. All rights reserved.
//

#import "YJRippleView.h"

@implementation YJRippleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        
        [self setup];
    }
    return self;
}

/*
 
 可以展示的个数 > 创建副本的数量 --->  则中间会有剩余的空白
 可以展示的个数 < 创建副本的数量 --->   则和等于的一样
 
   可以展示的个数 = 动画时间 / 复制副本之间的延迟
   实际展示的个数 = 可以展示的个数 > 创建副本的数量 ? 创建副本的数量 : 可以展示的个数

   波纹之间的宽度 = 放大倍数 * self.width / 可以展示的个数
   放大倍数 = 结束的比例 - 开始比例  （此处默认 x，y比例都相等）
 
*/

- (void)setup
{
    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = self.layer.bounds;
    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
    pulseLayer.fillColor = [UIColor clearColor].CGColor;//填充色
    pulseLayer.opacity = 0.0;
    pulseLayer.lineWidth = 2;
    pulseLayer.strokeColor = [UIColor redColor].CGColor;
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = self.bounds;
    replicatorLayer.instanceCount =5;//创建副本的数量,包括源对象。
    replicatorLayer.instanceDelay = 2.5;//复制副本之间的延迟
    [replicatorLayer addSublayer:pulseLayer];
    [self.layer addSublayer:replicatorLayer];
    
    // opacity 不透明度 用来表示闪烁
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(1.0);
    opacityAnima.toValue = @(0.0);
    
    // transform 缩放
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
//    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeRotation(0, 0, 0, 0), M_PI, 1, 1, 0)];
//    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DMakeRotation(0, 0, 0, 0), 2*M_PI, 1, 1, 1)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 5.0;// 动画时间
    groupAnima.autoreverses = YES;
    groupAnima.repeatCount = HUGE;  // 动画重复时间
    [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
}

@end
