
#import "CapturePhotoVC.h"

@interface CapturePhotoVC ()

@end

@implementation CapturePhotoVC
@synthesize strEmployeeID;
@synthesize strEmployeeName;
@synthesize captureDelegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    imgProfile.layer.borderColor = [UIColor lightGrayColor].CGColor;
    imgProfile.layer.borderWidth = 1.0;
    lblEmployeeID.text = strEmployeeID;
    lblEmployeeName.text = strEmployeeName;
    SETCORNER(imgProfile, 5.0);
    // Do any additional setup after loading the view.
}
-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
-(IBAction)btnUploadClicked:(id)sender
{
    if (APP_DELEGATE.isInternetOn == TRUE) {
        
        if ([self compareImage:imgProfile.image isEqualTo:[UIImage imageNamed:@"profile_dummy.png"]] == FALSE) {
            [self call_WS_UploadImage];
        }
    }else{
        [Utility offlineMessage];
    }
}
-(IBAction)btnDismissClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(IBAction)btnTakePictureClicked:(id)sender
{
    [self showCamera];
}
- (BOOL)compareImage:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}
-(void)showCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerController.delegate = self;
        pickerController.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        [self presentViewController:pickerController animated:YES completion:^{}];
    }
    
}
#pragma mark
#pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    imageOfParticipant = image;
    UIImage *oldImage = image;
    
    switch (oldImage.imageOrientation) {
        case UIImageOrientationUp:
            newOrientation = UIImageOrientationUp;
            break;
        case UIImageOrientationDown:
            newOrientation = UIImageOrientationDown;
            break;
        case UIImageOrientationLeft:
            newOrientation = UIImageOrientationLeft;
            break;
        case UIImageOrientationRight:
            newOrientation = UIImageOrientationRight;
            break;
        default:
            break;
            // you can also handle mirrored orientations similarly ...
    }
    UIImage *rotatedImage = [UIImage imageWithCGImage:oldImage.CGImage scale:1.0f orientation:newOrientation];
    rotatedImage = [Utility scaleToSize:rotatedImage.size imageToResize:rotatedImage];
    imageOfParticipant = rotatedImage;
    [imgProfile setImage:rotatedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Login webservice
-(void)call_WS_UploadImage
{
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }
    else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:strEmployeeID forKey:EMPLOYEE_ID];
    [dictParameter setObject: APP_DELEGATE.employee_id forKey:@"user_id"];

    NSData *imageData = UIImageJPEGRepresentation(imgProfile.image, 0.5); //1.0
    NSString *profileImageString = [MF_Base64Codec base64StringFromData:imageData];
    [dictParameter setObject:profileImageString forKey:EMPLOYEE_IMAGE];

    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_ASSIGN_EMPLOYEE_IMAGE];
    
    [APP_DELEGATE addProgressHUD:self];
    [PPEZoneEmployee sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    [PPEZoneEmployee sharedClient].responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"application/json",nil];
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            [Utility sucessLoginMessage:[responseObject valueForKey:@"message"]];
            
            if ([[responseObject valueForKey:@"success"]integerValue] == 1) {
                [self dismissViewControllerAnimated:YES completion:nil];
                [captureDelegate didCaptureImageSucess];
            }
        }
        else
        {
            [Utility failedMessage:@"Failed to upload Profile Image"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to upload Profile Image"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
