

#import <UIKit/UIKit.h>
#import "ReportCustomCell.h"
#import "ReportsTableHeaderView.h"
#import "ReturnItem.h"

@interface ReturnItemsVC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    IBOutlet UITableView *tblReturnProducts;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgEmpProfile;
    IBOutlet UILabel *lblEmpName,*lblEmpID;
    
    ReportsTableHeaderView *viewTableHeader;
    NSInteger indexOfTable;
    NSMutableArray *arrayReturnList;
    NSMutableDictionary *dictParameter;

}
@property (nonatomic, strong) UIPopoverController *notesPopover;

-(IBAction)btnBack:(id)sender;

@end
