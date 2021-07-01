//
//  NavigationImitateView.h
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/12/4.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationImitateView : UIView

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIView *titleView;
@property (assign, nonatomic) BOOL popModel;

+ (instancetype)initDefaule;

@end
