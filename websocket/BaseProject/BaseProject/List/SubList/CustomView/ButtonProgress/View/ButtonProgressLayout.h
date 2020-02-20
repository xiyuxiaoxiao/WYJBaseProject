//
//  ButtonProgressLayout.h
//  BaseProject
//
//  Created by ZSXJ on 2017/7/13.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ButtonProgressLayout : NSObject

+ (void)imageViewConstraint:(UIView *)view superView:(UIView *)superView;
+ (void)buttonConstraint:(UIView *)view superView:(UIView *)superView;
+ (void)labelConstraint:(UIView *)view superView:(UIView *)superView;
+ (void)messageLabelConstraint:(UIView *)view superView:(UIView *)superView;

@end
