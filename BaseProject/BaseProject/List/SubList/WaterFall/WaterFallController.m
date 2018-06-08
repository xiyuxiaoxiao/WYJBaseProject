//
//  ViewController.m
//  瀑布流
//
//  Created by WYJ on 16/4/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import "WaterFallController.h"
#import "CollectionViewCell.h"


#import "CustomLayout.h"
#define screenHeight [[UIScreen mainScreen]bounds].size.height //屏幕高度
#define screenWidth [[UIScreen mainScreen]bounds].size.width   //屏幕宽度
#define colletionCell 3  //设置具体几列

#define TopView1_Height 60
#define TopView2_Height 30

@interface WaterFallController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *collectionView;
    
    NSMutableArray *dataArray;
    NSMutableArray  *hArr; //记录每个cell的高度/ 数据源
    
}

@property (nonatomic, strong)   UIView *topView1;
@property (nonatomic, strong)   UIView *topView2;

@property (strong, nonatomic) CustomLayout *customeLayout;
@property (nonatomic) NSInteger cellColumn;
@property (nonatomic) CGFloat cellMargin;
@property (nonatomic) CGFloat cellMinHeight;
@property (nonatomic) CGFloat cellMaxHeight;

@property (nonatomic, strong)   NSLayoutConstraint *topViewHeight;

@end

@implementation WaterFallController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellColumn = 3;
    _cellMargin = 8;
    _cellMinHeight = 50;
    _cellMaxHeight = 200;
    
    
    dataArray = [[NSMutableArray alloc] init];
    hArr = [[NSMutableArray alloc] init];
    
    
    [hArr addObject:@"100"];
    [hArr addObject:@"500"];
    [hArr addObject:@"150"];
    [hArr addObject:@"100"];
    [hArr addObject:@"100"];
    [hArr addObject:@"100"];
    [hArr addObject:@"300"];
    [hArr addObject:@"300"];
    
    [hArr addObject:@"100"];
    [hArr addObject:@"400"];
    [hArr addObject:@"300"];
    
    [hArr addObject:@"230"];
    [hArr addObject:@"300"];
    [hArr addObject:@"370"];
    
    
    for (int i = 0; i < hArr.count; i ++) {
        [dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _customeLayout = [[CustomLayout alloc] init];
    
    
    _customeLayout.column = 3;
    _customeLayout.rowSpacing = 8;
    _customeLayout.columnSpacing = 8;
    _customeLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    [_customeLayout calctueCellHeightWithBlock:^CGFloat(NSIndexPath *index) {
        // block的定义
        
        CGFloat height = 0;
        
        height = [hArr[index.row] floatValue];
        return height;
    }];
    //    _customeLayout.layoutDelegate = self;
    
//    collectionView=[[UICollectionView alloc] init];
    
    collectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_customeLayout];
    
    collectionView.contentInset = UIEdgeInsetsMake(TopView1_Height+TopView2_Height, 0, 0, 0);
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [self.view addSubview:collectionView];
    
    
    self.topView1 = [[UIView alloc] init];
    self.topView1.backgroundColor = [UIColor redColor];
    
    self.topView2 = [[UIView alloc] init];
    self.topView2.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.topView1];
    [self.view addSubview:self.topView2];
    
// collcection 设置为全屏大小 然后设置偏移量 将topview1，2设置在collection的前面
    [self addLayout];
}


#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CollectionViewCell";
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.botlabel.text = dataArray[indexPath.row];
    
    cell.backgroundColor = [UIColor redColor];
    [cell resetLabelFrame];
    
    return cell;
}



#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [dataArray removeObjectAtIndex:indexPath.row];
    [hArr removeObjectAtIndex:indexPath.row];
    
    [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    // [collectionView reloadData];
    
}



//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark - 滑动的时候 隐藏topView (主要是 如何布局 没有将三个view一次高度排列布局 )

/*  
        collcection 设置为全屏大小 然后设置偏移量 将topview1，2设置在collection的前面
 
  小于和大于的时候 设置的0 和 60 不能取消  
 如果取消了，慢慢滑动 没问题 ，但是快速滑动 就会造成不对
 
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (collectionView == scrollView) {
        CGFloat yOffset = collectionView.contentOffset.y;
        
        // 向下滑动 偏移量 y 为 负数 ；向上为正
        
//        if (yOffset >= -30) {
//            self.topViewHeight.constant = 0;
//        }
//        else if (yOffset <= -30 && yOffset >= -90){
//            self.topViewHeight.constant = -1*yOffset - 30;
//        }else if (yOffset < -90) {
//            self.topViewHeight.constant = 60;
//        }
        
        
        // 偏移量 顶值
        if (yOffset + TopView2_Height >= 0) {
            self.topViewHeight.constant = 0;
        }
        
        // 偏移量 底值
        else if (yOffset + TopView2_Height + TopView1_Height <= 0) {
            self.topViewHeight.constant = TopView1_Height;
        }
        
        // 中间
        else {
            self.topViewHeight.constant = -1*yOffset - TopView2_Height;
        }
    }
}


#pragma mark - 添加约束
- (void)addLayout {
    [self addLayoutCollectionView:collectionView];
    [self addLayoutTopView1:self.topView1];
    [self addLayoutTopView2:self.topView2];
}

- (void)addLayoutTopView1:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setConstraint_Left_Trail:view];
    
    // 添加 height 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:TopView1_Height];
    [view addConstraint:heightConstraint];
    
    self.topViewHeight = heightConstraint;
    
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:topConstraint];
}

- (void)addLayoutTopView2:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setConstraint_Left_Trail:view];
    
    // 添加 height 约束
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:TopView2_Height];
    [view addConstraint:heightConstraint];
    
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:topConstraint];
}


- (void)addLayoutCollectionView:(UIView *)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setConstraint_Left_Trail:view];
    
    // 添加 bottom 约束
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self.view addConstraint:bottomConstraint];
    
    // 添加 top 约束
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    [self.view addConstraint:topConstraint];
}

- (void)setConstraint_Left_Trail:(UIView *)item {
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    [self.view addConstraint:trailingConstraint];
    
    // 添加 left 约束
    NSLayoutConstraint *left_Constraint = [NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [self.view addConstraint:left_Constraint];
}

@end
