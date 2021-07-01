//
//  WYJScreenTool.h
//  BaseProject
//
//  Created by 潇雨 on 2021/7/1.
//  Copyright © 2021 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYJScreenTool : NSObject

@property (nonatomic, assign) BOOL iphoneX;
@property (nonatomic, assign) double navaBarStatusHeight;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
