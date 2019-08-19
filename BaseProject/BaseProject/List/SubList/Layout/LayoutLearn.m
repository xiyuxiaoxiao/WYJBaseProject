//
//  LayoutLearn.m
//  BaseProject
//
//  Created by ZSXJ on 2019/2/28.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "LayoutLearn.h"

@interface LayoutLearn ()

@end

@implementation LayoutLearn

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


-(void)initData {
    
    [self.dataArray addObject:@{TitleKey:@"纯代码添加约束",
                                CN_Key:@"LayoutConstraintCodeController"}];
    [self.dataArray addObject:@{TitleKey:@"AKTLayout 学习",
                                CN_Key:@"AKTClassController"}];
    [self.dataArray addObject:@{TitleKey:@"Masonry 学习",
                                CN_Key:@"MasonryClassController"}];
}




@end
