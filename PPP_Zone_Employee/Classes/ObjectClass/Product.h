

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic, strong) NSString *strProductName,*strProductID,*strProductImage;
@property (nonatomic, strong) NSArray *arrProductAttribute;
@property (nonatomic, strong) NSMutableArray *arrayAllProductAttributes;
@property (nonatomic, strong) NSArray *arrIndependentAttribute;
@property (nonatomic, strong) NSMutableDictionary *dictOfAllAttributes;
@property (nonatomic, strong) NSMutableArray *arrOfSelectedAttributeValues;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic,strong) NSString *strAtteributeName;
@property (nonatomic,strong) NSString *strProductAttrId;
@end
