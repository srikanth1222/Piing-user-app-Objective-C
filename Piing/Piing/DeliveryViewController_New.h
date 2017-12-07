//
//  DeliveryViewController.h
//  Piing
//
//  Created by Piing on 10/24/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BraintreeCore.h"
#import "BraintreeCard.h"



@interface DeliveryViewController_New : UIViewController

@property(nonatomic, retain) NSMutableDictionary *orderInfo;

@property (nonatomic, strong) BTAPIClient *braintree;

@property (nonatomic, retain) NSArray *userAddresses;

@property (nonatomic, retain) NSArray *userSavedCards;

@property (nonatomic, assign) BOOL isFromRecurring;
@property (nonatomic, assign) BOOL isFromUpdateOrder;
@property (nonatomic, strong) NSMutableDictionary *dictAllowFields;
@property (nonatomic, strong) NSMutableDictionary *dictChangedValues;

@property (nonatomic, strong) NSMutableDictionary *arrayAllOrderDetails;

@end
