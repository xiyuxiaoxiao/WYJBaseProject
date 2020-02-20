//
//  Algorithm_MinInsert.c
//  NaviMap
//
//  Created by ZSXJ on 2017/8/16.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#include "Algorithm_MinInsert.h"


/*
 a      : 愿数组
 column : 数据点的个数
 R      : 剩余的点
 T      : 已经排好序的点
 */

// 使用一维数组 封装二维数组调用
// 根据 二维数组下标 转换 一维数组 对应的下标
int rowColumnTurnToIndex (int row, int column,int columnAll);
int rowColumnValue (int row, int column,int *a, int columnAll);
int towPointDistance (int *a, int row, int column,int columnAll);
int towPointValueMin (int *a, int row, int column,int columnAll);

int indexOfMinDistancePointToT (int index, int *T, int T_count,int *a,int column);
int minIndexOfR_T (int *R,int R_ount, int *T, int T_count,int *a, int column);
int valueOfInsertPointBetweenMN (int m, int n, int k, int *a, int column);
int indexOfInsertIntoT (int *T, int T_count,int *a, int column,int k);



#pragma mark - 计算最小插入排序

/*
 T   : 外部定义 最后存放相关排序好的数据的数组
 
 endIndex : 终点的下标
 endIndex == 0 则应该在初始化 T 的时候 对T的个数加 1， 正确设置T的个数 才能正确使用该功能

 初始化剩余的点 : 当设置终点不是0的时候 ，相应的个数（R_count）也会减 1，后面的点 相应的下标对应的值应加 1，
 
 */

void minInsertionEnter (int *a,int column, int *T, int startIndex, int endIndex) {
    //==========  初始化 排序 与 未排序 的点
    int T_count = 2;
    
    T[0] = startIndex;
    T[1] = endIndex;
    
    int R_count = column - 1;
    if (startIndex == endIndex) {
        R_count = column - 1;
    }else {
        R_count = column - 2;
    }

    
    int R[R_count];
    
    int ri = 0;
    for (int i = 0; i < column; i++) {
        if (i != startIndex && i != endIndex) {
            R[ri] = i;
            ri ++;
        }
    }
    // ===========================
    
    // =============== 相同之处 ⬇️ ====================
    while (R_count > 0) {
        
        int index_r = minIndexOfR_T(R, R_count, T, T_count-1, a, column);
        
        int k = R[index_r];
        int insertIndex_T = indexOfInsertIntoT(T, T_count, a, column, k);
        
        // =============== 相同之处 ⬆️ ====================
        // 修改数组T 插入
        T_count += 1;
        for (int i = T_count-1; i > insertIndex_T; i--) {
            T[i] = T[i-1];
        }
        T[insertIndex_T] = k;
        
        R_count -= 1;
        for (int i = index_r; i < R_count; i++) {
            R[i] = R[i+1];
        }
    }
}


#pragma - mark 计算一个点 在已经确定点中应该插入的位置

/*
 k :将要插入T中的点
 */
int indexOfInsertIntoT (int *T, int T_count,int *a, int column,int k) {
    
    int i = 1;      // 将要插入的位置
    int v_min = 1;  // 需要记录需要插入的之前
    
    while (i < T_count) {
        
        if (i == v_min) {
            i++;
            continue;
        }
        
        // i-1和i之间插入的值
        int m = T[i-1];
        int n = T[i];
        int v = valueOfInsertPointBetweenMN(m, n, k, a, column);
        
        int v_min_m = T[v_min-1];
        int v_min_n = T[v_min];
        int v_min_v = valueOfInsertPointBetweenMN(v_min_m, v_min_n, k, a, column);
        if (v < v_min_v) {
            v_min = i;
        }
        i++;
    }
    
    return v_min;
}

// C^mk + C^kn - C^mn
int valueOfInsertPointBetweenMN (int m, int n, int k, int *a, int column) {
    int mk = rowColumnValue(m, k, a, column);
    int kn = rowColumnValue(k, n, a, column);
    int mn = rowColumnValue(m, n, a, column);
    int v = mk+kn-mn;
    return v;
}


#pragma - mark 计算没有确定的点 在已经确定点中最小距离的点
/*
 计算R[r]点中 于 T[] 的距离的最小index
 
 【与T[]的距离  也就是一个点与T中所有点比较 距离最小的那个点所对应的距离】
 
 返回值     : R中的index
 */

int minIndexOfR_T (int *R,int R_ount, int *T, int T_count,int *a, int column) {
    
    int rMin = 0;
    int rMin_T_Index = 0;// 对应的每个T中的index
    int r = 0;
    while (r < R_ount) {
        
        // 计算R[r]点 于 T[] 每个点的距离的最小index
        int indexR = R[r];
        int tMin = indexOfMinDistancePointToT(indexR, T, T_count, a, column);
        
        if (r == 0) {
            rMin_T_Index = tMin;
            r++;
            continue;
        }
        
        if (towPointValueMin(a, indexR, T[tMin], column) < towPointValueMin(a, R[rMin], T[rMin_T_Index], column)) {
            rMin = r;
            rMin_T_Index = tMin;
        }
        
        r++;
    }
    
    return rMin;
}

/*
 计算一个点 在已经确定的序列中的点 与之最小距离对应的下标
 例 : T[3] = {0,5,0} index = 1; 最小的是 C^51 所以返回的是5的下标1
 
 返回值 : 对应T中相应的下标
 T     : 已经确定的点的数组
 index : 将要计算的点 在 0～column 中的点
 */

int indexOfMinDistancePointToT (int index, int *T, int T_count,int *a,int column) {
    
    int tMin = 0;
    
    int t = 1;
    while (t < T_count) {
        int indexT = T[t];
        int indexMin = T[tMin];
        if (towPointValueMin(a,indexT,index,column) < towPointValueMin(a, indexMin, index,column)) {
            tMin = t;
        }
        t++;
    }
    
    return tMin;
}

#pragma mark - 两个点之间的 距离计算 和 一维数组 表示 二维数组

// 计算两个点往返距离 中最小的一个（使用的是相应的值,不是row与column互换后求和）
int towPointValueMin (int *a, int row, int column,int columnAll) {
    int index1 = rowColumnValue(row, column, a, columnAll);
    int index2 = rowColumnValue(row, column, a, columnAll);
    if (index1 < index2) {
        return index1;
    }
    return index2;
}

// 计算两点之间的距离 : C^mn+C^nm
int towPointDistance (int *a, int row, int column,int columnAll) {
    int index1 = rowColumnValue(row, column, a, columnAll);
    int index2 = rowColumnValue(column, row, a, columnAll);
    return index1+index2;
}

// 获取下标对应的值
int rowColumnValue (int row, int column,int *a, int columnAll) {
    int index = rowColumnTurnToIndex(row,column,columnAll);
    return a[index];
}

// 根据 二维数组下标 转换 一维数组 对应的下标
int rowColumnTurnToIndex (int row, int column,int columnAll) {
    return row*columnAll+column;
}
