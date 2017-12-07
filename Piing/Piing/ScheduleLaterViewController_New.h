//
//  ScheduleLaterViewController.h
//  Piing
//
//  Created by Piing on 10/23/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SevenSwitch;

@interface ScheduleLaterViewController_New : UIViewController

@property (nonatomic, retain) NSArray *userAddresses;
@property (nonatomic, retain) NSArray *userSavedCards;
@property (nonatomic, assign) BOOL isFromUpdateOrder;

@property (nonatomic, strong) NSMutableDictionary *dictUpdateOrder;
@property (nonatomic, retain) NSString *bookNowCobID;

@property (nonatomic, strong) NSMutableDictionary *dictChangedValues;

@property (nonatomic, strong) NSString *strPopupMessage;

@property (nonatomic, assign) BOOL isScheduleLaterOpened;
@property (nonatomic, strong) NSMutableDictionary *dictAllowFields;

@property (nonatomic, strong) NSMutableArray *arrayJobTypeOrg;

@property (nonatomic, strong) NSMutableDictionary *arrayAllOrderDetails;

@end
