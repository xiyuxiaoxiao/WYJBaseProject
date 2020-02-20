//
//  ChatDrawAndSave.m
//  WYJNotePad
//
//  Created by WYJ on 16/5/16.
//  Copyright © 2016年 ShouXinTech. All rights reserved.
//

#import "ChatDrawAndSave.h"

@interface ChatDrawAndSave ()

@end

@implementation ChatDrawAndSave

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)startCraphics:(UIButton *)sender {
    // 气泡
//    [self qiPao];
    // 半圆
    [self banyuan];
}
- (void)banyuan {
    CGFloat w = 24;
    CGFloat h = 12;
    
    CGFloat centenX = w/2;
    CGFloat centenY = h;
    CGFloat radius = w/2;
    CGFloat startAngle = 0;
    CGFloat endAngle = M_PI;
    //开始图像绘图
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    //获取当前CGContextRef
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(w, h);
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();

    // 逆时针
    CGPathAddArc(path, NULL, centenX, centenY, radius, startAngle, endAngle, 1);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(gc, path);
    CGFloat rgb = 236/255.0;
    UIColor *color = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1];
    CGContextSetFillColorWithColor(gc, color.CGColor);
    //    CGContextSetStrokeColorWithColor(gc, [UIColor redColor].CGColor);
    //执行绘画 (会使得左边多一条线)
    //    CGContextStrokePath(gc);
    
    
    CGRect range = CGRectMake(0, 0, w, h);
    CGContextAddPath(gc, path);
    CGContextClip(gc);
    CGContextFillRect(gc, range);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(img);
    [data writeToFile:@"/Users/zsxj/Desktop/abc.png" atomically:YES];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(100, 200, w, h);
    [self.view addSubview:imgView];
}
- (void)qiPao {
    CGFloat w = 100;
    CGFloat h = 100;
    //开始图像绘图
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    //获取当前CGContextRef
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
    //    CGAffineTransform transform = CGAffineTransformMakeTranslation(w, h);
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    CGPoint origin = CGPointMake(0, 0);
    CGPathMoveToPoint(path, NULL, origin.x, origin.y + h / 2);
    CGPathAddLineToPoint(path, NULL, origin.x+ 10, origin.y + h / 2 - 5);
    CGPathAddLineToPoint(path, NULL, origin.x + 10, origin.y);
    CGPathAddLineToPoint(path, NULL, origin.x + w, origin.y);
    CGPathAddLineToPoint(path, NULL, origin.x + w, origin.y + h);
    CGPathAddLineToPoint(path, NULL, origin.x + 10, origin.y + h);
    CGPathAddLineToPoint(path, NULL, origin.x + 10 , origin.y + h / 2 + 5);
    CGPathAddLineToPoint(path, NULL, origin.x, origin.y + h / 2);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(gc, path);
    CGContextSetFillColorWithColor(gc, [UIColor greenColor].CGColor);
    //    CGContextSetStrokeColorWithColor(gc, [UIColor redColor].CGColor);
    //执行绘画 (会使得左边多一条线)
    //    CGContextStrokePath(gc);
    
    
    CGRect range = CGRectMake(0, 0, w, h);
    CGContextAddPath(gc, path);
    CGContextClip(gc);
    CGContextFillRect(gc, range);
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(img);
    [data writeToFile:@"/Users/zsxj/Desktop/abc.png" atomically:YES];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(100, 200, w, h);
    [self.view addSubview:imgView];
}

@end
