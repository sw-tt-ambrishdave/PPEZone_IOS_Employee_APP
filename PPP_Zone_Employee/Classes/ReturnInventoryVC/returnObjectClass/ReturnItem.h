
#import <Foundation/Foundation.h>

@interface ReturnItem : NSObject
@property (nonatomic, strong) NSString *strProductName,*strProductID;
@property (nonatomic, strong) NSString *strProductOutTime;
@property (nonatomic, strong) NSString *strDefectNote;
@property (nonatomic, strong) NSString *strProductImage;
@property (nonatomic, strong) NSString *strAttributeName;
@property (nonatomic, assign) BOOL isReturn;
@end
