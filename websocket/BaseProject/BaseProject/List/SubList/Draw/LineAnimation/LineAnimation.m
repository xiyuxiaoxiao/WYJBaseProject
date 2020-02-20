//
//  LineAnimation.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/29.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "LineAnimation.h"

@interface LineAnimation ()
{
    int count_addLayer;
}
@property (nonatomic, strong)   NSMutableArray *pointArray;

@property (nonatomic, strong)   CAShapeLayer *solidShapeLayer;
@property (nonatomic, strong)   CAShapeLayer *solidShapeLayer2;

@property (nonatomic, strong)   CABasicAnimation *animation;

// 为了取消循环调用的任务
@property (nonatomic, copy)   dispatch_block_t task;
@property (nonatomic, copy)   dispatch_block_t task2;

@end

@implementation LineAnimation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count_addLayer = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initPointArray];
    [self addPointWithPointArray:self.pointArray];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self drawLine];
    });
}

- (void)initPointArray {
    CGPoint a = CGPointMake(260, 150);
    CGPoint b = CGPointMake(110, 280);
    CGPoint c = CGPointMake(300, 400);
    CGPoint d = CGPointMake(160, 480);
    CGPoint e = CGPointMake(100, 100);
    CGPoint f = CGPointMake(130, 160);
    CGPoint g = CGPointMake(280, 170);
    CGPoint h = CGPointMake(250, 250);
    
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:[NSValue valueWithCGPoint:a]];
    [pointArray addObject:[NSValue valueWithCGPoint:e]];
    [pointArray addObject:[NSValue valueWithCGPoint:f]];
    [pointArray addObject:[NSValue valueWithCGPoint:b]];
    [pointArray addObject:[NSValue valueWithCGPoint:d]];
    [pointArray addObject:[NSValue valueWithCGPoint:c]];
    [pointArray addObject:[NSValue valueWithCGPoint:h]];
    [pointArray addObject:[NSValue valueWithCGPoint:g]];
    
    [pointArray addObject:[NSValue valueWithCGPoint:a]];
    
    self.pointArray = pointArray;
}

- (void)addPointWithPointArray:(NSArray *)pointArray {
    for (int i = 0; i < pointArray.count-1; i++) {
        NSValue *value = pointArray[i];
        CGPoint point = value.CGPointValue;
        
        UILabel *view = [[UILabel alloc] init];
        view.center = point;
        CGFloat w = 20;
        view.bounds = CGRectMake(0, 0, w, w);
        view.layer.cornerRadius = w/2;
        view.text = [NSString stringWithFormat:@"%d",i];
        view.textColor = [UIColor blackColor];
        view.font = [UIFont systemFontOfSize:14];
        view.textAlignment = NSTextAlignmentCenter;
        view.layer.borderColor = [UIColor darkGrayColor].CGColor;
        view.layer.borderWidth = 1;
        [self.view addSubview:view];
    }
}


- (void)drawLine {
    
    [self clearLayer];
    
    CAShapeLayer *solidShapeLayer = [self creatShapeLayer];
    [solidShapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
    self.solidShapeLayer = solidShapeLayer;
    
    CAShapeLayer *solidShapeLayer2 = [self creatShapeLayer];
    [solidShapeLayer2 setStrokeColor:[[UIColor whiteColor] CGColor]];
    solidShapeLayer2.lineWidth = 3;// 为了遮盖下面的边框 相等的时候难以完全遮盖
    self.solidShapeLayer2 = solidShapeLayer2;
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i < self.pointArray.count; i++) {
        
        NSValue *value = self.pointArray[i];
        CGPoint point = value.CGPointValue;
        
        if (i == 0) {
            //起点坐标
            [path moveToPoint:point];
        }else {
            //终点坐标
            [path addLineToPoint:point];
        }
    }
    
    solidShapeLayer.path = path.CGPath;
    
    solidShapeLayer2.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1);
    animation.duration = 2.0;
    self.animation = animation;
    
    [self addlay1];

}

- (CAShapeLayer *)creatShapeLayer {
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    solidShapeLayer.lineWidth = 2.0f ;
    solidShapeLayer.strokeEnd = 1;
    solidShapeLayer.autoreverses = NO;
    return solidShapeLayer;
}

//  有颜色的
- (void)addlay1 {
    
    [self.solidShapeLayer removeAllAnimations];
    [self.solidShapeLayer removeFromSuperlayer];
    
    // 第一次夹在最下面
    if (count_addLayer == 0) {
        [self.view.layer insertSublayer:self.solidShapeLayer atIndex:0];
    }else {
        [self.view.layer insertSublayer:self.solidShapeLayer above:self.solidShapeLayer2];
    }
    if (count_addLayer == 0) {
        count_addLayer = 1;
    }

    [self.solidShapeLayer addAnimation:self.animation forKey:nil];
    
    dispatch_block_t task = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        [self addlay2];
    });
    self.task = task;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), task);
}
// 白色的
- (void)addlay2 {
    
    [self.solidShapeLayer2 removeAllAnimations];
    [self.solidShapeLayer2 removeFromSuperlayer];

    // 创建2的时候 已经创建了1 所以直接加载1的上面
    [self.view.layer insertSublayer:self.solidShapeLayer2 above:self.solidShapeLayer];
    
    [self.solidShapeLayer2 addAnimation:self.animation forKey:nil];
    
    
    dispatch_block_t task2 = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
        [self addlay1];
    });
    self.task2 = task2;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), task2);
}

- (void)clearLayer {
    if (self.task) {
        dispatch_block_cancel(self.task);
    }
    if (self.task2) {
        dispatch_block_cancel(self.task2);
    }
    
    [self.solidShapeLayer removeAllAnimations];
    [self.solidShapeLayer2 removeAllAnimations];
    [self.solidShapeLayer removeFromSuperlayer];
    [self.solidShapeLayer2 removeFromSuperlayer];
}
@end
