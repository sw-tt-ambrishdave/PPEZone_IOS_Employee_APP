
#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ReportCustomCell.h"
#import "ReportsTableHeaderView.h"
#import "Employee.h"
#import "mendatoryDetailsVC.h"
@interface ViewController : UIViewController < UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    // Interface.
    IBOutlet UIView *searchView;
    IBOutlet UIButton *btnClose;
    IBOutlet UIButton *btnSearchEmployee;
    IBOutlet UITextField *txtSearchEmployee;
    
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSearch;
    IBOutlet UIButton *btnEnroll;
    
    IBOutlet UITableView *tblEmployeeList;
    // Objects.
    ReportsTableHeaderView *viewTableHeader;
    NSMutableArray *arrayOfEmployee;
    NSMutableDictionary *dictParameter;
    Employee *objEmployee;
    BOOL isNewRegistration;
}

/*
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;

- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;*/

@end

