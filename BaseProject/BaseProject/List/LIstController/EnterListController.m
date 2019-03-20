//
//  EnterListController.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/1.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "EnterListController.h"

@interface EnterListController ()
@end

@implementation EnterListController

- (NSMutableArray *)dataArray {
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:cellId];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.textLabel.text = dict[TitleKey];
    cell.detailTextLabel.text = dict[CN_Key];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    Class class = NSClassFromString(dict[CN_Key]);
    UIViewController *vc = [[class alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)initData {
    
    [self.dataArray addObject:@{TitleKey:@"聊天",
                                CN_Key:@"ChatEnterList"}];
    
    [self.dataArray addObject:@{TitleKey:@"自定义view",
                                CN_Key:@"CustomViewEnterList"}];
    
    [self.dataArray addObject:@{TitleKey:@"技术点",
                                CN_Key:@"TechnicalPointEnterList"}];
    
    [self.dataArray addObject:@{TitleKey:@"算法",
                                CN_Key:@"AlgorithmEnterList"}];
    
    [self.dataArray addObject:@{TitleKey:@"计算器",
                                CN_Key:@"WYJCalculatorList"}];
    
    [self.dataArray addObject:@{TitleKey:@"常见Bug",
                                CN_Key:@"CommonBugEnter"}];
    
    [self.dataArray addObject:@{TitleKey:@"瀑布流 (上滑隐藏topView 下滑展示)",
                            CN_Key:@"WaterFallController"}];
    
    [self.dataArray addObject:@{TitleKey:@"地图",
                            CN_Key:@"MapEnterList"}];
    
    [self.dataArray addObject:@{TitleKey:@"系统提醒事件",
                            CN_Key:@"ES_RemaindControler"}];
    
    [self.dataArray addObject:@{TitleKey:@"获取城市信息",
                            CN_Key:@"CitySelectController"}];
    
    [self.dataArray addObject:@{TitleKey:@"画图",
                                CN_Key:@"DrawEnterList"}];
    
    [self.dataArray addObject:@{TitleKey:@"扫一扫",
                                CN_Key:@"WYJScanEnterList"}];
    
    [self.dataArray addObject:@{TitleKey:@"Web",
                                CN_Key:@"WebEnter"}];
    
    [self.dataArray addObject:@{TitleKey:@"动画效果封装",
                                CN_Key:@"AnimationEncapsulation"}];
    
    [self.dataArray addObject:@{TitleKey:@"布局",
                                CN_Key:@"LayoutLearn"}];
}
@end
