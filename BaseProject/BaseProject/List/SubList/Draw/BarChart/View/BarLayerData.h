//
//  BarLayerData.h
//  BaseProject
//
//  Created by ZSXJ on 2018/10/24.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarLayerData : NSObject

@property (nonatomic, assign) CGFloat percent;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat y;


- (CAShapeLayer *)shapeLayer;
@end
