
//
//  PicView.m
//  WYJWindow
//
//  Created by ZSXJ on 2018/4/18.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "PicView.h"
#import "PieLayer.h"
#import "PieLayerData.h"

#define kPieRandColor [UIColor colorWithRed:arc4random() % 255 / 255.0f green:arc4random() % 255 / 255.0f blue:arc4random() % 255 / 255.0f alpha:1.0f]

#define Hollow_Circle_Radius 0 //中间空心圆半径，默认为0实心
#define KOffsetRadius 10 //偏移距离
#define KMargin 2 //边缘间距

@interface PicView () {
    CGFloat _radius;
//    CGFloat _radiusPadding; //  里面的小圆圈间距
    CGPoint _center;
}
@end

@implementation PicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        //线的半径为扇形半径的一半，线宽是扇形半径->半径+线宽的一半=真实半径，这样就能画出圆形了
        _radius = (frame.size.width - KMargin*2)/2.f;
        _center = CGPointMake(_radius + KMargin, _radius + KMargin);
        _sectorSpace = 0;
        
        //通过mask来控制显示区域
        self.layer.mask = [self creatMaskLayer];
    }
    
    return self;
}

#pragma mark -- Publish Methods


/*
 //方法一：每个layer公用一个圆形path，通过数据比例来控制strokeStart，strokeEnd，从而绘制对应区域；优点：性能相对较好；缺点：不容易通过touch来获取相应的layer。
 UIBezierPath *piePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius + Hollow_Circle_Radius startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
 CGFloat start = 0.f;
 CGFloat end = 0.f;
 for (NSNumber *number in array) {
 
 end =  start + number.floatValue;
 CAShapeLayer *pieLayer = [CAShapeLayer layer];
 pieLayer.strokeStart = start;
 pieLayer.strokeEnd = end;
 pieLayer.lineWidth = _radius*2 - Hollow_Circle_Radius;
 pieLayer.strokeColor = kPieRandColor.CGColor;
 pieLayer.fillColor = [UIColor clearColor].CGColor;
 pieLayer.path = piePath.CGPath;
 
 [self.layer addSublayer:pieLayer];
 start = end;
 }
 */

//方法二:每个layer对应一个path，通过数据比例来计算起始角点跟结束角点；相对第一种方法，创建的path较多；但是可以通过path来找到对应的layer，方便做后期操作
// 下面采用的是方法二
- (void)setDatas:(NSArray <NSNumber *>*)datas
          colors:(NSArray <UIColor *>*)colors{

    NSArray *newDatas = [self getPersentArraysWithDataArray:datas];

    CGFloat start = -M_PI_2;
    CGFloat end = start;
    
    while (newDatas.count > self.layer.sublayers.count) {
        
        PieLayer *pieLayer = [PieLayer layer];
        pieLayer.strokeColor = NULL;
        [self.layer addSublayer:pieLayer];
    }
    
    // 可以考虑在上面在加一层layer 将pielayey加载上面 不用subView的Layer 这样可以当点击移动pielayer的时候 不会使得线条和文本移动
    
    for (int i = 0; i < self.layer.sublayers.count; i ++) {
        
        PieLayer *pieLayer = (PieLayer *)self.layer.sublayers[i];
        // 为了防止点击过了之后 每次在刷新的时候 出现已经选中的状态
        pieLayer.position = CGPointMake(0, 0);
        pieLayer.isSelected = NO;
        
        if (i < newDatas.count) {
            pieLayer.hidden = NO;
            end =  start + (M_PI*2 - _sectorSpace*newDatas.count) *[newDatas[i] floatValue];
            
            // 此处 设置默认开始的颜色 color的 如果不够 就随机 自己写 需要写一个随机颜色不能一样的，否则出现错误
            pieLayer.fillColor = [colors.count > i?colors[i]:kPieRandColor CGColor];
            pieLayer.startAngle = start;
            pieLayer.endAngle = end;
            pieLayer.lineWidth = 1;
            pieLayer.strokeColor = [UIColor whiteColor].CGColor;
            
            // --- 设置数据 ---
            PieLayerData *pieData = [[PieLayerData alloc] init];
            pieData.startAngle = pieLayer.startAngle;
            pieData.endAngle = pieLayer.endAngle;
            pieData.radius = _radius;
            pieData.centerPoint = _center;
            pieData.firstLeadMargin = -20;
            pieData.secondLeadMargin = 20;
            
            start = end + _sectorSpace;
            
            
            // --- 开始创建layer ---
            pieLayer.path = [pieData pielayerPath].CGPath;
            
            
            // 需要移除之前的layer 然后在添加 或者直接改为属性 然后添加
            [pieLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            
            NSNumber *numObj = newDatas[i];
            CATextLayer *textLayer = [pieData createTextLayerWithText:[NSString stringWithFormat:@"%.2f%%",numObj.floatValue*100]];
            [pieLayer addSublayer:textLayer];
            
            CAShapeLayer *leadLineLayer = [pieData leadLineLayer];
            leadLineLayer.strokeColor = pieLayer.fillColor;
            [pieLayer addSublayer:leadLineLayer];
            
            pieLayer.mask = [self creatMaskLayer];
            
            // 如何给扇形添加layer
        }else{
            pieLayer.hidden = YES;
        }
    }
}

- (CAShapeLayer *)creatMaskLayer {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithArcCenter:_center radius:self.bounds.size.width/2.f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
    //设置边框颜色为不透明，则可以通过边框的绘制来显示整个view
    maskLayer.strokeColor = [UIColor greenColor].CGColor;
    maskLayer.lineWidth = self.bounds.size.width/1.f;
    //设置填充颜色为透明，可以通过设置半径来设置中心透明范围
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.path = maskPath.CGPath;
    
    return maskLayer;
}


#pragma mark -- Privite Methods
- (NSArray *)getPersentArraysWithDataArray:(NSArray *)datas{
    
/*
    // 降序排列
    NSArray *newDatas = [datas sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return NSOrderedDescending;
        }else if ([obj1 floatValue] > [obj2 floatValue]){
            return NSOrderedAscending;
        }else{
            return NSOrderedSame;
        }
    }];
*/
    NSArray *newDatas = datas;
    NSMutableArray *persentArray = [NSMutableArray array];
    NSNumber *sum = [newDatas valueForKeyPath:@"@sum.floatValue"];
    for (NSNumber *number in newDatas) {
        [persentArray addObject:@(number.floatValue/sum.floatValue)];
    }
    
    return persentArray;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CGPoint point = [touches.anyObject locationInView:self];
    
    [self upDateLayersWithPoint:point];
    
    NSLog(@"%@",NSStringFromCGPoint(point));
}

- (void)upDateLayersWithPoint:(CGPoint)point{
    
    //如需做点击效果，则应采用第二种方法较好
    for (PieLayer *layer in self.layer.sublayers) {
        
        if (CGPathContainsPoint(layer.path, &CGAffineTransformIdentity, point, 0) && !layer.isSelected) {
            layer.isSelected = YES;
            
            //原始中心点为（0，0），扇形所在圆心、原始中心点、偏移点三者是在一条直线，通过三角函数即可得到偏移点的对应x，y。
            CGPoint currPos = layer.position;
            double middleAngle = (layer.startAngle + layer.endAngle)/2.0;
            CGPoint newPos = CGPointMake(currPos.x + KOffsetRadius*cos(middleAngle), currPos.y + KOffsetRadius*sin(middleAngle));
            layer.position = newPos;
            
        }else{
            
            layer.position = CGPointMake(0, 0);
            layer.isSelected = NO;
        }
    }
}


#pragma mark -  动画
- (void)updateAnimationType:(PieLayerAnimationType)type {
    if (type == PieLayerAnimationTypeStrokeBeginToEnd) {
        [self strokeMaskLayer];
    }
    if (type == PieLayerAnimationTypeStrokeEach) {
        [self strokeSublayer];
    }
}

- (void)strokeMaskLayer{
    CABasicAnimation *animation = [self creatBaseAnimation];
    [self.layer.mask addAnimation:animation forKey:nil];
}

- (void)strokeSublayer{
    for (int i = 0; i < self.layer.sublayers.count; i ++) {
        PieLayer *pieLayer = (PieLayer *)self.layer.sublayers[i];
        
        CABasicAnimation *animation = [self creatBaseAnimation];
        animation.fromValue = @(pieLayer.startAngle/M_PI/2 + 0.25);
        // 0.001是为了防止间隙之间 数据经度的问题导致不完全相接
        animation.toValue = @(pieLayer.endAngle/M_PI/2 + 0.25+0.001);
        [pieLayer.mask addAnimation:animation forKey:nil];
    }
}

- (CABasicAnimation *)creatBaseAnimation {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.f;
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat:1.f];
    //禁止还原
    animation.autoreverses = NO;
    //禁止完成即移除
    animation.removedOnCompletion = YES;
    //让动画保持在最后状态
    //    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return animation;
}


- (void)dealloc {
    NSLog(@"销毁了 PickView");
}

@end
