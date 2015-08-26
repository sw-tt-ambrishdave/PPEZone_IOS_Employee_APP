

#import "Utility.h"

@implementation Utility

+(void)setControllersHeaderColor :(UIViewController *)controller color:(UIColor *)selectedModeTheme {
    
    controller.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    controller.navigationController.navigationBar.translucent = NO;
    //    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 768, 88)];
    
    
    
    //    controller.navigationController.navigationBar = navBar;
    if([controller.navigationController.navigationBar respondsToSelector:@selector(barTintColor)])
    {
        // iOS7
        controller.navigationController.navigationBar.barTintColor = selectedModeTheme;
    }
    else
    {
        // older
        controller.navigationController.navigationBar.tintColor = selectedModeTheme;
    }

    NSDictionary *normalAttributes;
  
        normalAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                            [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:23.0], NSFontAttributeName,  [UIColor whiteColor],NSForegroundColorAttributeName,
                            [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
  
    [controller.navigationController.navigationBar setTitleTextAttributes:normalAttributes];
}
+(NSString *)statusOfBoolValue:(BOOL)value
{
    NSString *status = value ? @"True": @"False";
    return status;
}
+(void)displayAlertWithMessage:(NSString*)strMsg
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"PPE Zone" message:[NSString stringWithFormat:@"\n%@",strMsg] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"OK") otherButtonTitles:nil, nil];
    [alert show];
}
+(NSString *)convertDateToDay : (NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:date];
        NSInteger year = [components year];
    //    NSInteger month=[components month];       // if necessary
    NSInteger day = [components day];
    //    NSInteger weekday = [components weekday]; // if necessary
    
    NSDateFormatter *weekDay = [[NSDateFormatter alloc] init];
    [weekDay setDateFormat:@"EEEE"];
    
    NSDateFormatter *calMonth = [[NSDateFormatter alloc] init];
    [calMonth setDateFormat:@"MMMM"];

    NSString *strFinal = [NSString stringWithFormat:@"%@ %li, %ld",[calMonth stringFromDate:date],(long)day,(long)year];
    
    return strFinal;
}
+(NSString *)convertCurrentDate : (NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}
+(NSString *)convertDateToFormattedString : (NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSString *currentDate = [dateFormatter stringFromDate:date];
    return currentDate;
}
#pragma mark --- UserDefault Methods
+(id)getUserDefaultValueForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+(BOOL)getUserDefaultBOOLForKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


+(void)setUserDefaultValue:(id)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setUserDefaultBool:(BOOL)value forKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(void)deleteUserDefaultValue:(NSString*)key
{
    NSUserDefaults * removeUD = [NSUserDefaults standardUserDefaults];
    [removeUD removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize ];
}
+ (NSInteger)randomValueBetween:(NSInteger)min and:(NSInteger)max {
    return (NSInteger)(min + arc4random_uniform(max - min + 1));
}
#pragma mark - MBProgressHUD Message Methods
+(void) offlineMessage
{
    [APP_DELEGATE addProgressHUD:self];
    APP_DELEGATE.progressHUD.mode = MBProgressHUDModeText;
    APP_DELEGATE.progressHUD.labelText = INTERNET_CONNECTIVITY_STATUS;
    [APP_DELEGATE.progressHUD show:YES];
    [APP_DELEGATE.progressHUD hide:YES afterDelay:2.0];
}
+(void) sucessMessage : (NSString *)message
{
    APP_DELEGATE.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    APP_DELEGATE.progressHUD.mode = MBProgressHUDModeCustomView;
    APP_DELEGATE.progressHUD.labelText = message;
    [APP_DELEGATE.progressHUD show:YES];
    [APP_DELEGATE.progressHUD hide:YES afterDelay:2.0];
}
+(void) sucessLoginMessage : (NSString *)message
{
    APP_DELEGATE.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    APP_DELEGATE.progressHUD.mode = MBProgressHUDModeCustomView;
    APP_DELEGATE.progressHUD.labelText = message;
    [APP_DELEGATE.progressHUD show:YES];
    [APP_DELEGATE.progressHUD hide:YES afterDelay:1.0];
}
+(void) failedMessage : (NSString *)message
{
    APP_DELEGATE.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Cross.png"]];
    APP_DELEGATE.progressHUD.mode = MBProgressHUDModeCustomView;
    APP_DELEGATE.progressHUD.labelText = message;
    [APP_DELEGATE.progressHUD show:YES];
    [APP_DELEGATE.progressHUD hide:YES afterDelay:2.0];
}

+(UIImage *) scaleToSize: (CGSize)size imageToResize:(UIImage *)imageToResize
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(imageToResize.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), imageToResize.CGImage);
    } else if (imageToResize.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM(context, M_PI_2);
        CGContextTranslateCTM(context, 0.0f, -size.width);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), imageToResize.CGImage);
    } else if (imageToResize.imageOrientation == UIImageOrientationDown) {
        CGContextRotateCTM(context, M_PI);
        CGContextTranslateCTM(context, -size.width, -size.height);
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageToResize.CGImage);
    } else {
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageToResize.CGImage);
    }
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    
    CGImageRelease(scaledImage);
    
    return image;
}
+(NSString*)checkNullORBlankString:(NSString*)string
{
    if([string isEqual: [NSNull null]] || [string isEqualToString:@"null"] || [string isEqualToString:@"(null)"] || [string isEqualToString:@""] || [string isEqualToString:@"0"])
        return @"";
    
    if(string != nil &&  string.length >0)
        return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return @"";
}
+(void)createShadowWithFrame:(UIImageView *)viewsub
{
    CALayer *layer = viewsub.layer;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    //    layer.shadowRadius = 5.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
}
@end
