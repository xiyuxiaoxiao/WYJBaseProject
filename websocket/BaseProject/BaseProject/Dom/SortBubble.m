
@interface SortBubble : NSObject
@end


@implementation SortBubble

// 冒泡排序
- (void)bubbleSort: (int *)array withCount: (int)count {
    
    // 用i表示j每次的结束下标， i从0到count的时候， i 表示循环的次数
    for (int  i = count - 1; i > 0; i --) {
        for (int j = 0; j < i; j ++) {
            if (array[j] > array[j + 1]) {
                int temp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = temp;
            }
        }
    }
}

// 冒泡排序 从两端同时开始，减少趟数，low端较大的往后， height端比较小的往前放

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

MakeSourcePath

@end
