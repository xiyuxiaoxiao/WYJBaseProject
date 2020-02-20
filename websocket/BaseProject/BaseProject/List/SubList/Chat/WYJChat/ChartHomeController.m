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
#import "JKDBHelper.h"

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

- (IBAction)saveOrder:(id)sender {
    
    [AddressList clearTable];
    [MessageList clearTable];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hud = [MBProgressHUD showHUDAddedTo:self.hudBackView animated:YES];
        });
        
        CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
        
        //在这写入要计算时间的代码
        [TestDataDatabase saveTestObjectAddressList];
//        [TestDataDatabase saveTestObjectMessageList];
        
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        
        NSLog(@"Linked in %f ms", linkTime *1000.0);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hide:YES afterDelay:0];
        });
        
    });
}



- (IBAction)addressListAction:(id)sender {
    UIViewController *vc = [[NSClassFromString(@"AddressLIstController") alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)updateDatabaseVersionAction:(id)sender {
    [JKDBVersionUpdateTest updateTable:@"MessageList" columns:@[@"content"] newColumn:@[@"messageText"]];
}
- (IBAction)updateDatabaseVersionToMessageAction:(id)sender {
    [MessageList updateTable:@"JKDBVersionUpdateTest" columns:@[@"messageText"] newColumn:@[@"content"]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%@",[JKDBHelper dbPath]);
}


@end
