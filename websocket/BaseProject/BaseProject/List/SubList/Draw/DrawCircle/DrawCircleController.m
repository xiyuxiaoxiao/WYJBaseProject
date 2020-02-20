//
//  DrawCircleController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/21.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "DrawCircleController.h"
#import "CustomCircleView.h"
#import "PortraitArrowView.h"
@interface DrawCircleController ()
@property (weak, nonatomic) IBOutlet CustomCircleView *circleView1;
@property (weak, nonatomic) IBOutlet CustomCircleView *circleView2;
@property (weak, nonatomic) IBOutlet CustomCircleView *circleView3;
@property (weak, nonatomic) IBOutlet PortraitArrowView *portrView;
@end

@implementation DrawCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _circleView1.type = Fanshaped;
    _circleView2.type = RadianAuthoClose;
    _circleView3.type = BottomMidArrow;
    
    self.portrView.image = [UIImage imageNamed:@"yuanyuan"];
    self.portrView.name = @"高圆圆";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"见风使舵非就是");
}


@end
