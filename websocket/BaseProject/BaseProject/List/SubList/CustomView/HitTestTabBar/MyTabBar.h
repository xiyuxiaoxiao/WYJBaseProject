//
//  MyTabBar.h
//  BaseProject
//
//  Created by ZSXJ on 2017/5/27.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabBar;

@protocol MyTabBarDelegate <NSObject>
 -(void)addButtonClick:(MyTabBar *)tabBar;
@end

@interface MyTabBar : UITabBar
@property (nonatomic,weak) id<MyTabBarDelegate> myTabBarDelegate;
@end
