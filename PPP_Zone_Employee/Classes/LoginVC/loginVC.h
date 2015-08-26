
#import <UIKit/UIKit.h>

@interface loginVC : UIViewController<RMScannerViewDelegate,CaptureProfileDelegate>
{
    // Interface.
    IBOutlet UIButton *btnLogin;
    IBOutlet UITextField *txtEmployeeId;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btnBack;
    IBOutlet UIView *loginView;
    IBOutlet UIImageView *imgUserLogin;
    IBOutlet UIView *viewUserNameContainer;
    
    // Objects.
    NSMutableDictionary *dictParameter;
    NSString *strBarcode;
    BOOL isBarcodeFailed;
    int intBarcodeFailedCount;
    NSTimer *timer;
}
@property (strong, nonatomic) IBOutlet RMScannerView *scannerView;

@end
