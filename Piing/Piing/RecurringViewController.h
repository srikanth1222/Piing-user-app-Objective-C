//
//  RecurringViewController.h
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"

#define RECURRING_SCREEN_TAG 50

@interface RecurringViewController : UIViewController
{
   

}

@property (nonatomic, assign) BOOL isBackFromDeliveryView;

@property (nonatomic, retain) NSArray *userAddresses;
@property (nonatomic, retain) NSMutableDictionary *recurringInfo;
@property (nonatomic, retain) NSMutableArray *pickUpDates;

@end
