//
//  RegistrationViewController.h
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface RegistrationViewController : UIViewController
{
    BOOL isForTouristBool;
}
@property (nonatomic, readwrite) BOOL isForTouristBool;
@property (nonatomic, assign) BOOL verificationCodeEnabled;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andWithType:(BOOL) isForTourist;

@end
