//
//  RC4.m
//  ELong
//
//  Created by TONG YU on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RC4.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation RC4

+ (NSMutableData *)rc4:(NSMutableData *)data key:(NSString *)encrytKey
{
	unsigned char *buffer = NULL;
	CCCryptorStatus status;
	CCCryptorRef decrypt_ref;
	size_t decrypted_length = 0;
//	size_t padded_length = 0;
	
	//NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:chapterPath];
	//DLOG(@"data=%s", [data mutableBytes]);
	//DLOG(@"data=%@", data);	
	
	//DLOG(@"encrytKey=%@", encrytKey);
	NSString *strstr2 = encrytKey;
	NSMutableData *key = [[NSMutableData alloc] init];
	[key appendData:[strstr2 dataUsingEncoding:NSUTF8StringEncoding]];
	
	// CCCryptorCreate
	status = CCCryptorCreate(kCCDecrypt, kCCAlgorithmRC4, 0, [key bytes], [key length], nil, &decrypt_ref);
	
	[key release];
	
	if (status != kCCSuccess) {
		//DLOG(@"CCCryptorCreate failed");
		//return nil;
	}
	
	// CCCryptorUpdate
	size_t bufsize = CCCryptorGetOutputLength(decrypt_ref, (size_t)[data length], true);
	buffer = malloc( bufsize);
	status = CCCryptorUpdate(decrypt_ref, [data bytes], (size_t)[data length], buffer, bufsize, &decrypted_length );
	
	
	if (status != kCCSuccess) {
		//DLOG(@"CCCryptorUpdate failed");
		//return nil;
	}
	//DLOG(@"decrypted_length=%d", decrypted_length);
	
	status = CCCryptorFinal(decrypt_ref, buffer + decrypted_length, bufsize - decrypted_length, &decrypted_length );
	if (status != kCCSuccess) {
		//DLOG(@"CCCryptorFinal failed");
		//return nil;
	}
	
	CCCryptorRelease(decrypt_ref);
	
	//DLOG(@"buffer=%s", buffer);
	//DLOG(@"buffer=%@", [NSData dataWithBytesNoCopy:buffer length: bufsize]);
	
	return [NSData dataWithBytesNoCopy:buffer length: bufsize];
}

+(NSString*)HloveyRC4:(NSString*)aInput key:(NSString*)aKey
{
	
    NSMutableArray *iS = [[NSMutableArray alloc] initWithCapacity:256];
    NSMutableArray *iK = [[NSMutableArray alloc] initWithCapacity:256];
	
    for (int i= 0; i<256; i++) {
        [iS addObject:[NSNumber numberWithInt:i]];
    }
	
    int j=1;
	
    for (short i=0; i<256; i++) {
		
        UniChar c = [aKey characterAtIndex:i%aKey.length];
		
        [iK addObject:[NSNumber numberWithChar:c]];
    }
	
    j=0;
	
    for (int i=0; i<255; i++) {
        int is = [[iS objectAtIndex:i] intValue];
        UniChar ik = (UniChar)[[iK objectAtIndex:i] charValue];
		
        j = (j + is + ik)%256;
        NSNumber *temp = [iS objectAtIndex:i];
        [iS replaceObjectAtIndex:i withObject:[iS objectAtIndex:j]];
        [iS replaceObjectAtIndex:j withObject:temp];
		
    }
	
    int i=0;
    j=0;
	
    NSString *result = aInput;
	
    for (short x=0; x<[aInput length]; x++) {
        i = (i+1)%256;
		
        int is = [[iS objectAtIndex:i] intValue];
        j = (j+is)%256;
		
        int is_i = [[iS objectAtIndex:i] intValue];
        int is_j = [[iS objectAtIndex:j] intValue]; 
		
        int t = (is_i+is_j) % 256;
        int iY = [[iS objectAtIndex:t] intValue];
		
        UniChar ch = (UniChar)[aInput characterAtIndex:x];
        UniChar ch_y = ch^iY;
		
        result = [result stringByReplacingCharactersInRange:NSMakeRange(x, 1) withString:[NSString stringWithCharacters:&ch_y length:1]];
    }
	
    [iS release];
    [iK release];
	
    return result;
}

@end
