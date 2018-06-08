//
//  dashLineView.h
//  不规则图片CGImage
//
//  Created by WYJ on 16/5/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashLineView : UIView

@property(nonatomic,strong)UIColor* lineColor;//虚线颜色
@property(assign,nonatomic)int index; // 三等分的时候，标记的位置

@end
