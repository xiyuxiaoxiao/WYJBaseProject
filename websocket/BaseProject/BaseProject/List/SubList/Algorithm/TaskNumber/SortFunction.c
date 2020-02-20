//
//  SortFunction.c
//  Lesson4_workjob
//
//  Created by ZSXJ on 2017/6/29.
//  Copyright © 2017年 lanou3g. All rights reserved.
//

// 递增
void quickSort(int *start,int count);
// 第一个大于 >num 的下标  -1 表示没有
int firstIsGreaterThan (int *array,int left, int right, int num);
// 大于的个数
int greaterThanCount(int *array,int count, int num);
// 小于等于的个数
int lessThanOrEqualCount(int *array,int count, int num);
