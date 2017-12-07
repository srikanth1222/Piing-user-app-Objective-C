//
//  AddressFeild.m
//  Ping
//
//  Created by SHASHANK on 26/01/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "AddressFeild.h"

@implementation AddressFeild

-(id)init {
    if (self = [super init])  {
        
        [self clearInfo];
    }
    return self;
}

-(void) clearInfo
{
    self.userID = @"";              //User ID after login or register
    
    self.addressName = @"";
    self.addressLine1 = @"";
    self.addressLine2 = @"";
    self.zipCode = @"";//@"1";            //Temporary
    self.city = @"";
    self.state = @"";
    self.country = @"";
    self.landmark = @"";
    self.addressType = @"10";
    self.notes = @"";
    self.isAddressDefault = @"0";
    self.token = @"rfIJlk22kds";    // Need to find how to get token
    self.fno = @"";
    self.uno = @"";
    
    self.addressID = @"";           //After use Only
    self.lat = @"";           //After use Only
    self.lng = @"";           //After use Only

}
@end
