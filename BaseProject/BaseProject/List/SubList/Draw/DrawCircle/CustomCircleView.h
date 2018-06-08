//
//  CustomCircleView.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/20.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 
 画圆圈的时候
 
 计算弧度 不是角度
 
 其次  
                ^(x3,y3);
                |
                |
                |
 (x2,y2);<------------->(x0,y0);
                |
                |
                |
                ^(x1,y1);
 
 （弧度）／角度 0 从 x0,y0 开始  向下开始 到（x1,y1）角度为 M_PI/2  (即是 顺时针计算弧度)
 
 在画圆圈的时候 
 CGContextAddArc(CGContextRef cg_nullable c, CGFloat x, CGFloat y,
 CGFloat radius, CGFloat startAngle, CGFloat endAngle, int clockwise)
 
 clockwise： 0 或者 1
 0: 表示  从开始角度到结束角度   顺时针画圆      然后取封闭的部分
 1: 表示  从开始角度到结束角度   逆时针画圆      然后取封闭的部分
 
 如果只有两个点 画圆 则两点直接连线 构成封闭区间
 如果需要获取扇形  还需要从中心点出发 到开始点画直线  然后画圆  在从终点回到中心点画直线
 
 */

typedef enum : NSUInteger {
    Fanshaped           = 1, // 扇形  从中心区域 
    RadianAuthoClose    = 2, // 只画圆弧 起点终点封闭
    BottomMidArrow      = 3, // 下面有一个箭头
} CustomCircleViewType;



@interface CustomCircleView : UIView

//上边部分圆形的宽高 == 宽  与下面角度的高  

@property (nonatomic, assign)   CustomCircleViewType type;

@end
