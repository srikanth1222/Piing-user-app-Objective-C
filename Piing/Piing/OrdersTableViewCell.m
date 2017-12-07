//
//  OrdersTableViewCell.m
//  Ping
//
//  Created by SHASHANK on 15/05/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "OrdersTableViewCell.h"
#define TEXT_COLOR [UIColor colorWithRed:128/255.0 green:127/255.0 blue:126/255.0 alpha:1.0]

#define BACKGROUND_LIGHT_GRAY_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0]
//227	225	226
#define BACKGROUND_MEDIUM_GRAY_COLOR [UIColor colorWithRed:227/255.0 green:225/255.0 blue:226/255.0 alpha:1.0]


@implementation OrdersTableViewCell
{
    AppDelegate *appDel;
}

- (void)awakeFromNib {
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andWithDelegate:(id) delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        appDel = [PiingHandler sharedHandler].appDel;
        
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
        
        float scrWidth = screen_width;
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        float onWidth = 104.4*MULTIPLYHEIGHT; //145
        
        float onX = 10.8*MULTIPLYHEIGHT;
        
        UIView *orderNumBgView = [[UIView alloc] initWithFrame:CGRectMake(onX, 10, scrWidth-(onX*2), onWidth)];
        orderNumBgView.backgroundColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.9];
        [self addSubview:orderNumBgView];
        orderNumBgView.layer.cornerRadius = 15.0;
        orderNumBgView.layer.masksToBounds = YES;
        
        NSInteger Width = orderNumBgView.frame.size.width;
        
        float onlHeight = 25.2*MULTIPLYHEIGHT;
        
        orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Width-80, onlHeight)];
        orderNumberLabel.backgroundColor = [UIColor clearColor];
        orderNumberLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        orderNumberLabel.textColor = [UIColor whiteColor];
        [orderNumBgView addSubview:orderNumberLabel];
        
        orderTypeLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width-80, CGRectGetMinY(orderNumberLabel.frame), 70, onlHeight)];
        orderTypeLbl.textColor = [UIColor whiteColor];
        orderTypeLbl.textAlignment = NSTextAlignmentRight;
        orderTypeLbl.font = orderNumberLabel.font;
        [orderNumBgView addSubview:orderTypeLbl];
        
        
        int yAxis = onlHeight+5*MULTIPLYHEIGHT;
        
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, onlHeight, Width, 1.0)];
        sepView.backgroundColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
        [orderNumBgView addSubview:sepView];
        
        UIImageView *pickupIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, yAxis, onlHeight, onlHeight)];
        pickupIcon.contentMode = UIViewContentModeScaleAspectFit;
        pickupIcon.image = [UIImage imageNamed:@"mywashes_pickup"];
        [orderNumBgView addSubview:pickupIcon];
        
        float pickupHeight = 14.4*MULTIPLYHEIGHT;
        
        UILabel *pickupLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis+2*MULTIPLYHEIGHT, Width/2, pickupHeight)];
        pickupLbl.backgroundColor = [UIColor clearColor];
        pickupLbl.textAlignment = NSTextAlignmentCenter;
        pickupLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1];
        pickupLbl.textColor = [UIColor whiteColor];
        pickupLbl.text = @"PICK UP";
        [orderNumBgView addSubview:pickupLbl];
        
        yAxis += pickupHeight;
        
        pickupdateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, Width/2, onlHeight)];
        pickupdateLbl.backgroundColor = [UIColor clearColor];
        pickupdateLbl.textAlignment = NSTextAlignmentCenter;
        pickupdateLbl.numberOfLines = 2;
        pickupdateLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+7];
        pickupdateLbl.textColor = [UIColor whiteColor];
        [orderNumBgView addSubview:pickupdateLbl];
        
        yAxis += pickupdateLbl.frame.size.height-(3*MULTIPLYHEIGHT);
        
        pickupSlotLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, Width/2, pickupHeight)];
        pickupSlotLbl.backgroundColor = [UIColor clearColor];
        pickupSlotLbl.textAlignment = NSTextAlignmentCenter;
        pickupSlotLbl.numberOfLines = 2;
        pickupSlotLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        pickupSlotLbl.textColor = [UIColor whiteColor];
        [orderNumBgView addSubview:pickupSlotLbl];
        
        yAxis = onlHeight+5*MULTIPLYHEIGHT;
        
        float SecondWidth = Width/2+pickupHeight;
        
        UIImageView *deliveryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SecondWidth+5, yAxis, onlHeight, onlHeight)];
        deliveryIcon.contentMode = UIViewContentModeScaleAspectFit;
        deliveryIcon.image = [UIImage imageNamed:@"mywashes_delivery"];
        [orderNumBgView addSubview:deliveryIcon];
        
        UILabel *deliveryLbl = [[UILabel alloc] initWithFrame:CGRectMake(SecondWidth, pickupLbl.frame.origin.y, Width/2, pickupHeight)];
        deliveryLbl.backgroundColor = [UIColor clearColor];
        deliveryLbl.textAlignment = NSTextAlignmentCenter;
        deliveryLbl.font = pickupLbl.font;
        deliveryLbl.textColor = [UIColor whiteColor];
        deliveryLbl.text = @"DELIVERY";
        [orderNumBgView addSubview:deliveryLbl];
        
        yAxis += pickupHeight;
        
        deliveryDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(SecondWidth, pickupdateLbl.frame.origin.y, Width/2, pickupdateLbl.frame.size.height)];
        deliveryDateLbl.backgroundColor = [UIColor clearColor];
        deliveryDateLbl.textAlignment = NSTextAlignmentCenter;
        deliveryDateLbl.numberOfLines = 2;
        deliveryDateLbl.font = pickupdateLbl.font;
        deliveryDateLbl.textColor = [UIColor whiteColor];
        [orderNumBgView addSubview:deliveryDateLbl];
        
        yAxis += pickupdateLbl.frame.size.height;
        
        deliverySlotLbl = [[UILabel alloc] initWithFrame:CGRectMake(SecondWidth, pickupSlotLbl.frame.origin.y, Width/2, pickupHeight)];
        deliverySlotLbl.backgroundColor = [UIColor clearColor];
        deliverySlotLbl.textAlignment = NSTextAlignmentCenter;
        deliverySlotLbl.numberOfLines = 2;
        deliverySlotLbl.font = pickupSlotLbl.font;
        deliverySlotLbl.textColor = [UIColor whiteColor];
        [orderNumBgView addSubview:deliverySlotLbl];
        
        float osHeight = 21.6*MULTIPLYHEIGHT;
        
        yAxis += osHeight;
        
        orderStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, Width, osHeight)];
        orderStatusLbl.userInteractionEnabled = YES;
        orderStatusLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
        orderStatusLbl.textColor = [UIColor darkGrayColor];
        orderStatusLbl.backgroundColor = [UIColor whiteColor];
        orderStatusLbl.text = @"";
        orderStatusLbl.textAlignment = NSTextAlignmentCenter;
        [orderNumBgView addSubview:orderStatusLbl];
        
        float imgHeight = 28.8*MULTIPLYHEIGHT;
        float minusY = 11.7*MULTIPLYHEIGHT;
        
        piingoUserImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, yAxis-minusY, imgHeight, imgHeight)];
        //piingoUserImageView.placeholderImage = [UIImage imageNamed:@"piingo_cap"];
        piingoUserImageView.layer.cornerRadius = CGRectGetWidth(piingoUserImageView.bounds)/2.0;
        piingoUserImageView.backgroundColor = [UIColor clearColor];
        piingoUserImageView.clipsToBounds = YES;
        piingoUserImageView.contentMode = UIViewContentModeScaleAspectFill;
        [orderNumBgView addSubview:piingoUserImageView];
        
        orderCostLbl = [[UILabel alloc] initWithFrame:CGRectMake(Width-60, yAxis, 50.0, osHeight)];
        orderCostLbl.backgroundColor = [UIColor clearColor];
        orderCostLbl.textAlignment = NSTextAlignmentRight;
        orderCostLbl.font = orderStatusLbl.font;
        orderCostLbl.textColor = orderStatusLbl.textColor;
        [orderNumBgView addSubview:orderCostLbl];
        
        yAxis += osHeight;
        
        CGRect rect = orderNumBgView.frame;
        rect.size.height = yAxis;
        orderNumBgView.frame = rect;
    }
    
    return self;
}
-(void) setDetails:(id) details andCellType:(int) cellType
{
    if (Static_screens_Build)
    {
        orderNumberLabel.text = @"OrderId # 1342456";
        orderTypeLbl.text = @"Express";
        pickupdateLbl.text = @"Home \n19th Apr 2015";
        deliveryDateLbl.text = @"Office \n2:15pm - 3:10pm";
        orderStatusLbl.text = @"Out For Pickup";
        orderCostLbl.text = @"S$20";
        
    }
    else
    {
        
        
//        var OrderStatus = {
//            "OB": "Order Booked",
//            "PO-P": "Piingo Out for Pickup",
//            "AD-P": "At The Door Pickup",
//            "PF": "Pickup Failure",
//            "OB-RS-P": "Order Rescheduled Pickup",
//            "OC": "Order Canceled",
//            "OP": "Order Pickup",
//            "WA-RE": "Received at Warehouse",
//            //"WA-REC": "Reconcile at Warehouse",
//            //"WIMZ": "Itemized",   //Sub Status Itemized : Partial, Partial
//            "RL": "Ready To Sent to Laundry",
//            "SL": "Send To Laundry",
//            "RECE-L": "Received at Laundry",
//            //"LIMZ": "Itemized at Laundry",
//            "LW": "Washing at Laundry",
//            "WC": "Washing Complete",
//            "SEND-W": "Send to Warehouse",
//            "RECE-L-W": "Received at Warehouse From Laundry",
//            "PO-D": "Piingo Out for Delivery",
//            "AD-D": "At The Door Delivery",
//            "DF": "Delivery Failure",
//            "OB-RS-D": "Order Rescheduled Delivery",
//            "OD": "Order Delivered",
//            "OD-PA": "Delivered Partially"
//        };
        
        orderNumberLabel.text = [NSString stringWithFormat:@"ORDER ID # %@", [details objectForKey:@"oid"]];
        
        NSString *strDate = [details objectForKey:@"pickUpDate"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"dd-MM-yyyy"];
        
        NSDate *date = [df dateFromString:strDate];
        [df setDateFormat:@"dd MMM"];
        
        strDate = [df stringFromDate:date];
        
        pickupdateLbl.text = [[NSString stringWithFormat:@"%@",strDate]uppercaseString];
        pickupSlotLbl.text = [NSString stringWithFormat:@"%@",[details objectForKey:@"pickUpSlotId"]];
        
        
        strDate = [details objectForKey:@"deliveryDate"];
        
        [df setDateFormat:@"dd-MM-yyyy"];
        
        date = [df dateFromString:strDate];
        [df setDateFormat:@"dd MMM"];
        
        strDate = [df stringFromDate:date];
        
        deliveryDateLbl.text = [[NSString stringWithFormat:@"%@",strDate]uppercaseString];
        
        deliverySlotLbl.text = [NSString stringWithFormat:@"%@",[details objectForKey:@"deliverySlotId"]];
        
        //orderStatusLbl.text = [[details objectForKey:@"statusMsg"] uppercaseString];
        
        NSString *strStatusCode = [details objectForKey:@"statusCode"];
        
        if ([strStatusCode isEqualToString:@"OB"] || [strStatusCode isEqualToString:@"OB-RS-P"])
        {
            orderStatusLbl.text = @"Order booked";
        }
        else if ([strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"AD-P"])
        {
            orderStatusLbl.text = @"Out for pickup";
        }
        else if ([strStatusCode isEqualToString:@"OP"] || [strStatusCode isEqualToString:@"WA-RE"] || [strStatusCode isEqualToString:@"WA-REC"] || [strStatusCode isEqualToString:@"WIMZ"] || [strStatusCode isEqualToString:@"RL"])
        {
            orderStatusLbl.text = @"Garments pickedup";
        }
        else if ([strStatusCode isEqualToString:@"LW"] || [strStatusCode isEqualToString:@"SL"] || [strStatusCode isEqualToString:@"RECE-L"] || [strStatusCode isEqualToString:@"WC"] || [strStatusCode isEqualToString:@"SEND-W"] || [strStatusCode isEqualToString:@"LIMZ"])
        {
            orderStatusLbl.text = @"Washing in progress";
        }
        else if ([strStatusCode isEqualToString:@"RECE-L-W"])
        {
            orderStatusLbl.text = @"Ready for delivery";
        }
        else if ([strStatusCode isEqualToString:@"PO-D"] || [strStatusCode isEqualToString:@"AD-D"] || [strStatusCode isEqualToString:@"OB-RS-D"])
        {
            orderStatusLbl.text = @"Out for delivery";
        }
        else if ([strStatusCode isEqualToString:@"OD"])
        {
            orderStatusLbl.text = @"Delivered";
        }
        else if ([strStatusCode isEqualToString:@"PF"])
        {
            orderStatusLbl.text = @"Pickup attempt failed";
        }
        else if ([strStatusCode isEqualToString:@"DF"])
        {
            orderStatusLbl.text = @"Delivery attempt failed";
        }
        else if ([strStatusCode isEqualToString:@"OD-PA"])
        {
            orderStatusLbl.text = @"Partially delivered";
        }
        
        NSString *strSt = orderStatusLbl.text;
        orderStatusLbl.text = [strSt uppercaseString];
        
        orderTypeLbl.text = [[details objectForKey:@"orderSpeed"] isEqualToString:@"E"] ? @"EXPRESS" : @"REGULAR";
        orderTypeLbl.textColor = [[details objectForKey:@"orderSpeed"] isEqualToString:@"E"] ? [UIColor colorFromHexString:@"da4936"] : [UIColor colorFromHexString:@"1B67C1"];
        
        orderCostLbl.text = @"";
        
        NSString *strPiingoId = @"";
        
        if ([[details objectForKey:@"direction"] caseInsensitiveCompare:@"Delivery"] == NSOrderedSame)
        {
            strPiingoId = [NSString stringWithFormat:@"%d", [[details objectForKey:@"dpid"] intValue]];
        }
        else
        {
            strPiingoId = [NSString stringWithFormat:@"%d", [[details objectForKey:@"ppid"] intValue]];
        }
        
        if ([strPiingoId intValue] > 0)
        {
            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", strPiingoId, @"pid", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@piingo/get", BASE_URL];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                    
                    NSDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[responseObj objectForKey:@"em"]];
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        if ([[dict objectForKey:@"image"] containsString:@"http"])
                        {
                            [piingoUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"piingo_cap"]];
                        }
                        else
                        {
                            [piingoUserImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_TRACKING_URL, [dict objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"piingo_cap"]];
                        }
                        
                    }];
                }
                else {
                    
                    [appDel displayErrorMessagErrorResponse:responseObj];
                }
            }];
        }
        else
        {
            piingoUserImageView.image = [UIImage imageNamed:@"piingo_cap"];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
