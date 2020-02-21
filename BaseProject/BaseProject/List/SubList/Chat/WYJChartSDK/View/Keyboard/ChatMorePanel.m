//
//  ChatMorePanel.m
//  BaseProject
//
//  Created by ZSXJ on 2020/2/21.
//  Copyright © 2020 WYJ. All rights reserved.
//

#import "ChatMorePanel.h"

@interface ChatMoreItemView()
@property (nonatomic, strong)   UIButton *iconView;
@property (nonatomic, strong)   UILabel *label;
@property (nonatomic, strong)   ChatMoreItem *model;
@end

@interface ChatMorePanel ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIView *topLine;
@end

@implementation ChatMorePanel

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        CGFloat f = 204/255.0;
        _topLine.backgroundColor = [UIColor colorWithRed:f green:f blue:f alpha:1];
    }
    return _topLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        self.scrollView.frame = self.bounds;
        self.data = [self.class modelArray];
        [self initItemsView];
        
        self.topLine.frame = CGRectMake(0, 0, frame.size.width, 0.5);
        [self addSubview:self.topLine];
    }
    return self;
}

- (void)initItemsView {
    for (int i = 0; i < self.data.count; i++) {
        ChatMoreItemView *view = [[ChatMoreItemView alloc] init];
        [self.scrollView addSubview:view];
        view.model = self.data[i];
        [view.iconView addTarget:self action:@selector(itemAction:) forControlEvents:(UIControlEventTouchUpInside)];
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat height = self.scrollView.frame.size.height;
        
        
        int col_max = 4;
        int row_max = 2;
        int row = i / col_max % row_max;      // 第几行
        int col = i % col_max;                // 第几列
        int page = i / (col_max*row_max);     // 第几页
        
        // 中间和两边间距等份
        CGFloat start_x = 18;
        CGFloat start_y = 15;
        CGFloat w = (width - start_x * 2) / col_max;
        CGFloat h = (height - start_y) / row_max;
        CGFloat x = start_x + w * col + page * width;
        CGFloat y = start_y + h * row;
        view.frame = CGRectMake(x, y, w, h);
    }
}

- (void)itemAction: (UIButton *)sender {
    ChatMoreItemView *view = (ChatMoreItemView *)sender.superview;
    if (self.itemTap) {    
        self.itemTap(view.model);
    }
}

+ (NSArray *)modelArray {
    NSMutableArray *items = [NSMutableArray array];
    NSArray *jsonArr = [self jsonData];
    for (NSDictionary *dict in jsonArr) {
        ChatMoreItem *item = [[ChatMoreItem alloc] init];
        item.label = dict[@"label"];
        item.iconName = dict[@"icon"];
        item.type = [dict[@"type"] integerValue];
        [items addObject:item];
    }
    
    return items;
}

+ (NSArray *)jsonData {
    return @[
        @{
            @"type": @(0),
            @"label": @"拍照",
            @"icon": @"Add Chat",
        },
        @{
            @"type": @(1),
            @"label": @"相册/素材",
            @"icon": @"Add Chat",
        },
        @{
            @"type": @(2),
            @"label": @"商品",
            @"icon": @"",
        },
        @{
            @"type": @(3),
            @"label": @"优惠券",
            @"icon": @"",
        },
        @{
            @"type": @(4),
            @"label": @"快捷回复",
            @"icon": @"",
        }
    ];
}

@end



@implementation ChatMoreItemView


- (void)setModel:(ChatMoreItem *)model {
    _model = model;
    
    self.label.text = model.label;
    [self.iconView setImage:[UIImage imageNamed:model.iconName] forState:(UIControlStateNormal)];
}

- (UIButton *)iconView {
    if (!_iconView) {
        _iconView = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _iconView.backgroundColor = [UIColor whiteColor];
        _iconView.layer.cornerRadius = 8;
        CGFloat f = 10;
        _iconView.contentEdgeInsets = UIEdgeInsetsMake(f, f, f, f);
        [self addSubview:_iconView];
    }
    return _iconView;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:12];
        CGFloat f = 102 / 255.0;
        _label.textColor = [UIColor colorWithRed:f green:f blue:f alpha:1];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return _label;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w_icon = 50;
    CGFloat x_icon = (self.frame.size.width - w_icon) / 2;
    self.iconView.frame = CGRectMake(x_icon, 0, w_icon, w_icon);
    
    self.label.frame = CGRectMake(0, w_icon, self.frame.size.width, 22);
}
@end
