//
//  PPEZoneEmployee.m
//  PPP_Zone_Employee
//
//  Created by Tejas Shah on 13/04/15.
//  Copyright (c) 2015 Tejas Shah. All rights reserved.
//

#import "PPEZoneEmployee.h"
#import "Constant.h"

@implementation PPEZoneEmployee

NSString * const kWFBaseURLString = BASE_URL;
static PPEZoneEmployee * _sharedClient = nil;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithBaseURL:(NSURL *)url
{
    NSLog(@"%s",__FUNCTION__);
    NSURL *finalURL;
    finalURL = url;
    self = [super initWithBaseURL:finalURL];
    if (!self) {
        return nil;
    }
    
    return self;
}

+ (PPEZoneEmployee *)sharedClient
{
    @synchronized(self) {
        if (_sharedClient == nil) {
            
            _sharedClient = [[PPEZoneEmployee alloc] initWithBaseURL:[NSURL URLWithString:kWFBaseURLString]];
        }
    }
    return _sharedClient;
}

@end
