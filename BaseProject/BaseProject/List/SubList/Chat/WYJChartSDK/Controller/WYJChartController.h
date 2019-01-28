//
//  WYJChartController.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYJChartAddress;
NS_ASSUME_NONNULL_BEGIN

@interface WYJChartController : UIViewController
@property (nonatomic, strong)  WYJChartAddress *myFriend;
@property (nonatomic, strong)  WYJChartAddress *currentUser;
@end

NS_ASSUME_NONNULL_END
