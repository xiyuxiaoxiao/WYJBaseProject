//
//  FDTemplateClassController.m
//  BaseProject
//
//  Created by ZSXJ on 2019/9/2.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import "FDTemplateClassController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "FDTemplateClassCell.h"

@interface FDTemplateClassController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)   NSMutableArray *data;
@end

@implementation FDTemplateClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 100) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FDTemplateClassCell" bundle:nil] forCellReuseIdentifier:@"FDTemplateClassCell"];
    
    [self testData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FDTemplateClassCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDTemplateClassCell"];
    [cell.button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"FDTemplateClassCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (void)configureCell: (FDTemplateClassCell *)cell atIndexPath: (NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = NO; 
    FDTemplateClassModal *obj = self.data[indexPath.row];
    cell.title.text = obj.title;
    
    cell.info.hidden = obj.hidden;
    if (obj.hidden) {
        cell.info.text = nil;
    }else {
        cell.info.text = obj.name;
    }
}

- (void)buttonClick: (UIButton *)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:  (UITableViewCell *)sender.superview.superview];
    FDTemplateClassModal *modal = self.data[indexPath.row];
    modal.hidden = !modal.hidden;
    [self.tableView reloadData];
}

- (void)testData {
    self.data = [NSMutableArray array];
    
    for (int i = 0; i < 40; i ++) {
        FDTemplateClassModal *obj = [[FDTemplateClassModal alloc] init];
        obj.hidden = NO;
        if (i % 3 == 0) {
            obj.title = @"附加费进口量房间里看风景的说法减肥法康师傅附加费进口量房间里看风景的说法减肥法康师傅";
            obj.name = @"解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房解放路房";
        }
        else if (i % 3 == 1) {
            obj.title = @"附加费";
            obj.name = @"解放";
        }
        else if (i % 3 == 2) {
            obj.title = @"附加费进口量房间里看";
            obj.name = @"解放路房间里看风景的水立方接待来访解放路房间里看风景的水立方接待来访";
        }
        
        [self.data addObject:obj];
    }
}
@end


@implementation FDTemplateClassModal

@end
