

#import "UITextField+EdgetTextField.h"

@implementation UITextField (EdgetTextField)
// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 0 );
}





@end
