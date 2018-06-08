//
//  LayoutConstraintCodeView.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/9.
//  Copyright © 2017年 WYJ. All rights reserved.
//


/**
 
 view 代码添加约束 注意事项
 
 1.要先禁止autoresizing功能，设置view 的translatesAutoresizingMaskIntoConstraints 属性为 NO;
 
 2.添加约束之前，一定要保证相关控件都已经在各自的父控件上。（就是要先addsubview，然后再添加约束addConstraint:）
 
 3.不用再给view设置frame
 
 
 约束添加规则总结：
 
 1.约束不依赖于其他控件（添加的约束和其他控件没有关系），会添加到自己身上
 
 2.如果是父子关系，设置子控件的约束，约束添加到父控件上
 
 3.如果是兄弟关系，设置两兄弟的约束，约束会添加到第一个共同的父控件上
 
 
 */


#import "LayoutConstraintCodeView.h"

@interface LayoutConstraintCodeView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UIButton *phoneButton;
@end




@implementation LayoutConstraintCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initSubView {
    
    self.titleLabel = [self.class creatLabel];
    [self addSubview:self.titleLabel];
    
    self.nameLabel = [self.class creatLabel];;
    [self addSubview:self.nameLabel];
    
    self.phoneLabel = [self.class creatLabel];;
    [self addSubview:self.phoneLabel];
    
    self.phoneButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.phoneButton];
    self.phoneButton.backgroundColor = [UIColor blueColor];
    
    [self setTitleLabelConstraint];
    [self setNameLabelConstraint];
    [self setPhoneLabelConstraint];
    [self setPhoneButtonConstraint];
}

+ (UILabel *)creatLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15];
    label.layer.borderWidth = 1;
    return label;
}

// 列表调用
- (void)setContent {
    
    for (UIView *aView in self.subviews) {
        [aView removeFromSuperview];
    }
    
    [self initSubView];
    
    self.titleLabel.text = @"配送信息";
    self.nameLabel.text = @"姓名";
    self.phoneLabel.text = @"1r938";
}

#pragma mark - 添加约束
- (void)setTitleLabelConstraint {
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self addConstraint:topConstraint];
    
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftConstraint];
    
    // 添加 height 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:39];
    [self.titleLabel addConstraint:heightConstraint];
}

- (void)setNameLabelConstraint {
    
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:topConstraint];
    
    // 添加 left 约束
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self addConstraint:leftConstraint];
    
    // 添加 height 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.nameLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30];
    [self.nameLabel addConstraint:heightConstraint];
}

- (void)setPhoneLabelConstraint {
    self.phoneLabel.translatesAutoresizingMaskIntoConstraints = NO;
    // 添加 Y 约束
    NSLayoutConstraint *centerY_Constraint = [NSLayoutConstraint constraintWithItem:self.phoneLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self addConstraint:centerY_Constraint];
    
    // 添加 X 约束
    NSLayoutConstraint *centerX_Constraint = [NSLayoutConstraint constraintWithItem:self.phoneLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:centerX_Constraint];
    
    // 添加 height 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.phoneLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self addConstraint:heightConstraint];
}

- (void)setPhoneButtonConstraint {
    
    self.phoneButton.translatesAutoresizingMaskIntoConstraints = NO;
    // 添加 trailing 约束
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.phoneButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self addConstraint:trailingConstraint];
    
    // 添加 centerY 约束
    NSLayoutConstraint *centerY_Constraint = [NSLayoutConstraint constraintWithItem:self.phoneButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.nameLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self addConstraint:centerY_Constraint];
    
    // 添加 height 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.phoneButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30];
    [self.phoneButton addConstraint:heightConstraint];
    
    // 添加 width 约束
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.phoneButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30];
    [self.phoneButton addConstraint:widthConstraint];
}

MakeSourcePath

@end
