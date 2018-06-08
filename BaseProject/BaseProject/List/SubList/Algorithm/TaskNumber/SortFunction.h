//
//  SortFunction.h
//  Lesson4_workjob
//
//  Created by ZSXJ on 2017/6/29.
//  Copyright © 2017年 lanou3g. All rights reserved.
//

void swapWith(int *array, int i, int j) {
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
}

// 递增
void quickSortLeftRight(int *start,int count, int left, int right) {
    
    if (left < right) {
        
        int i = left;
        int j = right + 1;
        
        while (YES) {
            
            while (i+1 < count && start[++i] < start[left]);
            while (j-1 > -1 && start[--j] > start[left]);
            if (i >= j) break;
            
            swapWith(start, i, j);
        }
        
        swapWith(start, left, j);
        quickSortLeftRight(start, count, left, j-1);
        quickSortLeftRight(start, count, j+1, right);
    }
}

// 递增
void quickSort(int *start,int count) {
    quickSortLeftRight(start, count, 0, count-1);
}


#pragma mark -  一组数中 查找 > 或者 <= num 的个数

// 第一个大于 >num 的下标  -1 表示没有
int firstIsGreaterThan (int *array,int left, int right, int num) {
    if (left == right) {
        if (array[right] > num) {
            return right;
        }
        //结束 没有大于这个数的
        return -1;
    }
    
    int mid = (left + right) / 2;
    if (array[mid] > num) {
        right = mid;
        // 之所以不减1  是因为要求出第一个大于num的数 所以要包含
    }
    if (array[mid] <= num) {
        left = mid + 1;
    }
    return  firstIsGreaterThan(array, left, right, num);
}

// 大于的个数
int greaterThanCount(int *array,int count, int num) {
    int index = firstIsGreaterThan(array, 0, count-1, num);
    if (index == -1) {
        return 0;
    }
    return count - index;
}

// 小于等于的个数
int lessThanOrEqualCount(int *array,int count, int num) {
    int start = greaterThanCount(array, count, num);
    return count - start;
}

/*
 当较小时间的都结束的时候 较大时间也肯定结束了， 然后大时间没开始的，较小时间也不会开始，
 所以可以对当前要查询的数组也排序 然后 从两端开始递归计算
 
 // 判断指定的时间段的时间是否满足相关条件的
*/

