//
//  WYJChartBaseCell.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYJChartDefine.h"
#import "WYJChartMessage.h"

@class WYJChartBaseCell;

@protocol WYJChartBaseCellDelegate <NSObject>
- (void)resendMessage:(WYJChartBaseCell *)cell;
@end


NS_ASSUME_NONNULL_BEGIN

@interface WYJChartBaseCell : UITableViewCell

//头像
@property (nonatomic, strong) UIImageView *iconView;
//时间
@property (nonatomic, strong) UILabel *timeLabel;
//失败按钮
@property (nonatomic, strong) UIButton *failureButton;
//菊花
@property (nonatomic, strong) UIActivityIndicatorView *activiView;

// 自己在右边
@property (nonatomic, assign) BOOL left;

@property (nonatomic, strong) WYJChartMessage *message;

@property (nonatomic, weak)   id <WYJChartBaseCellDelegate> delegate;

+ (void)registerClassWithTableView:(UITableView *)tableView;
+ (NSString *)identifyWithMessage:(WYJChartMessage *)message;

- (void)setFrame;
- (void)setFailureFrameWithContentFrame:(CGRect)contentFrame;
+ (CGFloat)extraHeight;

//添加长按手势
- (void)setupTap:(UIView*)tapView;
@end

NS_ASSUME_NONNULL_END
