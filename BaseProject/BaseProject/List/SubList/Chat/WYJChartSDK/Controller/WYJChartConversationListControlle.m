//
//  WYJChartConversationListControlle.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "WYJChartConversationListControlle.h"
#import "WYJChartAddress.h"
#import "MBProgressHUD.h"
#import "WYJChartConversation.h"
#import "WYJChartConversationCell.h"
#import "WYJChartMessage.h"

@interface WYJChartConversationListControlle ()<UITableViewDelegate,UITableViewDataSource,ChartDatabaseManagerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation WYJChartConversationListControlle

- (void)dealloc {
    
    [[ChartDatabaseManager share] deleteDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:NSClassFromString(@"WYJChartConversationCell") forCellReuseIdentifier:@"WYJChartConversationCell"];
    self.tableView.rowHeight = [WYJChartConversationCell cellHeight];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    
    [self request];
    
    [[ChartDatabaseManager share] addDelegate:self];
}

- (void)request {
    
    NSArray *arr = [WYJChartConversation findAddressWithOneMessage];
    self.dataArr = [NSMutableArray arrayWithArray:arr];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYJChartConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYJChartConversationCell"];
    cell.conversation = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject *obj = self.dataArr[indexPath.row];
    UIViewController *vc = [[NSClassFromString(@"WYJChartController") alloc] init];
    [vc setValue:[obj valueForKey:@"partnerUser"] forKey:@"myFriend"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ChartDatabaseManagerDelegate
// 会话更新
- (void)updateConversation: (NSObject *)conversation {
    WYJChartConversation *conver = [WYJChartConversation findByUserId:[(WYJChartConversation *)conversation partnerUserId]];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.partnerUserId = %@",conver.partnerUserId];
    NSArray *arr = [self.dataArr filteredArrayUsingPredicate:pre];
    if (arr.count >= 1) {
        NSInteger index = [self.dataArr indexOfObject:arr[0]];
        self.dataArr[index] = conver;
    }else {
        [self.dataArr insertObject:conver atIndex:0];
    }
    
    [self.tableView reloadData];
}
@end

