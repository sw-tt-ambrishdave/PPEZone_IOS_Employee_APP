

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Utility : NSObject
+(void)setControllersHeaderColor :(UIViewController *)controller color:(UIColor *)selectedModeTheme;
//+(UIBarButtonItem*)createLeftBarButtonWithDelegate:(id)delegate2;
+(NSString *)convertDateToDay : (NSDate *)date;
+(NSString *)convertDateToFormattedString : (NSDate *)date;
+(NSString *)convertCurrentDate : (NSDate *)date;
+(void)displayAlertWithMessage:(NSString*)strMsg;
+(NSString *)statusOfBoolValue:(BOOL)value;
#pragma mark - UserDefault Methods
+(id)getUserDefaultValueForKey:(NSString*)key;
+(BOOL)getUserDefaultBOOLForKey:(NSString*)key;
+(void)setUserDefaultValue:(id)value forKey:(NSString*)key;
+(void)setUserDefaultBool:(BOOL)value forKey:(NSString*)key;
+(void)deleteUserDefaultValue:(NSString*)key;
+ (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max;
+(void) offlineMessage;
+(void) sucessMessage : (NSString *)message;
+(void) sucessLoginMessage : (NSString *)message;
+(void) failedMessage : (NSString *)message;
+(UIImage *) scaleToSize: (CGSize)size imageToResize:(UIImage *)imageToResize;
+(NSString*)checkNullORBlankString:(NSString*)string;
+(void)createShadowWithFrame:(UIImageView *)viewsub;
@end
