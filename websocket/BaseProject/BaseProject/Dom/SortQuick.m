

#import <Foundation/Foundation.h>
@interface SortQuick : NSObject

@end

@implementation SortQuick

#pragma 快速排序 需要先用html拖进来  在该为text
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

-(void)swapWith: (int *)array inde:(int)index1 toIndex:(int)index2 {
    int temp = array[index1];
    array[index1] = array[index2];
    array[index2] = temp;
}

MakeSourcePath

@end
