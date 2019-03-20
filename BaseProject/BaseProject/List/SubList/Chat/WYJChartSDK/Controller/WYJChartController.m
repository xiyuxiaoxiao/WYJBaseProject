//
//  WYJChartController.m
//  BaseProject
//
//  Created by ZSXJ on 2019/1/23.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "WYJChartController.h"
#import "WYJChartBaseCell.h"
#import "WYJChartMessage.h"
#import "WYJChartCellTool.h"
#import "WYJChatKeyboard.h"
#import "WYJChartAddress.h"

#define PageCount 15

@interface WYJChartController ()<UITableViewDelegate, UITableViewDataSource,WYJChartBaseCellDelegate, ChartDatabaseManagerDelegate>
{
    NSInteger page;
    BOOL dataOver;
    BOOL requestting;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)   NSMutableArray *dataArr;
@property (nonatomic, strong) WYJChatKeyboard *customKeyboard;
@end

@implementation WYJChartController

- (void)dealloc {
    [[ChartDatabaseManager share] deleteDelegate:self];
}

- (NSMutableArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (WYJChatKeyboard *)customKeyboard {
    if (_customKeyboard == nil) {
        _customKeyboard = [[WYJChatKeyboard alloc]init];
        
        CGFloat f_color = 230/155.0;
        _customKeyboard.backgroundColor = [UIColor colorWithRed:f_color green:f_color blue:f_color alpha:1];
        _customKeyboard.delegate = self;
        
        [self.view addSubview: _customKeyboard];
    }
    return _customKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.myFriend.name;
    
    dataOver = NO;
    requestting = NO;
    [self initUI];
    
    
    self.tableView.estimatedRowHeight           = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.tableFooterView              = [[UIView alloc] initWithFrame:CGRectZero];
    
    [WYJChartBaseCell registerClassWithTableView:self.tableView];
    
    [self loadMoreMessage:nil];
    
    [[ChartDatabaseManager share] addDelegate:self];
    
    [WYJChartCellTool clearConversionUnReadWithUserId:self.myFriend.userId];
}

- (void)initUI {
    
    CGFloat f_color = 240/255.0;
    self.tableView.backgroundColor = [UIColor colorWithRed:f_color green:f_color blue:f_color alpha:1];
    
    CGFloat keyboardHeight = 49;
    self.tableView.frame = CGRectMake(0, 0, WYJScreenWidth, WYJScreenHeight - NavaBar_StatusHeight - keyboardHeight);
    self.customKeyboard.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), WYJScreenWidth, keyboardHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self scrollTableToLast];
}

- (void)loadMoreMessage:(id)sender {
    
    if (dataOver == YES) {
        return;
    }
    if (requestting) {
        return;
    }
    requestting = YES;
    
    if (page == 0) {
        [self.dataArr removeAllObjects];
        [self.tableView reloadData];
    }
    
    page += 1;
    
    
    CGFloat lastContentSizeHeight = self.tableView.contentSize.height;
    CGFloat lastOffsetY = self.tableView.contentOffset.y;
    
    WYJChartMessage *firstMeeage = self.dataArr.firstObject;
    NSString *lastId = nil;
    if (firstMeeage) {
        lastId = [NSString stringWithFormat:@"%d",firstMeeage.pk];
    }
    NSArray *arr = [WYJChartMessage findMessageArray:self.myFriend.userId page:page perPageCount:PageCount lastCreatId:lastId];
    
    for (WYJChartMessage *message in arr) {
        [WYJChartCellTool setCellheight:message];
    }
    
    requestting = NO;
    
    if (arr.count < PageCount) {
        // 没有数据了 不用在请求了 因此需要记录一下当前是否加载完毕
        dataOver = YES;
        if (arr.count == 0) {
            return;
        }
    }

    [self.dataArr insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)]];
    [self.tableView reloadData];
    
    CGFloat currentContentSizeHeight = self.tableView.contentSize.height;
    
    CGFloat contentSizeOffset = currentContentSizeHeight - lastContentSizeHeight;
    
    if (lastContentSizeHeight > 0 && contentSizeOffset > 1) {
        self.tableView.contentOffset = CGPointMake(0, lastOffsetY+contentSizeOffset);
    }
    
}

#pragma mark - tableView delagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WYJChartMessage *message    = self.dataArr[indexPath.row];
    NSString *identify          = [WYJChartBaseCell identifyWithMessage:message];
    WYJChartBaseCell *cell      = [tableView dequeueReusableCellWithIdentifier:identify];
    
    cell.message = message;
    
    NSString *url = @"";
    if (cell.left) {
        url = self.myFriend.portraitURL;
    }else {
        url = [WYJChartCellTool getCurrentUser].portraitURL;
    }
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [WYJChartCellTool reSetSendTimeMessage:self.dataArr whenCellHeightIndexpath:indexPath];
    
    WYJChartMessage *msg = self.dataArr[indexPath.row];
    return msg.cellHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y <= self.tableView.frame.size.height/6) {
        [self loadMoreMessage: nil];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.customKeyboard endEdit];
}

- (void)scrollTableToLast {
    [self scrollTableToLastAnimation:YES];
}
- (void)scrollTableToLastAnimation:(BOOL)animation {
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        
        CGFloat offsetY = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        
        if (fabs(offsetY - self.tableView.contentOffset.y) > 0.001) {
            
            //            self.tableView.contentOffset = CGPointMake(0, offsetY);
            //            [self.tableView setContentOffset:CGPointMake(0, offsetY)];
            //            [UIView animateWithDuration:0.1 animations:^{
            //            }];
            
            NSInteger row = self.dataArr.count - 1;
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:(UITableViewScrollPositionBottom) animated:animation];
        }
    }
}

#pragma mark - Keyboard Delegate
- (void)keyBoardFrameChange {
    CGFloat h = self.customKeyboard.frame.origin.y;
    self.tableView.frame = CGRectMake(0, 0, WYJScreenWidth, h);
    [self scrollTableToLastAnimation:NO];
}

- (void)sendMessageText:(NSString *)text {
    WYJChartMessage *msg = [WYJChartCellTool creatMessageText:text];
    [WYJChartCellTool sendMessage:msg toUser:self.myFriend];
}
- (void)sendMessageImage:(UIImage *)image {
    WYJChartMessage *msg = [WYJChartCellTool creatMessageImage:image];
    [WYJChartCellTool sendMessage:msg toUser:self.myFriend];
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

#pragma mark - ChartDatabaseManagerDelegate 消息接收
- (void)receiveMessageNew:(NSObject *)message {
    [self.dataArr addObject:message];
    [self.tableView reloadData];
    [self scrollTableToLast];
}

@end
