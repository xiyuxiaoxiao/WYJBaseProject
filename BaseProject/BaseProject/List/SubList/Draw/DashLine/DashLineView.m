//
//  dashLineView.m
//  不规则图片CGImage
//
//  Created by WYJ on 16/5/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import "DashLineView.h"

@interface DashLineView ()

@property(nonatomic)CGPoint startPoint;//虚线起点
@property(nonatomic)CGPoint endPoint;//虚线终点
@end

@implementation DashLineView

- (id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if(self) {
//        _lineColor = [UIColor redColor];
        _startPoint = CGPointMake(0, 1);
        
//        _endPoint = CGPointMake(frame.size.width , 1);
        // 设置自己背景clear就不会影响线条的颜色，否则两者叠加影响，
        //如果想实现交替出现的颜色，可以使用两个DashLineView 将其中一个的虚线绘制偏移CGContextSetLineDash第二个参数设置为负数
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    _endPoint = CGPointMake(rect.size.width , 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    CGContextSetLineWidth(context,rect.size.height);//线宽度
    
    CGContextSetStrokeColorWithColor(context,self.lineColor.CGColor);
    
    CGFloat lengths[] = {20,40};//先画4个点再画2个点
    
    
/*
     通过CGContextSetLineDash()绘制
        参数：
     phase:一个Float类型点数据,表示在第一个虚线绘制的时候跳过多少个点 
     phase: 用负数来让其实现向移动的功能
     lengths：一个数组，指明了虚线如何虚实，比如{5，6，4}代表画5个实，6个需，4个实,5个虚线。
     count：数组长度
 
*/
    CGContextSetLineDash(context,0-_index * 20, lengths,2);//注意2(count)的值等于lengths数组的长度
    
    CGContextMoveToPoint(context,self.startPoint.x,self.startPoint.y);
    
    CGContextAddLineToPoint(context,self.endPoint.x,self.endPoint.y);
    
    CGContextStrokePath(context);
    
    CGContextClosePath(context);
}
 

@end
