//
//  ViewBillDetailsController.h
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewBillDetailsController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tblViewBill;
}

@property (nonatomic, strong) NSMutableDictionary *dictViewBill;
@property (nonatomic, strong) NSString *strWashType;

@end
