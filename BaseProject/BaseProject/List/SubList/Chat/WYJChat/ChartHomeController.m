//
//  ChartHomeController.m
//  BaseProject
//
//  Created by ZSXJ on 2018/5/28.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "ChartHomeController.h"
#import "AddressList.h"
#import "MessageList.h"
#import "JKDBVersionUpdateTest.h"
#import "TestDataDatabase.h"
#import "MBProgressHUD.h"
#import "WYJChartDBHelper.h"

@interface ChartHomeController ()
@property (weak, nonatomic) IBOutlet UIView *hudBackView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation ChartHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AddressList createTable];
    [MessageList createTable];
    
}

- (IBAction)clearData:(id)sender {
    [AddressList clearTable];
    [MessageList clearTable];
}

- (IBAction)conversationList:(id)sender {
    
    UIViewController *vc = [[NSClassFromString(@"WYJChartConversationListControlle") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)addressListAction:(id)sender {
    UIViewController *vc = [[NSClassFromString(@"WYJChartAddressListController") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)updateDatabaseVersionAction:(id)sender {
    [JKDBVersionUpdateTest updateTable:@"MessageList" columns:@[@"content"] newColumn:@[@"messageText"]];
}
- (IBAction)updateDatabaseVersionToMessageAction:(id)sender {
    [MessageList updateTable:@"JKDBVersionUpdateTest" columns:@[@"messageText"] newColumn:@[@"content"]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",[WYJChartDBHelper dbPath]);
}


@end
