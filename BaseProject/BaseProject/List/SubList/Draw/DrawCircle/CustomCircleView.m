//
//  CustomCircleView.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/20.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "CustomCircleView.h"

@implementation CustomCircleView


#pragma mark - draw rect

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSet];
    }
    return  self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSet];
}

- (void)initSet {
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect
{
    
    [self drawInContext:UIGraphicsGetCurrentContext()];

    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.userInteractionEnabled = YES;
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self setContentCustom:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
//    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
//    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
//    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
//    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
//    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
//    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    
}


// 扇形  isFanshaped: (是否是扇形  自动合并 起点终点)
- (void)setContentCustom:(CGContextRef)context {
    CGRect rrect = self.bounds;
    
    //圆点
    CGFloat centerX     = rrect.size.width/2;
    CGFloat centerY     = centerX;
    
    CGFloat radius      = centerX;
    CGFloat angle       = 30; // 中间与某一边扇形之间的角度差
    CGFloat startAngle  = M_PI * (90+angle) / 180;
    CGFloat endAngle    = M_PI * (90-angle) / 180;
    
    CGFloat pointLeftY = radius * cosf(M_PI*angle/180) + centerY;
    CGFloat pointLeftX = centerX - radius * sinf(M_PI * angle/180);

    CGFloat pointRightY = pointLeftY;
    CGFloat pointRightX = centerX + radius * sinf(M_PI*angle/180);
    
    
    CGPoint pointLeft = CGPointMake(pointLeftX, pointLeftY);
    CGPoint pointRight = CGPointMake(pointRightX, pointRightY);
    
    CGPoint pointBottomMid = CGPointMake(centerX, rrect.size.height);
    
    // 绘制扇形 全部的路径
    if (self.type == Fanshaped) {
        
        CGContextMoveToPoint(context, centerX, centerY);
        CGContextAddLineToPoint(context,pointLeft.x, pointLeft.y);
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
        CGContextMoveToPoint(context, centerX, centerY);
    }
    
    else if (self.type == RadianAuthoClose){
        // angle 参数需要的是 弧度单位
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
    }
    
    else if (self.type == BottomMidArrow) {
        
        CGContextMoveToPoint(context, pointRight.x, pointRight.y);
        CGContextAddLineToPoint(context, pointBottomMid.x, pointBottomMid.y);
        CGContextAddLineToPoint(context,pointLeft.x, pointLeft.y);
        CGContextAddArc(context, centerX, centerY, radius, startAngle, endAngle, 0);
    }
    
    CGContextClosePath(context);
}



/*
 
 暂不适用 因为都是根据 中心点 与下面的间距 或者一定的角度 再去计算相应的点
 
 */

/*
#pragma mark - 计算圆上点的角度
+(CGFloat) calcCirclePointAngleWithCenter:(CGPoint) center  andWithPoint : (CGPoint) point andWithRadius: (CGFloat) radius{
    
    // 计算出来是角度 = 弧度 * （180/M_PI）
//    CGFloat angle = acosf((fabs(point.y - center.y))/radius) *180/M_PI;
    // 弧度
    CGFloat angle = acosf((fabs(point.y - center.y))/radius);
    
    
    if (point.y - center.y > 0) {
        if (point.x - center.x > 0) {
            angle = M_PI/2 - angle;
        }
        if (point.x - center.x < 0) {
            angle = M_PI/2 + angle;
        }
    }
    
    else if (point.y - center.y < 0) {
        if (point.x - center.x > 0) {
            angle = -1 * (M_PI/2 - angle);
        }
        if (point.x - center.x < 0) {
            angle = -1 * (M_PI/2 + angle);
        }
    }
    
    else if (point.y - center.y == 0) {
        if (point.x - center.x > 0) {
            angle = 0;
        }
        if (point.x - center.x < 0) {
            angle = M_PI;
        }
    }
    
    return angle;
}

// 计算角度上的点  angle：角度    cosf传入 弧度
+(CGPoint) calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

*/

@end
