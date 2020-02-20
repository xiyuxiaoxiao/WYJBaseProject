//
//  RC4.h
//  ELong
//
//  Created by TONG YU on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RC4 : NSObject {
	
}

+ (NSMutableData *)rc4:(NSMutableData *)data key:(NSString *)encrytKey;

+(NSString*)HloveyRC4:(NSString*)aInput key:(NSString*)aKey;

@end