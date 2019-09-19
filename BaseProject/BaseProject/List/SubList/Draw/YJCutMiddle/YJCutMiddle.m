//
//  YJCutMiddle.m
//  WYJNotePad
//
//  Created by ZSXJ on 16/7/20.
//  Copyright © 2016年 ShouXinTech. All rights reserved.
//

#import "YJCutMiddle.h"
#import "TimerWeakTarget.h"

@interface YJCutMiddle ()

{
    CGFloat angle;
    CGFloat angleIncrement;
    
    CGFloat angleX;
    CGFloat angleY;
    CGFloat angleZ;
    
    UIButton *lastButtonXYZ;
    CGFloat selectAngleXYZ;
    UITextField *selectAngleText;
}


@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIImageView *middelImageView;
@property (weak, nonatomic) IBOutlet UIImageView *originlImageView;

@property (weak, nonatomic) IBOutlet UITextField *textX;
@property (weak, nonatomic) IBOutlet UITextField *textY;
@property (weak, nonatomic) IBOutlet UITextField *textZ;
@property (weak, nonatomic) IBOutlet UIButton *angleButtonX;
@property (weak, nonatomic) IBOutlet UIButton *angleButtonY;
@property (weak, nonatomic) IBOutlet UIButton *angleButtonZ;
@end

@implementation YJCutMiddle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    angleX = 0.4;
    angleY = 0.5;
    angleZ = 0.3;
    angleIncrement = 0.01;
    
    // 先初始化指定当前选中哪个
    [self initAngleButton];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cutMiddle" ofType:@".png"];
    self.originlImageView.image = [UIImage imageWithContentsOfFile:path];
    //imageNamed 会内存缓存 不会在VC销毁的时候释放
//    self.originlImageView.image = [UIImage imageNamed:@"cutMiddle"];
    
    [self setCustomViewWithCAlayer];
    [self cutTheMiddleSection:self.customView];
//
    _middelImageView.layer.cornerRadius = 20;
    _middelImageView.layer.masksToBounds = YES;
}

-(void)setCustomViewWithCAlayer{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cutMiddle" ofType:@".png"];
    self.customView.layer.cornerRadius = self.customView.bounds.size.width / 2;
    self.customView.layer.contents = (__bridge id _Nullable)([UIImage imageWithContentsOfFile:path].CGImage);

    
//    self.customView.layer.masksToBounds = YES;

//    self.customView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.customView.layer.shadowOffset = CGSizeMake(5, -20);
//    self.customView.layer.shadowOpacity = 0.6;
}

- (IBAction)buttonaction:(id)sender {
    [self loopSpin];
}
-(void)loopSpin {
    
    [TimerWeakTarget scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(transformAction) userInfo:nil repeats:YES];

//    [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(transformAction) userInfo: nil repeats: YES];
}

-(void)transformAction {
    angle = angle + angleIncrement;
//    if (angle > 6.28) {
//        angle = 0;
//    }
    //旋转一个弧度
    self.customView.layer.transform = CATransform3DMakeRotation(angle, angleX, angleY, angleZ);
    //    self.customView.transform = CGAffineTransformMakeRotation(angle);
}

// 将view的中间抠出一块圆
-(void)cutTheMiddleSection: (UIView *)view {
    CGFloat w = view.frame.size.width;
    CGFloat h = view.frame.size.height;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, w, h)];
    UIBezierPath *pathCircle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(w/2, h/2) radius:25 startAngle:0 endAngle:2*M_PI clockwise:NO];
    [path appendPath:pathCircle];
    
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path.CGPath;
    view.layer.mask = shapeLayer;
}

-(void)dealloc {
    NSLog(@" 抠出中间圆的控制器 dealloc");
}
- (IBAction)speedUp:(id)sender {
    angleIncrement += 0.05;
}
- (IBAction)slowDown:(id)sender {
    if (angleIncrement > 0.05) {
        angleIncrement -= 0.05;
    }
}


//中间Button的与text的相关输入

-(void)initAngleButton {
    [self buttonXYZAction:_angleButtonZ];
    CGFloat angleButtonRadius = _angleButtonX.bounds.size.width / 2;
    _angleButtonX.layer.cornerRadius = angleButtonRadius;
    _angleButtonY.layer.cornerRadius = angleButtonRadius;
    _angleButtonZ.layer.cornerRadius = angleButtonRadius;
    
    _textX.text = [NSString stringWithFormat:@"%.1f",angleX];
    _textY.text = [NSString stringWithFormat:@"%.1f",angleY];
    _textZ.text = [NSString stringWithFormat:@"%.1f",angleZ];
}

- (IBAction)speedUpAngleXYZ:(UIButton *)sender {
    CGFloat angle = [selectAngleText.text floatValue];
    angle += 0.1;
    if (angle >= 1) {
        angle = 1;
    }
    
    selectAngleText.text = [NSString stringWithFormat:@"%.1f", angle];
    
    
    if (selectAngleText == _textX) {
        angleX = angle;
    }
    if (selectAngleText == _textY) {
        angleY = angle;
    }
    if (selectAngleText == _textZ) {
        angleZ = angle;
    }
}
- (IBAction)slowDownAngleXYZ:(UIButton *)sender {
    CGFloat angle = [selectAngleText.text floatValue];
    angle -= 0.1;
    if (angle <= 0) {
        angle = 0;
    }
    
    selectAngleText.text = [NSString stringWithFormat:@"%.1f", angle];
    
    
    if (selectAngleText == _textX) {
        angleX = angle;
    }
    if (selectAngleText == _textY) {
        angleY = angle;
    }
    if (selectAngleText == _textZ) {
        angleZ = angle;
    }
    
    
}

- (IBAction)buttonXYZAction:(UIButton *)sender {
    if (lastButtonXYZ == sender) {
        return;
    }
    
    sender.backgroundColor = [UIColor redColor];
    [sender setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    lastButtonXYZ.backgroundColor = [UIColor whiteColor];
    [lastButtonXYZ setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    lastButtonXYZ = sender;
    
    if (lastButtonXYZ == _angleButtonX) {
        selectAngleText = _textX;
    }else if (lastButtonXYZ == _angleButtonY) {
        selectAngleText = _textY;
    }else if (lastButtonXYZ == _angleButtonZ) {
        selectAngleText = _textZ;
    }
}


@end
