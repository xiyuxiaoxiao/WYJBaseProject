//
//  PieLayerData.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/19.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "PieLayerData.h"
#import "PieLayer.h"

@implementation PieLayerData

- (UIBezierPath *)pielayerPath{
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:self.centerPoint];
    [piePath addArcWithCenter:self.centerPoint radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    [piePath closePath];
    return piePath;
}

- (CAShapeLayer *)leadLineLayer {
    
    CGFloat radiusCenter1 = self.radius + self.firstLeadMargin;//环形扇形中心对应的半径
    CGFloat x1 = self.centerPoint.x + cosf((self.startAngle + self.endAngle) / 2) * radiusCenter1;
    CGFloat y1 = self.centerPoint.y + sinf((self.startAngle + self.endAngle) / 2) * radiusCenter1;
    
    CGFloat radiusCenter2 = self.radius + self.secondLeadMargin;//环形扇形中心对应的半径
    CGFloat x2 = self.centerPoint.x + cosf((self.startAngle + self.endAngle) / 2) * radiusCenter2;
    CGFloat y2 = self.centerPoint.y + sinf((self.startAngle + self.endAngle) / 2) * radiusCenter2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x1, y1)];
    [path addLineToPoint:CGPointMake(x2,y2)];
    [path addLineToPoint:CGPointMake(x2>=self.centerPoint.x?x2+37:x2-37, y2)];
    
    CAShapeLayer *leadLayer = [CAShapeLayer layer];
    leadLayer.path = path.CGPath;
    leadLayer.fillColor = [UIColor clearColor].CGColor;
    leadLayer.strokeColor = [UIColor whiteColor].CGColor;
    leadLayer.lineWidth = 2;
    
    return leadLayer;
}



- (CATextLayer *)createTextLayerWithText:(NSString *)text {
    
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    textLayer.contentsScale = 2;
    textLayer.alignmentMode = @"center";
    textLayer.fontSize = 14;
    textLayer.string = text;
    textLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
    
    CGSize size = [self.class textSizeWithText:text font:textLayer.fontSize];
    CGFloat w = size.width;
    CGFloat h = size.height;
    
//    textLayer.frame = [self textFrameCenterWithWidth:w height:h];
    textLayer.frame = [self textFrameLeaderLineWithWidth:w height:h];
    
    return textLayer;
}

// 创建text在扇形中心的frame
- (CGRect)textFrameCenterWithWidth:(CGFloat)w height:(CGFloat)h {
    CGFloat radiusCenter = self.radius/2;//环形扇形中心对应的半径
    return CGRectMake(self.centerPoint.x + cosf((self.startAngle + self.endAngle) / 2) * radiusCenter - w/2, self.centerPoint.y + sinf((self.startAngle + self.endAngle) / 2) * radiusCenter - h/2, w, h);
}

// 创建text在引线上的frame
- (CGRect)textFrameLeaderLineWithWidth:(CGFloat)w height:(CGFloat)h {
    
    CGFloat radiusCenter2 = self.radius + self.secondLeadMargin;//环形扇形中心对应的半径
    CGFloat x2 = self.centerPoint.x + cosf((self.startAngle + self.endAngle) / 2) * radiusCenter2;
    CGFloat y2 = self.centerPoint.y + sinf((self.startAngle + self.endAngle) / 2) * radiusCenter2;
    
    CGFloat textX = x2 >= self.centerPoint.x? x2+10:x2-w-10;
    CGFloat textY = y2 - h - 2;
    
    CGFloat radiusCenter = self.radius/2;//环形扇形中心对应的半径
    return CGRectMake(textX, textY, w, h);
}

+ (CGSize)textSizeWithText:(NSString *)text font:(CGFloat)font{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:(CGSizeMake(100, 0))];
    return size;
}

@end
