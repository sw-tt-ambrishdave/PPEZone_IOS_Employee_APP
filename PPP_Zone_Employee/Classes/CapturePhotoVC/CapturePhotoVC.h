
#import <UIKit/UIKit.h>

@protocol CaptureProfileDelegate
-(void) didCaptureImageSucess;
@end
@interface CapturePhotoVC : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    IBOutlet UIButton *btnDismiss;
    IBOutlet UIImageView *imgProfile;
    IBOutlet UILabel *lblEmployeeID;
    IBOutlet UILabel *lblEmployeeName;
    
    UIImageOrientation newOrientation;
    UIImage *imageOfParticipant;
    NSMutableDictionary *dictParameter;

}
@property (nonatomic,strong) id<CaptureProfileDelegate> captureDelegate;
@property (nonatomic, strong) NSString *strEmployeeID;
@property (nonatomic, strong) NSString *strEmployeeName;
-(IBAction)btnUploadClicked:(id)sender;
-(IBAction)btnTakePictureClicked:(id)sender;
-(IBAction)btnDismissClicked:(id)sender;

@end
