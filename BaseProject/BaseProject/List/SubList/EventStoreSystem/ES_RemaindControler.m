//
//  ES_RemaindControler.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/5.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "ES_RemaindControler.h"
#import "EventStoreManager.h"
@interface ES_RemaindControler ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation ES_RemaindControler

- (NSMutableArray *)array {
    if (nil == _array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeChanged:)
                                                 name:EKEventStoreChangedNotification
                                               object:[EventStoreManager shareManager].eventStore];
    
    [EventStoreManager requestAccessToEntityType];
    [self refresh];
    
}

- (void)refresh {
    [EventStoreManager findAllReminder:^(NSArray<EKReminder *> *reminders) {
        
        for (EKReminder *reminder in reminders) {
            NSLog(@"\n %@ \n %@  ,  %@",reminder,reminder.calendarItemIdentifier,reminder.calendarItemExternalIdentifier);
        }
        
        self.array = [NSMutableArray arrayWithArray:reminders];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)storeChanged: (EKEventStore *)eventStore {
    [self refresh];
}

- (IBAction)delegateAllAction:(id)sender {
    [EventStoreManager delegate];
}

- (IBAction)addAction:(id)sender {
    [EventStoreManager addReminder];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    
    EKReminder *reminder = self.array[indexPath.row];
    cell.textLabel.text = reminder.title;
    return cell;
}

@end
