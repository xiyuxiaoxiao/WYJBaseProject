//
//  PieLayer.m
//  WYJWindow
//
//  Created by ZSXJ on 2018/4/18.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "PieLayer.h"
#import <UIKit/UIKit.h>

@implementation PieLayer


- (void)dealloc {
    NSLog(@"销毁了 PieLayer");
}

- (CATextLayer *)textLayer {
    if (_textLayer == nil) {
        
        CGFloat padding = 0; // 内边距
        CGFloat KMargin = 20;// 外边距
        CGFloat radius = 100;// 半径
        CGFloat radiusCenter = (radius - KMargin - padding)/2;//环形扇形中心对应的半径
        
        _textLayer = [[CATextLayer alloc] init];
        _textLayer.contentsScale = 2;
        _textLayer.alignmentMode = @"center";
        _textLayer.fontSize = 14;
        _textLayer.string = _text;
        
        CGSize size = [self.class textSizeWithText:_text font:_textLayer.fontSize];
        CGFloat w = size.width;
        CGFloat h = size.height;
        
        _textLayer.frame = CGRectMake(self.centerPoint.x + cosf((self.startAngle + self.endAngle) / 2) * radiusCenter - w/2, self.centerPoint.y + sinf((self.startAngle + self.endAngle) / 2) * radiusCenter - h/2, w, h);
        [self addSublayer:_textLayer];
    }
    return _textLayer;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLayer.string = text;
}

+ (CGSize)textSizeWithText:(NSString *)text font:(CGFloat)font{
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:font];
    label.text = text;
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:(CGSizeMake(100, 0))];
    return size;
}


@end
