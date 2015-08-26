
#import "loginVC.h"

@interface loginVC ()

@end

@implementation loginVC
@synthesize scannerView;
- (void)viewDidLoad {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    isBarcodeFailed = FALSE;
    intBarcodeFailedCount = 0;
    viewUserNameContainer.hidden = YES;
//    strBarcode = @"123456"; //65833254 //1234567890 //123456
    [super viewDidLoad];
    APP_DELEGATE.currentViewController = self;
    
    [imgUserLogin setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MOC-%ld.jpeg",(long)[Utility randomValueBetween:8 and:10]]]];
    
    scannerView.layer.borderWidth = 1.0;
    scannerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    APP_DELEGATE.currentViewController = self;

    [scannerView setVerboseLogging:YES];
    [scannerView setAnimateScanner:YES];
    [scannerView setDisplayCodeOutline:YES];
    [scannerView startCaptureSession];
}
-(void) viewWillAppear:(BOOL)animated
{
    APP_DELEGATE.currentViewController = self;
}
-(void) viewDidAppear:(BOOL)animated
{
    timer = [NSTimer scheduledTimerWithTimeInterval:APP_DELEGATE.intScanTimer target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
}
-(void)timerCalled
{
    [timer invalidate];
    timer = nil;
    ++intBarcodeFailedCount;
    if (intBarcodeFailedCount == 3) {
        [timer invalidate];
        timer = nil;
        NSLog(@"Attamt Finish ---- %d",intBarcodeFailedCount);
//        [Utility displayAlertWithMessage:[NSString stringWithFormat:@"Attamt Finish ---- %d",intBarcodeFailedCount]];
        [scannerView stopScanSession];
        scannerView.hidden = YES;
        viewUserNameContainer.hidden = NO;
        isBarcodeFailed = TRUE;
        txtPassword.text = @"";
        txtEmployeeId.text = @"";
        [txtEmployeeId becomeFirstResponder];
    }else{
        NSLog(@"Attamt ---- %d",intBarcodeFailedCount);
//        [Utility displayAlertWithMessage:[NSString stringWithFormat:@"Attamt ---- %d",intBarcodeFailedCount]];
        
        UIAlertView *alertFail = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Failed to scan Barcode" delegate:self cancelButtonTitle:@"Retry" otherButtonTitles: nil];
        alertFail.tag = 1010;
        alertFail.delegate = self;
        [alertFail show];
    }
    NSLog(@"Timer Called");
    // Your Code
}
#pragma mark - RMScanner Delegate Methods
- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType {
    [timer invalidate];
    timer = nil;
    NSLog(@"Timer Called");

    intBarcodeFailedCount = 0;
    strBarcode = scannedCode;
    isBarcodeFailed = FALSE;

    if (APP_DELEGATE.isInternetOn == TRUE) {
        isBarcodeFailed = FALSE;
        [self call_WS_Login];
    }else{
        [Utility offlineMessage];
    }
}

- (void)errorGeneratingCaptureSession:(NSError *)error {
    [scannerView stopCaptureSession];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"This device does not have a camera. Run this app on an iOS device that has a camera." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alert.tag = 1000;
    [alert show];
}

- (void)errorAcquiringDeviceHardwareLock:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Tap to focus is currently unavailable. Try again in a little while." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)shouldEndSessionAfterFirstSuccessfulScan {
        return YES;
}
#pragma mark - AlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1010) {
        if (buttonIndex == 0) {
              timer = [NSTimer scheduledTimerWithTimeInterval:APP_DELEGATE.intScanTimer target:self selector:@selector(timerCalled) userInfo:nil repeats:NO];
            if (scannerView.hidden == FALSE) {
                [scannerView startScanSession];
            }
        }
    }
}
#pragma mark - Login webservice
-(void)call_WS_Login
{
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }
    else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    if (isBarcodeFailed == TRUE) {
        [dictParameter setObject:txtEmployeeId.text forKey:EMPLOYEE_ID];
    }else{
        [dictParameter setObject:strBarcode forKey:EMPLOYEE_BARCODE];
    }
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_LOGIN];
    
    [APP_DELEGATE addProgressHUD:self];
    [PPEZoneEmployee sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    [PPEZoneEmployee sharedClient].requestSerializer = [AFJSONRequestSerializer serializer];
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            [Utility sucessLoginMessage:[responseObject valueForKey:@"message"]];
            
            if ([[responseObject valueForKey:@"success"]integerValue] == 1) {
                
                APP_DELEGATE.employee_id = [NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"user"] valueForKey:@"app_user_id"]];
                APP_DELEGATE.showreturn  = [NSString stringWithFormat:@"%@",[responseObject valueForKey:@"showreturn"]];
                
                if ([[responseObject valueForKey:@"is_image"] intValue] == 0) {
                    
                    NSString *strName = [NSString stringWithFormat:@"%@ %@",[[responseObject valueForKey:@"user"] valueForKey:@"firstname"],[[responseObject valueForKey:@"user"] valueForKey:@"lastname"]];
                    [self openCapturePhotoView:[NSString stringWithFormat:@"%@",[[responseObject valueForKey:@"user"] valueForKey:@"employee_id"]] employeeName:strName];
                }else{
                    [self performSelector:@selector(dismissIndicator) withObject:nil afterDelay:1.0];
                }
            }
        }
        else
        {
            [Utility failedMessage:[responseObject valueForKey:@"message"]];
         
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      //  NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Authentication Failed"];
//        ++intBarcodeFailedCount;
//        if (intBarcodeFailedCount == 4) {
//            scannerView.hidden = YES;
//            viewUserNameContainer.hidden = NO;
//            isBarcodeFailed = TRUE;
//            txtPassword.text = @"";
//            txtEmployeeId.text = @"";
//            [txtEmployeeId becomeFirstResponder];
//        }
//        if (scannerView.hidden == FALSE) {
//            [scannerView startScanSession];
//        }
    }];
}

#pragma mark - Open Capture PhotoView
-(void) openCapturePhotoView : (NSString *) strEmployeeId employeeName : (NSString *)strName
{
  
     CapturePhotoVC *capturePhotoVC = (CapturePhotoVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"CapturePhotoVC"];
     capturePhotoVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     capturePhotoVC.strEmployeeID = strEmployeeId;
    capturePhotoVC.strEmployeeName = strName;
    capturePhotoVC.captureDelegate = self;
     UINavigationController *myNavigationController =
     [[UINavigationController alloc] initWithRootViewController:capturePhotoVC];
     [self presentViewController:myNavigationController animated:YES completion:nil];
    
}
-(void) didCaptureImageSucess
{
    [self performSelector:@selector(dismissIndicator) withObject:nil afterDelay:1.5];

}
#pragma mark - Touch Method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

#pragma mark - Back
-(IBAction)back:(id)sender
{
    [timer invalidate];
    timer = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Login
-(IBAction)login:(id)sender
{
    if (APP_DELEGATE.isInternetOn == TRUE)
    {
        [self call_WS_Login];
    }

    /* Comment just for adding popup into Tools screen
    if (isBarcodeFailed == FALSE) {
        if (![[Utility checkNullORBlankString:strBarcode] isEqualToString:@""] ) {
            if (APP_DELEGATE.isInternetOn == TRUE)
            {
                if (isBarcodeFailed == TRUE) {
                    if (![[Utility checkNullORBlankString:txtEmployeeId.text] isEqualToString:@""]){
                        [self call_WS_Login];
                    }else{
                        [Utility displayAlertWithMessage:@"Please enter Employee ID"];
                    }
                }
            }
            else{
                [Utility offlineMessage];
            }
        }else{
            [Utility displayAlertWithMessage:@"Please scan barcode"];
        }
    }else{
        if (APP_DELEGATE.isInternetOn == TRUE)
        {
            if (![[Utility checkNullORBlankString:txtEmployeeId.text] isEqualToString:@""]){
                [self call_WS_Login];
            }else{
                [Utility displayAlertWithMessage:@"Please enter Employee ID"];
            }
        }
        else{
            [Utility offlineMessage];
        }
    }
   */
}

-(void)dismissIndicator
{
    [timer invalidate];
    timer = nil;

    [APP_DELEGATE.progressHUD hide:YES];
    [self performSegueWithIdentifier:@"personSegue" sender:self];
}


#pragma mark - TextView Delegate Method
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void) myKeyboardWillHideHandler:(NSNotification *)notification {
    [txtEmployeeId resignFirstResponder];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == txtEmployeeId || textField == txtPassword)
    {
        int length = (int)[textField.text length] ;
        if (length >= MAX_LENGTH && ![string isEqualToString:@""])
        {
            textField.text = [textField.text substringToIndex:MAX_LENGTH];
            return NO;
        }
        else if([[textField text] length] == 0)
        {
            if([string isEqualToString:@" "])
            {
                return NO;
            }
        }
    }
    return YES;
}


- (void) animateTextField: (UITextField*)textField up: (BOOL) up
{
    if (textField==txtEmployeeId)
    {
        const int movementDistance = 200;
        const float movementDuration = 0.3f;
        int movement = (up ? -movementDistance : movementDistance);
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        loginView.frame = CGRectOffset(loginView.frame, 0, movement);
        [UIView commitAnimations];
    }
}

#pragma mark - Status Bar Hidden Default
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
