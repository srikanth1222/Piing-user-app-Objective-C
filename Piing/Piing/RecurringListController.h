//
//  RecurringListController.h
//  Piing
//
//  Created by Veedepu Srikanth on 21/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecurringListController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tblRecurring;
    
    NSMutableArray *arrayRecurringList;
    
    UIButton *EditButton;
}

@end
