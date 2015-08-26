

#import <UIKit/UIKit.h>


@interface saftyCollectionCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UILabel *lblsafty;
@property (nonatomic,strong) IBOutlet UIImageView *imgSafty;
@property (nonatomic, strong) IBOutlet UIImageView *imgIssuedProduct;
@property (nonatomic,retain) IBOutlet UIButton *btnCenterPrint;
@property (nonatomic,retain) IBOutlet UIButton *btnPrint;
@property (nonatomic,retain) IBOutlet UITextField *txtSelection;
@property (nonatomic,retain) IBOutlet UIButton *btnSelection;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;


@end
