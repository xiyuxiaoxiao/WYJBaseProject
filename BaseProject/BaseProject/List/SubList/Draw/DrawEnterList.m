//
//  DrawEnterList.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/21.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "DrawEnterList.h"

@interface DrawEnterList ()

@end

@implementation DrawEnterList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)initData {
    
    [self.dataArray addObject:@{TitleKey:@"UIBezierPath学习",
                                CN_Key:@"BezierPathVC"}];
    
    [self.dataArray addObject:@{TitleKey:@"画圆圈 扇形",
                                CN_Key:@"DrawCircleController"}];
    [self.dataArray addObject:@{TitleKey:@"圆弧中间等份圆",
                                CN_Key:@"ArcEqualVC"}];
    [self.dataArray addObject:@{TitleKey:@"虚线",
                                CN_Key:@"DrawDashLineVC"}];
    [self.dataArray addObject:@{TitleKey:@"中间扣掉",
                                CN_Key:@"YJCutMiddle"}];
    [self.dataArray addObject:@{TitleKey:@"水波纹",
                                CN_Key:@"YJRippleVC"}];
    [self.dataArray addObject:@{TitleKey:@"自己绘制保存图片",
                                CN_Key:@"ChatDrawAndSave"}];
    [self.dataArray addObject:@{TitleKey:@"画线动画",
                                CN_Key:@"LineAnimation"}];
    
    [self.dataArray addObject:@{TitleKey:@"饼状图（其中计算文字位置还需要计算）",
                                CN_Key:@"PieChartVC"}];
    
}

@end
