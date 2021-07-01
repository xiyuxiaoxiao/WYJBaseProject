//
//  NavigationImitateView.m
//  OmniChannelClient
//
//  Created by ZSXJ on 2017/12/4.
//  Copyright © 2017年 ZSXJ. All rights reserved.
//

#import "NavigationImitateView.h"
#import "WYJScreenTool.h"

@interface NavigationImitateView ()
@property (strong, nonatomic) IBOutlet UIView *thisView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@end

@implementation NavigationImitateView

+ (instancetype)initDefaule {
    
    NavigationImitateView *view = [[NavigationImitateView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [WYJScreenTool sharedInstance].navaBarStatusHeight)];
    return view;
}

#pragma mark - view
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initFromIB];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initFromIB];
    }
    return self;
}

-(void)initFromIB {
    
    _popModel = NO;
    
    NSBundle *boundle =[NSBundle bundleForClass:self.class];
    UINib *nib = [UINib nibWithNibName:@"NavigationImitateView" bundle:boundle];
    _thisView = (UIView *)[[nib instantiateWithOwner:self options:nil] firstObject];
    _thisView.frame = self.bounds;
    [self addSubview:_thisView];
    
    [self initSubView];
}

- (void) initSubView {
    
    self.topSpace.constant = [WYJScreenTool sharedInstance].navaBarStatusHeight - 44;
    
    UIColor *tintColor = [UIColor colorWithRed:30/255.0F green:30/255.0F blue:30/255.0F alpha:1];
    
    self.leftButton.tintColor  = tintColor;
    self.rightButton.tintColor = tintColor;
    self.titleLabel.textColor  = tintColor;
    
    [self.leftButton setImage:[[UIImage imageNamed:@"back_arrow_black"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)] forState:(UIControlStateNormal)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height;
    
    CGFloat w = self.titleView.bounds.size.width;
    CGFloat h = self.titleView.bounds.size.height;
    
    CGFloat y = H - (44-h)/2 - h;
    self.titleView.frame = CGRectMake((W-w)/2, y, w, h);
}

- (void)setTitleView:(UIView *)titleView {
    _titleView = titleView;
    [self addSubview:titleView];
}

- (void)setPopModel:(BOOL)popModel {
    _popModel = popModel;
    
    if (popModel) {
        [self.leftButton setImage:[UIImage imageNamed:@"turn_close"] forState:(UIControlStateNormal)];
    }
}

@end
