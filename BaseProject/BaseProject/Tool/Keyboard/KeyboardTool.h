//
//  KeyboardTool.h
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/12/8.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyboardTool : NSObject
+ (void)keyboardWillShownNotification:(NSNotification *)notification controllerView:(UIView *)view textField:(UITextField *)txtField;
+ (void)hideKeyboard:(NSNotification *)notification controllerView:(UIView *)view;
@end
