//
//  CustomLayoutAttributes.h
//  瀑布流
//
//  Created by WYJ on 16/4/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import <UIKit/UIKit.h>


// 本来打算使用这个代理计算cell高度的， 最后使用block来实现
@protocol CustomLayoutAttributesDelegate <NSObject>

-(CGFloat)calctueCellHeight: (UICollectionView *)collection
                heightForPhotoAtIndexPath: (NSIndexPath *) indexpath;

@end


@interface CustomLayoutAttributes : UICollectionViewLayoutAttributes

@property (assign, nonatomic) CGFloat cellHeight;

@end
