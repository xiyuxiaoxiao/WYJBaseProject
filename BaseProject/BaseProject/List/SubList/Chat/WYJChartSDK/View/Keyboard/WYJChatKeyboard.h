//
//  WYJChatKeyboard.h
//  BaseProject
//
//  Created by ZSXJ on 2019/1/24.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYJChatKeyboardDelegate <NSObject>

- (void)sendMessageText:(NSString *)text;

// 必须在修改keyboarfd frame的时候 立即修改tableview frame 否则会出现动画不衔接的效果
- (void)keyBoardFrameChange;
@end

NS_ASSUME_NONNULL_BEGIN

@interface WYJChatKeyboard : UIView
@property (nonatomic, weak)   id<WYJChatKeyboardDelegate> delegate;

- (void)endEdit;
@end

NS_ASSUME_NONNULL_END
