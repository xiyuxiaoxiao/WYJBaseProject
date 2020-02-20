#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>





@interface AnimationEffect : NSObject





/**
 
 *  push/pop转场动画封装
 
 *
 
 *  @param type           动画类型
 
 *  @param subType        动画子类型
 
 *  @param duration       动画时间
 
 *  @param timingFunction 动画定时函数属性
 
 *  @param theView        self.view  当前控制器视图
 
 *
 
 *  @return 返回一个动画
 
 */



+ (CATransition *)showAnimationType:(NSString *)type

                        withSubType:(NSString *)subType

                           duration:(CFTimeInterval)duration

                     timingFunction:(NSString *)timingFunction

                               view:(UIView *)theView;







@end
