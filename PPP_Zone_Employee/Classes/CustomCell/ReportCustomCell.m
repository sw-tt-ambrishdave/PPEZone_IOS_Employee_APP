
#import "ReportCustomCell.h"

@implementation ReportCustomCell
@synthesize lblSep1;
@synthesize lblEmpID,lblEmpName,lblInTime,lblOutTime,lblProductID,lblProductName;
@synthesize btnNotes,btnCancel;
@synthesize indicator,lblAttributeName;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
