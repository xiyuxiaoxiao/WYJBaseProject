//
//  CustomLayout.m
//  瀑布流
//
//  Created by WYJ on 16/4/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import "CustomLayout.h"

@interface CustomLayout ()
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, strong) NSMutableArray *columnsHeight;

@property (nonatomic, assign) CGFloat contentHegit;

@property (nonatomic, copy) HeightBlock block;


@end


@implementation CustomLayout



-(instancetype)init
{
    self = [super init];
    if (self) {
        
        _columnsHeight = [NSMutableArray array];
        _attributes = [NSMutableArray array];
        
    }
    
    return self;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    _contentHegit = 0;
    
    [_columnsHeight removeAllObjects];
    [_attributes removeAllObjects];
    
    for (NSInteger i = 0; i < _column; i ++) {
        [_columnsHeight addObject: [NSString stringWithFormat:@"%f", 0.0]];
    }
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i ++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        [_attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    
}


+(Class)layoutAttributesClass
{
    return [CustomLayoutAttributes class];
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.collectionView.bounds.size.width, _contentHegit);
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomLayoutAttributes *customLayoutAttributes = [CustomLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    customLayoutAttributes.cellHeight = self.block(indexPath);
    
    
    int minColumn = 0;
    for (int i = 0; i < _columnsHeight.count; i ++) {
        if ([_columnsHeight[minColumn] floatValue] > [_columnsHeight[i] floatValue]) {
            minColumn = i;
        }
    }
    
    CGFloat itemH = customLayoutAttributes.cellHeight;
    CGFloat itemW = (self.collectionView.bounds.size.width - (self.sectionInset.left + self.sectionInset.right) - (self.column - 1) * self.columnSpacing) / self.column;

    
    CGRect frame;
    frame.size = CGSizeMake(itemW, itemH);
    
    CGFloat x = self.sectionInset.left + minColumn * (itemW + self.columnSpacing);
    CGFloat y = [_columnsHeight[minColumn] floatValue];
    
    _columnsHeight[minColumn] = @(y + self.rowSpacing + itemH);
    
    frame.origin = CGPointMake(x, y);
    
    customLayoutAttributes.frame = frame;
    
    _contentHegit = MAX(_contentHegit, CGRectGetMaxY(frame));
    

    return customLayoutAttributes;
}


-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attributes;
}


// 必须实现（或者已经用代理代替了，可以不用实现）
-(void)calctueCellHeightWithBlock: (HeightBlock)block
{
    if (self.block != block) {
        self.block = block;
    }
}



@end
