//
//  AKTClassController.m
//  BaseProject
//
//  Created by ZSXJ on 2019/2/28.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "AKTClassController.h"
#import <AKTKit.h>

@interface AKTClassController ()

@end

@implementation AKTClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBlueView];
}

- (void)addBlueView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    
    [view aktLayout:^(AKTLayoutShellAttribute *layout) {
        // 中心点Y坐标与self.view中心点Y对齐
        layout.centerY.equalTo(akt_view(self.view));
        // 高度是self.view的高度的0.33倍
        layout.height.equalTo(akt_view(self.view)).multiple(.33);
        // 左边缘与self.view左边缘对齐
        layout.left.equalTo(self.view.akt_left).offset(10);
        // 右边缘与self.view的中心点X坐标对齐并左偏移space／2
        layout.right.equalTo(self.view.akt_centerX).offset(-10/2);
        // 添加参考 enqualTo("AKTReference")
        // 参考类型的创建(AKTReference)：视图、值、size、视图的布局属性
        // 视图: akt_value(VALUE)
        // 值: akt_view(VIEW)
        // size: akt_size(WIDTH, HEIGHT)
        // 布局属性： self.view.akt_left
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *view = self.view.subviews[0];
    [UIView aktAnimation:^{
        [UIView animateWithDuration:1.f delay:0 usingSpringWithDamping:.3 initialSpringVelocity:.2 options:0 animations:^{
            
            view.frame = CGRectMake((self.view.width-150)/2, (self.view.height-150)/2, 150, 150);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

@end
