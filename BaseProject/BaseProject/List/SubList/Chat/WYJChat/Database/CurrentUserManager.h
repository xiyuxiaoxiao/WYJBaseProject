//
//  CurrentUserManager.h
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AddressList;

@interface CurrentUserManager : NSObject

+ (AddressList *)currentUser;

@end
