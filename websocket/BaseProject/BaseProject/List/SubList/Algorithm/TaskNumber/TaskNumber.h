//
//  TaskNumber.h
//  BaseProject
//
//  Created by ZSXJ on 2017/6/30.
//  Copyright © 2017年 WYJ. All rights reserved.
//


/*
 题：
 已知：n个任务 包含 开始时间和结束时间 [ )   startTime <= time < endTime
 先给定一组时间 查询每个时间对应的 正在执行的任务个数
 
 */


/*
 思路
 
 开始时间 > 自己的  未开始的
 结束时间 <= 自己的  完毕的  （用大于自己的来查找 剩下的就是 <= 的）
 
 剩下的就是 正在执行的
 
 已知 一段时间的开始时间和结束时间  开始时间排序的
 
 计算开始时间的 直接从
 当每个给定的时间 需要多长时间呢
 
 */


#import <UIKit/UIKit.h>

@interface TaskNumber : UIViewController

@end
