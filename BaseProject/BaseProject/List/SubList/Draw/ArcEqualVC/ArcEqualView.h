//
//  RadiusView.h
//  等分
//
//  Created by ZSXJ on 2016/11/22.
//  Copyright © 2016年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcEqualView : UIView
@property(nonatomic,strong)NSArray *imageNameArray;

-(void)firstPointAdd;
-(void)firstPointDown;
-(void)seconderPointAdd;
-(void)seconderPointDown;

@end
