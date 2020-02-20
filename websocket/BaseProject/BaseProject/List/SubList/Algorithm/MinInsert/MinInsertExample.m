//
//  MinInsertExample.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/22.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "MinInsertExample.h"
#import "Algorithm_MinInsert.h"

@interface MinInsertExample ()
@property (nonatomic, strong)               NSMutableArray      *pointArray;
@property (weak, nonatomic)     IBOutlet    UIButton            *pathPlanButton;
@property (weak, nonatomic) IBOutlet UITextField *startText;
@property (weak, nonatomic) IBOutlet UITextField *endText;
@end

@implementation MinInsertExample

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPointArray];
    [self addPointWithPointArray:self.pointArray];
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
    [pointArray addObject:[NSValue valueWithCGPoint:b]];
    [pointArray addObject:[NSValue valueWithCGPoint:c]];
    [pointArray addObject:[NSValue valueWithCGPoint:d]];
    [pointArray addObject:[NSValue valueWithCGPoint:e]];
    [pointArray addObject:[NSValue valueWithCGPoint:f]];
    [pointArray addObject:[NSValue valueWithCGPoint:g]];
    [pointArray addObject:[NSValue valueWithCGPoint:h]];
    
    self.pointArray = pointArray;
}

#pragma mark 添加相关点
- (void)addPointWithPointArray:(NSArray *)pointArray {
    for (int i = 0; i < pointArray.count; i++) {
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
#pragma mark 添加轨迹线
- (void)drawLine:(NSArray *)array indexT:(int *)T T_Count:(int)T_count {
    
    //动画
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //Set some variables on the animation
    pathAnimation.calculationMode = kCAAnimationPaced;
    //We want the animation to persist - not so important in this case - but kept for clarity
    //If we animated something from left to right - and we wanted it to stay in the new position,
    //then we would need these parameters
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = 10;
    //Lets loop continuously for the demonstration
    pathAnimation.repeatCount = HUGE_VALF;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    //Now we have the path, we tell the animation we want to use this path - then we release the path
    
    //    =====================画路线==============
    
    
    
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[[UIColor orangeColor] CGColor]];
    solidShapeLayer.lineWidth = 2.0f ;
    
    for (int i = 0; i < T_count; i++) {
        int index = T[i];
        NSValue *value = array[index];
        CGPoint point = value.CGPointValue;
        
        if (i == 0) {
            //起点坐标
            CGPathMoveToPoint(solidShapePath, NULL, point.x, point.y);
            CGPathMoveToPoint(curvedPath, NULL, point.x, point.y);
        }else {
            //终点坐标
            CGPathAddLineToPoint(solidShapePath, NULL, point.x,point.y);
            CGPathAddLineToPoint(curvedPath, NULL, point.x,point.y);
        }
    }
    
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    
    //    [self.view.layer addSublayer:solidShapeLayer];
    [self.view.layer insertSublayer:solidShapeLayer atIndex:0];
    
    //  添加动画    ===============
    NSValue *value = array[0];
    [self addLayer:pathAnimation point:value.CGPointValue];
    
    for (int i = 1; i < 9; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self addLayer:pathAnimation point:value.CGPointValue];
        });
    }
}

#pragma mark 添加点移动轨迹
- (void)addLayer:(CAKeyframeAnimation *)pathAnimation point:(CGPoint)point {
    
    UIView *circleView = [[UIView alloc] init];
    circleView.backgroundColor = [UIColor redColor];
    circleView.center = point;
    CGFloat circleViewW = 10;
    circleView.bounds = CGRectMake(0, 0, circleViewW, circleViewW);
    circleView.layer.cornerRadius = circleViewW/2;
    circleView.layer.masksToBounds = YES;
    [self.view addSubview:circleView];
    
    //Add the animation to the circleView - once you add the animation to the layer, the animation starts
    [circleView.layer addAnimation:pathAnimation
                            forKey:@"moveTheSquare"];
}

#pragma mark - 例子计算
- (IBAction)pathPlanButtonAction:(id)sender {
    [self oneFunc];
    self.pathPlanButton.enabled = NO;
}

- (void)oneFunc {
    NSMutableArray *pointArray = self.pointArray;
    
    int column = pointArray.count  ;
    int newArray[column * column];
    for (int i = 0; i < column; i++) {
        for (int j = 0; j < column; j++) {
            int index = i*column + j;
            if (i == j) {
                int s = 0;
                newArray[index] = s;
            }else {
                NSValue *startP = pointArray[i];
                NSValue *endP = pointArray[j];
                CGFloat distance = [self distanceA:startP.CGPointValue B:endP.CGPointValue];
                NSNumber *number = [NSNumber numberWithFloat:distance];
                int distanceInt = number.intValue;;
                newArray[index] = distanceInt;
            }
        }
    }
    
    int start = [self.class getIndexValue:self.startText.text max:column];
    int end = [self.class getIndexValue:self.endText.text max:column];
    
    if (start == 0) {
        self.startText.text = @"0";
    }
    if (end == 0) {
        self.endText.text = @"0";
    }
    
    
    int T_count = column;
    if (start == end) {
        T_count = column + 1;
    }
    
    int T[T_count];
    minInsertionEnter(newArray, column, T, start, end);
    [self drawLine:pointArray indexT:T T_Count:T_count];
}

+ (int)getIndexValue:(NSString *)str max:(int)max{
    int n = 0;
    if ([InfoValidator numberVaildor:str m:1 int:3]) {
        n = [str intValue];
        
        if (n >= max || n < 0) {
            n = 0;
        }
    }
    
    return n;
}

- (CGFloat)distanceA:(CGPoint)a B:(CGPoint)b {
    return sqrt(pow((a.x - b.x),2) + pow((a.y - b.y),2));
}

#pragma mark 查看原题
-(IBAction)MinInsertImageAndSubject{
    
    Class class = NSClassFromString(@"MinInsert");
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 设置终点
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.startText resignFirstResponder];
    [self.endText resignFirstResponder];
}

@end
