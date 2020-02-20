//
//  ButtonProgressLayout.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/13.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ButtonProgressLayout.h"

@implementation ButtonProgressLayout

+ (void)imageViewConstraint:(UIView *)view superView:(UIView *)superView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setConstraitCenterX_Y_H_View:view superView:superView];

    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:view attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    [view addConstraint:width];
}

+ (void)buttonConstraint:(UIView *)view superView:(UIView *)superView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self setConstraitCenterX_Y_H_View:view superView:superView];
    [self setConstraitCenterW_View:view superView:superView];
}

+ (void)labelConstraint:(UIView *)view superView:(UIView *)superView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self setConstraitCenterX_Y_H_View:view superView:superView];
    [self setConstraitCenterW_View:view superView:superView];
}

+ (void)messageLabelConstraint:(UIView *)view superView:(UIView *)superView {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0];
    [superView addConstraint:centerX];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeBottom) multiplier:1 constant:15];
    [superView addConstraint:top];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:0];
    [superView addConstraint:height];
    
    [self setConstraitCenterW_View:view superView:superView];
}


+ (void)setConstraitCenterX_Y_H_View:(UIView *)view superView:(UIView *)superView {
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0];
    [superView addConstraint:centerX];
    
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeCenterY) multiplier:1 constant:0];
    [superView addConstraint:centerY];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    [superView addConstraint:height];
}

+ (void)setConstraitCenterW_View:(UIView *)view superView:(UIView *)superView {
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeWidth) multiplier:1 constant:0];
    [superView addConstraint:width];
}

@end
