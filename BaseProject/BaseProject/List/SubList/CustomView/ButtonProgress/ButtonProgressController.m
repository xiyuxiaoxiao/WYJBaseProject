//
//  ButtonProgressController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/12.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ButtonProgressController.h"
#import "ButtonProgress.h"

@interface ButtonProgressController ()
@property (weak, nonatomic) IBOutlet ButtonProgress *buttonPro;
@property (nonatomic, assign)   BOOL annomation;

@property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@property (nonatomic, strong)   ButtonProgress *buttonProByFrame;
@property (nonatomic, assign)   BOOL annomationByFrame;
@end

@implementation ButtonProgressController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setLabel];
}
- (void)setLabel {
    self.lableTitle.text = @"";
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:7];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.lableTitle.text = @"返回是废旧塑料";
    [UIView commitAnimations];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _annomation = NO;
    
    // xib
    [self.buttonPro addTarget:self action:@selector(loginAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonPro setText:@"登 录"];
    
    
    // 纯代码
    _annomationByFrame = NO;
    
    CGFloat w = 150;
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - w)/2;
    self.buttonProByFrame = [[ButtonProgress alloc] initWithFrame:CGRectMake(x, 100, w, 40)];
    [self.view addSubview:self.buttonProByFrame];
    [self.buttonProByFrame addTarget:self action:@selector(loginActionByFrame) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonProByFrame setText:@"登 录"];

}

- (void)loginAction {
    self.annomation = !self.annomation;
    if (self.annomation) {
        // 禁止当前UI交互  在结束后 在设置当前允许操作
        //        self.view.userInteractionEnabled = NO;
        [self.buttonPro startAction];
    }else {
        [self.buttonPro endActionSuccess:YES message:@"请求成功"];
    }
}

- (void)loginActionByFrame {
    self.annomationByFrame = !self.annomationByFrame;
    if (self.annomationByFrame) {
        // 禁止当前UI交互  在结束后 在设置当前允许操作
        [self.buttonProByFrame startAction];
    }else {
        [self.buttonProByFrame endActionSuccess:NO message:@"请求失败"];
    }
}


@end
