//
//  TaskNumber.m
//  BaseProject
//
//  Created by ZSXJ on 2017/6/30.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "TaskNumber.h"
#import "SortFunction.h"
@interface TaskNumber ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TaskNumber

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *str = @"\n"
        "void version2() {\n"
        "int count = 3;\n"
        "int array[3] = {0,5,2};\n"
        "int endArray[3] = {4,7,8};\n"
    
    "\n"
    
        "// 先排序\n"
        "quickSort(array, count);\n"
        "quickSort(endArray, count);\n"
    
    "\n"
    
        "for (int i = 0; i < count; i++) {\n"
            "printf(\"%d,\",array[i]);\n"
        "}\n"
        "printf(\"\n\");\n"
        "for (int i = 0; i < count; i++) {\n"
            "printf(\"%d,\",endArray[i]);\n"
        "}\n"
    
    "\n"
    
        "printf(\"\n正在执行的任务个数\n\");\n"
        "int queryArray[4] = {1,9,4,3};\n"
        "for (int i = 0; i < 4; i++) {\n"
            "int start_no = greaterThanCount(array, count, queryArray[i]);\n"
            "int end_yes = lessThanOrEqualCount(endArray, count, queryArray[i]);\n"
            "int starting = count - start_no - end_yes;\n"
    
    "\n"
    
            "printf(\"%d \",starting);\n"
        "}\n"
        "printf(\"\n\");\n"
    "}\n"
    "\n\n\n\n\n "
    "结果：\n"
    "0,2,5,\n"
    "4,7,8,\n"
    "正在执行的任务个数\n"
    "1 0 1 2\n";
    
    
    /*
     
     */
    self.textView.text = str;
    self.textView.editable = NO;
    
    
    
    version2();
    // 查看打印结果
}

// 对开始结束时间优化
void version2() {
    int count = 3;
    int array[3] = {0,5,2};
    int endArray[3] = {4,7,8};
    
    // 先排序
    quickSort(array, count);
    quickSort(endArray, count);
    
    for (int i = 0; i < count; i++) {
        printf("%d,",array[i]);
    }
    printf("\n");
    for (int i = 0; i < count; i++) {
        printf("%d,",endArray[i]);
    }
    
    printf("\n正在执行的任务个数\n");
    int queryArray[4] = {1,9,4,3};
    for (int i = 0; i < 4; i++) {
        int start_no = greaterThanCount(array, count, queryArray[i]);
        int end_yes = lessThanOrEqualCount(endArray, count, queryArray[i]);
        int starting = count - start_no - end_yes;
        
        printf("%d ",starting);
    }
    printf("\n");
}


// 对外层的for循环优化

/*
 
 两边计算法  根据两边计算中间的
 
 需要记录左边与右边两边的 开始下标与结束下标
 然后 去左边与右边的 开始下标  计算当前自己的开始下标
 然后 去左边与右边的 结束下标  计算当前自己的结束下标
 
 最后根据 开始下标 计算结束个数  根据结束下标 计算结束个数 在计算正在执行的个数
 
 */


void version3() {
    
    int count = 3;
    int array[3] = {2,5,3};
    int endArray[3] = {4,7,8};
    
    // 先排序
    quickSort(array, count);
    quickSort(endArray, count);
    
    for (int i = 0; i < count; i++) {
        printf("%d,",array[i]);
    }
    printf("\n");
    for (int i = 0; i < count; i++) {
        printf("%d,",endArray[i]);
    }
    
    int arrayNew[13] = {1,2,4,5,6,7,18,20,21,22,23,24,25};
    int resultArray[13] = {0,0,0,0,0,0,0,0,0,0,0,0,0};
    resultArray[0] = 0;
    resultArray[12] = -1;
    calculateTimeIndex(arrayNew, 0, 12, resultArray, endArray, 0, -1, 3);
    
    
    printf("结果下标\n");
    for (int i = 0; i < 13; i++) {
        printf("%d,",resultArray[i]);
    }
}

/*
 目前只计算 结束时间的
 resultArray 存放结果的
 left 表示计算当前的
 right 表示计算当前右边的
 count: endArray count
 */
// 结束时间 计算一定范围内的结束时间与开始时间  是否需要返回  目前只单独计算结束时间
void calculateTimeIndex(int *array,int left,int right, int *resultArray, int *endArray,int leftEnd, int rightEnd, int count) {
    
    if (left == right) {
        // 结束 不在计算
        return;
    }
    
    if (left + 1 == right) {
        // 只需要在计算right即可；一般right会和后面的时候 被计算 所以不需要在计算
        return;
    }
    
    int leftEndNew = leftEnd;
    int rightEndNew = rightEnd;
    
    int mid = (left + right)/2;
    
    
    int midEndIndex;
    // 说明没有大于左边的数  更没有大于自己的数了
    if (leftEnd == -1) {
        midEndIndex = leftEndNew;
        
        if (left+1 < 13) {
            for (int i = left+1; i < right; i++) {
                printf("s mid:%d index: %d\n", array[i],midEndIndex);
                resultArray[i] = midEndIndex;
            }
        }
        return;
    }
    
    // 没有大于右边的数  所以下标应该在最右边
    if (rightEnd == -1) {
        rightEndNew = count-1;
    }
    
    midEndIndex = firstIsGreaterThan(endArray, leftEndNew, rightEndNew, array[mid]);
    int midEndIndexNew = midEndIndex;
    
    if (midEndIndex == -1) {
        midEndIndex = rightEnd;
    }
    
    printf("y mid:%d index:%d \n", array[mid],midEndIndex);
    resultArray[mid] = midEndIndex;
    
    calculateTimeIndex(array, left, mid, resultArray, endArray, leftEnd, midEndIndexNew, count);
    calculateTimeIndex(array, mid, right, resultArray, endArray, midEndIndex, rightEnd, count);
    
}

@end
