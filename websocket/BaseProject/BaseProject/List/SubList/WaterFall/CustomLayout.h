//
//  CustomLayout.h
//  瀑布流
//
//  Created by WYJ on 16/4/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLayoutAttributes.h"

typedef CGFloat(^ HeightBlock)(NSIndexPath *index);



@interface CustomLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger column;             // 列

@property (nonatomic, assign) CGFloat rowSpacing;           // 行间距
@property (nonatomic, assign) CGFloat columnSpacing;          // 列间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;    // 内边距

-(void)calctueCellHeightWithBlock: (HeightBlock)block;


// 也可通过代理实现cell高度计算
//@property (nonatomic, weak) id<CustomLayoutAttributesDelegate>layoutDelegate;
@end
