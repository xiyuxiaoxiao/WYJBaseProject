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
    [self.buttonPro startAction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.buttonPro endActionSuccess:YES message:@"请求成功"];
    });
}

- (void)loginActionByFrame {
    self.annomationByFrame = !self.annomationByFrame;
    
    [self.buttonProByFrame startAction];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.buttonProByFrame endActionSuccess:NO message:@"请求失败"];
    });
}


@end
