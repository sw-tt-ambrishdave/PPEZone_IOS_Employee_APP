//
//  PPEZoneEmployee.h
//  PPP_Zone_Employee
//
//  Created by Tejas Shah on 13/04/15.
//  Copyright (c) 2015 Tejas Shah. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface PPEZoneEmployee : AFHTTPRequestOperationManager
{
    
}
+ (PPEZoneEmployee *)sharedClient;
- (id)initWithBaseURL:(NSURL *)url;

@end
