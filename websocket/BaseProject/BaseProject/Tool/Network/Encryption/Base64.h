//
//  Base64.h
//  TaobaoShow
//
//  Created by yutong on 13-7-31.
//
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject {
	
}

+ (NSString *)base64EncodeString:(NSString *)strData;
+ (NSString *)base64EncodeData:(NSData *)objData;
+ (NSData *)base64DecodeString:(NSString *)strBase64;

// New
+ (NSString *)base64EncodedStringFromData:(NSData *)data;
@end
