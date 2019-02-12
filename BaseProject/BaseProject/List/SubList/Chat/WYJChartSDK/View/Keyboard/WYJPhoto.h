//
//  WYJPhoto.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/31.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYJPhoto : NSObject
+ (void)getPhoto: (void (^)(UIImage *img))backBlc;
@end

NS_ASSUME_NONNULL_END
