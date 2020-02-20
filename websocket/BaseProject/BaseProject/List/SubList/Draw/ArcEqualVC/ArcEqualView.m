//
//  RadiusView.m
//  等分
//
//  Created by ZSXJ on 2016/11/22.
//  Copyright © 2016年 WYJ. All rights reserved.
//

#import "ArcEqualView.h"

@interface ArcEqualView ()
{
    double startAngle;  // 开始角度
    double angle;       // 间距角度
    double radius;      // 半径
    CGPoint center;     // 圆心
    
    CGFloat firstPointY;
    CGFloat secondPointY;
}
@end

@implementation ArcEqualView

- (instancetype)init
{
    self = [super init];
    if (self) {
        firstPointY = 80;
        secondPointY = 30;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        firstPointY = 80;
        secondPointY = 30;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [self creatRadian: rect];
    [self addImageView];
}

// 根据左边的点 与右边的点 圆心 确定圆  以左边点为 PI／2圆心在数轴上计算
-(void)creatRadian:(CGRect)rect {
    
    // 此计算特殊在于 圆心在y轴并且第一个点为: PI/2 使得有些计算比较方便
    
    // 第一个点
    CGFloat point1X = 0;
    CGFloat point1Y = 80;
    point1Y = firstPointY;
    
    // 第二个点
    CGFloat point2X = rect.size.width;
    CGFloat point2Y = 30;
    point2Y = secondPointY;
    
    CGFloat centerX  = 0;
    CGFloat centerY  = 0;
    centerY = (pow(point2X, 2) - pow(point1Y, 2) + pow(point2Y, 2))/(point2Y - point1Y)/2;
    
    // 圆心
    center = CGPointMake(centerX, centerY);
    
    // 半径
    radius = point1Y - centerY;
    
    // 角度 angle = 2 * arcsin(d/r)
    double x = pow(point1Y - point2Y, 2) + pow(point1X - point2X, 2);
    CGFloat distancePoint1and2 = fabs(pow(x, 0.5));
    double r = distancePoint1and2/radius;
    angle = asin(r/2) * 2;  //一PI为单位的
    
    // 起始角度
    startAngle = M_PI/2;
    
    //结束角度
    CGFloat endAngle = startAngle - angle;
    
    //开始画圆  clockwise 是否顺时针方向
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:NO];
    [path setLineWidth:1];
    [[UIColor lightGrayColor] set];
    [path stroke];
    
}

//添加等份的View
-(void)addImageView {
    double specing = angle/10;           // 两边的间距弧度

    double newAngleSpac = angle - specing*2;  //新的弧度的间距
    double newStartAngle = startAngle - specing;// 新的起始角标 两边都少了一点
    
    for (int i = 0; i < 5; i ++) {
        
        double newA = newStartAngle - newAngleSpac/(5-1) * i;
        
        CGFloat x =  center.x + cos(newA)*radius;
        CGFloat y =  center.y + sin(newA)*radius;
        CGPoint newPoint = CGPointMake(x, y);
        
        UIImageView *view = [[UIImageView alloc] init];
        view.center = newPoint;
        
        CGFloat viewW = 30;
        if (i == 2) {
            viewW = 40;
        }
        view.bounds = CGRectMake(0, 0, viewW, viewW);
        
        
        view.backgroundColor = [UIColor blueColor];
        view.layer.cornerRadius = viewW/2;
        view.layer.masksToBounds = YES;
        NSString *imageName = @"";
        if (_imageNameArray.count > i) {
            imageName = _imageNameArray[i];
        }
        view.image = [UIImage imageNamed:imageName];
        
        [self addSubview:view];
    }
}


-(void)firstPointAdd {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    firstPointY += 10;
    [self setNeedsDisplay];
}
-(void)firstPointDown {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    firstPointY -= 30;
    [self setNeedsDisplay];
}

-(void)seconderPointAdd {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    secondPointY += 10;
    [self setNeedsDisplay];
}

-(void)seconderPointDown {
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    secondPointY -= 10;
    [self setNeedsDisplay];
}

@end
