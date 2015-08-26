//
//  Attributes.h
//  PPP_Zone_Employee
//
//  Created by Diken Shah on 8/13/15.
//  Copyright (c) 2015 Tejas Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attributes : NSObject
@property (nonatomic, strong) NSString *strAttributeTitle,*strAttributeID,*strAttributeValue,*strAttributeValueID;
@property (nonatomic, assign) BOOL isAttributeSelect;
@property (nonatomic, assign) BOOL is_dependent;
@property (nonatomic, strong) NSString *strUPC_Code;
@property (nonatomic, assign) int product_attr_id;
@property (nonatomic, assign) float stock;
@end
