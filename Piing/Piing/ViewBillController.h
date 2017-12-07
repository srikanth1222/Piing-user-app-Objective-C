//
//  ViewBillController.h
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBillController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{

}

@property (nonatomic, strong) NSString *strCobID;
@property (nonatomic, strong) NSString *strPaymentType;
@property (nonatomic, strong) NSString *strUserId;
@property (nonatomic, assign) BOOL isPartialBill;

@end
