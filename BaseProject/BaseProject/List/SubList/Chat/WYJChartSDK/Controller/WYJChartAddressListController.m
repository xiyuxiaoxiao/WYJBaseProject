//
//  WYJChartAddressListController.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "WYJChartAddressListController.h"
#import "WYJChartAddress.h"
#import "MBProgressHUD.h"
#import "WYJChartCellTool.h"
@interface WYJChartAddressListController ()<UITableViewDelegate,UITableViewDataSource,ChartDatabaseManagerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WYJChartAddressListController

- (void)dealloc {
    
    [[ChartDatabaseManager share] deleteDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self request];
    
    [[ChartDatabaseManager share] addDelegate:self];
}

- (IBAction)addFriendAction:(id)sender {
    if (self.textField.text.length < 1) {
        [self.textField resignFirstResponder];
        return;
    }
    
    [WYJChartAddress addNewFriendWithName:self.textField.text];
    
    self.textField.text = nil;
    [self.textField resignFirstResponder];
}

- (void)request {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hud.hidden = NO;
            });
        });
        
        
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        self.dataArr = [NSMutableArray arrayWithArray:[WYJChartAddress findAll]];
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        
        NSLog(@"Linked in %f ms", linkTime *1000.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hide:NO];
            self.hud = nil;
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYJChartAddress *address = self.dataArr[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    
    cell.textLabel.text = address.name;
    cell.detailTextLabel.text = address.userId;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject *obj = self.dataArr[indexPath.row];
    UIViewController *vc = [[NSClassFromString(@"WYJChartController") alloc] init];
    [vc setValue:obj forKey:@"myFriend"];
    [self.navigationController pushViewController:vc animated:YES];
}

// 删除当前用户的文件
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    
    [self.dataArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationTop)];
}

#pragma mark - ChartDatabaseManagerDelegate
- (void)newAddress:(NSObject *)user {
    [self.dataArr addObject:user];
    [self.tableView reloadData];
}

@end

