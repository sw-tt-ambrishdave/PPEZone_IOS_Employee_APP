
#import "saftyToolsVC.h"
#import "saftyCollectionCell.h"
#import "selectedCell.h"
#import <CoreImage/CoreImage.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface saftyToolsVC ()

@end

@implementation saftyToolsVC
@synthesize titleToolName,tagNumber,wokZonePopover;

- (void)viewDidLoad {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    APP_DELEGATE.currentViewController = self;
    
    [super viewDidLoad];
    
    
    if (APP_DELEGATE.isInternetOn == TRUE) {
        [self call_WS_Safty_Tools];
    }
    else{
        [Utility offlineMessage];
    }
    
    // Do any additional setup after loading the view.
    arraySaftyTools = [[NSMutableArray alloc]init];
    arrayToolSelected = [[NSMutableArray alloc]init];
    subArraySelectedTools = [[NSMutableArray alloc]init];
    
    imgQRView.hidden = YES;
    lblTitle.text = titleToolName;
    
    viewTableContainer.hidden = YES;
    viewWishlistContainer.hidden = YES;
    viewAttributes.hidden = YES;
    
    viewTableContainer.frame = CGRectMake(self.view.frame.size.width + 1.0, viewTableContainer.frame.origin.y,viewTableContainer.frame.size.width, viewTableContainer.frame.size.height);
    
    [tblView registerNib:[UINib nibWithNibName:@"selectedCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

-(void)viewWillAppear:(BOOL)animated
{
    checkedIndexPaths = [[NSMutableArray alloc]init];
    [collectionSafty registerClass:[saftyCollectionCell class] forCellWithReuseIdentifier:@"saftyCollectionCell"];
}

#pragma mark - safty products issue
-(void)call_WS_Saft_Product_Issue : (int) intWishList
{
    NSMutableArray *arraySelectedProducts = [[NSMutableArray alloc]init];
    
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }
    else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:APP_DELEGATE.employee_id forKey:PRODUCT_ISSUE_USER_ID];
    [dictParameter setObject:[NSNumber numberWithInt:intWishList] forKey:@"wishlist"];
    
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"self.isSelected == TRUE"];
    NSArray *demoArray = [APP_DELEGATE.arrayProductSelect filteredArrayUsingPredicate:test];
    
    for (Product *objProd in demoArray) {
       
        NSMutableDictionary *dictProducts = [[NSMutableDictionary alloc]init];
        [dictProducts setObject:objProd.strProductID forKey:PORDUCT_ISSUE_PRODUCT_ID];
        [dictProducts setObject:objProd.strProductName forKey:PRODUCT_TITLE];

        if([objProd.arrOfSelectedAttributeValues count] > 0)
        {
            NSMutableArray *arrayTemp = [NSMutableArray array];
            for (Attributes *objAttribu in objProd.arrOfSelectedAttributeValues) {
                NSMutableDictionary *dictAttri = [NSMutableDictionary dictionary];
                [dictAttri setObject:objAttribu.strAttributeID forKey:@"attr_id"];
                [dictAttri setObject:objAttribu.strAttributeTitle forKey:@"attr_title"];
                [dictAttri setObject:objAttribu.strAttributeValueID forKey:@"value_id"];
                [dictAttri setObject:objAttribu.strAttributeValue forKey:@"value_title"];

                [dictAttri setObject:[NSNumber numberWithInt:objAttribu.product_attr_id] forKey:@"product_attr_id"];
                [dictAttri setObject:[Utility checkNullORBlankString:objAttribu.strUPC_Code] forKey:@"upc_code"];
                [dictAttri setObject:[NSNumber numberWithBool:objAttribu.is_dependent] forKey:@"is_dependent"];
                [dictAttri setObject:[NSNumber numberWithFloat:objAttribu.stock] forKey:@"stock"];
                [arrayTemp addObject:dictAttri];
                dictAttri = nil;
            }
            [dictProducts setObject:arrayTemp forKey:PRODUCT_ISSUE_ATTRIBUTE];
        }
        [arraySelectedProducts addObject:dictProducts];
        dictProducts = nil;
    }
    
    [dictParameter setObject:arraySelectedProducts forKey:@"products"];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_PRODUCT_ISSUE];
    
    [APP_DELEGATE addProgressHUD:self];
    [PPEZoneEmployee sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            [APP_DELEGATE.arrayProductSelect removeAllObjects];
            [Utility sucessMessage:[responseObject valueForKey:MESSAGE]];
            [self performSelector:@selector(dismissIndicator) withObject:nil afterDelay:2.0];
        }
        else
        {
            [Utility failedMessage:[responseObject valueForKey:MESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to issue inventories"];
    }];
}


-(void)dismissIndicator
{
    viewTableContainer.hidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Safty Tools listing webservice
-(void)call_WS_Safty_Tools
{
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }
    else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    
    dictParameter = [NSMutableDictionary dictionary];
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:[NSNumber numberWithInt:[tagNumber intValue]] forKey:PRODUCT_LIST_BODY_PART];
    [dictParameter setObject:APP_DELEGATE.employee_id forKey:PRODUCT_LIST_EMPLOYEE_ID];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_PRODUCT_LIST];
    
    [APP_DELEGATE addProgressHUD:self];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE) {
            [APP_DELEGATE.progressHUD hide:YES];
            
            if (arraySaftyTools != nil && [arraySaftyTools count] > 0)
                [arraySaftyTools removeAllObjects];
            else
                arraySaftyTools = [[NSMutableArray alloc] init];
            
            NSArray *detailArray = [responseObject valueForKey:@"products"];
            for (NSDictionary *dictProduct in detailArray)
            {
                Product *objProduct = [[Product alloc] init];
                objProduct.strProductName = [dictProduct valueForKey: PRODUCT_TITLE];
                objProduct.strProductImage = [dictProduct valueForKey:PRODUCT_IMAGE];
                objProduct.strProductID = [dictProduct valueForKey:PRODUCT_ID];
               NSDictionary *check = [dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES];

                if([check count]> 0)
                {
//                    objProduct.arrayAllProductAttributes = [dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES];
                    
                    
                    NSLog(@"Count --- %d ",[objProduct.arrayAllProductAttributes count]);
                    objProduct.arrProductAttribute = [dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES];
                    
                    
                    
                   objProduct.dictOfAllAttributes = [dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES];
                    NSLog(@"First Value of All Attribute ---- %@",[dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES]);
                 
                    for (int i = 0; i < [[dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES] count]; i++) {
                        NSLog(@"Data Value ---- %@",[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0]);
                        
                        Attributes *objAttribute = [[Attributes alloc] init];
                        objAttribute.strAttributeTitle = [[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"attr_title"];
                        
                        objAttribute.strAttributeID = [[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"attr_id"];

                        objAttribute.strAttributeValueID = [[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"value_id"];

                        objAttribute.strAttributeValue = [[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"value_title"];
                        
                        objAttribute.is_dependent = [[[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"is_dependent"] boolValue];
                        
                        objAttribute.strUPC_Code = [[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"upc_code"];
                        
                        objAttribute.product_attr_id = [[[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"product_attr_id"] intValue];
                        
                        objAttribute.stock = [[[[objProduct.dictOfAllAttributes valueForKey:[[objProduct.dictOfAllAttributes allKeys] objectAtIndex:i]] objectAtIndex:0] valueForKey:@"stock"] floatValue];
                        
                        [objProduct.arrOfSelectedAttributeValues addObject:objAttribute];
                        objAttribute = nil;
                    }
                    
//                    objProduct.strAtteributeName = [[objProduct.arrProductAttribute objectAtIndex:0]valueForKey:PRODUCT_ISSUE_ATTRIBUTE_TITLE];
//                    objProduct.strProductAttrId = [[objProduct.arrProductAttribute objectAtIndex:0]valueForKey:PRODUCT_ATTRIBUTE_ID];
                }
                else
                {
                    objProduct.arrProductAttribute = nil;
                    objProduct.strAtteributeName = @"";
                    objProduct.strProductAttrId = @"";
                }
                
                NSDictionary *checkIndependentAttr = [dictProduct valueForKey:PRODUCT_INDEPENDENT_ATTRIBUTES];
                objProduct.arrIndependentAttribute = [dictProduct valueForKey:PRODUCT_INDEPENDENT_ATTRIBUTES];
                NSLog(@"Array --- %@",objProduct.arrIndependentAttribute);

                objProduct.isSelected = FALSE;
                
                [arraySaftyTools addObject:objProduct];
                objProduct = nil;
            }
            [collectionSafty reloadData];
        }
        else
        {
            [Utility failedMessage:[responseObject valueForKey:MESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to fetch Product(s)"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - back
-(IBAction)back:(id)sender
{
    viewTableContainer.hidden = YES;
    viewTableContainer.frame = CGRectMake(self.view.frame.size.width + 1.0, viewTableContainer.frame.origin.y,viewTableContainer.frame.size.width, viewTableContainer.frame.size.height);
    CGRect frame = ViewCollectionContainer.frame;
    frame.origin.y = ViewCollectionContainer.frame.origin.y;
    frame.origin.x = 0.0;
    ViewCollectionContainer.frame = frame;
    [btnHistory setImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - Finish
-(IBAction)finsih:(id)sender
{
    if ([APP_DELEGATE.arrayProductSelect count] > 0) {
        if (viewTableContainer.hidden == YES) {
            viewTableContainer.hidden = NO;
            viewSubTblContainer.layer.cornerRadius = 10.0;
            viewTableContainer.frame = CGRectMake(0, 0, 768, 1024);
            
            for (Product *objProduct in APP_DELEGATE.arrayProductSelect) {
                NSLog(@"Product Name --- %@",objProduct.strProductName);
                for (Attributes *objAttri in objProduct.arrOfSelectedAttributeValues) {
                    NSLog(@"Attribute Name --- %@",objAttri.strAttributeValue);
                }
            }
            
            [self bounceAnimation:viewTableContainer];
            [tblView reloadData];
        }
    }else{
        UIAlertView *alertMsg = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"There is no product(s) into cart" delegate:selectedIndexPath cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertMsg show];
    }
 }

#pragma mark - History
-(IBAction)history:(id)sender
{
    if (viewTableContainer.hidden == NO) {
        
        [btnHistory setImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             CGRect frame = ViewCollectionContainer.frame;
                             frame.origin.y = ViewCollectionContainer.frame.origin.y;
                             frame.origin.x = 0.0;
                             ViewCollectionContainer.frame = frame;
                             
                             CGRect frame1 = viewTableContainer.frame;
                             frame1.origin.y = viewTableContainer.frame.origin.y;
                             frame1.origin.x = self.view.frame.size.width + 1.0;
                             viewTableContainer.frame = frame1;
                             
                             btnBackPPE.frame = CGRectMake(50.0, btnBackPPE.frame.origin.y, btnBackPPE.frame.size.width, btnBackPPE.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             viewTableContainer.hidden = YES;
                             
                         }];
    }
    else {
        viewTableContainer.hidden = NO;
        [btnHistory setImage:[UIImage imageNamed:@"history_active.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^ {
                             CGRect frame = ViewCollectionContainer.frame;
                             frame.origin.y = ViewCollectionContainer.frame.origin.y;
                             frame.origin.x = (-225);
                             ViewCollectionContainer.frame = frame;
                             
                             CGRect frame1 = viewTableContainer.frame;
                             frame1.origin.y = viewTableContainer.frame.origin.y;
                             frame1.origin.x = self.view.frame.size.width - 225.0;
                             viewTableContainer.frame = frame1;
                             btnBackPPE.frame = CGRectMake(275.0, btnBackPPE.frame.origin.y, btnBackPPE.frame.size.width, btnBackPPE.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}
-(void) bounceAnimation : (UIView *)view
{
    CALayer *viewLayer = view.layer;
    viewLayer.cornerRadius=1.0;
    CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    popInAnimation.duration = 0.3;
    popInAnimation.values = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:1.1], [NSNumber numberWithFloat:.9], [NSNumber numberWithFloat:1], nil];
    popInAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:0.8], [NSNumber numberWithFloat:1.0], nil];
    [viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];
}
-(IBAction)btnCancleClicked:(id)sender
{
    viewTableContainer.hidden = YES;
    viewWishlistContainer.hidden = YES;
}
-(IBAction)btnWishListClicked:(id)sender
{
    if ([APP_DELEGATE.arrayProductSelect count] > 0) {
        if (viewWishlistContainer.hidden == YES) {
            viewWishlistContainer.hidden = NO;
            viewWishlistContainer.layer.cornerRadius = 10.0;
            viewWishlistContainer.layer.masksToBounds = YES;
            viewWishlistContainer.frame = CGRectMake(0, 0, 768, 1024);
            
            
            [self bounceAnimation:viewWishlistContainer];
            [tblView reloadData];
        }
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


-(IBAction)btnDoneClicked:(id)sender
{
    
    UIButton *btnSelect = (UIButton *)sender;
    
    if (APP_DELEGATE.isInternetOn == TRUE) {
        if (btnSelect.tag == 100){
            [self call_WS_Saft_Product_Issue:1];
        }
        else {
            [self call_WS_Saft_Product_Issue:0];
        }
    }else{
        [Utility offlineMessage];
    }
    
}

-(IBAction)btnAttributeSelectionDoneClicked:(id)sender
{
    viewAttributes.hidden = YES;
    
    Product *objProduct = [arraySaftyTools objectAtIndex:selectedProductTag];

    if (objProduct.isSelected == TRUE) {
        objProduct.isSelected = FALSE;
        
        
        if ([APP_DELEGATE.arrayProductSelect count] > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.strProductID == %@",objProduct.strProductID];
            NSArray *arrTmp = [APP_DELEGATE.arrayProductSelect filteredArrayUsingPredicate:predicate];
            if ([arrTmp count] > 0)
            {
                Product *objPro = [arrTmp objectAtIndex:0];
                [APP_DELEGATE.arrayProductSelect removeObject:objPro];
            }
        }
    }
    else {
        objProduct.isSelected = TRUE;
        for (Attributes *objAttri in objProduct.arrOfSelectedAttributeValues) {
            NSLog(@"Attribute --- %@",objAttri.strAttributeValue);
        }
        [APP_DELEGATE.arrayProductSelect addObject:objProduct];
    }
    [collectionSafty reloadData];
}
-(IBAction)btnAttributeSelectionCancleClicked:(id)sender
{
    viewAttributes.hidden = YES;
}

#pragma mark - Collection view delegate and datasource methods.

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [arraySaftyTools count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"saftyCollectionCell";
   __weak saftyCollectionCell *cell = [collectionView1 dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Product *objProduct = [arraySaftyTools objectAtIndex:indexPath.row];
    
    /*
    if ([objProduct.arrProductAttribute count] != 0) {
        
        cell.btnCenterPrint.hidden = YES;
        cell.btnPrint.tag = indexPath.row;
        cell.btnPrint.hidden = NO;
        cell.txtSelection.hidden = NO;
        cell.btnSelection.hidden = NO;
        cell.btnSelection.tag = indexPath.row;
        [cell.btnSelection addTarget:self action:@selector(btnAttributeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSelection setTitle:objProduct.strAtteributeName forState:UIControlStateNormal];
        cell.btnSelection.accessibilityLabel = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    }
    else {
        cell.btnCenterPrint.hidden = NO;
        cell.btnPrint.hidden = YES;
        cell.txtSelection.hidden = YES;
        cell.btnSelection.hidden = YES;
        cell.btnCenterPrint.tag = indexPath.row;
    }
    */

    cell.btnCenterPrint.hidden = NO;
    cell.btnPrint.hidden = YES;
    cell.txtSelection.hidden = YES;
    cell.btnSelection.hidden = YES;
    cell.btnCenterPrint.tag = indexPath.row;
    
    cell.lblsafty.text = objProduct.strProductName;
    
    NSURL *imageURL = [NSURL URLWithString:objProduct.strProductImage];
    UIImage *placeholderImage = [UIImage imageNamed :@"profile_dummy.png"];
    [cell.indicator startAnimating];
    [cell.imgSafty setImageWithURL:imageURL
                  placeholderImage:placeholderImage
                           options:SDWebImageRefreshCached
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         [cell.indicator stopAnimating];
     }];
    
    cell.btnCenterPrint.tag = indexPath.row;
    cell.btnPrint.tag = indexPath.row;
    [cell.btnPrint addTarget:self action:@selector(btnIssueProductClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnCenterPrint addTarget:self action:@selector(btnIssueProductClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([APP_DELEGATE.arrayProductSelect count] > 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.strProductID == %@",objProduct.strProductID];
        NSArray *arrTmp = [APP_DELEGATE.arrayProductSelect filteredArrayUsingPredicate:predicate];
        if ([arrTmp count] > 0)
        {
            objProduct.isSelected = TRUE;
        }
    }else{
        objProduct.isSelected = FALSE;
    }
    
    if (objProduct.isSelected == TRUE)
    {
        cell.imgIssuedProduct.hidden = NO;
        [cell.btnPrint setImage:[UIImage imageNamed:@"btn_return.png"] forState:UIControlStateNormal];
        [cell.btnCenterPrint setImage:[UIImage imageNamed:@"btn_return.png"] forState:UIControlStateNormal];
    }
    else
    {
        cell.imgIssuedProduct.hidden = YES;
        [cell.btnPrint setImage:[UIImage imageNamed:@"btn_issue.png"] forState:UIControlStateNormal];
        [cell.btnCenterPrint setImage:[UIImage imageNamed:@"btn_issue.png"] forState:UIControlStateNormal];

    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView1 didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - selection
-(IBAction)btnAttributeClicked:(UIButton *)sender//(id)sender
{
    /*
    if ([arrayIndependentAttributes count] > 0 && arrayIndependentAttributes != nil) {
        [arrayIndependentAttributes removeAllObjects];
    }else{
        arrayIndependentAttributes = [[NSMutableArray alloc]init];
    }
    Product *objProduct = [arraySaftyTools objectAtIndex:[sender tag]];
    arrayIndependentAttributes = [objProduct.arrProductAttribute mutableCopy];
    
    UIViewController *VC_callStatusChg = [[UIViewController alloc] init];
    tblViewReportType = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 200) style:UITableViewStylePlain];
    tblViewReportType.delegate = self;
    tblViewReportType.dataSource = self;
    tblViewReportType.tag = 101;
    tblViewReportType.backgroundColor = [UIColor clearColor];
    tblViewReportType.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblViewReportType.scrollEnabled = YES;
    tblViewReportType.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    MainIndex = [sender.accessibilityLabel intValue];
    
    [VC_callStatusChg.view addSubview:tblViewReportType];
    VC_callStatusChg.preferredContentSize = CGSizeMake(250,200);
    
    wokZonePopover = [[UIPopoverController alloc] initWithContentViewController:VC_callStatusChg];
    wokZonePopover.delegate=self;
    [wokZonePopover setPopoverContentSize:CGSizeMake(250, 200) animated:NO];
    [wokZonePopover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
     */
    
    if (viewAttributes.hidden == YES) {
        viewAttributes.hidden = NO;
        [self bounceAnimation:viewAttributes];
    }
    
    
    
}

#pragma mark - UIAlertview Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1010) {
        if (buttonIndex == 0) {
            NSLog(@"OK Clicked");
            [APP_DELEGATE.arrayProductSelect removeObjectAtIndex:selectedIndexPath.row];
            [tblView deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [collectionSafty reloadData];
            if ([APP_DELEGATE.arrayProductSelect count] == 0) {
                viewTableContainer.hidden = YES;
                viewWishlistContainer.hidden = YES;

            }
            
        }else{
            NSLog(@"Cancel Clicked");
        }
    }
}
#pragma mark - product selected.
-(IBAction)btnIssueProductClicked:(id)sender
{
    selectedProductTag = [sender tag];
    
    Product *objProduct = [arraySaftyTools objectAtIndex:selectedProductTag];
    
    if ([objProduct.arrProductAttribute count] > 0) {
        
        if (objProduct.isSelected == TRUE) {
            objProduct.isSelected = FALSE;
            
            
            if ([APP_DELEGATE.arrayProductSelect count] > 0)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.strProductID == %@",objProduct.strProductID];
                NSArray *arrTmp = [APP_DELEGATE.arrayProductSelect filteredArrayUsingPredicate:predicate];
                if ([arrTmp count] > 0)
                {
                    Product *objPro = [arrTmp objectAtIndex:0];
                    [APP_DELEGATE.arrayProductSelect removeObject:objPro];
                }
            }
        }else{
            if (viewAttributes.hidden == YES) {
                viewAttributes.hidden = NO;
                
//                if (dictOfAllAttributes != nil && [dictOfAllAttributes count] >0) {
//                    [dictOfAllAttributes removeAllObjects];
//                }else{
//                    dictOfAllAttributes = [[NSMutableDictionary alloc] init];
//                }
                
                dictOfAllAttributes = objProduct.dictOfAllAttributes;
                subArraySelectedTools = objProduct.arrOfSelectedAttributeValues;
                tblAttributesList.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                [tblAttributesList reloadData];
                [self bounceAnimation:viewAttributes];
            }
        }
    }else{
        if (objProduct.isSelected == TRUE) {
            objProduct.isSelected = FALSE;
            
            
            if ([APP_DELEGATE.arrayProductSelect count] > 0)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.strProductID == %@",objProduct.strProductID];
                NSArray *arrTmp = [APP_DELEGATE.arrayProductSelect filteredArrayUsingPredicate:predicate];
                if ([arrTmp count] > 0)
                {
                    Product *objPro = [arrTmp objectAtIndex:0];
                    [APP_DELEGATE.arrayProductSelect removeObject:objPro];
                }
            }
        }
        else {
            objProduct.isSelected = TRUE;
            [APP_DELEGATE.arrayProductSelect addObject:objProduct];
        }
    }
    
    
    [collectionSafty reloadData];
}


- (UIImage *)resizeImage:(UIImage *)image
             withQuality:(CGInterpolationQuality)quality
                    rate:(CGFloat)rate
{
    UIImage *resized = nil;
    CGFloat width = image.size.width * rate;
    CGFloat height = image.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [image drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}



#pragma mark - Table View Delegate & DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 1010) {
        return [APP_DELEGATE.arrayProductSelect count];
    }else if(tableView.tag == 101){
        return [arrayIndependentAttributes count];
    }else if (tableView.tag == 5050){
        return [subArraySelectedTools count];
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1010) {
       __weak ReportCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCustomCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReportCustomCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:3];
        }
        
        Product *objProduct = [APP_DELEGATE.arrayProductSelect objectAtIndex:indexPath.row];
        cell.lblProductName.text = objProduct.strProductName;
        NSURL *imageURL = [NSURL URLWithString:objProduct.strProductImage];
        UIImage *placeholderImage = [UIImage imageNamed :@"profile_dummy.png"]; //[arraySaftyTools objectAtIndex:indexPath.row]];
        cell.lblProductID.text = objProduct.strProductID;
        [cell.indicator startAnimating];
        [cell.imgProduct setImageWithURL:imageURL
                        placeholderImage:placeholderImage
                                 options:SDWebImageRefreshCached
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             //         NSLog(@"image loaded");
             [cell.indicator stopAnimating];
         }];
        cell.btnCancel.tag = indexPath.row + 500;
        [cell.btnCancel addTarget:self action:@selector(btnDeleteProductClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else if(tableView.tag == 101){
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[[arrayIndependentAttributes objectAtIndex:indexPath.row]valueForKey:PRODUCT_ISSUE_ATTRIBUTE_TITLE]]];//@"value_title"]]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        AppFontWithSize(cell.textLabel, 18.0);
        return cell;

    }else if(tableView.tag == 5050){
         AttributesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttributesCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AttributesCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];
        }

        Attributes *objAttribute = [subArraySelectedTools objectAtIndex:indexPath.row];
        cell.btnAttributeValues.tag = indexPath.row;
        [cell.btnAttributeValues addTarget:self action:@selector(btnSelectAttributeClicked:) forControlEvents:UIControlEventTouchUpInside];
//        cell.lblAttributeName.text = [[dictOfAllAttributes allKeys] objectAtIndex:indexPath.row];
        
        cell.lblAttributeName.text = objAttribute.strAttributeTitle;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

//        int index = [[dictOfAllAttributes valueForKey:[[dictOfAllAttributes allKeys] objectAtIndex:indexPath.row]] indexOfObject:cell.btnAttributeValues.titleLabel.text];
//        if (index < 0 || index > [[dictOfAllAttributes valueForKey:[[dictOfAllAttributes allKeys] objectAtIndex:indexPath.row]] count]) {
//            index = 0;
//        }
        

//        NSString *strAttName = [[[dictOfAllAttributes valueForKey:[[dictOfAllAttributes allKeys] objectAtIndex:indexPath.row]] objectAtIndex:index] valueForKey:@"value_title"];

        
        NSString *strAttName = objAttribute.strAttributeValue;
        [cell.btnAttributeValues setTitle:strAttName forState:UIControlStateNormal];
        [cell.btnAttributeValues setTitle:strAttName forState:UIControlStateHighlighted];
        [cell.btnAttributeValues setTitle:strAttName forState:UIControlStateSelected];
        
        AppFontWithSize(cell.lblAttributeName, 22);
        AppFontWithSize(cell.btnAttributeValues.titleLabel, 22);
        return cell;
    }
    else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:
                    UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[[arrayIndependentAttributes objectAtIndex:indexPath.row]valueForKey:PRODUCT_ISSUE_ATTRIBUTE_TITLE]]];//@"value_title"]]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        AppFontWithSize(cell.textLabel, 18.0);
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 5050) {
        return 70;
    }else if (tableView.tag == 1010){
        return 120;
    }else if(tableView.tag == 101){
        return 50;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1010) {
        Product *objProduct = [APP_DELEGATE.arrayProductSelect objectAtIndex:indexPath.row];
        NSLog(@"Name *** %@",[objProduct strProductName]);
    }else if (tableView.tag == 5050){
        
        NSLog(@"Data Value ---- %@",[[dictOfAllAttributes allKeys] objectAtIndex:indexPath.row]);

    }else{
        NSLog(@"%ld",(long)indexPath.row);
        
        Product *objProduct = [arraySaftyTools objectAtIndex:selectedProductTag];
        objProduct.strAtteributeName = [[arrayIndependentAttributes objectAtIndex:indexPath.row]valueForKey: PRODUCT_ISSUE_ATTRIBUTE_TITLE];//@"value_title"];
        
        NSLog(@"Selected ---- %@",[dictOfAllAttributes valueForKey:[[dictOfAllAttributes allKeys] objectAtIndex:intSubAttributeIndex]]);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.value_title == %@",objProduct.strAtteributeName];
        NSArray *array = [[dictOfAllAttributes valueForKey:[[dictOfAllAttributes allKeys] objectAtIndex:intSubAttributeIndex]] filteredArrayUsingPredicate:predicate];
        
        NSLog(@"Array === %@",array);
        NSLog(@"Selected Attribute ---- %@",objProduct.arrOfSelectedAttributeValues);
        Attributes *objArr = [[Attributes alloc] init];
        objArr.strAttributeTitle = [[array objectAtIndex:0] valueForKey:@"attr_title"];
        objArr.strAttributeID = [[array objectAtIndex:0] valueForKey:@"attr_id"];
        objArr.strAttributeValue = [[array objectAtIndex:0] valueForKey:@"value_title"];
        objArr.strAttributeValueID = [[array objectAtIndex:0] valueForKey:@"value_id"];

        objArr.product_attr_id = [[[array objectAtIndex:0] valueForKey:@"product_attr_id"] intValue];
        objArr.stock = [[[array objectAtIndex:0] valueForKey:@"stock"] floatValue];
        objArr.is_dependent = [[[array objectAtIndex:0] valueForKey:@"is_dependent"] boolValue];
        objArr.strUPC_Code = [[array objectAtIndex:0] valueForKey:@"upc_code"];

        [objProduct.arrOfSelectedAttributeValues replaceObjectAtIndex:intSubAttributeIndex withObject:objArr];
        objArr = nil;
        
        NSIndexPath *indexCell = [NSIndexPath indexPathForRow:intSubAttributeIndex inSection:0];
        AttributesCell *cell = (AttributesCell *)[tblAttributesList cellForRowAtIndexPath:indexCell];
        [cell.btnAttributeValues setTitle:objProduct.strAtteributeName forState:UIControlStateNormal];
        
        [wokZonePopover dismissPopoverAnimated:YES];
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void) btnSelectAttributeClicked : (UIButton *)sender
{
    NSLog(@"Data Value ---- %@",[[dictOfAllAttributes allKeys] objectAtIndex:sender.tag]);
    
    if ([arrayIndependentAttributes count] > 0 && arrayIndependentAttributes != nil) {
        [arrayIndependentAttributes removeAllObjects];
    }else{
        arrayIndependentAttributes = [[NSMutableArray alloc]init];
    }
    
    intSubAttributeIndex = sender.tag;
    
    NSArray *arrayTmp = [dictOfAllAttributes valueForKey:[[dictOfAllAttributes allKeys] objectAtIndex:sender.tag]];
    for (NSDictionary *dict in arrayTmp) {
        [arrayIndependentAttributes addObject:dict];
    }
//    arrayIndependentAttributes = [dictOfAllAttributes valueForKey:[[dictOfAllAttributes allKeys] objectAtIndex:sender.tag]];
    
    UIViewController *VC_callStatusChg = [[UIViewController alloc] init];
    tblViewReportType = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 400, 200) style:UITableViewStylePlain];
    tblViewReportType.delegate = self;
    tblViewReportType.dataSource = self;
    tblViewReportType.tag = 101;
    tblViewReportType.backgroundColor = [UIColor clearColor];
    tblViewReportType.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tblViewReportType.scrollEnabled = YES;
    tblViewReportType.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    MainIndex = [sender.accessibilityLabel intValue];
    
    [VC_callStatusChg.view addSubview:tblViewReportType];
    VC_callStatusChg.preferredContentSize = CGSizeMake(400,200);
    
    wokZonePopover = [[UIPopoverController alloc] initWithContentViewController:VC_callStatusChg];
    wokZonePopover.delegate=self;
    [wokZonePopover setPopoverContentSize:CGSizeMake(400, 200) animated:NO];
    [wokZonePopover presentPopoverFromRect:sender.bounds inView:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}
#pragma mark - Return Items.
-(void) btnDeleteProductClicked : (UIButton *)btn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag-500 inSection:0];
    selectedIndexPath = indexPath;
    
    UIAlertView *alertDelete = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Do you want to remove this product from the cart?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alertDelete.tag = 1010;
    [alertDelete show];
    
}
-(IBAction)selectReturn:(UIButton*)sender
{
    NSLog(@"%ld",(long)sender.tag);
    
}

#pragma mark - Resize image.
-(UIImage*)imageWithImage:(UIImage*)image //scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext(CGSizeMake(113.0, 145.0));
    [image drawInRect:CGRectMake(0,0,113.0,145.0)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



#pragma mark - Status Bar Hidden Default
- (BOOL)prefersStatusBarHidden {
    return YES;
}



@end
