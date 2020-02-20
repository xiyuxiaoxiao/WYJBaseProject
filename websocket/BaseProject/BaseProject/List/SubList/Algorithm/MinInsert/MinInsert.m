//
//  MinInsert.m
//  BaseProject
//
//  Created by ZSXJ on 2017/8/16.
//  Copyright © 2017年 WYJ. All rights reserved.
//

#import "MinInsert.h"
#import "Algorithm_MinInsert.h"

static int const column = 6;
static int const a[6*6] = {
    0 , 24, 50, 38, 55, 20,
    22, 0 , 32, 23, 45, 18,
    47, 35, 0 , 15, 21, 60,
    39, 27, 17, 0 , 14, 25,
    57, 42, 18, 16, 0 , 42,
    21, 16, 57, 21, 41, 0 ,
};

@interface MinInsert ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation MinInsert

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    i:row , j:column
    
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < column; i++) {
        
        for (int j = 0; j < column; j++) {
            int n = a[i*column+j];
            [str appendFormat:@"%2d,\t",n];
        }
        if (i < column - 1) {
            [str appendFormat:@"\n"];
        }
    }
    
    self.textView.text = str;
    self.textView.editable = NO;
}


- (IBAction)buttonAction:(id)sender {
    [self minInsertionArrayC:a column:column];
//    [self minInsertionArrayOC:a column:column];
}

- (void)minInsertionArrayC:(int *)a column:(int)column {
    
    int T[column+1];
    minInsertionEnter(a, column, T, 0, 0);
    
    int T_count = column+1;
    // 结果打印
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < T_count; i++) {
        
        if (i == 0) {
            [str appendString:@"{"];
        }
        if (i == T_count-1) {
            [str appendFormat:@"%d}",T[i]];
            break;
        }
        [str appendFormat:@"%d,",T[i]];
    }
    
    NSLog(@"最后结果：%@",str);
    
    int timeSum = 0;
    for (int i = 0; i < T_count-1; i++) {
        int m = T[i];
        int n = T[i+1];
        timeSum += rowColumnValue(m, n, a, column);
    }
    NSLog(@"总时间：%d",timeSum);
    
    self.resultLabel.text = [NSString stringWithFormat:@"最后结果：%@ \n\n总时间：%d",str,timeSum];
}

// 使用OC数组
- (void)minInsertionArrayOC:(int *)a column:(int)column {
    NSMutableArray *T_Array = [NSMutableArray array];
    NSMutableArray *R_Array = [NSMutableArray array];
    
    [T_Array addObject:@"0"];
    [T_Array addObject:@"0"];
    for (int i = 1; i<column; i++) {
        [R_Array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    while (R_Array.count > 0) {
        int T_count = (int)T_Array.count;
        int R_count = (int)R_Array.count;
        
        int T[T_Array.count];
        int R[R_Array.count];
        
        for (int i = 0; i < T_Array.count; i++) {
            NSString *str = T_Array[i];
            T[i] = str.intValue;
        }
        
        for (int i = 0; i < R_Array.count; i++) {
            NSString *str = R_Array[i];
            R[i] = str.intValue;
        }
        
        int index_r = minIndexOfR_T(R, R_count, T, T_count-1, a, column);
        
        int k = R[index_r];
        int insertIndex_T = indexOfInsertIntoT(T, T_count, a, column, k);
        
        [T_Array insertObject:[NSString stringWithFormat:@"%d",k] atIndex:insertIndex_T];
        [R_Array removeObjectAtIndex:index_r];
    }
    
    // 结果打印
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < T_Array.count; i++) {
        NSString *point = T_Array[i];
        if (i == 0) {
            [str appendString:@"{"];
        }
        if (i == T_Array.count-1) {
            [str appendFormat:@"%@}",point];
            break;
        }
        [str appendFormat:@"%@,",point];
    }
    
    NSLog(@"最后结果：%@",str);
    
    int timeSum = 0;
    for (int i = 0; i < T_Array.count-1; i++) {
        int m = [T_Array[i] intValue];
        int n = [T_Array[i+1] intValue];
        timeSum += rowColumnValue(m, n, a, column);
    }
    NSLog(@"总时间：%d",timeSum);
}


- (IBAction)addImageViewAction:(id)sender {

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"minInser"]];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:imageView action:@selector(removeFromSuperview)];
    [imageView addGestureRecognizer:tap];
    imageView.userInteractionEnabled = YES;
}

@end
