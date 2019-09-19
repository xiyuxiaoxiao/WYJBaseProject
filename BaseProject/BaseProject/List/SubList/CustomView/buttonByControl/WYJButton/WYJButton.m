//
//  WYJButton.m
//  使用UIControl自定义button控件
//
//  Created by ZSXJ on 2019/8/19.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJButton.h"

@interface WYJButton ()
@property (strong, nonatomic) NSMutableDictionary *titleDic;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;
@end

@implementation WYJButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        self.label.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.label];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 40, 40)];
        [self addSubview:self.imageView];
        
        self.imageView.backgroundColor = [UIColor orangeColor];
    }
    
    return self;
}



- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state {
    [self.titleDic setValue:title forKey:@(state).stringValue];
    [self updateLabelText];
}
-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateLabelText];
}

- (void)updateLabelText {
    NSString *str = [self.titleDic valueForKey:@(self.state).stringValue];
    if (str) {
        self.label.text = str;
        return;
    }
    self.label.text = [self.titleDic valueForKey: @(UIControlStateNormal).stringValue];
}

- (NSDictionary *)titleDic {
    if (!_titleDic) {
        _titleDic = [NSMutableDictionary dictionary];
    }
    return _titleDic;
}

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.label.textColor = [UIColor whiteColor];
    }else {
        self.label.textColor = [UIColor blackColor];
    }
}


@end
