//
//  BarChartView.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/24.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "BarChartView.h"
#import "BarLayerData.h"

@implementation BarChartView

// 如果需要重新刷新数据 可以对当前view移除  重新添加View 或者奖坐标轴与柱状图分开 只刷新柱状图
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 0.1;
        
        [self initBarLayerData];
    }
    return self;
}

- (void)initBarLayerData {
    BarLayerData *barData = [[BarLayerData alloc] init];
    barData.width = self.bounds.size.width;
    barData.y = 0;
    
    NSArray *array =  @[@(0.25),@(0.5),@(0.75),@(1)];
    
    /*
      k  = space / barH 间隔与柱状的比例
      n = 柱状个数
     
     n * barH + (n-1)*spaceHeight  = H;
        n * barH + (n-1)*(k*barH)) = H;
     
        barH = H / (n + (n-1)*k);
     */
    CGFloat k = 21/20;
    NSInteger n = array.count;
    barData.height = self.bounds.size.height / (n+(n-1)*k);
    
    for (int i = 0; i < array.count; i++) {
        
        NSNumber *number = array[i];
        barData.percent = number.floatValue;
        barData.y = i*(1+k)*barData.height;
        
        [self.layer addSublayer: [barData shapeLayer]];
        
        
        // 创建 y坐标分割点
        CGFloat barCenter = barData.y + barData.height/2;
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        layer.frame = CGRectMake(-10, barCenter-0.5, 10, 1);
        [self.layer addSublayer:layer];
    }
    
    [self creatleftYAxis];
}

// 创建y坐标轴分割点
- (void)creatleftYAxis {
    
    // y轴超出view本身的长度
    CGFloat y_over = 10;
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    layer.frame = CGRectMake(-1, 0-y_over, 1, self.bounds.size.height+y_over*2);
    [self.layer addSublayer:layer];
}

@end
