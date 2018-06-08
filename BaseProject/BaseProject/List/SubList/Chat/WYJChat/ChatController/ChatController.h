//
//  ChatController.h
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "NewBaseKeyboardController.h"
#import "AddressList.h"
@interface ChatController : NewBaseKeyboardController
@property (nonatomic,strong) AddressList *myFriend;
@property (nonatomic,strong) AddressList *currentUser;
@end
