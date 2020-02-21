//
//  ChatMoreItem.h
//  BaseProject
//
//  Created by ZSXJ on 2020/2/21.
//  Copyright © 2020 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatMoreItem : NSObject
@property (nonatomic, copy)   NSString *label;
@property (nonatomic, copy)   NSString *iconName;
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
