//
//  AnimationEncapsulation.m
//  BaseProject
//
//  Created by ZSXJ on 2018/10/16.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "AnimationEncapsulation.h"

@interface AnimationEncapsulation ()

@end

@implementation AnimationEncapsulation

- (void)viewDidLoad {
    [super viewDidLoad];
}



-(void)initData {
    
    [self.dataArray addObject:@{TitleKey:@"仿QQ抽屉",
                                CN_Key:@"YJSlideMenu"}];
    [self.dataArray addObject:@{TitleKey:@"1",
                                CN_Key:@"DazFireController"}];
    [self.dataArray addObject:@{TitleKey:@"2",
                                CN_Key:@"DazFireworksController"}];
    [self.dataArray addObject:@{TitleKey:@"3",
                                CN_Key:@"DazInfoController"}];
    [self.dataArray addObject:@{TitleKey:@"4",
                                CN_Key:@"DazTouchController"}];
    [self.dataArray addObject:@{TitleKey:@"5",
                                CN_Key:@"DazViewController"}];
    
}
@end
