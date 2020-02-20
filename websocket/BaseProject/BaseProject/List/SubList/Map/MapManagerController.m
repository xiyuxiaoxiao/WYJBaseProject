//
//  MapManagerController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/1.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "MapManagerController.h"
#import "MapSkipManager.h"

@interface MapManagerController ()

@end

@implementation MapManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地图";
}
- (IBAction)buttonAction:(id)sender {

    NSDictionary *dict = @{@"latitude":@"39.97721104213634",
                           @"longitude":@"116.36991900000002"};
    [MapSkipManager skipMapAppWithOrderInfo: dict];
}

@end
