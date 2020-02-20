//
//  BezierPathView.m
//  BaseProject
//
//  Created by ZSXJ on 2018/4/23.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    
    return self;
}

- (void)refresh {
    [self creatMaskLayer];
    self.layer.mask = _maskLayer;
}

- (void)addMaskLayer {
    [self creatMaskLayer];
    
    // mask 是 对于超出的部分进行隐藏，在self.layer上 留下 _maskLayer的非空白的部分 （也就是 只显示_maskLayer 所规划的路径部分，当然_maskLayer.fillColor && strokeColor 等不会显示，只是充当 非空白区域的模式，其中颜色的透明度 也会影响显露的部分）
    [self.layer addSublayer: _maskLayer];
}

- (void)creatMaskLayer {
    CGRect frame = self.frame;
    
    //线的半径为扇形半径的一半，线宽是扇形半径->半径+线宽的一半=真实半径，这样就能画出圆形了
    _radius = (frame.size.width - _kMargin*2)/2.f;
    _centerPoint = CGPointMake(_radius + _kMargin, _radius + _kMargin);
    
    //通过mask来控制显示区域
    _maskLayer = [CAShapeLayer layer];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:_centerPoint radius:_radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    _maskLayer.path = maskPath.CGPath;
    
    //设置边框颜色为不透明，则可以通过边框的绘制来显示整个view
    _maskLayer.strokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:_strokeColorAlpha].CGColor;
    
    // lineWidth line的中心在圆周上 设置line的width 一半在圆内 一半在圆外
    _maskLayer.lineWidth = _lineWidth;
    
    //设置填充颜色为透明，可以通过设置半径来设置中心透明范围
    _maskLayer.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:_fillColorAlpha].CGColor;;
    
    // 绘制边线轮廓路径的子区域
    _maskLayer.strokeEnd = _strokeEnd;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    if (_maskLayer) {
        _maskLayer.lineWidth = lineWidth;
    }
}


@end
