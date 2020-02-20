//
//  CityController.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/16.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CityBlock)(NSString *);

@interface CityController : UITableViewController

@property (nonatomic, copy)     NSString *currentTitle;
@property (nonatomic, strong)   NSArray *array;

@property (nonatomic, copy)     NSString *selectedStr;
@property (nonatomic, copy)     CityBlock selectBlock;

@end
