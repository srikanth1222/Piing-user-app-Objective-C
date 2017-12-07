//
//  MyBookingViewController.h
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyBookingViewControllerDelegate <NSObject>

-(void) callParentControll:(NSString *) methodType;

@end


@interface MyBookingViewController : UIViewController

@end
