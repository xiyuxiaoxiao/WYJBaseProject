//
//  MessageController.m
//  网络请求
//
//  Created by WYJ on 16/5/14.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import "MessageController.h"
#import "MessageCell.h"
@interface MessageController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong)UIImageView *backImageView;

@property (nonatomic, strong)UIImageView *topImageView;

@property (nonatomic, strong)NSMutableArray *array;

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation MessageController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initTableView];
    
    _array = [NSMutableArray array];
    
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];
    [self.array addObject:[UIImage imageNamed:@"chat Image Test.jpg"]];

    self.backImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
    self.backImageView.image = [UIImage imageNamed:@"Chat BackGround.jpg"];
    [self.view insertSubview:self.backImageView atIndex:0];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    //    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:@"Message Cell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Message Cell"];
}

-(UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:self.tableView.bounds];
        [_topImageView setHighlighted:YES];
//        _topImageView.userInteractionEnabled = YES;
    }
    return _topImageView;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Message Cell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"text%ld",indexPath.row];
    cell.messageImageView.image = self.array[indexPath.row];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageimageLong:)];
    [cell.messageImageView addGestureRecognizer:tap];
    cell.messageImageView.userInteractionEnabled = YES;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row%4 * 50 + 50;
}


- (void)messageimageLong:(UITapGestureRecognizer *)sender {
    
    self.topImageView.image = ((MessageImageView *)sender.view).image;
    
    [self.view addSubview:self.topImageView];
    
    [self performSelector:@selector(removeTopVoew) withObject:nil afterDelay:1.5];
}

-(void) removeTopVoew{
    [self.topImageView removeFromSuperview];
    self.topImageView = nil;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView == scrollView) {
        CGFloat yOffset = self.tableView.contentOffset.y;
        
        NSLog(@"%f",yOffset);
        if (yOffset < 0) {
            CGFloat w = self.tableView.bounds.size.width;
            CGFloat h = self.tableView.bounds.size.height;
            w = w - yOffset;
            h = h - yOffset * 2;
            self.backImageView.frame = CGRectMake(yOffset / 2, yOffset, w, h);
        }
    }
}

@end
