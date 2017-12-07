//
//  ViewBillController.h
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBillEstimatorController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *dictMain;
@property (nonatomic, strong) NSString *strTotalPrice;

@end
