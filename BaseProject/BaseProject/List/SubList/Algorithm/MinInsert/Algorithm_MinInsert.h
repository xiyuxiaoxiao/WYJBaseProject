//
//  Algorithm_MinInsert.h
//  NaviMap
//
//  Created by ZSXJ on 2017/8/16.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#ifndef Algorithm_MinInsert_h
#define Algorithm_MinInsert_h

#include <stdio.h>

#endif /* Algorithm_MinInsert_h */

/*
 T   : 外部定义 最后存放相关排序好的数据的数组
 
 endIndex : 终点的下标
 endIndex == 0 则应该在初始化 T 的时候 对T的个数加 1， 正确设置T的个数 才能正确使用该功能
 
 初始化剩余的点 : 当设置终点不是0的时候 ，相应的个数（R_count）也会减 1，后面的点 相应的下标对应的值应加 1，
 
 */
void minInsertionEnter (int *a,int column, int *T, int startIndex, int endIndex);

//  主要是外部采用OC法调用  如果采用C 只需要上面的方法即可
int minIndexOfR_T (int *R,int R_ount, int *T, int T_count,int *a, int column);
int indexOfInsertIntoT (int *T, int T_count,int *a, int column,int k);
int rowColumnValue (int row, int column,int *a, int columnAll);
