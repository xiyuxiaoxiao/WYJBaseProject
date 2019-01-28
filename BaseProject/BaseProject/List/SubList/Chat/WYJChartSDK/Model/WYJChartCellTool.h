//
//  WYJChartCellTool.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYJChartMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartCellTool : NSObject
+ (void)setCellheight: (WYJChartMessage *)message;
+ (NSMutableArray *)testArray;
+ (WYJChartMessage *)creatMessageText: (NSString *)text;
@end

NS_ASSUME_NONNULL_END
