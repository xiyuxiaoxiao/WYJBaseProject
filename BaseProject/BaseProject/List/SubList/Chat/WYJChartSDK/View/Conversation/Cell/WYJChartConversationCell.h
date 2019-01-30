//
//  WYJChartConversationCell.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/30.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYJChartConversation;

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartConversationCell : UITableViewCell
@property (nonatomic, strong)     WYJChartConversation *conversation;

+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
