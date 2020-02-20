//
//  CanNotAddSelfAsSubView.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/19.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "CanNotAddSelfAsSubView.h"

@interface CanNotAddSelfAsSubView ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CanNotAddSelfAsSubView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.editable = NO;
    CGFloat edge = 10;
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.textContainerInset = UIEdgeInsetsMake(edge, edge, edge, edge);
    [self setTextViewText];
}

- (void)setTextViewText {
    
    NSString *url2 = @" https://www.zhihu.com/question/28675580 \n\n";
    
    
    NSString *str = @"问题描述：这个问题非常常见，就是平时我们做一个按钮（我们假设这个页面是RootVC），按钮加一个事件，点击这个事件的时候会push出一个新的控制器A，当我们连续快速（时间间隔在0.5S内，也就是PUSH前一个事件的PUSH动画还没结束之前）点击两次这个按钮的时候，就会导致这个按钮连续响应了两次事件，同时推出了两个控制器A1、A2（这两个控制器都是A类型的），当我们再次点击A1（A2）返回的时候，点击第一次返回会是黑屏，再次点击A2（A1）返回的时候，就会报以下这个崩溃。";
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
    [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 0)];
    
    
    NSMutableAttributedString *attributeURL = [[NSMutableAttributedString alloc] initWithString:url2];
    [attributeURL addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:133/255.0 blue:83/255.0 alpha:1] range:NSMakeRange(0, url2.length)];
    
    
    NSMutableAttributedString *attributeDescribe = [[NSMutableAttributedString alloc] initWithString:str];
    
    
    [attribute appendAttributedString:attributeURL];
    [attribute appendAttributedString:attributeDescribe];
    
    self.textView.attributedText = attribute;
}


@end
