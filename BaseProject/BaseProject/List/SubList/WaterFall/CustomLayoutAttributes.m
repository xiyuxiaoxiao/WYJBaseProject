//
//  CustomLayoutAttributes.m
//  瀑布流
//
//  Created by WYJ on 16/4/11.
//  Copyright © 2016年 ShouXinTeam. All rights reserved.
//

#import "CustomLayoutAttributes.h"

@implementation CustomLayoutAttributes

-(id)copyWithZone:(NSZone *)zone
{
    CustomLayoutAttributes *copy = (CustomLayoutAttributes *)[super copyWithZone:zone];
    copy.cellHeight = _cellHeight;
    
    return copy;
}

@end
