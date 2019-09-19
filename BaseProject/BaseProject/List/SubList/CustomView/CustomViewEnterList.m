//
//  CustomViewEnterList.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/12.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "CustomViewEnterList.h"

@interface CustomViewEnterList ()

@end

@implementation CustomViewEnterList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"自定义登录动画View",
                                CN_Key:@"ButtonProgressController"}];
    
    [self.dataArray addObject:@{TitleKey:@"文字逐个显示",
                                CN_Key:@"TextOneByOne"}];
    [self.dataArray addObject:@{TitleKey:@"tabbar中间凸出（重写hitTest）",
                                CN_Key:@"MyTabBarController"}];
    
    [self.dataArray addObject:@{TitleKey:@"使用UIControl自定义button控件",
                                CN_Key:@"ButtonByControlTestVC"}];
}

@end
