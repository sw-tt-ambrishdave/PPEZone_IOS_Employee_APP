

#import "AFHTTPRequestOperationManager.h"

@interface PPEZoneEmployee : AFHTTPRequestOperationManager
+ (PPEZoneEmployee *)sharedClient;
- (id)initWithBaseURL:(NSURL *)url;

@end
