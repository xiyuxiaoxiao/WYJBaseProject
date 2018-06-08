//
//  MessageImageView.m
//  网络请求
//
//  Created by WYJ on 16/5/14.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import "MessageImageView.h"

@implementation MessageImageView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.highlightedImage = [UIImage imageNamed:@"Chat Back.jpg"];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.highlightedImage = [UIImage imageNamed:@"Chat Back.jpg"];
    }
    return self;
}
-(void)layoutSubviews {
    NSString *messageBGImageName = @"Chat Back.jpg";
    
    UIImage *bubble = [UIImage imageNamed:messageBGImageName];
    UIImageView *imageView2 = [[UIImageView alloc] init];
    [imageView2 setFrame:self.bounds];
    [imageView2 setImage:[bubble stretchableImageWithLeftCapWidth:30 topCapHeight:30]];
    
    CALayer *layer = imageView2.layer;
    layer.frame = (CGRect){{0,0},imageView2.layer.frame.size};
    self.layer.mask = layer;
    
    [self setNeedsDisplay];
    
    NSLog(@"MesViewLaySub");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = YES;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.highlighted = NO;
}
@end
