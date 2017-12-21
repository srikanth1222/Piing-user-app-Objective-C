//
//  BookViewController.h
//  Piing
//
//  Created by Piing on 10/31/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressFeild.h"
#import "BraintreeCore.h"
#import "BraintreeCard.h"
#import "MyBookingViewController.h"



@class SevenSwitch;

@interface BookViewController : UIViewController {
    
}

@property (nonatomic, strong) id <MyBookingViewControllerDelegate> delegate;

@property (nonatomic, strong) BTAPIClient *braintree;

@property (nonatomic, retain) NSDictionary *selectedAddress;

@property (nonatomic, retain) NSArray *userAddresses;
@property (nonatomic, retain) NSArray *userSavedCards;

@property (nonatomic, retain) AddressFeild *addressField;

@property (nonatomic, retain) NSString *bookNowCobID;
@property (nonatomic, retain) NSString *piingoName;
@property (nonatomic, retain) NSString *piingoImg;
@property (nonatomic, strong) NSString *piingoId;

//@property (nonatomic, retain) NSMutableArray *usersavedCardArray;
@property (nonatomic, strong) NSDictionary *dictBookNowDetails;

@property (nonatomic, retain) NSMutableDictionary *orderEditDetails;
@property (nonatomic, retain) NSMutableDictionary *dictAllowUpdates;

@property (nonatomic, strong) NSString *bookNowETAStr;
@property (nonatomic, assign) BOOL isCurrentTimeSlot;

@property (nonatomic, assign) BOOL isFromBookNow;
@property (nonatomic, assign) BOOL isFromOrdersList;
@property (nonatomic, strong) NSString *bookNowPT;

@property (nonatomic, assign) BOOL isBookNowStarted;
@property (nonatomic, strong) NSString *strFinalAmount;

-(void) updateOrderDetails;

-(void) callPreviewAction:(NSString *) strActionType;

@end
