

#import <Foundation/Foundation.h>

@interface Employee : NSObject
@property (nonatomic, strong) NSString *strEmpFirstName,*strEmpLastName,*strEmpID,*strJobZoneName;
@property (nonatomic, assign) int intEmpJobZoneID;
@property (nonatomic, strong) NSString *strFaceNodes;
@property (nonatomic, strong) NSString *strEmpImage;
@property (nonatomic, strong) NSString *strBarcode;
@property (nonatomic, assign) int intAppUserID;
@end
