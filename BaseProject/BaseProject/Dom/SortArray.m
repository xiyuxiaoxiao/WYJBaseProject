
@interface SortArray : NSObject
@end


@implementation SortArray

/**
    交换实现 也可以使用  异或
        int a=2; int b=3;
        a = a ^ b;
        b = a ^ b;
        a = a ^ b;
 */
#pragma 交换
-(void)swapWith: (int *)array inde:(int)index1 toIndex:(int)index2 {
    int temp = array[index1];
    array[index1] = array[index2];
    array[index2] = temp;
}


#pragma 冒泡排序
- (void)bubbleSort: (int *)array withCount: (int)count {
    
    // 用i表示j每次的结束下标， i从0到count的时候， i 表示循环的次数
    for (int  i = count - 1; i > 0; i --) {
        for (int j = 0; j < i; j ++) {
            if (array[j] > array[j + 1]) {
                [self swapWith:array inde:j toIndex:j+1];
            }
        }
    }
}

#pragma 冒泡排序 从两端同时开始，减少趟数，low端较大的往后， height端比较小的往前放

/*
    经测试， 实际上两种方式，比较的次数一样，只是第二种对于冒泡的算法Q能小一点
 */
- (void)bubbleSort2: (int *)array withCount: (int)count {
    
    int low = 0;
    int height = count - 1;
    int i;
    
    while (low < height) {
        for (i = low; i < height; i ++) {
            if (array[i] > array[i + 1]) {
                int temp = array[i];
                array[i] = array[i+1];
                array[i+1] = temp;
            }
        }
        
        height --;
        
        for (i = height; i > low; i --) {
            if (array[i] < array[i - 1]) {
                int temp = array[i];
                array[i] = array[i-1];
                array[i-1] = temp;
            }
        }
        low ++;
    }
}



/**
    
    每次遍历从后面的开始 找出后面最大/最小的元素位置
    然后和当前 i 进行交换 因为 i 前面的都是每次从后面或许的 结果中 排序好的
 */
#pragma 选择排序
- (void)selectSort:(int *)array count:(int)count {
    for(int i = 0; i < count; i++) {
        
        // ------从后面的找出最大/最小的位置------
        int maxIndex = i;
        for (int j = i+1; j < count; j++) {
            if (array[j] < array[maxIndex]) {
                maxIndex = j;
            }
        }
        // -------------
        [self swapWith:array inde:i toIndex:maxIndex];
    }
}

#pragma 插入排序
- (void)insertionSort: (int *)array withCount:(int)count {
    
    for (int i = 1; i < count; i++) {
        
        if (array[i] < array[i - 1]) {
            
            int x = array[i];
            
            array[i] = array[i - 1];
            
            int j = i - 2;
            
            if (j >= 0) {
                while (x < array[j]) {
                    array[j + 1] = array[j];
                    j--;
                    
                    if (j < 0) {
                        break;
                    }
                }
            }
            
            array[j + 1] = x;
        }
    }
}

#pragma 递归阶乘
- (int)digui:(int)n {
    if (n <= 1) return 1;
    return n * [self digui:n-1];
}


#pragma 快速排序
-(void)quickSort: (int *)array withCount:(int)count withLeft:(int)left withRight: (int)right {

    if (left < right) {
        int i = left;
        int j = right + 1;
        
        while (YES) {
            while ((i+1 < count) && (array[++i] < array[left]));
            while ((j-1 > -1) && (array[--j] > array[left]));
            
            if (i >= j) {
                break;
            }
            
            [self swapWith:array inde:i toIndex:j];
        }
        
        
        [self swapWith:array inde:left toIndex:j];
        
        [self quickSort:array withCount:count withLeft:left withRight:j-1];
        
        [self quickSort:array withCount:count withLeft:j+1 withRight:right];
    }
}

MakeSourcePath

@end
