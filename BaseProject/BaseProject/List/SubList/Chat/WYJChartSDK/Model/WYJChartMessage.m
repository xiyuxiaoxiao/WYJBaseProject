//
//  WYJChartMessage.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/15.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartMessage.h"
#import "WYJChartDefine.h"

@implementation WYJChartMessage
- (void)reSendServer {
    self.sendStatus = SendStatusSending;
}
- (void)sendSuccess {
    self.sendStatus = SendStatusSuccess;
}
@end
