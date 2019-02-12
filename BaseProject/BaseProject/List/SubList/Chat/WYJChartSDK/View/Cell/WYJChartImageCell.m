//
//  WYJChartImageCell.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/31.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartImageCell.h"
#import "UIImage+WYJChartImageStore.h"

@implementation WYJChartImageCell

- (UIImageView *)contentBackView {
    if (_contentBackView == nil) {
        _contentBackView = [[UIImageView alloc] init];
        
        _contentBackView.tintColor = [UIColor greenColor];
        
        if (self.left) {
            _contentBackView.tintColor = [UIColor whiteColor];
            _contentBackView.image = [[[UIImage imageNamed:@"Text Voice Bubble Incoming"] stretchableImageWithLeftCapWidth:20 topCapHeight:22]
                                      imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        }else {
            _contentBackView.image = [[[UIImage imageNamed:@"Text Voice Bubble Outgoing"] stretchableImageWithLeftCapWidth:20 topCapHeight:22]
                                      imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        }
    }
    return _contentBackView;
}

- (UIImageView *)imageMessageView {
    if (!_imageMessageView) {
        _imageMessageView = [[UIImageView alloc] init];
        _imageMessageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageMessageView.clipsToBounds = YES;
        _imageMessageView.userInteractionEnabled = YES;
        _imageMessageView.backgroundColor = [UIColor darkGrayColor];
        // 如果采用 addSubView 让遮罩在上面 则需要使用不透明的部分遮掉  但是这样 需要不透明部分的颜色与背景颜色一致 否则不行
        _imageMessageView.layer.mask = self.contentBackView.layer;
    }
    return _imageMessageView;
}

- (void)setFrame {
    [super setFrame];
    
    [self addSubview:self.imageMessageView];
    
    [self.activiView bringSubviewToFront:self.imageMessageView];
}

- (void)setContentBackFrame: (CGSize)contentSize {
    CGFloat w = contentSize.width;
    CGFloat h = contentSize.height;
    CGFloat y = CGRectGetMinY(self.iconView.frame);
    CGFloat x = 0;
    
    if (self.left) {
        x = CGRectGetMaxX(self.iconView.frame) + 8;
    }else {
        x = CGRectGetMinX(self.iconView.frame) - w - 8;
    }
    self.imageMessageView.frame = CGRectMake(x, y, w, h);
    self.contentBackView.frame = CGRectMake(0, 0, w, h);
}

- (void)setMessage:(WYJChartMessage *)message {
    [super setMessage:message];
    
    [self setContentBackFrame:message.contentBackSize];
    
    [super setFailureFrameWithContentFrame:self.contentBackView.frame];
    
    
    CGRect frame_active = self.activiView.frame;
    frame_active.origin.x = self.imageMessageView.center.x - frame_active.size.width / 2;
    frame_active.origin.y = self.imageMessageView.center.y - frame_active.size.height / 2;
    
    self.activiView.frame = frame_active;
    
    
    NSString *path = [UIImage filePathDocument];
    NSString *imageFilePtah = [path stringByAppendingString:message.content];
    
    [self.imageMessageView sd_setImageWithURL:[NSURL fileURLWithPath:imageFilePtah] placeholderImage:nil];
    // 使用sdwebimagex显示 就不会出现卡顿 或者将data缓存下来
}

@end
