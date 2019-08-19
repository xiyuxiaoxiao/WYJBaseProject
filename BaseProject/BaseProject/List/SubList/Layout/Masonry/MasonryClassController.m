//
//  MasonryClassController.m
//  BaseProject
//
//  Created by ZSXJ on 2019/8/19.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "MasonryClassController.h"
#import "Masonry.h"
@interface MasonryClassController ()

@end

@implementation MasonryClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self topView];
    [self equal_height];
}
    - (void)topView {
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"更新约束" forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(updateMasonry) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(60);
            make.left.equalTo(self.view).offset(30);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(45);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"发顺丰开始代理费看到了；发付款了；第三方克雷登斯； 多上；发";
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor greenColor];
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).offset(10);
            make.right.equalTo(self.view).offset(-30);
            make.width.lessThanOrEqualTo(@(200));
        }];
    }
    
    
    - (void)equal_height {
        UIView *redView = [[UIView alloc] init];
        redView.tag = 100;
        redView.backgroundColor = [UIColor redColor];
        [self.view addSubview:redView];
        
        
        UIView *yeallowView = [[UIView alloc] init];
        yeallowView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:yeallowView];
        
        UIView *greenView = [[UIView alloc] init];
        greenView.backgroundColor = [UIColor greenColor];
        [self.view addSubview:greenView];
        
        
        
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(200));
            make.left.equalTo(self.view).offset(30);
            make.centerY.equalTo(self.view);
            make.right.equalTo(yeallowView.mas_left).offset(-5);
        }];
        
        [yeallowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(greenView.mas_left).offset(-5);
        }];
        
        [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-30);
            make.top.height.width.equalTo(@[redView, yeallowView]);
        }];
        
        
        //创建动画
        [UIView animateWithDuration:1 animations:^{
            [self.view layoutIfNeeded];
        }];
        
        
    }
    
    - (void)updateMasonry {
        UIView *redView = [self.view viewWithTag:100];
        CGFloat h = redView.frame.size.height;
        
        if (h >= 200) {
            h = 20;
        }else {
            h = 200;
        }
        
        [redView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(h));
        }];
        
        //创建动画
        [UIView animateWithDuration:1.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        
    }

@end
