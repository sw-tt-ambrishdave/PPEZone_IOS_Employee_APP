

#import "Product.h"

@implementation Product
@synthesize strProductID,strProductImage,strProductName,arrProductAttribute,isSelected,strAtteributeName,strProductAttrId;
@synthesize arrIndependentAttribute,arrayAllProductAttributes,dictOfAllAttributes,arrOfSelectedAttributeValues;

- (id)init
{
    self = [super init];
    if (self) {
        //        NSLog(@"Init method of Participants called");
        
        if (arrayAllProductAttributes != nil && [arrayAllProductAttributes count] >0) {
            [arrayAllProductAttributes removeAllObjects];
        }else{
            arrayAllProductAttributes = [[NSMutableArray alloc] init];
        }
        
        if (dictOfAllAttributes != nil && [dictOfAllAttributes count] >0) {
            [dictOfAllAttributes removeAllObjects];
        }else{
            dictOfAllAttributes = [[NSMutableDictionary alloc] init];
        }
        
        if (arrOfSelectedAttributeValues != nil && [arrOfSelectedAttributeValues count] >0) {
            [arrOfSelectedAttributeValues removeAllObjects];
        }else{
            arrOfSelectedAttributeValues = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

@end
