//
//  WYJChartDefine.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#ifndef WYJChartDefine_h
#define WYJChartDefine_h

#define WYJScreenWidth      [UIScreen mainScreen].bounds.size.width
#define WYJScreenHeight     [UIScreen mainScreen].bounds.size.height
#define WYJChartCellWidth   (WYJScreenWidth - 40)

#define IPhoneX             (WYJScreenHeight == 812 ? YES : NO)
#define NavaBar_StatusHeight    (IPhoneX ? 88 : 64)

// 0：发送成功 、1：正在发送 、 2：发送失败
static int SendStatusSuccess                  = 0;
static int SendStatusSending                  = 1;
static int SendStatusFaile                    = 2;

// 0：已读 1：未读
static int ReadStatusRead                     = 0;
static int ReadStatusUnRead                   = 1;


// 消息类型
static int MessageTypeText                    = 1;
static int MessageTypeImage                   = 2;

#endif /* WYJChartDefine_h */
