//
//  MyTabBar.m
//  BaseProject
//
//  Created by ZSXJ on 2017/5/27.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "MyTabBar.h"
#import "UIView+Category.h"

#define AddButtonMargin 32

@interface MyTabBar ()

//指向中间“+”按钮
@property (nonatomic,weak) UIButton *addButton;
//指向“添加”标签
@property (nonatomic,weak) UILabel *addLabel;

@end

@implementation MyTabBar


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        UIButton *addBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"addNomal"] forState:(UIControlStateNormal)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"addHight"] forState:(UIControlStateHighlighted)];
        [addBtn addTarget:self action:@selector(addBtnDidClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:addBtn];
        self.backgroundColor = [UIColor whiteColor];
        self.addButton = addBtn;
    }
    return self;
}

- (void)addBtnDidClick {
    if ([self.myTabBarDelegate respondsToSelector:@selector(addButtonClick:)]) {
        [self.myTabBarDelegate addButtonClick:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        // 横线的高度0.5
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
            view.hidden = YES;
        }
    }
    
    self.addButton.size = CGSizeMake(self.addButton.currentBackgroundImage.size.width, self.addButton.currentBackgroundImage.size.height);
    self.addButton.center = self.center;
    self.addButton.centerY = 0;
    self.addButton.backgroundColor = [UIColor whiteColor];
    self.addButton.layer.cornerRadius = self.addButton.size.width/2;
    
    UILabel *addLbl = [[UILabel alloc] init];
    addLbl.text = @"添加";
    addLbl.font = [UIFont systemFontOfSize:10];
    addLbl.textColor = [UIColor grayColor];
    [addLbl sizeToFit];
    
    addLbl.centerX = self.addButton.centerX;
    addLbl.centerY = self.bounds.size.height - addLbl.size.height/2;
    [self addSubview:addLbl];
    self.addLabel = addLbl;
    
    int btnIndex = 0;
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    for (UIView *btn in self.subviews) {//遍历TabBar的子控件
         if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //每一个按钮的宽度等于TabBar的三分之一
            btn.width = self.width / 3;
            btn.x = btn.width * btnIndex;
             
             if (btnIndex == 0) {
                 // 设置后 当选中一个的时候 背景颜色会清掉
//                 btn.backgroundColor = [UIColor greenColor];
             }
             if (btnIndex == 2) {
//                 btn.backgroundColor = [UIColor orangeColor];
             }
             
             btnIndex ++;
             
             //如果索引是1(即“+”按钮)，直接让索引加一
             if (btnIndex == 1) {
                 btnIndex ++;
             }
             
             
         }
    }
    
     //将“+”按钮放到视图层次最前面
     [self bringSubviewToFront:self.addButton];
}


//重写hitTest方法，去监听"+"按钮和“添加”标签的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //这一个判断是关键，不判断的话push到其他页面，点击“+”按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有TabBar的，那么肯定是在根控制器页面
    //在根控制器页面，那么我们就需要判断手指点击的位置是否在“+”按钮或“添加”标签上
    //是的话让“+”按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO)
        {
            //将当前TabBar的触摸点转换坐标系，转换到“+”按钮的身上，生成一个新的点
            CGPoint newA = [self convertPoint:point toView:self.addButton];
            //将当前TabBar的触摸点转换坐标系，转换到“添加”标签的身上，生成一个新的点
            CGPoint newL = [self convertPoint:point toView:self.addLabel];

            //判断如果这个新的点是在“+”按钮身上，那么处理点击事件最合适的view就是“+”按钮
            if ( [self.addButton pointInside:newA withEvent:event])
                {
                    return self.addButton;
                }
            //判断如果这个新的点是在“添加”标签身上，那么也让“+”按钮处理事件
            else if([self.addLabel pointInside:newL withEvent:event])
                {
//                    return self.addButton;
                    return [super hitTest:point withEvent:event];
                }
            else
                {//如果点不在“+”按钮身上，直接让系统处理就可以了
                    return [super hitTest:point withEvent:event];
                }
        }
    else
        {
            //TabBar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
            return [super hitTest:point withEvent:event];
        }
}
@end
