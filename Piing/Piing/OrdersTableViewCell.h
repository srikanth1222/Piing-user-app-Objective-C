//
//  OrdersTableViewCell.h
//  Ping
//
//  Created by SHASHANK on 15/05/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableViewCell : UITableViewCell
{
    UILabel *orderNumberLabel;
    UILabel *orderTypeLbl;
    UILabel *pickupdateLbl, *deliveryDateLbl;
    UILabel *pickupSlotLbl, *deliverySlotLbl;
    
    UILabel *orderStatusLbl;
    UILabel *orderCostLbl;
    
    UIImageView *piingoUserImageView;
}

-(void) setDetails:(id) details andCellType:(int) cellType;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andWithDelegate:(id) delegate;
@end
