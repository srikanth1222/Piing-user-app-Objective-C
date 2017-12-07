//
//  RegistrationFeilds.h
//  Ping
//
//  Created by SHASHANK on 26/01/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegistrationFeilds : NSObject

@property (nonatomic, retain) NSString * businessType; //Default 1
@property (nonatomic, retain) NSString * userType; //Default 1
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * dateOfBirth; //two digit date of birth
@property (nonatomic, retain) NSString * monthOfBirth; //digit month of birth
@property (nonatomic, retain) NSString * title; //Mr, mrs etc //Default 1
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * cellPhone;
@property (nonatomic, retain) NSString * imei;
@property (nonatomic, retain) NSString * source; //Default value from mobilr is 'm'
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * alternatePhone;
@property (nonatomic, retain) NSString * referalCode;
@property (nonatomic, retain) NSString * extn_Number;

@end
