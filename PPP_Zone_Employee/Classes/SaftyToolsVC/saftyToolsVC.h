
#import <UIKit/UIKit.h>
#import "selectedCell.h"
#import "Product.h"
#import "ReportCustomCell.h"
#import "AttributesCell.h"
@interface saftyToolsVC : UIViewController<UIPopoverControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    // Interface.
    IBOutlet UIButton *btnFinish;
    IBOutlet UIButton *btnBack;
    IBOutlet UIButton *btnBackPPE;
    IBOutlet UIButton *btnHistory;
    IBOutlet UICollectionView *collectionSafty;
    IBOutlet UITableView *tblView,*tblAttributesList;
    IBOutlet UIView *viewTableContainer;
    IBOutlet UIView *ViewCollectionContainer;
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgQRView;
    IBOutlet UIView *viewSubTblContainer;
    IBOutlet UIView *viewWishlistContainer;
    IBOutlet UIView *viewAttributes;

    
    // Objects.
    NSIndexPath *selectedIndexPath;
    NSMutableArray *checkedIndexPaths;
    NSMutableArray *arraySaftyTools;
    NSMutableArray *arrayToolSelected;
    NSMutableArray *arrayIndependentAttributes;
    NSMutableDictionary *dictOfAllAttributes;
    NSString *title;
    NSMutableDictionary *dictParameter;
    
    NSMutableArray *subArraySelectedTools;
    NSString *selectedIndex;
    UITableView *tblViewReportType;
    int MainIndex;
    int selectedProductTag;
    int intSubAttributeIndex;
}
@property (nonatomic, strong) UIPopoverController *wokZonePopover;
@property (nonatomic,retain)  NSString *titleToolName;
@property (nonatomic,retain)  NSString *tagNumber;

-(IBAction)btnAttributeSelectionDoneClicked:(id)sender;
-(IBAction)btnAttributeSelectionCancleClicked:(id)sender;

-(IBAction)btnCancleClicked:(id)sender;
-(IBAction)btnDoneClicked:(id)sender;

@end
