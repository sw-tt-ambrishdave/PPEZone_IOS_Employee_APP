
#import "ViewController.h"
#import "loginVC.h"
#import "AppDelegate.h"


@interface ViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
//@property (nonatomic, strong) NSMutableArray *arrConnectedDevices;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    self.navigationController.navigationBarHidden = YES;
    APP_DELEGATE.currentViewController = self;
    
    searchView.hidden = YES;
    
    if (APP_DELEGATE.intScanTimer == 0) {
        APP_DELEGATE.intScanTimer = 5;
    }
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([arrayOfEmployee count] > 0 & arrayOfEmployee != nil)
        [arrayOfEmployee removeAllObjects];
    [tblEmployeeList reloadData];
}

#pragma mark - Search
-(IBAction)search:(id)sender
{
    searchView.hidden = NO;
    tblEmployeeList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Enroll
-(IBAction)enroll:(id)sender
{
    isNewRegistration = TRUE;
    [self performSegueWithIdentifier:SEGUE_ENROLL sender:self];
}

#pragma mark - Login
-(IBAction)login:(id)sender
{
    [self performSegueWithIdentifier:SEGUE_LOGIN sender:self];
}

#pragma mark - Search Employee
-(IBAction)searchEmployee:(id)sender
{
    if ([txtSearchEmployee.text isEqualToString:@""])
    {
        [Utility displayAlertWithMessage:@"Search field is empty"];
    }
    else
    {
        if (APP_DELEGATE.isInternetOn == TRUE)
        {
            [self call_WS_Employee_Search];
        }
        else
        {
            [Utility offlineMessage];
        }
    }
}
#pragma mark - Close
-(IBAction)close:(id)sender
{
    [txtSearchEmployee resignFirstResponder];
    searchView.hidden = YES;
    tblEmployeeList.delegate = nil;
    tblEmployeeList.dataSource = nil;
    
}
#pragma mark - Segue Method
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_LOGIN])
    {
    }
    else if ([segue.identifier isEqualToString:SEGUE_ENROLL])
    {
        mendatoryDetailsVC *objEnrollVC = (mendatoryDetailsVC *)segue.destinationViewController;
        if (isNewRegistration == TRUE)
        {
            objEnrollVC.objEmployee = nil;
        }
        else
        {
            objEnrollVC.objEmployee = objEmployee;
        }
    }
}


#pragma mark - textField Delegate Methods.
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrayOfEmployee count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   __weak ReportCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCustomCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReportCustomCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    Employee *objEmp = [arrayOfEmployee objectAtIndex:indexPath.row];
    cell.lblEmpName.text = [NSString stringWithFormat:@"%@ %@",objEmp.strEmpFirstName,objEmp.strEmpLastName];
    cell.lblJobZone.text = objEmp.strJobZoneName; //[NSString stringWithFormat:@"%d",objEmp.intEmpJobZoneID];
    cell.lblEmpID.text = objEmp.strEmpID;
    if (![objEmp.strEmpImage isEqualToString:@""])
    {
        
        NSURL *imageURL = [NSURL URLWithString:objEmp.strEmpImage];
        UIImage *placeholderImage = [UIImage imageNamed :@"profile_dummy.png"]; //
        [cell.indicator startAnimating];
        [cell.imgEmployee setImageWithURL:imageURL
                        placeholderImage:placeholderImage
                                 options:SDWebImageRefreshCached
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             [cell.indicator stopAnimating];
         }];
        
        

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([arrayOfEmployee count] <= 0)
    {
        return 0;
    }
    return 52;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([arrayOfEmployee count] <= 0)
    {
        return nil;
    }
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ReportsTableHeaderView" owner:self options:nil];
    
    viewTableHeader = (ReportsTableHeaderView *)[bundle objectAtIndex:0];
    return viewTableHeader;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isNewRegistration = FALSE;
    objEmployee = [arrayOfEmployee objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:SEGUE_ENROLL sender:self];
}
#pragma mark - Webservice Call Method
-(void)call_WS_Employee_Search
{
    if (dictParameter)
    {
        [dictParameter removeAllObjects];
    }
    else
    {
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:txtSearchEmployee.text forKey:EMPLOYEE_SEARCH];
    txtSearchEmployee.text = @"";
    [txtSearchEmployee resignFirstResponder];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_EMP_SEARCH];
    
    [APP_DELEGATE addProgressHUD:self];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            [APP_DELEGATE.progressHUD hide:YES];
            
            if ([arrayOfEmployee count] > 0 & arrayOfEmployee != nil)
                [arrayOfEmployee removeAllObjects];
            else
                arrayOfEmployee = [NSMutableArray array];
            
            if ([responseObject valueForKey:@"TotalCount"] > 0)
            {
                for (NSDictionary *dictEmp in [responseObject valueForKey:EMPLOYEES]) {
                    Employee *objEmp = [[Employee alloc] init];
                    objEmp.strEmpFirstName = [dictEmp valueForKey:EMPLOYEE_FIRSTNAME];
                    objEmp.strEmpLastName = [dictEmp valueForKey:EMPLOYEE_LASTNAME];
                    objEmp.strEmpID = [dictEmp valueForKey:EMPLOYEE_ID];
                    objEmp.intEmpJobZoneID = [[dictEmp valueForKey:EMPLOYEE_JOBZONE_ID] intValue];
                    objEmp.strJobZoneName = [dictEmp valueForKey:EMPLOYEE_JOBZONE_NAME];
                    objEmp.strEmpImage = [dictEmp valueForKey:EMPLOYEE_IMAGE];
                    objEmp.intAppUserID = [[dictEmp valueForKey:EMPLOYEE_APP_USER_ID] intValue];
                    objEmp.strBarcode = [dictEmp valueForKey:@"barcode"];
                    [arrayOfEmployee addObject:objEmp];
                    objEmp = nil;
                }
            }
            tblEmployeeList.delegate = self;
            tblEmployeeList.dataSource = self;
            tblEmployeeList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [tblEmployeeList reloadData];
        }
        else
        {
            [Utility failedMessage:[responseObject valueForKey:@"message"]];
            
            if ([arrayOfEmployee count] > 0 & arrayOfEmployee != nil)
                [arrayOfEmployee removeAllObjects];
            
            [tblEmployeeList reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to search Employee"];
        
    }];
}

#pragma mark - Webservice Call Method



#pragma mark - Status Bar Hidden Default
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
