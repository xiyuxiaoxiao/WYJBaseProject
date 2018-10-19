//
//  PieChartVC.m
//  BaseProject
//
//  Created by ZSXJ on 2018/4/20.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "PieChartVC.h"
#import "PicView.h"

@interface PieChartVC ()
{
    PicView *pieView;
}
@end

@implementation PieChartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addPicView];
    
}

- (void)addPicView {
    pieView = [[PicView alloc] initWithFrame:CGRectMake(80, 100, 200, 200)];
    [self.view addSubview:pieView];
    
    [pieView setDatas:[self getDatas] colors:@[[UIColor redColor],[UIColor purpleColor]]];
    [pieView updateAnimationType:(PieLayerAnimationTypeStrokeEach)];
    
    pieView.backgroundColor = [UIColor greenColor];
}

- (IBAction)animation1:(id)sender {
    [pieView updateAnimationType:(PieLayerAnimationTypeStrokeEach)];
}
- (IBAction)animation2:(id)sender {
    [pieView updateAnimationType:(PieLayerAnimationTypeStrokeBeginToEnd)];
}

- (NSArray *)getDatas{
//    return @[@(1),@(2),@(3),@(4)];
    return @[@(4),@(3),@(2),@(1)];
    
    int cout = arc4random() % 5;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < cout+1 ; i++) {
        
        [arr addObject:@(arc4random()%100)];
    }
    
    return arr;
}

@end
