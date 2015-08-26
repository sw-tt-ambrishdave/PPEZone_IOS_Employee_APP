

#import "AppDelegate.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface AppDelegate () <MBProgressHUDDelegate>

@end

@implementation AppDelegate
@synthesize arrayProductSelect;
@synthesize navigation,window;
@synthesize isInternetOn,progressHUD;
@synthesize employee_id,showreturn;
@synthesize intScanTimer;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Utility setUserDefaultValue:@"3" forKey:UD_COMPANY_ID];
    [Utility setUserDefaultValue:@"Tyson - Amarillo" forKey:UD_COMPANY_NAME];

    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    [self checkInternetConnetion];
    
    if (APP_DELEGATE.isInternetOn == TRUE) {
        [self call_WS_ScanTimer];
    }else{
        APP_DELEGATE.intScanTimer = 5;
    }
    
    if (arrayProductSelect != nil && [arrayProductSelect count] > 0)
        [arrayProductSelect removeAllObjects];
    else
        arrayProductSelect = [[NSMutableArray alloc] init];
    
    return YES;
}
-(void)call_WS_ScanTimer
{
    if (dictParameter)
    {
        [dictParameter removeAllObjects];
    }
    else
    {
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_GET_SCANTIME];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            NSLog(@"Timer Value --- %d",[[responseObject valueForKey:@"timer"] intValue]);
            APP_DELEGATE.intScanTimer = [[responseObject valueForKey:@"timer"] intValue];
        }
        else
        {
            APP_DELEGATE.intScanTimer = 5;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error ***** %@",error);
        APP_DELEGATE.intScanTimer = 5;
    }];
}

#pragma mark - Reachability Methods


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        [self checkStatus:reachability];
        
        BOOL connectionRequired = [reachability connectionRequired];
        NSString* baseLabelText = @"";
        
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
    }
    if (reachability == self.internetReachability)
    {
        [self checkStatus:reachability];
    }
    if (reachability == self.wifiReachability)
    {
        [self checkStatus:reachability];
    }
}

-(void)checkStatus :(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...*/
            
            self.isInternetOn = FALSE;
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            self.isInternetOn = TRUE;
            
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            break;
        }
        case ReachableViaWiFi:        {
            self.isInternetOn = TRUE;
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeInternetConnection" object:nil];
}
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

#pragma mark --- User defiend Method

- (void) checkInternetConnetion{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    
    NSString *remoteHostName = @"www.apple.com";
    
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    [self updateInterfaceWithReachability:self.hostReachability];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
}
-(void)addProgressHUD : (UIViewController *)vc
{
    progressHUD = [[MBProgressHUD alloc] initWithView:APP_DELEGATE.window];
    [APP_DELEGATE.window addSubview:progressHUD];
    progressHUD.delegate = self;
    progressHUD.color = THEME_COLOR;
    [progressHUD show:YES];
    progressHUD.labelText = @"Loading...";
    progressHUD.dimBackground = YES;
}
#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [progressHUD removeFromSuperview];
    progressHUD = nil;
}
#pragma mark - Status Bar Hidden Default
- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    UIApplication  *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = 0;
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
        
    }];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}
@end
