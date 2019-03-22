//
//  WYJChartImageCell.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/31.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartImageCell.h"
#import "UIImage+WYJChartImageStore.h"
#import "UIImageView+WYJChartImageViewStore.h"

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
        
        [self setupTap:_imageMessageView];
    }
    return _imageMessageView;
}

- (void)setFrame {
    [self addSubview:self.imageMessageView];
    
    [super setFrame];
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
    
    [super setFailureFrameWithContentFrame:self.imageMessageView.frame];
    
    [self.imageMessageView wyjImageUrl:message.contentInfoModel.fileURLServer localImagePath:message.contentInfoModel.fileURL];
}

@end
