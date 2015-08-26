
#import "mendatoryDetailsVC.h"

@interface mendatoryDetailsVC ()

@end

@implementation mendatoryDetailsVC
#pragma mark - Synthesize Variables
@synthesize wokZonePopover,mainText;
@synthesize objEmployee,scannerView;
#pragma mark - Viewcontroller Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    APP_DELEGATE.currentViewController = self;
    checkedIndex = 1234566;
    txtWorkZone.userInteractionEnabled = NO;
    isEditField = NO;
    if (objEmployee != nil) {
        isEditField = YES;
        txtFirstName.text = objEmployee.strEmpFirstName;
        txtLastName.text = objEmployee.strEmpLastName;
        txtEmployeeId.text = objEmployee.strEmpID;
        txtWorkZone.text = objEmployee.strJobZoneName;
        txtWorkZone.accessibilityLabel = [NSString stringWithFormat:@"%d",objEmployee.intEmpJobZoneID];
        txtEmployeeId.enabled = FALSE;
        txtEmployeeId.textColor = [UIColor lightGrayColor];
        strBarcode = objEmployee.strBarcode;
    }
    else
    {
        isEditField = NO;
    }
    scannerView.layer.borderWidth = 1.0;
    scannerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    APP_DELEGATE.currentViewController = self;

    [scannerView setVerboseLogging:YES];
    [scannerView setAnimateScanner:YES];
    [scannerView setDisplayCodeOutline:YES];
    [scannerView startCaptureSession];

    
    if (APP_DELEGATE.isInternetOn == TRUE)
        [self call_WS_JobZone];
    else
        [Utility offlineMessage];
}
#pragma mark - RMScanner Delegate Methods
- (void)didScanCode:(NSString *)scannedCode onCodeType:(NSString *)codeType {
    
    strBarcode = scannedCode;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:scannedCode delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    [alert show];
}

- (void)errorGeneratingCaptureSession:(NSError *)error {
    [scannerView stopCaptureSession];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"This device does not have a camera. Run this app on an iOS device that has a camera." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}

- (void)errorAcquiringDeviceHardwareLock:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Tap to focus is currently unavailable. Try again in a little while." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

- (BOOL)shouldEndSessionAfterFirstSuccessfulScan {
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag != 1000) {
       if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Okay"])
        {
            [scannerView startScanSession];
        }
    }
}

#pragma mark - User Defined methods
-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)navigateToHomeScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)workZoneSelected:(id)sender
{
    [self resignKeyboard];
    UIViewController *VC_callStatusChg = [[UIViewController alloc] init];
    tblViewReportType = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 450, 200) style:UITableViewStylePlain];
    tblViewReportType.delegate = self;
    tblViewReportType.dataSource = self;
    tblViewReportType.tag = 101;
    tblViewReportType.backgroundColor = [UIColor clearColor];
    tblViewReportType.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblViewReportType.scrollEnabled = YES;
    tblViewReportType.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [VC_callStatusChg.view addSubview:tblViewReportType];
    VC_callStatusChg.preferredContentSize = CGSizeMake(450,200);
    
    wokZonePopover = [[UIPopoverController alloc] initWithContentViewController:VC_callStatusChg];
    wokZonePopover.delegate=self;
    [wokZonePopover setPopoverContentSize:CGSizeMake(450, 200) animated:NO];
    [wokZonePopover presentPopoverFromRect:bntWorkZone.bounds inView:bntWorkZone permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
#pragma mark ------ Save & Continue
-(IBAction)SaveAndContinue:(id)sender
{
    [self.view endEditing:YES];
    
    if (APP_DELEGATE.isInternetOn == TRUE)
    {
        isSaveClose = NO;
        
        NSString *strMsg;
        if ([txtFirstName.text isEqualToString:@""])
        {
            strMsg = @"Please enter your first name.";
            [txtFirstName becomeFirstResponder];
        }
        else if ([txtLastName.text isEqualToString:@""])
        {
            strMsg = @"Please enter your last name.";
            [txtLastName becomeFirstResponder];
        }
        else if ([txtEmployeeId.text isEqualToString:@""])
        {
            strMsg = @"Please enter your employee ID.";
            [txtEmployeeId becomeFirstResponder];
        }
        else if ([txtWorkZone.text isEqualToString:@""])
        {
            strMsg = @"Please select your Job Zone.";
            [txtEmployeeId resignFirstResponder];
            [txtFirstName resignFirstResponder];
            [txtLastName resignFirstResponder];
            [self workZoneSelected:self];
        }
        else if ([[Utility checkNullORBlankString:strBarcode] isEqualToString:@""])
        {
            strMsg = @"Please Scan barcode.";
            [txtEmployeeId resignFirstResponder];
            [txtFirstName resignFirstResponder];
            [txtLastName resignFirstResponder];
            [scannerView startScanSession];
        }
        else if (isEditField == NO) {
        }
        
        if(strMsg.length > 0)
        {
            [APP_DELEGATE addProgressHUD:self];
            APP_DELEGATE.progressHUD.mode = MBProgressHUDModeText;
            APP_DELEGATE.progressHUD.labelText = strMsg;
            [APP_DELEGATE.progressHUD show:YES];
            [APP_DELEGATE.progressHUD hide:YES afterDelay:2.0];
            return;
        }
        [self call_WS_Employee_Registration];
    }
    else
    {
        [Utility offlineMessage];
    }
}

#pragma mark ------ Save & Close
-(IBAction)SaveAndClose:(id)sender
{
    isSaveClose = YES;
    
     [self.view endEditing:YES];
    
    if (APP_DELEGATE.isInternetOn == TRUE)
    {
        NSString *strMsg;
        if ([txtFirstName.text isEqualToString:@""])
        {
            strMsg = @"Please enter your first name.";
            [txtFirstName becomeFirstResponder];
        }
        else if ([txtLastName.text isEqualToString:@""])
        {
            strMsg = @"Please enter your last name.";
            [txtLastName becomeFirstResponder];
        }
        else if ([txtEmployeeId.text isEqualToString:@""])
        {
            strMsg = @"Please enter your employee ID.";
            [txtEmployeeId becomeFirstResponder];
        }
        else if ([txtWorkZone.text isEqualToString:@""])
        {
            strMsg = @"Please select your Job Zone.";
            [txtEmployeeId resignFirstResponder];
            [txtFirstName resignFirstResponder];
            [txtLastName resignFirstResponder];
            [self workZoneSelected:self];
        }
        else if ([[Utility checkNullORBlankString:strBarcode] isEqualToString:@""])
        {
            strMsg = @"Please Scan barcode.";
            [txtEmployeeId resignFirstResponder];
            [txtFirstName resignFirstResponder];
            [txtLastName resignFirstResponder];
        }
        else if (isEditField == NO) {

        }
        if(strMsg.length > 0)
        {
            [APP_DELEGATE addProgressHUD:self];
            APP_DELEGATE.progressHUD.mode = MBProgressHUDModeText;
            APP_DELEGATE.progressHUD.labelText = strMsg;
            [APP_DELEGATE.progressHUD show:YES];
            [APP_DELEGATE.progressHUD hide:YES afterDelay:2.0];
            return;
        }
        [self call_WS_Employee_Registration];
    }
    else
    {
        [Utility offlineMessage];
    }
}

#pragma mark - Webservice Methods
-(void)call_WS_JobZone
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[Utility getUserDefaultValueForKey:UD_COMPANY_ID] forKey:COMPANY_ID];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_JOBZONE];
    
    [APP_DELEGATE addProgressHUD:self];
    
    [PPEZoneEmployee sharedClient].requestSerializer = [AFJSONRequestSerializer serializer];
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            [APP_DELEGATE.progressHUD hide:YES];
            
            if ([arrayOfJobZone count] > 0 && arrayOfJobZone != nil)
                [arrayOfJobZone removeAllObjects];
            else
                arrayOfJobZone = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dictJobZone in [responseObject valueForKey:JOBE_ZONE])
            {
                [arrayOfJobZone addObject:dictJobZone];
            }
        }
        else
        {
            [Utility failedMessage:[responseObject valueForKey:MESSAGE]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to fetch Job Zones list"];
    }];
}
-(void)call_WS_Employee_Registration
{
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }
    else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:txtEmployeeId.text forKey:EMPLOYEE_ID];
    [dictParameter setObject:txtFirstName.text forKey:EMPLOYEE_FIRSTNAME];
    [dictParameter setObject:txtLastName.text forKey:EMPLOYEE_LASTNAME];
    int intJobZone = [txtWorkZone.accessibilityLabel intValue];
    [dictParameter setObject:[NSNumber numberWithInt:intJobZone] forKey:EMPLOYEE_JOBZONE_ID];
    [dictParameter setObject:strBarcode forKey:EMPLOYEE_BARCODE];
    [dictParameter setObject:[NSNumber numberWithInt:objEmployee.intAppUserID] forKey:EMPLOYEE_APP_USER_ID];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_EMP_REGISTRATION];
    
    [APP_DELEGATE addProgressHUD:self];
    [PPEZoneEmployee sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            [Utility sucessMessage:[responseObject valueForKey:MESSAGE]];
            if (isSaveClose == YES)
            {
                [self performSelector:@selector(navigateToHomeScreen) withObject:nil afterDelay:2.0];
            }
            else
            {
                isEditField = NO;
                objEmployee = nil;
                
                txtFirstName.text = @"";
                txtLastName.text = @"";
                txtEmployeeId.text = @"";
                txtWorkZone.text = @"";
                txtPassword.text = @"";
                txtConfirmPassword.text = @"";
                txtEmployeeId.enabled = TRUE;
                txtEmployeeId.textColor = [UIColor blackColor];
                [txtFirstName becomeFirstResponder];
            }
        }
        else
        {
            [Utility failedMessage:[responseObject valueForKey:MESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to register Employee"];
    }];
}
#pragma mark - Touch Method
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}


#pragma mark - Table View Delegate & DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [arrayOfJobZone count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    cell.layoutMargins = UIEdgeInsetsZero;
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (checkedIndex == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [[arrayOfJobZone objectAtIndex:indexPath.row] valueForKey:JOB_TITLE];
    cell.textLabel.adjustsFontSizeToFitWidth=YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    checkedIndex = indexPath.row;
    txtWorkZone.text = [[arrayOfJobZone objectAtIndex:indexPath.row] valueForKey:JOB_TITLE];
    bntWorkZone.accessibilityLabel = [[arrayOfJobZone objectAtIndex:indexPath.row] valueForKey:JOB_ID];
    txtWorkZone.accessibilityLabel = [[arrayOfJobZone objectAtIndex:indexPath.row] valueForKey:JOB_ID];
    [wokZonePopover dismissPopoverAnimated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Validation
-(BOOL) checkValidation
{
    BOOL isValidate;
    if ([txtFirstName.text isEqualToString:@""]){
        
    }
    return isValidate;
}


#pragma mark - textField Delegate Methods.

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing: (UITextField *)textField
{
    
    mainText = textField;
    btnBarPrev =   [[UIBarButtonItem alloc]initWithTitle:@"PREV" style:UIBarButtonItemStyleBordered target:self action:@selector(previousTextField)];
    btnBarNext = [[UIBarButtonItem alloc] initWithTitle:@"NEXT" style:UIBarButtonItemStyleBordered target:self action:@selector(nextTextField)];
    
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    keyboardToolBar.barStyle = UIBarStyleDefault;
    [keyboardToolBar setItems: [NSArray arrayWithObjects:
                                btnBarPrev,
                                btnBarNext,
                                [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)],
                                nil]];
    textField.inputAccessoryView = keyboardToolBar;
    if (textField == txtConfirmPassword) {
        btnBarNext.enabled = FALSE;
    }else{
        btnBarNext.enabled = TRUE;
    }
    
    if (textField == txtFirstName) {
        btnBarPrev.enabled = FALSE;
    }else{
        btnBarPrev.enabled = TRUE;
    }
    
    return YES;
}
- (void)nextTextField {
    
    switch (mainText.tag) {
        case 0:{
            [txtLastName becomeFirstResponder];
            
        }break;
        case 1:{
            [txtEmployeeId becomeFirstResponder];
            
        }break;
        case 2:{
            [txtEmployeeId resignFirstResponder];
            [txtFirstName resignFirstResponder];
            [txtLastName resignFirstResponder];
            [self workZoneSelected:self];
        }break;
        case 3:{
            [txtPassword becomeFirstResponder];
        }break;
        case 4:{
            [txtConfirmPassword becomeFirstResponder];
        }break;
        default:
            break;
    }
}

-(void)previousTextField
{
    switch (mainText.tag) {
        case 1:{
            [txtFirstName becomeFirstResponder];
        }break;
        case 2:{
            [txtLastName becomeFirstResponder];
        }break;
        case 3:{
            [txtEmployeeId becomeFirstResponder];
        }break;
        case 4:{
            [txtEmployeeId resignFirstResponder];
            [txtFirstName resignFirstResponder];
            [txtLastName resignFirstResponder];
            [self workZoneSelected:self];
        }break;
        case 5:{
            [txtPassword becomeFirstResponder];
        }break;
        default:
            break;
    }
}

-(void)resignKeyboard {
    
    [txtEmployeeId resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtWorkZone resignFirstResponder];
    [txtPassword resignFirstResponder];
    [txtConfirmPassword resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == txtEmployeeId || textField == txtFirstName || textField == txtLastName || textField == txtPassword || textField == txtConfirmPassword)
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

#pragma mark - Status Bar Hidden Default
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
