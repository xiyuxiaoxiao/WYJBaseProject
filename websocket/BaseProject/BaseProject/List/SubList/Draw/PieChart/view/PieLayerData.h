//
//  PieLayerData.h
//  BaseProject
//
//  Created by ZSXJ on 2018/10/19.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
  可以考虑将 pielayer 的 startAngle & endAngle 数据存在在datas或者计算 可以将 PieLayer 删除不用继承
 */

@interface PieLayerData : NSObject

@property (nonatomic,assign)CGFloat radius;     //扇形 主要是用于subLayer的时候用
@property (nonatomic,assign)CGPoint centerPoint;
@property (nonatomic,assign)CGFloat startAngle; //开始角度
@property (nonatomic,assign)CGFloat endAngle;   //结束角度

@property (nonatomic,assign)CGFloat sectorSpace; //间隔角度

//@property (nonatomic,assign)CGFloat margin;          // 圆周与正方形的外边距
@property (nonatomic,assign)CGFloat firstLeadMargin; // 第一个点与半径的距离
@property (nonatomic,assign)CGFloat secondLeadMargin;// 第二个点与半径的距离

- (UIBezierPath *)pielayerPath;
- (CAShapeLayer *)leadLineLayer;
- (CATextLayer *)createTextLayerWithText:(NSString *)text;

@end
