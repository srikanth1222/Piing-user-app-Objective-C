//
//  AddressFeild.h
//  Ping
//
//  Created by SHASHANK on 26/01/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressFeild : NSObject

@property (nonatomic, retain) NSString * userID;

@property (nonatomic, retain) NSString * addressName;
@property (nonatomic, retain) NSString * addressLine1;
@property (nonatomic, retain) NSString * addressLine2;
@property (nonatomic, retain) NSString * zipCode;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * landmark;
@property (nonatomic, retain) NSString * addressType;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * isAddressDefault;

@property (nonatomic, retain) NSString * addressID;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lng;

@property (nonatomic, retain) NSString * token;

@property (nonatomic, strong) NSString *fno;
@property (nonatomic, strong) NSString *uno;

@property (nonatomic, assign) BOOL fnoApplicable;
@property (nonatomic, assign) BOOL unoApplicable;

-(void) clearInfo;

@end
