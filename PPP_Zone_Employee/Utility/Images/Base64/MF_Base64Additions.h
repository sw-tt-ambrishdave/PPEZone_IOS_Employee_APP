

#import <Foundation/Foundation.h>

@interface NSString (Base64Addition)
+(NSString *)stringFromBase64String:(NSString *)base64String;
-(NSString *)base64String;
@end

@interface NSData (Base64Addition)
+(NSData *)dataWithBase64String:(NSString *)base64String;
-(NSString *)base64String;
@end

@interface MF_Base64Codec : NSObject 
+(NSData *)dataFromBase64String:(NSString *)base64String;
+(NSString *)base64StringFromData:(NSData *)data;
@end
