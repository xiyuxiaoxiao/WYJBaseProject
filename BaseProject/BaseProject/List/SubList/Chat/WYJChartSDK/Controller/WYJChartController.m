//
//  WYJChartController.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartController.h"
#import "WYJChartTextCell.h"
#import "WYJChartMessage.h"
#import "WYJChartCellTool.h"
#import "WYJChatKeyboard.h"

@interface WYJChartController ()<UITableViewDelegate, UITableViewDataSource,WYJChartBaseCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)   NSMutableArray *dataArr;
@property (nonatomic, strong) WYJChatKeyboard *customKeyboard;
@end

@implementation WYJChartController
- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerClass:[WYJChartTextCell class] forCellReuseIdentifier:@"WYJChartTextCell_left"];
    [self.tableView registerClass:[WYJChartTextCell class] forCellReuseIdentifier:@"WYJChartTextCell_right"];
    
    self.dataArr = [WYJChartCellTool testArray];
    [self.tableView reloadData];
}


- (WYJChatKeyboard *)customKeyboard {
    if (_customKeyboard == nil) {
        _customKeyboard = [[WYJChatKeyboard alloc]init];
        _customKeyboard.delegate = self;
    }
    return _customKeyboard;
}
- (void)initUI {
    
    
    CGFloat keyboardHeight = 49;
    self.tableView.frame = CGRectMake(0, 20, WYJScreenWidth, WYJScreenHeight - NavaBar_StatusHeight - keyboardHeight-20);
    
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), WYJScreenWidth, keyboardHeight);
    
    self.customKeyboard.frame = frame;
//    self.customKeyboard = [[WYJChatKeyboard alloc] initWithFrame:frame];
    [self.view addSubview:self.customKeyboard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self scrollTableToLast];
}

#pragma mark - tableView delagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    WYJChartMessage *message = self.dataArr[indexPath.row];
    if (!message.byMySelf) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WYJChartTextCell_left"];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"WYJChartTextCell_right"];
    }
    ((WYJChartBaseCell *)cell).message = message;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYJChartMessage *msg = self.dataArr[indexPath.row];
    return msg.cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.customKeyboard endEdit];
}

- (void)scrollTableToLast {
    
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        
        CGFloat offsetY = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        
        if (fabs(offsetY - self.tableView.contentOffset.y) > 0.001) {
            
//            self.tableView.contentOffset = CGPointMake(0, offsetY);
//            [self.tableView setContentOffset:CGPointMake(0, offsetY)];
//            [UIView animateWithDuration:0.1 animations:^{
//            }];
            
            NSInteger row = self.dataArr.count - 1;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:YES];
        }
    }
}

#pragma mark - Keyboard Delegate
- (void)keyBoardFrameChange {
    CGFloat h = self.customKeyboard.frame.origin.y;
    self.tableView.frame = CGRectMake(0, 20, WYJScreenWidth, h-20);
    [self scrollTableToLast];
}

- (void)sendMessageText:(NSString *)text {
    WYJChartMessage *msg = [WYJChartCellTool creatMessageText:text];
    msg.sendStatus = SendStatusSending;
    [self.dataArr addObject:msg];
    [self.tableView reloadData];
    [self scrollTableToLast];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        msg.sendStatus = SendStatusSuccess;
        [self.tableView reloadData];
    });
}


#pragma mark - ChartCell delegate

// 重新发送
- (void)resendMessage:(WYJChartBaseCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WYJChartMessage *message = cell.message;
    [message reSendServer];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [message sendSuccess];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    });
}

@end
