//
//  PieLayer.h
//  WYJWindow
//
//  Created by ZSXJ on 2018/4/18.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PieLayer : CAShapeLayer
@property (nonatomic,assign)CGFloat startAngle; //开始角度
@property (nonatomic,assign)CGFloat endAngle;   //结束角度
@property (nonatomic,assign)BOOL    isSelected; //是否已经选中
@end


typedef enum : NSUInteger {
    PieLayerAnimationTypeStrokeBeginToEnd = 1,
    PieLayerAnimationTypeStrokeEach = 2,
} PieLayerAnimationType;
