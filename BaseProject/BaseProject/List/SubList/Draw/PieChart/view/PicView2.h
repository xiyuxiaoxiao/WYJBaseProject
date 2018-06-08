//
//  PicView2.h
//  BaseProject
//
//  Created by ZSXJ on 2018/4/23.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

// 网上的有问题 内存暴增 并且减不下的问题  其中 对于文本的计算需要在重新设置一下未知  目前没有在中心
@interface PicView2 : UIView
/** 扇形间距，默认为0*/
@property (nonatomic,assign)CGFloat sectorSpace;

///数据源
- (void)setDatas:(NSArray <NSNumber *>*)datas
          colors:(NSArray <UIColor *>*)colors;

- (void)stroke;
@end
