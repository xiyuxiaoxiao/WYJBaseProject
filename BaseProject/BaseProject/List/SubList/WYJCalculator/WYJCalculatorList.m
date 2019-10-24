//
//  WYJCalculatorList.m
//  BaseProject
//
//  Created by ZSXJ on 2019/2/19.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJCalculatorList.h"

@interface WYJCalculatorList ()

@end

@implementation WYJCalculatorList

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"地铁 月供",
                                @"filePath":@"subwayCostEachMonth.html"}];
    [self.dataArray addObject:@{TitleKey:@"提前还贷的钱可用多少年",
                                CN_Key:@"RestMoneyEveryYearController"}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    UIViewController *vc;
    if (!dict[CN_Key]) {
        vc = [[SourceViewController alloc] init];
        ((SourceViewController *)vc).filePath = [[NSBundle mainBundle] pathForResource:dict[@"filePath"] ofType:nil];
    }else {
        Class class = NSClassFromString(dict[CN_Key]);
        vc = [[class alloc] init];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
