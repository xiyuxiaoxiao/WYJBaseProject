//
//  CollectionViewCell.m
//  瀑布流
//
//  Created by WYJ on 16/4/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _botlabel = [[UILabel alloc] initWithFrame:self.bounds];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor purpleColor];
        _botlabel.font = [UIFont systemFontOfSize:15];
        _botlabel.backgroundColor = [UIColor greenColor];
        [self addSubview:_botlabel];
    }
    
    return self;
}

-(void)resetLabelFrame
{
    _botlabel.frame = self.bounds;
}

// 在cell展示的时候触发
//-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    [super applyLayoutAttributes:layoutAttributes];
//    
//    if (layoutAttributes != nil) {
//        NSLog(@"******");
//    }
//}

@end
