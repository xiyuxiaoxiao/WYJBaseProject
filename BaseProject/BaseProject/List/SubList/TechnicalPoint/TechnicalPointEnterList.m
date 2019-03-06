//
//  TechnicalPointEnterList.m
//  BaseProject
//
//  Created by ZSXJ on 2017/7/14.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "TechnicalPointEnterList.h"

@interface TechnicalPointEnterList ()

@end

@implementation TechnicalPointEnterList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"block 使用",
                                CN_Key:@"BlockPoint"}];
    [self.dataArray addObject:@{TitleKey:@"copy 内存管理",
                                CN_Key:@"CopyMemory"}];
    
    [self.dataArray addObject:@{TitleKey:@"GCD多线程",
                                @"filePath":@"多线程GCD.htm",
                                }];
    [self.dataArray addObject:@{TitleKey:@"NSOperation、NSOperationQueue",
                                @"filePath":@"NSOperation.htm"}];
    [self.dataArray addObject:@{TitleKey:@"pthread、NSThread",
                                @"filePath":@"NSThread.htm"}];
    
    [self.dataArray addObject:@{TitleKey:@"GCD 自己的总结",
                                CN_Key:@"GCDMySummary"
                                }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    SourceViewController *vc = [[SourceViewController alloc] init];
    
    if (dict[CN_Key]) {
        vc.filePath = SourcePathByClassName(dict[CN_Key]);
    }
    else if (dict[@"filePath"]){
        vc.filePath = [[NSBundle mainBundle] pathForResource:dict[@"filePath"] ofType:nil];
    }else {
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
//    [NSClassFromString(@"GCDMySummary") performSelector:@selector(test1)];
}

@end
