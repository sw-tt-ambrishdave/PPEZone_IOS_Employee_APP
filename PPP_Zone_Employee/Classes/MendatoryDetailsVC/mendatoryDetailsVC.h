
#import <UIKit/UIKit.h>
#import "Employee.h"
@interface mendatoryDetailsVC : UIViewController<UIPopoverControllerDelegate,UITableViewDelegate,UITableViewDataSource,RMScannerViewDelegate>
{
    // Interface.
    
    IBOutlet UITextField *txtFirstName;
    IBOutlet UITextField *txtLastName;
    IBOutlet UITextField *txtEmployeeId;
    IBOutlet UITextField *txtWorkZone;
    IBOutlet UITextField *txtPassword;
    IBOutlet UITextField *txtConfirmPassword;
    IBOutlet UIButton *bntWorkZone;

    // Objects.
    UITableView *tblViewReportType;
    UITextField *mainText;
    UIBarButtonItem *btnBarPrev;
    UIBarButtonItem *btnBarNext;
    NSMutableArray *arrayOfJobZone;
    NSMutableDictionary *dictParameter;
    NSString *strBarcode;
    BOOL isSaveClose;
    BOOL isEditField;
    NSInteger checkedIndex;
}
@property (strong, nonatomic) IBOutlet RMScannerView *scannerView;

@property (nonatomic, strong) Employee *objEmployee;
@property (nonatomic, strong) UIPopoverController *wokZonePopover;
@property (nonatomic,retain) UITextField *mainText;

@end
