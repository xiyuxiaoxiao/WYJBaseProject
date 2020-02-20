//
//  ArcEqualVC.m
//  WYJNotePad
//
//  Created by ZSXJ on 2016/11/22.
//  Copyright © 2016年 ShouXinTech. All rights reserved.
//

#import "ArcEqualVC.h"
#import "ArcEqualView.h"
@interface ArcEqualVC ()
@property (nonatomic,strong)ArcEqualView *arcEqualView;
@end

@implementation ArcEqualVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"等份一段圆弧";
    
    ArcEqualView *view = [[ArcEqualView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100)];
    
    view.imageNameArray = @[@"defaultPeople",@"yuanyuan",@"me",@"woman1",@"man1",];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor darkGrayColor];
    _arcEqualView = view;
}


- (IBAction)firstPointAdd:(id)sender {
    [_arcEqualView firstPointAdd];
}
- (IBAction)firstPointJian:(id)sender {
    [_arcEqualView firstPointDown];
}
- (IBAction)secondPointAdd:(id)sender {
    [_arcEqualView seconderPointAdd];
}
- (IBAction)secondPointJian:(id)sender {
    [_arcEqualView seconderPointDown];
}
@end
