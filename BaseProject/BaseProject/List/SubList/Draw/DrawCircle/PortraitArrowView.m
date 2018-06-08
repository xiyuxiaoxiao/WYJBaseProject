//
//  PortraitArrowView.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/21.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "PortraitArrowView.h"
#import "CustomCircleView.h"

@interface PortraitArrowView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CustomCircleView *customCircleView;

@end

@implementation PortraitArrowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = image;
}

- (void)setName:(NSString *)name {
    _name = name;
    _nameLabel.text = name;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addAllView];
    }
    return  self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self addAllView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 30);
    
    CGFloat customCircleViewY = self.nameLabel.frame.size.height;
    self.customCircleView.frame = CGRectMake(0, customCircleViewY, self.bounds.size.width, self.bounds.size.height - customCircleViewY);
    
    CGFloat x = 3;
    CGFloat y = x+self.customCircleView.frame.origin.y;
    CGFloat imageViewW = self.bounds.size.width - x*2;
    CGFloat imageViewH = imageViewW;

    self.imageView.frame = CGRectMake(x, y, imageViewW, imageViewH);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius  = imageViewW/2;
}


- (void)addAllView {
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor blueColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    CustomCircleView *view = [[CustomCircleView alloc] init];
    view.type = BottomMidArrow;
    [self addSubview:view];
    
    self.customCircleView = view;

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    self.imageView = imageView;
}

//- (void)addCustomCircleView:(CGRect)frame {
//    
//    CustomCircleView *view = [[CustomCircleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//    view.type = BottomMidArrow;
//    [self addSubview:view];
//    
//    self.customCircleView = view;
//    
//    CGFloat x = 3;
//    CGFloat y = x;
//    CGFloat imageViewW = frame.size.width - x*2;
//    CGFloat imageViewH = imageViewW;
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageViewW, imageViewH)];
//    imageView.layer.cornerRadius = imageViewW/2;
//    imageView.layer.masksToBounds = YES;
//    [self addSubview:imageView];
//    
//    self.imageView = imageView;
//}

@end
