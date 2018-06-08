//
//  MapSkipManager.h
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/5/23.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapSkipManager : NSObject

@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;
@property (nonatomic,copy) NSString *desAddress;

+ (void)skipMapAppWithOrderInfo:(NSDictionary *)info;

@end
