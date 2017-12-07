//
//  PriceListViewController.h
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"


@protocol PriceListViewController_NewDelegate <NSObject>

-(void) didDismissPricingView;

@end


@interface PriceListViewController_New : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
   
}

@property (nonatomic, strong) id <PriceListViewController_NewDelegate> delegate;

@property (nonatomic, assign) BOOL isFlipping;
@property (nonatomic, assign) BOOL isFromWelcome;
@property (nonatomic, strong) NSString *selectedServiceTypeId;


@end
