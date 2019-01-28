//
//  WYJChartTextCell.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WYJChartTextCell : WYJChartBaseCell
@property (nonatomic, strong)   UIImageView *contentBackView;
@property (nonatomic, strong)   UILabel *messageLabel;

- (void)setContentText:(NSString *)text ;
@end

NS_ASSUME_NONNULL_END
