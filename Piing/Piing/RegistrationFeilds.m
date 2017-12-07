//
//  RegistrationFeilds.m
//  Ping
//
//  Created by SHASHANK on 26/01/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "RegistrationFeilds.h"

@implementation RegistrationFeilds

-(id)init {
    if (self = [super init])  {
        
        self.businessType = @"1";       //Default 1
        self.userType = @"1";           //Default 1
        self.title = @"1";              //Default 1
        self.source = @"m";             //'m' for mobile 'w' for web
        
        self.emailAddress = @"";
        self.password = @"";
        self.dateOfBirth = @"15"; //two digit date of birth
        self.monthOfBirth = @"10"; //digit month of birth
        self.firstName = @"";
        self.lastName = @"";
        self.cellPhone = @"";
        self.imei = @"IMEI";
        self.token = @"rfIJlk22kds"; // Need to find how to get token
        self.alternatePhone = @"";
        self.referalCode = @"";
        self.extn_Number = @"";
    }
    return self;
}
@end
