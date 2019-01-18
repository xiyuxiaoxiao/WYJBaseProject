//
//  WYJAddressListController.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "WYJAddressListController.h"
#import "AddressList.h"
#import "ChatController.h"
#import "MBProgressHUD.h"
#import "MessageList.h"

#import "WYJChartAddress.h"
#import "WYJChartManager.h"

@interface WYJAddressListController ()<UITableViewDelegate,UITableViewDataSource,ChartDatabaseManagerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WYJAddressListController

- (void)dealloc {
    [WYJChartAddress bg_removeChangeForTableName:nil identify:@"WYJAddressListController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [WYJChartAddress bg_registerChangeForTableName:nil identify:@"WYJAddressListController" block:^(bg_changeState result) {
        [self request];
    }];
    
    
    [self request];
    
}

- (IBAction)addFriendAction:(id)sender {
    
    [WYJChartManager addAddressList];
}

- (void)request {
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    
    NSArray *array = [WYJChartAddress bg_findAll:nil];
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"Linked in %f ms", linkTime *1000.0);

    self.dataArr = [NSMutableArray arrayWithArray:array];
    [self.hud hide:NO];
    self.hud = nil;
    [self.tableView reloadData];
    
    if (self.dataArr.count == 0) {
        [WYJChartManager initDataAddressList];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYJChartAddress *address = self.dataArr[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    
    cell.textLabel.text = address.name;
    cell.detailTextLabel.text = @"";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ChatController *vc = [[ChatController alloc] init];
//    vc.myFriend = self.dataArr[indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end

