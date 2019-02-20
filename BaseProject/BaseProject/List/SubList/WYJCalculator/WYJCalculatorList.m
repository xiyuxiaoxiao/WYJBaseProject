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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    SourceViewController *vc = [[SourceViewController alloc] init];
    vc.filePath = [[NSBundle mainBundle] pathForResource:dict[@"filePath"] ofType:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
