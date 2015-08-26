
#ifndef TapCloud_Constant_h
#define TapCloud_Constant_h


#endif



#define APP_DELEGATE    ((AppDelegate *) [[UIApplication sharedApplication] delegate])

#pragma mark - check ios version and Screen

#define IOS_NEWER_OR_EQUAL_TO_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#pragma mark - TEXTFIELD MAX LENGTH
#define MAXLENGTH 255


#pragma mark - Font

#define APP_TITLE @"PPE ZONE"
#define INTERNET_CONNECTIVITY_STATUS             @"This functionality is not available while not connected to the Internet (offline)"

#define HelveticaNeue_CondensedBold    @"HelveticaNeue-CondensedBold"

#define AppFontWithSize(object,float) {[object setFont:[UIFont fontWithName:HelveticaNeue_CondensedBold size:float]];}
#define SETCORNER(Object,float) if(Object){[Object.layer setMasksToBounds:YES];[Object.layer setCornerRadius:float];}

#pragma mark - COLORS LIST
#define THEME_COLOR [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0] //[UIColor colorWithRed:247.0/255.0 green:235.0/255.0 blue:114.0/255.0 alpha:1.0]

#define MAX_LENGTH  40
#define TEXTFIELD_PLACEHOLDER_COLOR [UIColor darkGrayColor]

#define COLOR_NAVIGATIONBAR [UIColor colorWithRed:27.0f/255.0f green:158.0f/255.0f blue:241.0f/255.0f alpha:1.0]

/************* Webservice URL****************/
#pragma mark - Webservice Contents
//#define BASE_URL    @"http://192.168.3.195/ppezone/services"
#define BASE_URL @"http://ppezone.com/demo/services"

#pragma mark - WS COMMON Keys

#define COMPANY_ID  @"company_id"
#define JOBE_ZONE   @"jobzones"
#define SUCCESS  @"success"
#define EMPLOYEES @"employees"
#define MESSAGE @"message"

#pragma mark - WS Action Keys
#define ACTION_JOBZONE  @"getregisteredjobzones"
#define ACTION_EMP_REGISTRATION  @"employeeregistration"
#define ACTION_EMP_SEARCH  @"searchregisteredemployee"
#define ACTION_LOGIN    @"loginauth"
#define ACTION_PRODUCT_LIST @"getproductlist"
#define ACTION_PRODUCT_ISSUE @"requesttoissueproducts"
#define ACTION_RETURN_PRODUCT_LIST @"getproductstoreturn"
#define ACTION_RETURN_PRIDUCT_SELECTED_LIST @"requesttoreturnproducts"
#define ACTION_WISHLIST_PRODUCTLIST    @"requestwishlistproducts"
#define ACTION_ASSIGN_EMPLOYEE_IMAGE @"assignimagetoemployee"
#define ACTION_GET_SCANTIME @"getscantimer"

#pragma mark - WS_JobZone Keys
#define JOB_ID  @"id"
#define JOB_TITLE   @"job_title"

#pragma mark - WS_Employee Registration
#define EMPLOYEE_ID @"employee_id"
#define EMPLOYEE_FIRSTNAME  @"firstname"
#define EMPLOYEE_LASTNAME   @"lastname"
#define EMPLOYEE_FACENODES  @"facenodes"
#define EMPLOYEE_IMAGE  @"image"
#define EMPLOYEE_JOBZONE_ID @"jobzone_id"
#define EMPLOYEE_JOBZONE_NAME @"job_title"
#define EMPLOYEE_USER_ID @"user_id"
#define EMPLOYEE_PASSWORD   @"password"
#define EMPLOYEE_CONFIRM_PASSWORD   @"confirm_password"
#define EMPLOYEE_BARCODE    @"barcode"

#pragma mark - WS_Employee Search
#define EMPLOYEE_SEARCH @"search"
#define EMPLOYEE_APP_USER_ID    @"app_user_id"

#pragma mark - WS_Login
#define EMPLOYEE_LOGIN_FACENODES @"facenodes"

#pragma mark - UserDefault Keys

#define UD_COMPANY_ID   @"CompanyID"
#define UD_COMPANY_NAME @"CompanyName"

#pragma mark - Navigation Segue Keys
#define SEGUE_ENROLL  @"enrollSegue"
#define SEGUE_RETURN_PRODUCT @"pushReturnListSegue"
#define SEGUE_SCAN_IN @"pushScanINSegue"
#define SEGUE_LOGIN @"loginSegue"
#define SEGUE_RETURN_INVENTORY @"returnSegue"
#define SEGUE_SAFETY_TOOLS  @"saftySegue"

#pragma mark - Product List
#define PRODUCT_LIST_BODY_PART @"bodypart"
#define PRODUCT_LIST_EMPLOYEE_ID @"user_id"
#define PRODUCT_ID  @"product_id"
#define PRODUCT_TITLE @"product_title"
#define PRODUCT_IMAGE @"image"
#define PRODUCT_INDEPENDENT_ATTRIBUTES  @"independent_attributes"
#define PRODUCT_DEPENDENT_ATTRIBUTE @"dependent_attributes"
#define PRODUCT_ALL_ATTRIBUTES  @"attributes"

#pragma mark - Issue Product list
#define PRODUCT_ISSUE_USER_ID  @"user_id"
#define PORDUCT_ISSUE_PRODUCT_ID @"product_id"
#define PRODUCT_ISSUE_ATTRIBUTE @"attribute"
#define PRODUCT_ISSUE_ATTRIBUTE_TITLE @"value_title"
#define PRODUCT_ATTRIBUTE_ID @"product_attr_id"
#define PRODUCT_SUB_ATTRIBUTE_ID @"value_id"
#define PRODUCT_ATTRIBUTE_DETAILS   @"attribute_details"
#define PRODUCT_ATTRIBUTES_VALUE @"attributes"


#pragma mark - Return Product list
#define RETURN_PRODUCT_NAME @"product_title"
#define RETURN_PRODUCT_ID @"issue_id"
#define RETURN_PRODUCT_IMAGE @"image"
#define RETURN_PRODUCT_DATE @"issue_requested_at"

