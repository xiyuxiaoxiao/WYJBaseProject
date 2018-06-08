//
//  AlgorithmEnterList.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/30.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "AlgorithmEnterList.h"

@interface AlgorithmEnterList ()

@end

@implementation AlgorithmEnterList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initData {
    [self.dataArray addObject:@{TitleKey:@"任务 正在执行的个数判断 ",
                                CN_Key:@"TaskNumber"}];
    [self.dataArray addObject:@{TitleKey:@"最小插入法 ",
                                CN_Key:@"MinInsertExample"}];
    [self.dataArray addObject:@{TitleKey:@"排序",
                                CN_Key:@"SortViewController"}];
    
    [self.dataArray addObject:@{TitleKey:@"n个数形成圆圈 删除第m个 求最后一个",
                                CN_Key:@"LastRemainExample"}];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
