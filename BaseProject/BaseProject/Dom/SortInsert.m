

@interface SortInsert : NSObject
@end

@implementation SortInsert

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

MakeSourcePath

@end
