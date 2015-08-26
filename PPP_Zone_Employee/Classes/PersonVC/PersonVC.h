
#import <UIKit/UIKit.h>
#import "selectedCell.h"

@interface PersonVC : UIViewController<UIAlertViewDelegate>
{
    // Interface.
    IBOutlet UIButton *btnFinish;
    IBOutlet UIButton *btnHistory;
    IBOutlet UIButton *btnHead;
    IBOutlet UIButton *bntChest;
    IBOutlet UIButton *btnHandLeft;
    IBOutlet UIButton *btnHandRight;
    IBOutlet UIButton *btnLegs;
    IBOutlet UIButton *btnFoot;
    IBOutlet UIButton *btnWishList;
    
    IBOutlet UIView *pppManView;
    IBOutlet UITableView *tblView,*tblViewFinal;
    IBOutlet UIView *viewTableContainer;
    IBOutlet UIView *viewSubTblContainer;
    IBOutlet UIView *viewWishlistContainer;
    IBOutlet UIButton *btnReturnInventory;
    
    // Objects.
    NSIndexPath *selectedIndexPath;
    NSMutableArray *arrayToolSelected;
    NSInteger tagCheck;
    NSMutableDictionary *dictParameter;
    NSMutableArray *arrayWishListProducts;
}
@property (nonatomic ,retain) IBOutlet selectedCell *cellObj;

-(IBAction)btnCancleClicked:(id)sender;
-(IBAction)btnDoneClicked:(id)sender;
-(IBAction)btnWishListClicked:(id)sender;

//-(IBAction)<#selector#>:(id)sender)
@end
