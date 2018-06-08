//
//  EnterListController.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/1.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TitleKey @"title"
#define CN_Key @"controllerName"

@interface EnterListController : UITableViewController

@property (nonatomic, strong) NSMutableArray *dataArray;


- (void)initData;

@end
