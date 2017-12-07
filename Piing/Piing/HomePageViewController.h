//
//  HomePageViewController.h
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTableController.h"


@interface HomePageViewController : UIViewController <DemoTableControllerDelegate>

@property (nonatomic, retain) NSArray *userSavedCards;

- (void) loadAPIForBookNowStatus;

@end
