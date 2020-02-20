//
//  MessageCell.h
//  网络请求
//
//  Created by WYJ on 16/5/14.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageImageView.h"
@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet MessageImageView *messageImageView;
@end
