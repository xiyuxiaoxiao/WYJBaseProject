//
//  ImageTechnologyList.m
//  BaseProject
//
//  Created by ZSXJ on 2019/10/10.
//  Copyright © 2019 WYJ. All rights reserved.
//

#import "ImageTechnologyList.h"

@interface ImageTechnologyList ()

@end

@implementation ImageTechnologyList

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"渐近加载图片",
                                CN_Key:@"ImageIoLoadVC"}];
    [self.dataArray addObject:@{TitleKey:@"ps微信图片",
                                CN_Key:@"ImagePswxVC"}];
}

@end
