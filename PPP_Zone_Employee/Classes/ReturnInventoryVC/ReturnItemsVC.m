

#import "ReturnItemsVC.h"


@interface ReturnItemsVC ()

@end

@implementation ReturnItemsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    APP_DELEGATE.currentViewController = self;
    
    imgEmpProfile.layer.cornerRadius = 2.0;
    imgEmpProfile.layer.borderColor = [UIColor darkGrayColor].CGColor;
    imgEmpProfile.layer.borderWidth = 1.0;
    imgEmpProfile.backgroundColor = [UIColor whiteColor];
    
    [Utility createShadowWithFrame:imgEmpProfile];

    tblReturnProducts.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [tblReturnProducts reloadData];
    lblTitle.text = [NSString stringWithFormat:@"Return Inventory"];
    
    //[APP_DELEGATE addProgressHUD:self];
    if (APP_DELEGATE.isInternetOn == TRUE) {
        [self WS_GET_PRODUCT_LIST];
    }else{
        [Utility offlineMessage];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - back
-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [arrayReturnList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   __weak ReportCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCustomCell"];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReportCustomCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:1];
    }
    
    if (indexPath.row == 0)
        cell.lblSep1.hidden = NO;
    else
        cell.lblSep1.hidden = YES;
    
    
    ReturnItem *objRetItem = [arrayReturnList objectAtIndex:indexPath.row];
    
    cell.imgProduct.layer.cornerRadius = 2.0;
    cell.imgProduct.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.imgProduct.layer.borderWidth = 1.0;
    cell.imgProduct.backgroundColor = [UIColor whiteColor];
    [Utility createShadowWithFrame:cell.imgProduct];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    NSString *strAttributeName = objRetItem.strAttributeName;
    cell.lblProductID.text = [strAttributeName stringByReplacingOccurrencesOfString:@"<br/>" withString:@", "];
    cell.lblProductID.textColor = [UIColor lightGrayColor];
    cell.lblProductName.text = objRetItem.strProductName;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateNotFormatted = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@",objRetItem.strProductOutTime]];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString * dateFormatted = [dateFormatter stringFromDate:dateNotFormatted];
    
    cell.lblOutTime.text = dateFormatted;
    [cell.imgProduct setImage:[UIImage imageNamed:objRetItem.strProductImage]];
    
    
    NSURL *imageURL = [NSURL URLWithString:objRetItem.strProductImage];
    UIImage *placeholderImage = [UIImage imageNamed :@"profile_dummy.png"];
    [cell.indicator startAnimating];
    [cell.imgProduct setImageWithURL:imageURL
                    placeholderImage:placeholderImage
                             options:SDWebImageRefreshCached
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         [cell.indicator stopAnimating];
     }];
    
    if (objRetItem.isReturn == TRUE)
    {
        [cell.btnReturn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnReturn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    }
    cell.btnReturn.tag = indexPath.row + 500;
    [cell.btnReturn addTarget:self action:@selector(btnReturnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        return 52.0;
    }
    else
    {
        return 0;
    }
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
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"ReportsTableHeaderView" owner:self options:nil];
    if ([arrayReturnList count] > 0) {
        viewTableHeader = (ReportsTableHeaderView *)[bundle objectAtIndex:1];
        return viewTableHeader;
    }
    else{
        return nil;
    }
}

#pragma mark - Return Clicked
-(void)btnReturnClicked : (id)sender
{
    UIButton *btnReturn = (UIButton *)sender;
    
    ReturnItem *objRetItem = [arrayReturnList objectAtIndex:btnReturn.tag - 500];
    if (objRetItem.isReturn == TRUE)
        objRetItem.isReturn = FALSE;
    else
        objRetItem.isReturn = TRUE;
    
    [tblReturnProducts reloadData];
}


#pragma mark - Done
-(IBAction)Done:(id)sender
{
    if (APP_DELEGATE.isInternetOn == TRUE)
        [self WS_Return_selected_List];
    else
        [Utility offlineMessage];
}

#pragma mark -Call Web Service
-(void)WS_GET_PRODUCT_LIST
{
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }
    else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:APP_DELEGATE.employee_id forKey:PRODUCT_LIST_EMPLOYEE_ID];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_RETURN_PRODUCT_LIST];
    
    [APP_DELEGATE addProgressHUD:self];
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE) {
            [APP_DELEGATE.progressHUD hide:YES];
            
            if (arrayReturnList != nil && [arrayReturnList count] > 0) {
                [arrayReturnList removeAllObjects];
            }else{
                arrayReturnList = [[NSMutableArray alloc] init];
            }
            
            NSArray *arrayEmployeeDetail = [responseObject valueForKey:@"employee"];
            NSString *name = [NSString stringWithFormat:@"%@ %@",[arrayEmployeeDetail valueForKey:@"firstname"],[arrayEmployeeDetail valueForKey:@"lastname"]];
            lblEmpName.text = name;
            lblEmpID.text = [arrayEmployeeDetail valueForKey:@"employee_id"];
            
            NSURL *imageURL = [arrayEmployeeDetail valueForKey:@"image"];
            UIImage *placeholderImage = [UIImage imageNamed :@"profile_dummy.png"]; //
            [imgEmpProfile setImageWithURL:imageURL
                             placeholderImage:placeholderImage
                                      options:SDWebImageRefreshCached
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
             {
                 //NSLog(@"image loaded");
             }];
            
            NSArray *detailArray = [responseObject valueForKey:@"issueproducts"];
            for (NSDictionary *dictProduct in detailArray)
            {
                ReturnItem *objProduct = [[ReturnItem alloc] init];
                objProduct.strProductName = [dictProduct valueForKey:RETURN_PRODUCT_NAME];
                objProduct.strProductImage = [dictProduct valueForKey:RETURN_PRODUCT_IMAGE];
                objProduct.strProductID = [dictProduct valueForKey:RETURN_PRODUCT_ID];
                objProduct.strProductOutTime = [dictProduct valueForKey:RETURN_PRODUCT_DATE];
                objProduct.isReturn = FALSE;
                objProduct.strAttributeName = [dictProduct valueForKey:@"attribute_details"];
                [arrayReturnList addObject:objProduct];
                objProduct = nil;
            }
            [tblReturnProducts reloadData];
        }else{
            [Utility failedMessage:[responseObject valueForKey:@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to fetch return inventory list"];
    }];
}

-(void)dismissIndicator
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)WS_Return_selected_List
{
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:APP_DELEGATE.employee_id forKey:PRODUCT_ISSUE_USER_ID];
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"self.isReturn == TRUE"];
    NSArray *demoArray = [arrayReturnList filteredArrayUsingPredicate:test];
    NSMutableArray *returnIssueId;
    if (returnIssueId != nil && [returnIssueId count] > 0) {
        [returnIssueId removeAllObjects];
    }else{
        returnIssueId = [[NSMutableArray alloc]init];
    }
    
    for (ReturnItem *obj in demoArray) {
        NSLog(@"%@",obj.strProductID);
        [returnIssueId addObject:obj.strProductID];
    }
    [dictParameter setObject:returnIssueId forKey:@"return"];
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_RETURN_PRIDUCT_SELECTED_LIST];
    
    [APP_DELEGATE addProgressHUD:self];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE) {
            [Utility sucessMessage:[responseObject valueForKey:MESSAGE]];
            [self performSelector:@selector(dismissIndicator) withObject:nil afterDelay:2.0];
        }
        else{
            [Utility failedMessage:[responseObject valueForKey:MESSAGE]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to send return request"];
    }];
}

#pragma mark - Status Bar Hidden Default
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
