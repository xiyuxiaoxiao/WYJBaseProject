//
//  DazViewController.h
//  Dazzle
//
//  Created by Leonhard Lichtschlag on 9/Feb/12.
//  Copyright (c) 2012 Leonhard Lichtschlag. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAEmitterLayer;

// ===============================================================================================================
@interface DazViewController : UIViewController
// ===============================================================================================================

@property (strong, nonatomic)	UIButton *likeButton;
@property (strong)						CAEmitterLayer	*heartsEmitter;

@end
