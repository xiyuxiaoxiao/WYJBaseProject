//
//  FDTemplateClassCell.h
//  BaseProject
//
//  Created by ZSXJ on 2019/9/2.
//  Copyright © 2019年 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FDTemplateClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

NS_ASSUME_NONNULL_END
