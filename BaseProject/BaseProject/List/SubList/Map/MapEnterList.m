//
//  MapEnterList.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/20.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "MapEnterList.h"

@interface MapEnterList ()

@end

@implementation MapEnterList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"跳转安装的地图 第三方",
                                CN_Key:@"MapManagerController"}];
    
    [self.dataArray addObject:@{TitleKey:@"高德地图 自定义气泡",
                                CN_Key:@"CustomAnnotationViewController"}];
    [self.dataArray addObject:@{TitleKey:@"系统地图添加大头针",
                                CN_Key:@"SystemMapController"}];
    
    [self.dataArray addObject:@{TitleKey:@"项目中的",
                                CN_Key:@"MapController"}];
    
    
    
}

@end
