//
//  ChatController.m
//  FMDBMoreTable
//
//  Created by ZSXJ on 2018/5/25.
//  Copyright © 2018年 WYJ. All rights reserved.
//

#import "ChatController.h"
#import "AddressList.h"
#import "MessageList.h"
#import "ChatMyCell.h"
#import "ChatFriendCell.h"
#import "CurrentUserManager.h"

@interface ChatController ()<UITableViewDelegate,UITableViewDataSource,ChartDatabaseManagerDelegate>
{
    NSInteger page;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITextField *callBackTextField;
@property (weak, nonatomic) IBOutlet UITextField *sendMessageTextField;
@end

@implementation ChatController

- (void)dealloc {
    [[ChartDatabaseManager share] deleteDelegate:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArr = [NSMutableArray array];
    page = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.currentUser = [CurrentUserManager currentUser];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatMyCell" bundle:nil] forCellReuseIdentifier:@"ChatMyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatFriendCell" bundle:nil] forCellReuseIdentifier:@"ChatFriendCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"模拟下啦加载更多" style:(UIBarButtonItemStylePlain) target:self action:@selector(loadMoreMessage:)];
    
    [[ChartDatabaseManager share] addDelegate:self];
    
    self.callBackTextField.delegate = self;
    self.sendMessageTextField.delegate = self;
    [self loadMoreMessage:nil];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageList *message = self.dataArr[indexPath.row];
    AddressList *user;
    ChatCell *cell;
    if ([message.fromUserId isEqualToString: self.currentUser.userId]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChatFriendCell"];
        user = self.currentUser;
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ChatMyCell"];
        user = self.myFriend;
    }
    
    cell.name.text = user.name;
    cell.messageText.text = message.content;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (IBAction)sendMessage:(id)sender {
    
    MessageList *message = [[MessageList alloc] init];
    message.toUserId = self.myFriend.userId;
    message.fromUserId = self.currentUser.userId;
    message.content = self.sendMessageTextField.text;
//    message.serverReceiveTime = [self.class serverDate];
    
    [message saveOrUpdate];
}

- (IBAction)receiveMessage:(id)sender {
    
    MessageList *message = [[MessageList alloc] init];
    message.toUserId = self.currentUser.userId;
    message.fromUserId = self.myFriend.userId;
    message.content = self.callBackTextField.text;
//    message.serverReceiveTime = [self.class serverDate];
    
    [message saveOrUpdate];
}

+ (NSString *)serverDate {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [NSDate date];
    return [inputFormatter stringFromDate:inputDate];
}


- (void)loadMoreMessage:(id)sender {
    
    if (page == 0) {
        [self.dataArr removeAllObjects];
        [self.tableView reloadData];
    }
    
    page += 1;
    
    
    CGFloat lastContentSizeHeight = self.tableView.contentSize.height;
    CGFloat lastOffsetY = self.tableView.contentOffset.y;
    
    MessageList *firstMeeage = self.dataArr.firstObject;
    NSString *lastId = nil;
    if (firstMeeage) {
        lastId = [NSString stringWithFormat:@"%d",firstMeeage.pk];
    }
    NSArray *arr = [MessageList findMessageArray:self.myFriend.userId page:page perPageCount:10 lastCreatId:lastId];
//    NSArray *arr = [MessageList findMessageArray:self.myFriend.userId page:page perPageCount:10];
    [self.dataArr insertObjects:arr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, arr.count)]];
    [self.tableView reloadData];
    
    CGFloat currentContentSizeHeight = self.tableView.contentSize.height;
    
    CGFloat contentSizeOffset = currentContentSizeHeight - lastContentSizeHeight;
    
    if (lastContentSizeHeight > 0 && contentSizeOffset > 1) {
        self.tableView.contentOffset = CGPointMake(0, lastOffsetY+contentSizeOffset - 60);
    }
    
}

- (IBAction)loadAllMessage:(id)sender {
    page = 0;
    NSArray *array = [MessageList findMessageArray:self.myFriend.userId page:1 perPageCount:1000];
    [self.dataArr addObjectsFromArray:array];
    [self.tableView reloadData];
}

- (void)refreshTableWhenNewMsg {
    if (self.tableView.contentSize.height > self.tableView.bounds.size.height) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGFloat offsetY = self.tableView.contentSize.height - self.tableView.bounds.size.height;
            self.tableView.contentOffset = CGPointMake(0, offsetY);
        }];
    }
    
}

+ (BOOL)scrollViewDidScrollResignFirstResponse {
    return YES;
}

- (void)messageNew:(MessageList *)message {
    [self.dataArr addObject:message];
    [self.tableView reloadData];
    [self refreshTableWhenNewMsg];
}
@end
