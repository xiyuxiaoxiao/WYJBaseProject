//
//  AddressLIstController.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "AddressLIstController.h"
#import "AddressList.h"
#import "ChatController.h"
#import "MBProgressHUD.h"
#import "AddressListManager.h"
#import "MessageList.h"

@interface AddressLIstController ()<UITableViewDelegate,UITableViewDataSource,ChartDatabaseManagerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AddressLIstController

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
    [AddressListManager addNewFriend:self.textField.text];
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
        self.dataArr = [NSMutableArray arrayWithArray:[AddressList findAll]];
//        self.dataArr = [NSMutableArray arrayWithArray:[AddressList findAddressWithOneMessage]];
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
    
    AddressList *address = self.dataArr[indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cell"];
    
    cell.textLabel.text = address.name;
    cell.detailTextLabel.text = address.lastNewMessage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatController *vc = [[ChatController alloc] init];
    vc.myFriend = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addressListUpdate {
    [self request];
}
- (void)messageNew:(MessageList *)message {
    NSString *frientId = message.fromUserId;
    if ([message.fromUserId isEqualToString:[CurrentUserManager currentUser].userId]) {
        frientId = message.toUserId;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userId == %@",frientId];
    
    AddressList *address = [self.dataArr filteredArrayUsingPredicate:predicate].firstObject;
    
    if (!address) {
        return;
    }
    
    address.lastNewMessage = message.content;
    
    [self.tableView reloadData];
}

@end

