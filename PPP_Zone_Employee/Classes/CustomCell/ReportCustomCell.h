

#import <UIKit/UIKit.h>

@interface ReportCustomCell : UITableViewCell
@property (nonatomic, strong)IBOutlet UILabel *lblSep1,*lblJobZone;
@property (nonatomic, strong) IBOutlet UILabel *lblEmpName,*lblEmpID,*lblProductName,*lblProductID,*lblInTime,*lblOutTime;

@property (nonatomic, strong) IBOutlet UILabel *lblDate,*lblStockInHand;
@property (nonatomic, strong) IBOutlet UIButton *btnNotes;

@property (nonatomic, strong) IBOutlet UIImageView *imgProduct,*imgEmployee;
@property (nonatomic, strong) IBOutlet UIButton *btnReturn;
@property (nonatomic, strong) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) IBOutlet UILabel *lblAttributeName;
@end
