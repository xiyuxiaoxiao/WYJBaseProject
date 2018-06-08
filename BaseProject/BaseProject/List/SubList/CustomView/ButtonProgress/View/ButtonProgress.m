//
//  ButtonProgress.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/12.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ButtonProgress.h"
#import "MBProgressHUD+DIY.h"
#import "ButtonProgressLayout.h"
#define ButtonBackColor [UIColor colorWithRed:1 green:0.5 blue:0.6 alpha:1]

@interface ButtonProgress ()
{
    CGRect boundsOriginal;
    BOOL imageViewAnnimation;
    UIColor *buttonBackColor;
}
@property (nonatomic, strong)   UIButton *button;
@property (nonatomic, strong)   UILabel *label;
@property (nonatomic, strong)   UIImageView *imageView;
@property (nonatomic, copy)     NSString *text;

@property (nonatomic, strong)   UILabel *messageLabel;
@property (nonatomic, strong)   NSLayoutConstraint *messageHeight;
@end

@implementation ButtonProgress

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    buttonBackColor = backgroundColor;
    [self setSubViewBackgroundColor];
}
- (void)setSubViewBackgroundColor {
    self.button.backgroundColor = buttonBackColor;
    self.imageView.tintColor = buttonBackColor;
    self.messageLabel.backgroundColor = buttonBackColor;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubView];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    [self initSubView];
}

#pragma mark - subView
- (void)initSubView {
    imageViewAnnimation = YES;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.image = [[UIImage imageNamed:@"btn_icon_loading"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    [self addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:button];
    self.button = button;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    self.label = label;
    
    
    UILabel *messagelabel = [[UILabel alloc] init];
    messagelabel.textAlignment = NSTextAlignmentCenter;
    messagelabel.textColor = [UIColor whiteColor];
    [self addSubview:messagelabel];
    self.messageLabel = messagelabel;
    
    [ButtonProgressLayout imageViewConstraint:self.imageView superView:self];
    [ButtonProgressLayout buttonConstraint:self.button superView:self];
    [ButtonProgressLayout labelConstraint:self.label superView:self];
    [ButtonProgressLayout messageLabelConstraint:self.messageLabel superView:self];
    
    [self setBackgroundColor:ButtonBackColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.button.layer.cornerRadius = self.button.bounds.size.height/2;
    self.imageView.layer.cornerRadius = self.imageView.bounds.size.height/2;
    self.messageLabel.layer.cornerRadius = self.bounds.size.height/2;
    self.messageLabel.layer.masksToBounds = YES;
}

#pragma mark - 设置相关内容
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setText:(NSString *)text {
    self.label.text = text;
    _text = text;
}




#pragma mark - 动画
- (void)startAction{
    self.imageView.image = [[UIImage imageNamed:@"btn_icon_loading"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    
    [self buttonScaleDown];
    [self imageViewShow];
    self.label.hidden = YES;
}
- (void)endActionSuccess:(BOOL)success message:(NSString *)message{
    
    [self imageViewStopAnnimation];

    NSString *imageName;
    if (success) {
        imageName = @"success";
    }else {
        imageName = @"error";
    }
    self.imageView.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    [self messageInfo:message];
    
    [self performSelector:@selector(restoreOriginal) withObject:nil afterDelay:1];
}
// 恢复 原始
- (void)restoreOriginal {
    [self messageInfo:nil];
    [self buttonWillOriginal];
    [self buttonScaleUp];
}

- (void)messageInfo:(NSString *)message {
    
    self.messageLabel.text = message;
    CGFloat w = self.messageLabel.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    if (message == nil) {
        h = 0;
    }
    /*
     如果使用高度的constant变化  则会使得后面其他动画没有效果
     如果使用bounds 则会使得位置偏上一点 出现错误
     所以目前改为frame
    */
    
    CGFloat x = self.messageLabel.frame.origin.x;
    CGFloat y = self.messageLabel.frame.origin.y;
    self.messageLabel.frame = CGRectMake(x, y, w, h);
}


- (void)imageViewShow {
    self.imageView.alpha = 0;
    [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        //隐藏按钮
        self.imageView.alpha = 1;
        self.button.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self spinStart];
    }];
}

// imageView停止旋转
- (void)imageViewStopAnnimation {
    imageViewAnnimation = NO;
    [self.imageView.layer removeAllAnimations];
    self.imageView.transform = CGAffineTransformIdentity;
    self.imageView.alpha = 1;
}
// button将要恢复的时候
- (void)buttonWillOriginal {
    [self.button.layer removeAllAnimations];
    self.button.backgroundColor = buttonBackColor;
    self.label.hidden = NO;
}

- (void)spinStart {
    imageViewAnnimation = YES;
    [self spinView:self.imageView curve:(UIViewAnimationCurveEaseIn)];
}


//[self.imageView.layer removeAllAnimations];
//停止需要设置变量 在代理的停止方法中停掉 当移除的时候 会走停止的方法
- (void)spinView:(UIView *)view curve:(UIViewAnimationCurve)curve {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDidStopSelector:@selector(spinViewEnd)];
    view.transform = CGAffineTransformRotate(view.transform, M_PI / 2);
    [UIView commitAnimations];
}
- (void)spinViewEnd {
    if (imageViewAnnimation) {
        [self spinView:self.imageView curve:UIViewAnimationCurveLinear];
    }
}

// 按钮恢复
- (void)buttonScaleUp {
    [self animationsDuration:0.2 animation:^{
        self.button.bounds = boundsOriginal;
    }];
}
// 按钮缩小
- (void)buttonScaleDown {
    boundsOriginal = self.button.bounds;
    CGFloat h = self.button.bounds.size.height;
    [self animationsDuration:0.5 animation:^{
        self.button.bounds = CGRectMake(0, 0, h, h);
    }];
}

- (void)animationsDuration:(NSTimeInterval)duration animation:(void (^) (void))annimation {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:duration];//动画时间
    annimation();
    [UIView commitAnimations]; //启动动画
}
@end
