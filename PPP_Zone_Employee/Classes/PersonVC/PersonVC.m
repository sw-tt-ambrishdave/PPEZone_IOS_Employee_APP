
#import "PersonVC.h"
#import "ViewController.h"
#import "saftyToolsVC.h"
#import "ReturnItemsVC.h"


@interface PersonVC ()

@end


@implementation PersonVC
@synthesize cellObj;

- (void)viewDidLoad {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    
    if ([APP_DELEGATE.arrayProductSelect count] > 0 && APP_DELEGATE.arrayProductSelect != nil) {
        [APP_DELEGATE.arrayProductSelect removeAllObjects];
    }
    
    [super viewDidLoad];
    
    if ([APP_DELEGATE.showreturn isEqualToString:@"0"]) {
        btnFinish.frame = CGRectMake(105, 964.0, 240, 50.0);
        btnWishList.frame = CGRectMake(415, 964.0, 240, 50.0);
        btnReturnInventory.hidden = YES;
    }
    else {
        btnReturnInventory.hidden = NO;
        btnFinish.frame = CGRectMake(13, 964.0, 240, 50.0);
        btnWishList.frame = CGRectMake(264, 964.0, 240, 50.0);
        btnReturnInventory.frame = CGRectMake(515, 964.0, 240, 50.0);
    }
    
    APP_DELEGATE.currentViewController = self;
    
    // Do any additional setup after loading the view.
    
    viewTableContainer.hidden = YES;
    viewWishlistContainer.hidden = YES;
    viewTableContainer.frame = CGRectMake(self.view.frame.size.width + 1.0, viewTableContainer.frame.origin.y,viewTableContainer.frame.size.width, viewTableContainer.frame.size.height);
    arrayToolSelected = [[NSMutableArray alloc]init];
    
    
    [arrayToolSelected addObject:@{@"name":@"The Peak A79 Csa Type1",@"ImageName":@"img_1.png"}];
    [arrayToolSelected addObject:@{@"name":@"The Peak A79 Csa Type1",@"ImageName":@"img_2.png"}];
    [arrayToolSelected addObject:@{@"name":@"The Peak A79 Csa Type1",@"ImageName":@"img_3.png"}];
    [arrayToolSelected addObject:@{@"name":@"The Peak A79 Csa Type1",@"ImageName":@"img_4.png"}];
    [arrayToolSelected addObject:@{@"name":@"The Peak A79 Csa Type1",@"ImageName":@"img_5.png"}];
    [arrayToolSelected addObject:@{@"name":@"The Peak A79 Csa Type1",@"ImageName":@"img_1.png"}];
    [arrayToolSelected addObject:@{@"name":@"The Peak A79 Csa Type1",@"ImageName":@"img_2.png"}];
    
    [tblView registerNib:[UINib nibWithNibName:@"selectedCell" bundle:nil]
  forCellReuseIdentifier:@"Cell"];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void)viewWillAppear:(BOOL)animated
{
    if ([APP_DELEGATE.arrayProductSelect count] > 0) {
        
        [btnFinish setImage:[UIImage imageNamed:@"btn_cart.png"] forState:UIControlStateNormal];
    }
    else {
        
        [btnFinish setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
    }
    
    viewTableContainer.hidden = YES;
    viewTableContainer.frame = CGRectMake(self.view.frame.size.width + 225.0, viewTableContainer.frame.origin.y,viewTableContainer.frame.size.width, viewTableContainer.frame.size.height);
    CGRect frame = pppManView.frame;
    frame.origin.y = pppManView.frame.origin.y;
    frame.origin.x = 0.0;
    pppManView.frame = frame;
    [btnHistory setImage:[UIImage imageNamed:@"history.png"] forState:UIControlStateNormal];
}

#pragma mark - Return Inventory
-(IBAction)ReturnInventory:(id)sender
{
    // returnSegue
    [self performSegueWithIdentifier:SEGUE_RETURN_INVENTORY sender:self];
}


#pragma mark - Table View Delegate & DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1010) {
        return [APP_DELEGATE.arrayProductSelect count];
    }else{
        return [arrayWishListProducts count];
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
        UIImage *placeholderImage = [UIImage imageNamed :@"profile_dummy.png"];
        cell.lblProductID.text = objProduct.strProductID;
        [cell.indicator startAnimating];
        [cell.imgProduct setImageWithURL:imageURL
                        placeholderImage:placeholderImage
                                 options:SDWebImageRefreshCached
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             [cell.indicator stopAnimating];
         }];
        cell.btnCancel.tag = indexPath.row + 500;
        [cell.btnCancel addTarget:self action:@selector(btnDeleteProductClicked:) forControlEvents:UIControlEventTouchUpInside];
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    else{
       __weak ReportCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReportCustomCell"];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ReportCustomCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:2];
        }
        
        Product *objProduct = [arrayWishListProducts objectAtIndex:indexPath.row];
        cell.lblProductName.text = objProduct.strProductName;
        NSURL *imageURL = [NSURL URLWithString:objProduct.strProductImage];
        UIImage *placeholderImage = [UIImage imageNamed :@"profile_dummy.png"];
        cell.lblProductID.text = objProduct.strProductID;
        cell.lblAttributeName.text = objProduct.strAtteributeName;
        [cell.indicator startAnimating];
        [cell.imgProduct setImageWithURL:imageURL
                        placeholderImage:placeholderImage
                                 options:SDWebImageRefreshCached
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             [cell.indicator stopAnimating];
         }];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSLog(@"Deleted row.");
}

#pragma mark - Resize image.
-(UIImage*)imageWithImage:(UIImage*)image {
    UIGraphicsBeginImageContext(CGSizeMake(113.0, 145.0));
    [image drawInRect:CGRectMake(0,0,113.0,145.0)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
                             CGRect frame = pppManView.frame;
                             frame.origin.y = pppManView.frame.origin.y;
                             frame.origin.x = 0.0;
                             pppManView.frame = frame;
                             
                             CGRect frame1 = viewTableContainer.frame;
                             frame1.origin.y = viewTableContainer.frame.origin.y;
                             frame1.origin.x = self.view.frame.size.width + 1.0; //225.0;
                             viewTableContainer.frame = frame1;
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
                             CGRect frame = pppManView.frame;
                             frame.origin.y = pppManView.frame.origin.y;
                             frame.origin.x = (-225);
                             pppManView.frame = frame;
                             CGRect frame1 = viewTableContainer.frame;
                             frame1.origin.y = viewTableContainer.frame.origin.y;
                             frame1.origin.x = self.view.frame.size.width - 225.0;
                             viewTableContainer.frame = frame1;
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
-(IBAction)btnDoneClicked:(id)sender
{

    UIButton *btnSelect = (UIButton *)sender;
    if (APP_DELEGATE.isInternetOn == TRUE) {
        if (btnSelect.tag == 100) {
            [self call_WS_Saft_Product_Issue:1];
        }else if(btnSelect.tag == 300)
        {
            for (Product *objProduct in arrayWishListProducts) {
                
              NSPredicate *temp = [NSPredicate predicateWithFormat:@"self.strProductID = %@",objProduct.strProductID];
                
                NSArray *dataTemp = [APP_DELEGATE.arrayProductSelect filteredArrayUsingPredicate:temp];
                if ([dataTemp count] == 0) {
                    [APP_DELEGATE.arrayProductSelect addObject:objProduct];
                }
            }
            viewTableContainer.hidden = YES;
            viewWishlistContainer.hidden = YES;
            
            
            if ([APP_DELEGATE.arrayProductSelect count] > 0) {
                
                [btnFinish setImage:[UIImage imageNamed:@"btn_cart.png"] forState:UIControlStateNormal];
            }
            else {
                
                [btnFinish setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
            }
            
            [self finish:self];
            
        }
        else{
            [self call_WS_Saft_Product_Issue:0];
        }
    }else if(btnSelect.tag == 300)
    {
        for (Product *objProduct in arrayWishListProducts) {
            [APP_DELEGATE.arrayProductSelect addObject:objProduct];
        }
    }
    else{
        [Utility offlineMessage];
    }
    
}
-(IBAction)btnWishListClicked:(id)sender
{
    if ([arrayWishListProducts count] > 0 && arrayWishListProducts != nil) {
        [arrayWishListProducts removeAllObjects];
    }else{
        arrayWishListProducts = [[NSMutableArray alloc] init];
    }
   
    if (APP_DELEGATE.isInternetOn == TRUE) {
        [self call_WS_WishList_Product_List];
        
    }else{
        [Utility offlineMessage];
    }
}
-(void) btnDeleteProductClicked : (UIButton *)btn
{
    UIAlertView *alertDelete = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Do you want to remove this product from the cart?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alertDelete.tag = 1010;
    [alertDelete show];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag-500 inSection:0];
//
    selectedIndexPath = indexPath;
}
#pragma mark - UIAlertview Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1010) {
        if (buttonIndex == 0) {
            //NSLog(@"OK Clicked");
            [APP_DELEGATE.arrayProductSelect removeObjectAtIndex:selectedIndexPath.row];
            [tblViewFinal deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            if ([APP_DELEGATE.arrayProductSelect count] == 0) {
                viewTableContainer.hidden = YES;
                viewWishlistContainer.hidden = YES;
                [btnFinish setImage:[UIImage imageNamed:@"btn_back.png"] forState:UIControlStateNormal];
            }
            
        }else{
           // NSLog(@"Cancel Clicked");
        }
    }else if (alertView.tag == 1011){
        if (buttonIndex == 0) {
           // NSLog(@"OK Clicked");
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
           // NSLog(@"Cancel Clicked");
        }
    }
}
#pragma mark - Select Safty Tools
-(IBAction)selectSaftyTools:(id)sender
{
    //UIButton *btn = (UIButton *)sender;
    tagCheck =[sender tag];
    [self performSegueWithIdentifier:SEGUE_SAFETY_TOOLS sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_SAFETY_TOOLS])
    {
        saftyToolsVC *objVC =(saftyToolsVC *)segue.destinationViewController;
        
        switch (tagCheck) {
            case 13:
                objVC.titleToolName = @"Head";
                objVC.tagNumber = @"13";
                
                break;
            case 14:
                objVC.titleToolName = @"Upper Torso";
                objVC.tagNumber = @"14";
                break;
                
            case 15:
                objVC.titleToolName = @"Hands";
                objVC.tagNumber = @"15";
                break;
                
            case 16:
                objVC.titleToolName = @"Legs";
                objVC.tagNumber = @"16";
                break;
                
            case 17:
                objVC.titleToolName = @"Feet";
                objVC.tagNumber = @"17";
                break;
                
            default:
                break;
        }
    }
    else if ([segue.identifier isEqualToString:SEGUE_RETURN_INVENTORY])
    {
        //loginVC *objVC =(loginVC *)segue.destinationViewController;
        //ReturnItemsVC *objVC = (ReturnItemsVC *)segue.destinationViewController;
    }
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
          /*
        if (![obj.strAtteributeName isEqualToString:@""]) {
            
          if ([obj.arrProductAttribute isKindOfClass:[NSArray class]]) {
            
               
                    NSPredicate *test1 = [NSPredicate predicateWithFormat:@"self.value_title == %@",obj.strAtteributeName];
                    NSArray *temp = [obj.arrProductAttribute filteredArrayUsingPredicate:test1];
                    [dictProducts setObject:temp forKey:PRODUCT_ISSUE_ATTRIBUTE];
                

            }
            else if([obj.arrProductAttribute isKindOfClass:[NSDictionary class]]) {
                
                NSArray *temp = [[NSArray alloc]initWithObjects:obj.arrProductAttribute, nil];
                [dictProducts setObject:temp  forKey:PRODUCT_ISSUE_ATTRIBUTE];
            }
            else {
                
                [dictProducts setObject:obj.arrProductAttribute forKey:PRODUCT_ISSUE_ATTRIBUTE];
            }
        }
    else {
        [dictProducts setObject:obj.strProductName forKey:PRODUCT_TITLE];
    }
           */

        [arraySelectedProducts addObject:dictProducts];
        dictProducts = nil;
    }
    
    [dictParameter setObject:arraySelectedProducts forKey:@"products"];
    
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_PRODUCT_ISSUE];
    
    [APP_DELEGATE addProgressHUD:self];
    [PPEZoneEmployee sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"Responce ***** %@",responseObject);
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
        //NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to issue inventories"];
    }];
}

-(void) call_WS_WishList_Product_List
{
    if (dictParameter) {
        [dictParameter removeAllObjects];
    }
    else{
        dictParameter = [[NSMutableDictionary alloc] init];
    }
    [dictParameter setObject:[NSNumber numberWithInt:[[Utility getUserDefaultValueForKey:UD_COMPANY_ID] intValue]] forKey:COMPANY_ID];
    [dictParameter setObject:APP_DELEGATE.employee_id forKey:PRODUCT_ISSUE_USER_ID];
    NSString *actionAndPHP=[NSString stringWithFormat:@"services.php?action=%@",ACTION_WISHLIST_PRODUCTLIST];
    
    [APP_DELEGATE addProgressHUD:self];
    [PPEZoneEmployee sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
    
    [[PPEZoneEmployee sharedClient] POST:actionAndPHP parameters:dictParameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Responce ***** %@",responseObject);
        BOOL responseStatus = [[responseObject valueForKey:SUCCESS] boolValue];
        if (responseStatus == TRUE)
        {
            [APP_DELEGATE.progressHUD hide:YES];
            if (arrayWishListProducts != nil && [arrayWishListProducts count] > 0)
                [arrayWishListProducts removeAllObjects];
            else
                arrayWishListProducts = [[NSMutableArray alloc] init];
            
            NSArray *detailArray = [responseObject valueForKey:@"products"];
            if ([detailArray count] > 0) {
                for (NSDictionary *dictProduct in detailArray)
                {
                    Product *objProduct = [[Product alloc] init];
                    objProduct.strProductName = [dictProduct valueForKey:PRODUCT_TITLE];
                    objProduct.strProductImage = [dictProduct valueForKey:PRODUCT_IMAGE];
                    objProduct.strProductID = [dictProduct valueForKey:PRODUCT_ID];
                    objProduct.strProductAttrId = [dictProduct valueForKey:PRODUCT_ATTRIBUTE_ID];
                    if([dictProduct valueForKey:PRODUCT_ATTRIBUTES_VALUE] == (NSString *)[NSNull null] || [dictProduct valueForKey:PRODUCT_ATTRIBUTES_VALUE] == 0 || [[dictProduct valueForKey:PRODUCT_ATTRIBUTES_VALUE] isKindOfClass:[NSNull class]] || [[dictProduct valueForKey:PRODUCT_ATTRIBUTES_VALUE] count] == 0)
                    {
                        objProduct.arrProductAttribute = nil;
                        objProduct.strAtteributeName = @"";
                    }
                    else
                    {
                        objProduct.arrProductAttribute = [dictProduct valueForKey:PRODUCT_ATTRIBUTES_VALUE];
                        NSLog(@"%@",objProduct.arrProductAttribute);
                      
                        
                        NSLog(@"DATA ---- %@",[dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES]);
                        for (NSDictionary *dict in [dictProduct valueForKey:PRODUCT_ALL_ATTRIBUTES]) {
                            Attributes *objAttribute = [[Attributes alloc] init];
                            objAttribute.strAttributeTitle = [dict valueForKey:@"attr_title"];
                            objAttribute.strAttributeID = [dict valueForKey:@"attr_id"];
                            objAttribute.strAttributeValueID = [dict valueForKey:@"value_id"];
                            objAttribute.strAttributeValue = [dict valueForKey:@"value_title"];
                            
                            objAttribute.is_dependent = [[dict valueForKey:@"is_dependent"] boolValue];
                            objAttribute.strUPC_Code = [Utility checkNullORBlankString:[dict valueForKey:@"upc_code"]];
                            objAttribute.product_attr_id = [[dict valueForKey:@"product_attr_id"] intValue];
                            objAttribute.stock = [[dict valueForKey:@"stock"] floatValue];
                            
                            [objProduct.arrOfSelectedAttributeValues addObject:objAttribute];
                            objAttribute = nil;
                        }
                    }
                    NSString *strAttributeName = [dictProduct valueForKey:PRODUCT_ATTRIBUTE_DETAILS];
                    objProduct.strAtteributeName = [strAttributeName stringByReplacingOccurrencesOfString:@"<br/>" withString:@", "];
                    
                    objProduct.isSelected = YES;
                    [arrayWishListProducts addObject:objProduct];
                    objProduct = nil;
                }
                if ([arrayWishListProducts count] > 0) {
                    if (viewWishlistContainer.hidden == YES) {
                        viewWishlistContainer.hidden = NO;
                        viewWishlistContainer.layer.cornerRadius = 10.0;
                        viewWishlistContainer.layer.masksToBounds = YES;
                        viewWishlistContainer.frame = CGRectMake(0, 0, 768, 1024);
                        [self bounceAnimation:viewWishlistContainer];
                        [tblView reloadData];
                    }
                }
            }
            else {
                [Utility failedMessage:[responseObject valueForKey:@"products"]];
            }
        }
        else
        {
            [Utility failedMessage:[responseObject valueForKey:MESSAGE]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error ***** %@",error);
        [Utility failedMessage:@"Failed to issue inventories"];
    }];
}
-(void)dismissIndicator
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - Finish
-(IBAction)finish:(id)sender
{
    if ([APP_DELEGATE.arrayProductSelect count] > 0) {
        if (viewTableContainer.hidden == YES) {
            viewTableContainer.hidden = NO;
            viewSubTblContainer.layer.cornerRadius = 10.0;
            viewTableContainer.layer.masksToBounds = YES;
            viewTableContainer.frame = CGRectMake(0, 0, 768, 1024);
            [self bounceAnimation:viewTableContainer];
            [tblViewFinal reloadData];
        }
    }
    else
    {
        UIAlertView *alertDelete = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Do you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alertDelete.tag = 1011;
        [alertDelete show];

    }
    
}

#pragma mark - back
-(IBAction)logOut:(id)sender
{
    UIAlertView *alertDelete = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Do you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alertDelete.tag = 1011;
    [alertDelete show];
}


#pragma mark - Status Bar Hidden Default
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
