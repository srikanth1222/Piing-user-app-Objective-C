//
//  AddAddressViewController.h
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressFeild.h"

@protocol AddAddressViewControllerDelegate <NSObject>

-(void) didAddNewAddress;

@end

@interface AddAddressViewController : UIViewController

@property (nonatomic, strong) id <AddAddressViewControllerDelegate> delegate;

@property (nonatomic, strong) AddressFeild *addressFeild;
@property (nonatomic, assign) BOOL isEditingAddress;
@property (nonatomic, assign) BOOL isFromReg;
@end
