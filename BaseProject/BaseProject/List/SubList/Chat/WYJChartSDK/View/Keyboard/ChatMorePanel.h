//
//  ChatMorePanel.h
//  BaseProject
//
//  Created by ZSXJ on 2020/2/21.
//  Copyright © 2020 WYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMoreItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatMorePanel : UIView
@property (nonatomic, copy)  void(^itemTap)(ChatMoreItem *moreItem);
@end


@interface ChatMoreItemView : UIView
@end

NS_ASSUME_NONNULL_END
