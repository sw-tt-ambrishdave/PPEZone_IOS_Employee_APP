

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableDictionary *dictParameter;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) UINavigationController *navigation;
@property (nonatomic, retain) UIViewController* currentViewController;

@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@property (nonatomic, strong) NSMutableArray *arrayProductSelect;

@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, assign) BOOL isInternetOn;
@property (nonatomic,retain) NSString *employee_id;
@property (nonatomic,retain) NSString *showreturn;
@property (nonatomic, assign) int intScanTimer;

-(void)addProgressHUD : (id)vc;

@end

