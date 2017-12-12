//
//  ScheduleLaterViewController.m
//  Piing
//
//  Created by Piing on 10/23/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "ScheduleLaterViewController_New.h"
#import "DeliveryViewController_New.h"
#import "ListViewController.h"
#import "DemoTableController.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "UIButton+CenterImageAndTitle.h"
#import "CustomPopoverView.h"
#import "Piing-Swift.h"
#import "DateTimeViewController.h"
#import "PreferencesViewController.h"
#import "FXBlurView.h"
#import "PriceListViewController_New.h"
#import "CustomSegmentControl.h"




#define PLACE_HOLDER_COLOR_INSTEAD_IMAGE [UIColor clearColor]


#define SCHEDULE_SCREEN_TAG 50

@interface ScheduleLaterViewController_New () <DemoTableControllerDelegate, CustomPopoverViewDelegate, DateTimeViewControllerDelegate, PreferencesViewControllerDelegate, HMSegmentedControlDelegate, UIScrollViewDelegate> {
    UIView *scheduleScreenView;
    UIButton *addressBtn;
    
    UILabel *pickUpDateLbl;
    UILabel *pickUpTimeLbl;
    
    ListViewController *listView;
    
    NSDictionary *selectedAddress;
    
    AppDelegate *appDel;
    
    FPPopoverKeyboardResponsiveController *popover;
    
    CustomPopoverView *customPopOverView;
    
    UILabel *LblDaysToDeliver;
        
    float previousAddressYAxis;
    
    __block UIView *view_Top;
    
    UILabel *lblSwitch;
    NSTimer *timerSwitch;
    
    CGFloat previousSliderValue;
    UILabel *lblOrderType;
    
    CGFloat showlblSwitchTime;
    
    FXBlurView *blurEffect;
    
    UIView *view_Popup, *view_BG;
    
    BOOL prefsOpenedAutomatically;
    
    UILabel *lblInst;
    
    HMSegmentedControl *segmentCleaning;
    
    UIScrollView *scrollViewWashType;
    
    NSDictionary *dictJobTypes;
    
    //SevenSwitch *mySwitch2;
    //UISegmentedControl *segmentSwitch;
    
    CGFloat addOrMinusYPos;
    
    NSMutableDictionary *dictPickupDatesAndTimes;
    
    NSMutableArray *arraAlldata;
    
    NSMutableDictionary *dictServiceType;
    
    BOOL curtainSelected, dryCleaningSelected, shoeSelected;
    
    //SevenSwitch *switchCurtain;
    UISegmentedControl *segmentCurtain;
    
    NSString *selectedCurtainServiceType;
    
    UIView *viewSome;
    
    UIButton *btnCurtain, *btnDryCleaning, *btnShoe;
    
    UIImageView *imgEcoBG;
    
    BOOL knowMoreExpanded;
    
    NSInteger selected_DC_Tag;
    
    NSMutableArray *arraySelectedServiceTypes;
    
    UIButton *btnSwitch;
}

@property (nonatomic, retain) NSMutableArray *pickUpDates;

@property (nonatomic, retain) NSMutableDictionary *orderInfo;

@end


@implementation ScheduleLaterViewController_New

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    appDel = [PiingHandler sharedHandler].appDel;
    
    self.userAddresses = [PiingHandler sharedHandler].userAddress;
    self.userSavedCards = [PiingHandler sharedHandler].userSavedCards;
    
    arraySelectedServiceTypes = [[NSMutableArray alloc]init];
    
    self.orderInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    dictPickupDatesAndTimes = [[NSMutableDictionary alloc]init];
    
    self.pickUpDates = [[NSMutableArray alloc]init];
    arraAlldata = [[NSMutableArray alloc]init];
    
    if (self.isFromUpdateOrder)
    {
        
        if ([self.dictAllowFields count] && ([[self.dictAllowFields objectForKey:@"pickupAddress"] intValue] == 0) && ([[self.dictAllowFields objectForKey:@"pickupDate"] intValue] == 0) && ([[self.dictAllowFields objectForKey:@"pickupSlot"] intValue] == 0) && ([[self.dictAllowFields objectForKey:@"serviceType"] intValue] == 0) && ([[self.dictAllowFields objectForKey:@"orderSpeed"] intValue] == 0) && ([[self.dictAllowFields objectForKey:@"preferences"] intValue] == 0) && ([[self.dictAllowFields objectForKey:@"pickupAddress"] intValue] == 0))
        {
            DeliveryViewController_New *vc = [[DeliveryViewController_New alloc] init];
            vc.orderInfo = [[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
            vc.isFromUpdateOrder = YES;
            vc.dictAllowFields = [[NSMutableDictionary alloc]initWithDictionary:self.dictAllowFields];
            vc.dictChangedValues = [[NSMutableDictionary alloc]initWithDictionary:self.dictChangedValues];
            vc.arrayAllOrderDetails = [[NSMutableDictionary alloc]initWithDictionary:self.arrayAllOrderDetails];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:self.userAddresses];
        NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.dictUpdateOrder objectForKey:ORDER_PICKUP_ADDRESS_ID]]];
        sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
        
        if ([sortedArray count] > 0)
        {
            selectedAddress = [sortedArray objectAtIndex:0];
        }
        
        [self.orderInfo addEntriesFromDictionary:self.dictUpdateOrder];
        
        [arraySelectedServiceTypes addObjectsFromArray:[self.orderInfo objectForKey:ORDER_JOB_TYPE]];
    }
    else
    {
        NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:self.userAddresses];
        NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"default == %d", 1];
        sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
        
        if ([sortedArray count] > 0)
        {
            selectedAddress = [sortedArray objectAtIndex:0];
        }
        else
        {
            selectedAddress = [self.userAddresses objectAtIndex:0];
        }
        
        [self.orderInfo setValue:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
        [self.orderInfo setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:ORDER_USER_ID];
        [self.orderInfo setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN] forKey:@"t"];
        [self.orderInfo setObject:@"From IOS" forKey:ORDER_NOTES];
        [self.orderInfo setObject:@"" forKey:PROMO_CODE];
        
        if (![appDel.strGlobalPreferenes length])
        {
            NSMutableDictionary *dictMain = [appDel getDefaultPreferences];
            
            NSMutableString *strPref = [@"" mutableCopy];
            
            if ([dictMain count])
            {
                [strPref appendString:@"["];
                
                for (NSString *strakey in dictMain)
                {
                    [strPref appendFormat:@"%@", [NSString stringWithFormat:@"{\"name\":\"%@\",\"value\":\"%@\"},", strakey, [dictMain objectForKey:strakey]]];
                }
                
                if ([strPref hasSuffix:@","])
                {
                    strPref = [[strPref substringToIndex:[strPref length]-1]mutableCopy];
                }
                
                [strPref appendString:@"]"];
            }
            
            appDel.strGlobalPreferenes = strPref;
        }
        
        [self.orderInfo setObject:appDel.strGlobalPreferenes forKey:PREFERENCES_SELECTED];
        
    }
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    float yPos = 27*MULTIPLYHEIGHT;;
    
    scheduleScreenView = [[UIView alloc] initWithFrame:screenBounds];
    scheduleScreenView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scheduleScreenView];
    
    if ([self.strPopupMessage length])
    {
        showlblSwitchTime = 7;
        
        [self showPopupMessage];
    }
    else
    {
        showlblSwitchTime = 1;
    }
    
    [self createScheduleScreenView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yPos, CGRectGetWidth(screenBounds), 40.0)];
    
    NSString *string;
    
    if (self.isFromUpdateOrder)
    {
        string = @"UPDATE ORDER";
    }
    else
    {
        string = @"PICKUP";
    }
    
    [appDel spacingForTitle:titleLbl TitleString:string];
    
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor grayColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    [scheduleScreenView addSubview:titleLbl];
    
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(CGRectGetWidth(screenBounds) - 50.0, yPos, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
    [scheduleScreenView addSubview:closeBtn];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0, 2.0)];
    progressView.backgroundColor = APPLE_BLUE_COLOR;
    //[scheduleScreenView addSubview:progressView];
    
    
    [UIView animateWithDuration:0.3 delay:0.2 options:0 animations:^{
        
        progressView.frame = CGRectMake(0.0, 0.0, screen_width/2, 2.0);
        
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)fetchPickUpDates:(BOOL) btnClicked
{
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [selectedAddress objectForKey:@"_id"], @"pickupAddressId", arraySelectedServiceTypes, @"serviceTypes", @"S", @"orderType", nil];
    
    if (self.isFromUpdateOrder)
    {
        [detailsDic setObject:[self.orderInfo objectForKey:@"oid"] forKey:@"oid"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/pickupdates", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            if (btnClicked)
            {
                [arraAlldata removeAllObjects];
                [self.pickUpDates removeAllObjects];
                [dictPickupDatesAndTimes removeAllObjects];
                
                NSArray *arrayData = [NSArray arrayWithArray:[responseObj objectForKey:@"dates"]];
                
                //[arraAlldata addObjectsFromArray:[responseObj objectForKey:@"dates"]];
                
                for (int i = 0; i < [arrayData count]; i++)
                {
                    if ([[[arrayData objectAtIndex:i] objectForKey:@"slots"] count])
                    {
                        [arraAlldata addObject:[arrayData objectAtIndex:i]];
                        
                        [self.pickUpDates addObject:[[arrayData objectAtIndex:i] objectForKey:@"date"]];
                        
                        [dictPickupDatesAndTimes setObject:[[arrayData objectAtIndex:i] objectForKey:@"slots"] forKey:[[arrayData objectAtIndex:i] objectForKey:@"date"]];
                    }
                }
                
                [self clickedOnPickupdate];
            }
            else
            {
                [arraAlldata removeAllObjects];
                [self.pickUpDates removeAllObjects];
                [dictPickupDatesAndTimes removeAllObjects];
                
                [arraAlldata addObjectsFromArray:[responseObj objectForKey:@"dates"]];
                
                BOOL foundDate = NO;
                BOOL foundSlot = NO;
                
                for (int i = 0; i < [arraAlldata count]; i++)
                {
                    if ([[[arraAlldata objectAtIndex:i]objectForKey:@"date"] isEqualToString:[self.orderInfo objectForKey:ORDER_PICKUP_DATE]])
                    {
                        foundDate = YES;
                        
                        NSArray *slotsArray = [[arraAlldata objectAtIndex:i]objectForKey:@"slots"];
                        
                        for (int j = 0; j < [slotsArray count]; j++)
                        {
                            NSDictionary *dict = [slotsArray objectAtIndex:j];
                            
                            if ([[dict objectForKey:@"slot"] isEqualToString:[self.orderInfo objectForKey:ORDER_PICKUP_SLOT]])
                            {
                                foundSlot = YES;
                                
                                break;
                            }
                        }
                    }
                    
                    if (foundDate || !foundSlot)
                    {
                        break;
                    }
                }
                
                if (foundDate && foundSlot)
                {
                    
                }
                else
                {
                    pickUpDateLbl.text = @"PICKUP DATE : TIME";
                    
                    [self.orderInfo removeObjectForKey:ORDER_PICKUP_DATE];
                    [self.orderInfo removeObjectForKey:ORDER_PICKUP_SLOT];
                }
            }
        }
        else {
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


-(void) showPopupMessage
{
    
    float viewX = 20;
    
    view_Top = [[UIView alloc]initWithFrame:CGRectMake(viewX, 0, screen_width-(viewX*2), 0)];
    view_Top.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.9];
    view_Top.layer.cornerRadius = 14.0;
    [self.view addSubview:view_Top];
    
    
    float lblX = 10*MULTIPLYHEIGHT;
    float lblY = 10*MULTIPLYHEIGHT;
    
    UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, view_Top.frame.size.width-(lblX*2), 20)];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.numberOfLines = 0;
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
    [view_Top addSubview:lblMessage];
    lblMessage.text = self.strPopupMessage;
    
    CGFloat lblHeight = [AppDelegate getLabelHeightForBoldText:self.strPopupMessage WithWidth:lblMessage.frame.size.width FontSize:lblMessage.font.pointSize];
    
    CGRect rectLbl = lblMessage.frame;
    rectLbl.size.height = lblHeight;
    lblMessage.frame = rectLbl;
    
    CGRect frameView = view_Top.frame;
    frameView.origin.y = -(lblHeight+lblY+10);
    frameView.size.height = lblHeight+lblY+10;
    view_Top.frame = frameView;
    
    
    
    [UIView animateWithDuration:0.2 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect frameView = view_Top.frame;
        frameView.origin.y = 20;
        view_Top.frame = frameView;
        
        scheduleScreenView.frame = CGRectMake(0, view_Top.frame.size.height-10*MULTIPLYHEIGHT, screen_width, screen_height);
        
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(hidePopupMessage) withObject:nil afterDelay:5.0f];
        
    }];
    
}

-(void) hidePopupMessage
{
    [UIView animateWithDuration:0.2 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect frameView = view_Top.frame;
        frameView.size.height = -view_Top.frame.size.height;
        view_Top.frame = frameView;
        
        scheduleScreenView.frame = self.view.bounds;
        
        
    } completion:^(BOOL finished) {
        
        [view_Top removeFromSuperview];
        view_Top = nil;
        
    }];
}

-(void) didAddNewAddress
{
    [self closeCustomPopover];
    
    [self getAddress];
}

-(void) closeCustomPopover
{
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        
        customPopOverView.alpha = 0.0;
        
        CGRect frame = addressBtn.frame;
        frame.origin.y = previousAddressYAxis;
        addressBtn.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
        addressBtn.selected = NO;
        
        [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }];
}

-(void) getAddress
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/get", BASE_URL];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            NSArray *sortedArray = [responseObj objectForKey:@"addresses"];
            
            [PiingHandler sharedHandler].userAddress = sortedArray;
            self.userAddresses = [PiingHandler sharedHandler].userAddress;
        }
        else {
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


- (void)createScheduleScreenView
{
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGFloat ratio = MULTIPLYHEIGHT;
    CGFloat yPos = 90*ratio;
    
    // Custom Switch
    
    CGFloat btnHeight = 20*MULTIPLYHEIGHT;
    CGFloat viewW = 150*MULTIPLYHEIGHT;
    
    UIView *viewType = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2-viewW/2, yPos, viewW, btnHeight)];
    viewType.layer.cornerRadius = 13.0;
    viewType.backgroundColor = [UIColor clearColor];
    viewType.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
    viewType.layer.borderWidth = 0.6f;
    viewType.layer.masksToBounds = YES;
    [scheduleScreenView addSubview:viewType];
    
    CGFloat btnX = 0;
    
    for (int i = 0; i < 2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+1;
        btn.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
        [viewType addSubview:btn];
        btn.layer.cornerRadius = 13.0;
        
        NSString *str1 = @"REGULAR";
        NSString *str2 = @"EXPRESS";
        
        if (i == 0)
        {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str1];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attr length])];
            
            float spacing = 0.5f;
            [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
            
            NSMutableAttributedString *attrSel = [[NSMutableAttributedString alloc] initWithString:str1];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [attrSel length])];
            [attrSel addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrSel length])];
            
            [btn setAttributedTitle:attr forState:UIControlStateNormal];
            [btn setAttributedTitle:attrSel forState:UIControlStateSelected];
            
//            btn.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
            btn.backgroundColor = [UIColor clearColor];
            
            if (self.isFromUpdateOrder)
            {
                if ([[self.orderInfo objectForKey:ORDER_TYPE] caseInsensitiveCompare:ORDER_TYPE_REGULAR] == NSOrderedSame)
                {
//                    btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                    btn.backgroundColor = BLUE_COLOR;
                    btn.selected = YES;
                }
            }
            else
            {
//                btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                btn.backgroundColor = BLUE_COLOR;
                btn.selected = YES;
                
                btnSwitch = btn;
            }
        }
        else
        {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str2];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attr length])];
            
            float spacing = 1.0f;
            [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
            
            NSMutableAttributedString *attrSel = [[NSMutableAttributedString alloc] initWithString:str2];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [attrSel length])];
            [attrSel addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrSel length])];
            
            [btn setAttributedTitle:attr forState:UIControlStateNormal];
            [btn setAttributedTitle:attrSel forState:UIControlStateSelected];
            
            //btn.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
            
            if (self.isFromUpdateOrder)
            {
                if ([[self.orderInfo objectForKey:ORDER_TYPE] caseInsensitiveCompare:@"E"] == NSOrderedSame)
                {
//                    btn.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.7].CGColor;
                    btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                    //viewType.layer.borderColor = btn.backgroundColor.CGColor;
                    
                    btn.selected = YES;
                }
            }
            
            [viewType sendSubviewToBack:btn];
        }
        
        //btn.layer.borderWidth = 1.0f;
        
        [btn addTarget:self action:@selector(btnOptionsSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat btnWidth = viewW/2;
        
        btn.frame = CGRectMake(btnX, 0, btnWidth, viewType.frame.size.height);
        
        btnX += btnWidth-1;
    }
    
//    CGFloat sgX = 65 * MULTIPLYHEIGHT;
//    CGFloat sgH = 18 * MULTIPLYHEIGHT;
//    
//    segmentSwitch = [[UISegmentedControl alloc]initWithItems:@[@"REGULAR", @"EXPRESS"]];
//    segmentSwitch.frame = CGRectMake(sgX, yPos, screen_width-(sgX * 2), sgH);
//    [segmentSwitch setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateSelected];
//    [segmentSwitch setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLORCODE(64, 143, 210, 1.0), NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateNormal];
//    [segmentSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    segmentSwitch.tintColor = RGBCOLORCODE(64, 143, 210, 1.0);
//    segmentSwitch.selectedSegmentIndex = 0;
//    [scheduleScreenView addSubview:segmentSwitch];
    
//    mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake((screen_width/2)-(90/2),  yPos, 90, 25)];
//    //mySwitch2.center = CGPointMake(self.view.bounds.size.width * 0.5, 30);
//    //mySwitch2.inactiveColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
//    //mySwitch2.onTintColor = [UIColor colorWithRed:0.45f green:0.58f blue:0.67f alpha:1.00f];
//    [mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    //    mySwitch2.offImage = [UIImage imageNamed:@"toggle_nonselected"];
//    //    mySwitch2.onImage = [UIImage imageNamed:@"toggle_selected"];
//    //mySwitch2.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
//    mySwitch2.activeColor = [UIColor clearColor];
//    mySwitch2.inactiveColor = [UIColor clearColor];
//    mySwitch2.onTintColor = [UIColor clearColor];
//    mySwitch2.onLabel.textColor = BLUE_COLOR;
//    mySwitch2.offLabel.textColor = [UIColor grayColor];
//    mySwitch2.isRounded = YES;
//    mySwitch2.shadowColor = [UIColor clearColor];
//    mySwitch2.activeBorderColor = BLUE_COLOR;
//    mySwitch2.inactiveBorderColor = RGBCOLORCODE(200, 200, 200, 1.0);
//    mySwitch2.onThumbImage = [UIImage imageNamed:@"thumb_selected"];
//    mySwitch2.offThumbImage = [UIImage imageNamed:@"thumb_nonselected"];
//    [mySwitch2 setOn:NO animated:YES];
//    [scheduleScreenView addSubview:mySwitch2];
    
    
    //    float lblOX = 95*MULTIPLYHEIGHT;
    //    float lblOWidth = 45*MULTIPLYHEIGHT;
    //    float lblH = 23*MULTIPLYHEIGHT;
    
    //    lblOrderType = [[UILabel alloc]initWithFrame:CGRectMake(lblOX, yPos, lblOWidth, lblH)];
    //    lblOrderType.text = @"REGULAR";
    //    lblOrderType.textColor = RGBCOLORCODE(170, 170, 170, 1.0);
    //    lblOrderType.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
    //    [scheduleScreenView addSubview:lblOrderType];
    //
    //    UISlider *sliderPer = [[UISlider alloc]initWithFrame:CGRectMake(lblOX+lblOWidth,  yPos, 35*MULTIPLYHEIGHT, lblH)];
    //    //sliderPer.thumbTintColor = RGBCOLORCODE(24, 157, 153, 1.0);
    //    sliderPer.tintColor = RGBCOLORCODE(24, 157, 153, 1.0);
    //    [sliderPer addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    //    [scheduleScreenView addSubview:sliderPer];
    //    sliderPer.continuous = NO;
    //    [sliderPer setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateNormal];
    //    [sliderPer setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateHighlighted];
    
    
    yPos += 25+5*MULTIPLYHEIGHT;
    
    
    float lblSHeight = 16*MULTIPLYHEIGHT;
    
    lblSwitch = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, lblSHeight)];
    lblSwitch.textAlignment = NSTextAlignmentCenter;
    lblSwitch.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    lblSwitch.textColor = RGBCOLORCODE(200, 200, 200, 1.0);
    [scheduleScreenView addSubview:lblSwitch];
    lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
    
    lblSwitch.alpha = 0.0;
    
    [UIView animateWithDuration:0.2 delay:showlblSwitchTime options:0 animations:^{
        
        lblSwitch.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        timerSwitch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hidelblSwitch) userInfo:nil repeats:NO];
        
    }];
    
    if (self.isFromUpdateOrder)
    {
        if ([[self.orderInfo objectForKey:ORDER_TYPE] caseInsensitiveCompare:ORDER_TYPE_REGULAR] == NSOrderedSame)
        {
            //[mySwitch2 setOn:NO animated:YES];
            //segmentSwitch.selectedSegmentIndex = 0;
        }
        else
        {
            lblSwitch.text = [@"Next day Delivery" uppercaseString];
            
            //segmentSwitch.tintColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
            
//            mySwitch2.thumbImage = [UIImage imageNamed:@"thumb_selected"];
//            
//            [mySwitch2 setOn:YES animated:YES];
            
            //segmentSwitch.selectedSegmentIndex = 1;
        }
    }
    else
    {
        //[mySwitch2 setOn:NO animated:YES];
        
        //segmentSwitch.selectedSegmentIndex = 0;
    }
    
    
    //    if (self.isFromUpdateOrder)
    //    {
    //        if ([[self.orderInfo objectForKey:ORDER_TYPE] caseInsensitiveCompare:@"R"] == NSOrderedSame)
    //        {
    //            lblOrderType.text = @"REGULAR";
    //            [sliderPer setValue:0 animated:YES];
    //        }
    //        else
    //        {
    //            lblSwitch.text = [@"Next day Delivery" uppercaseString];
    //            lblOrderType.text = @"EXPRESS";
    //            [sliderPer setValue:1.0 animated:YES];
    //
    //            [sliderPer setThumbImage:[UIImage imageNamed:@"selected_thumb"] forState:UIControlStateNormal];
    //            [sliderPer setThumbImage:[UIImage imageNamed:@"selected_thumb"] forState:UIControlStateHighlighted];
    //        }
    //    }
    
    yPos += lblSHeight + 12*MULTIPLYHEIGHT;
    
    float xPos = 14.4*MULTIPLYHEIGHT;;
    
    float height = 35.0*ratio;
    
    {
        addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addressBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        addressBtn.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [addressBtn setTitle:@"SILOSO BEACH, SINGAPORE" forState:UIControlStateNormal];
        [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        addressBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 35*MULTIPLYHEIGHT, 0.0, 26*MULTIPLYHEIGHT);
        [addressBtn addTarget:self action:@selector(selectPickUpAddress:) forControlEvents:UIControlEventTouchUpInside];
        [scheduleScreenView addSubview:addressBtn];
        [addressBtn setBackgroundImage:[AppDelegate imageWithColor:[[UIColor grayColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
        addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [addressBtn setTitle:[self setTitleForAddress] forState:UIControlStateNormal];
        addressBtn.layer.cornerRadius = 15.0;
        addressBtn.clipsToBounds = YES;
        
        UIImageView *locImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, 0.0, 10*MULTIPLYHEIGHT, CGRectGetHeight(addressBtn.bounds))];
        locImgView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        locImgView.contentMode = UIViewContentModeScaleAspectFit;
        locImgView.image = [UIImage imageNamed:@"address_sl"];
        locImgView.userInteractionEnabled = NO;
        [addressBtn addSubview:locImgView];
        
        UIImageView *dropDownIconView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(addressBtn.bounds) - (xPos*1.5)), 2.0, 15.0, CGRectGetHeight(addressBtn.bounds))];
        dropDownIconView.contentMode = UIViewContentModeScaleAspectFit;
        dropDownIconView.image = [UIImage imageNamed:@"down_arrow"];
        dropDownIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        dropDownIconView.userInteractionEnabled = NO;
        [addressBtn addSubview:dropDownIconView];
        
    }
    
    yPos += height+20*MULTIPLYHEIGHT;
    
    {
        
        UIView *washModeSelectionView = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), 115.0*ratio)];
        washModeSelectionView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        washModeSelectionView.layer.cornerRadius = 15.0;
        
        float segmentHeight = 22*MULTIPLYHEIGHT;
        
        scrollViewWashType = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10*MULTIPLYHEIGHT+segmentHeight, washModeSelectionView.frame.size.width, washModeSelectionView.frame.size.height-(10*MULTIPLYHEIGHT+segmentHeight+15*MULTIPLYHEIGHT))];
        scrollViewWashType.delegate = self;
        scrollViewWashType.backgroundColor = [UIColor clearColor];
        scrollViewWashType.showsHorizontalScrollIndicator = NO;
        scrollViewWashType.showsVerticalScrollIndicator = NO;
        [washModeSelectionView addSubview:scrollViewWashType];
        //scrollView.scrollEnabled = NO;
        scrollViewWashType.pagingEnabled = YES;
        
        
        //        CALayer *myLayer = [[CALayer alloc]init];
        //        myLayer.backgroundColor = [UIColor whiteColor].CGColor;
        //        myLayer.frame = CGRectMake(washModeSelectionView.frame.origin.x+2*MULTIPLYHEIGHT, washModeSelectionView.frame.origin.y + washModeSelectionView.frame.size.height-1, washModeSelectionView.frame.size.width-(2*MULTIPLYHEIGHT*2), 2);
        //        myLayer.shadowColor = [[UIColor grayColor] CGColor];
        //        myLayer.shadowOffset = CGSizeMake(0.0, 2.0);
        //        myLayer.shadowOpacity = 1.0;
        //        myLayer.shadowRadius = 2.0;
        //        [scheduleScreenView.layer addSublayer:myLayer];
        
        UIImageView *imgTopStrip = [[UIImageView alloc]initWithFrame:CGRectMake(xPos+2*MULTIPLYHEIGHT, washModeSelectionView.frame.origin.y+washModeSelectionView.frame.size.height-4.7*MULTIPLYHEIGHT, (CGRectGetWidth(screenBounds) - ((xPos+2*MULTIPLYHEIGHT)*2)), 5*MULTIPLYHEIGHT)];
        imgTopStrip.contentMode = UIViewContentModeScaleAspectFill;
        imgTopStrip.image = [UIImage imageNamed:@"mywallet_topstrip.png"];
        //[scheduleScreenView addSubview:imgTopStrip];
        
        [scheduleScreenView addSubview:washModeSelectionView];
        
        
        NSArray *arrCleaning = @[CATEGORY_SERVICETYPE_GENERAL, CATEGORY_SERVICETYPE_SPECIALCARE, CATEGORY_SERVICETYPE_HOME];
        
        segmentCleaning = [[HMSegmentedControl alloc]initWithSectionTitles:arrCleaning];
        segmentCleaning.delegate = self;
        segmentCleaning.frame = CGRectMake(3, 10*MULTIPLYHEIGHT, washModeSelectionView.frame.size.width-6, segmentHeight);
        
        float left = 20*MULTIPLYHEIGHT;
        float right = 20*MULTIPLYHEIGHT;
        
        segmentCleaning.type = HMSegmentedControlTypeText;
        segmentCleaning.segmentEdgeInset = UIEdgeInsetsMake(0, left, 0, right);
        segmentCleaning.backgroundColor = [UIColor clearColor];
        segmentCleaning.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        segmentCleaning.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        segmentCleaning.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4], NSKernAttributeName : @(1)};
        segmentCleaning.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : BLUE_COLOR, NSFontAttributeName : [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4], NSKernAttributeName : @(1)};
        [segmentCleaning addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        [washModeSelectionView addSubview:segmentCleaning];
        segmentCleaning.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        segmentCleaning.selectionIndicatorColor = [UIColor clearColor];
        segmentCleaning.selectionIndicatorBoxOpacity = 1.0f;
        segmentCleaning.selectedSegmentIndex = 0;
        segmentCleaning.verticalDividerEnabled = YES;
        segmentCleaning.verticalDividerColor = [UIColor lightGrayColor];
        segmentCleaning.verticalDividerWidth = 1;
        segmentCleaning.selectionIndicatorHeight = 7*MULTIPLYHEIGHT;
        
        [segmentCleaning setIndexChangeBlock:^(NSInteger index) {
            
            //[self scrollAnimated];
            
        }];
        
        [self segmentedControlChangedValue:segmentCleaning];
        
        [self performSelector:@selector(offsetChange) withObject:nil afterDelay:0.5];
        
        
        float widthe = 28*MULTIPLYHEIGHT;
        segmentCleaning.scrollView.contentInset = UIEdgeInsetsMake(0, widthe, 0, widthe);
        
        
        
        NSArray *btnTitlesPersonal = @[@"LOAD WASH", @"DRY CLEANING", @"WASH & IRON", @"IRONING"];
        NSArray *btnIconsPersonal = @[@"load_wash", @"dry_cleaning", @"wash_and_iron", @"ironing"];
        NSArray *btnSelIconsPersonal = @[@"load_wash_selected", @"dry_cleaning_selected", @"wash_and_iron_selected", @"ironing_selected"];
        
        NSArray *btnTitlesSpecial = @[@"BAGS", @"SHOES", @"LEATHER"];
        NSArray *btnIconsSpecial = @[ @"bags", @"shoes", @"leather"];
        NSArray *btnSelIconsSpecial = @[@"bags_selected", @"shoes_selected", @"leather_selected"];
        
        NSArray *btnTitlesHome = @[@"CURTAINS", @"CARPET"];
        NSArray *btnIconsHome = @[@"curtains", @"carpet"];
        NSArray *btnSelIconsHome = @[@"curtains_selected", @"carpet_selected"];
        
        
        dictServiceType = [[NSMutableDictionary alloc]init];
        [dictServiceType setObject:SERVICETYPE_WF forKey:@"LOAD WASH"];
        [dictServiceType setObject:SERVICETYPE_DC forKey:@"DRY CLEANING"];
        [dictServiceType setObject:SERVICETYPE_WI forKey:@"WASH & IRON"];
        [dictServiceType setObject:SERVICETYPE_IR forKey:@"IRONING"];
        [dictServiceType setObject:SERVICETYPE_CA forKey:@"CARPET"];
        [dictServiceType setObject:SERVICETYPE_CC forKey:@"CURTAINS"];
        [dictServiceType setObject:SERVICETYPE_BAG forKey:@"BAGS"];
        [dictServiceType setObject:SERVICETYPE_SHOE forKey:@"SHOES"];
        [dictServiceType setObject:SERVICETYPE_LE forKey:@"LEATHER"];
        
        dictJobTypes = [[NSDictionary alloc]initWithObjectsAndKeys:btnTitlesPersonal, @"1", btnTitlesSpecial, @"2", btnTitlesHome, @"3", nil];
        
        NSDictionary *dictJobTypesIcons = [[NSDictionary alloc]initWithObjectsAndKeys:btnIconsPersonal, @"1", btnIconsSpecial, @"2", btnIconsHome, @"3", nil];
        
        NSDictionary *dictJobTypesSelIcons = [[NSDictionary alloc]initWithObjectsAndKeys:btnSelIconsPersonal, @"1", btnSelIconsSpecial, @"2", btnSelIconsHome, @"3", nil];
        
        float viewX = 0.0;
        
        int tagValue = 0;
        
        for (int k=0; k < [dictJobTypes count]; k++)
        {
            NSArray *arrTitles = [dictJobTypes objectForKey:[NSString stringWithFormat:@"%d", k+1]];
            NSArray *arrIcons = [dictJobTypesIcons objectForKey:[NSString stringWithFormat:@"%d", k+1]];
            NSArray *arrSelIcons = [dictJobTypesSelIcons objectForKey:[NSString stringWithFormat:@"%d", k+1]];
            
            float btnWidth = 0.0;
            
            float minusWidth = 0.0;
            
            if (k == 0)
            {
                minusWidth = 0.0;
                
                btnWidth = CGRectGetWidth(washModeSelectionView.bounds)/[arrTitles count];
                viewX = k*washModeSelectionView.frame.size.width;
            }
            else if (k == 1)
            {
                minusWidth = 20*MULTIPLYHEIGHT;
                
                btnWidth = CGRectGetWidth(washModeSelectionView.bounds)/[arrTitles count];
                viewX = k*washModeSelectionView.frame.size.width;
            }
            else if (k == 2)
            {
                minusWidth = 25*MULTIPLYHEIGHT;
                
                btnWidth = CGRectGetWidth(washModeSelectionView.bounds)/[arrTitles count];
                viewX = k*washModeSelectionView.frame.size.width;
            }
            
            UIView *viewType = [[UIView alloc]initWithFrame:CGRectMake(viewX+minusWidth, 0, scrollViewWashType.frame.size.width-(minusWidth*2), scrollViewWashType.frame.size.height)];
            viewType.tag = k+1;
            viewType.backgroundColor = [UIColor clearColor];
            [scrollViewWashType addSubview:viewType];
            
//            if (k == 1)
//            {
//                viewType.backgroundColor = [UIColor greenColor];
//            }
            
            float Width = viewType.frame.size.width/[arrTitles count];
            
            for (int i=0; i<arrTitles.count; i++) {
                
                UIButton *washBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                washBtn.frame = CGRectMake(i*(Width), 0, Width, viewType.frame.size.height);
                washBtn.tag = SCHEDULE_SCREEN_TAG + 7 + tagValue;
                //washBtn.backgroundColor = [UIColor redColor];
                washBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
                [washBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [washBtn setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
                [washBtn setTitle:[arrTitles objectAtIndex:i] forState:UIControlStateNormal];
                [washBtn setImage:[UIImage imageNamed:[arrIcons objectAtIndex:i]] forState:UIControlStateNormal];
                [washBtn setImage:[UIImage imageNamed:[arrSelIcons objectAtIndex:i]] forState:UIControlStateSelected];
                [washBtn addTarget:self action:@selector(selectWashType:) forControlEvents:UIControlEventTouchUpInside];
                //washBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
                [viewType addSubview:washBtn];
                
                if (self.isFromUpdateOrder)
                {
                    
                    if (k == 0)
                    {
                        if (i == 0 && [self.arrayJobTypeOrg containsObject:SERVICETYPE_WF])
                        {
                            washBtn.selected = YES;
                        }
                        else if (i == 1 && ([self.arrayJobTypeOrg containsObject:SERVICETYPE_DC] || [self.arrayJobTypeOrg containsObject:SERVICETYPE_DCG]))
                        {
                            washBtn.selected = YES;
                            
                            if ([self.arrayJobTypeOrg containsObject:SERVICETYPE_DCG] && [self.arrayJobTypeOrg containsObject:SERVICETYPE_DC])
                            {
                                [washBtn setImage:[UIImage imageNamed:@"dc_dcg_selected"] forState:UIControlStateSelected];
                                [washBtn setTitleColor:RGBCOLORCODE(105, 151, 20, 1.0) forState:UIControlStateSelected];
                            }
                            else if ([self.arrayJobTypeOrg containsObject:SERVICETYPE_DCG])
                            {
                                [washBtn setImage:[UIImage imageNamed:@"dcg_selected"] forState:UIControlStateSelected];
                                [washBtn setTitleColor:RGBCOLORCODE(105, 151, 20, 1.0) forState:UIControlStateSelected];
                            }
                        }
                        else if (i == 2 && [self.arrayJobTypeOrg containsObject:SERVICETYPE_WI])
                        {
                            washBtn.selected = YES;
                        }
                        else if (i == 3 && [self.arrayJobTypeOrg containsObject:SERVICETYPE_IR])
                        {
                            washBtn.selected = YES;
                        }
                    }
                    
                    else if (k == 1)
                    {
                        if (i == 0 && [self.arrayJobTypeOrg containsObject:SERVICETYPE_CA])
                        {
                            washBtn.selected = YES;
                        }
                        else if (i == 1 && ([self.arrayJobTypeOrg containsObject:SERVICETYPE_CC_DC] || [self.arrayJobTypeOrg containsObject:SERVICETYPE_CC_W_DC] || [self.arrayJobTypeOrg containsObject:SERVICETYPE_CC_WI] || [self.arrayJobTypeOrg containsObject:SERVICETYPE_CC_W_WI]))
                        {
                            washBtn.selected = YES;
                        }
                    }
                    
                    else if (k == 2)
                    {
                       
                        if (i == 0 && [self.arrayJobTypeOrg containsObject:SERVICETYPE_BAG])
                        {
                            washBtn.selected = YES;
                        }
                        else if (i == 1 && ([self.arrayJobTypeOrg containsObject:SERVICETYPE_SHOE_POLISH] || [self.arrayJobTypeOrg containsObject:SERVICETYPE_SHOE_CLEAN]))
                        {
                            washBtn.selected = YES;
                        }
                        else if (i == 2 && [self.arrayJobTypeOrg containsObject:SERVICETYPE_LE])
                        {
                            washBtn.selected = YES;
                        }
                    }
                }
                
                [washBtn centerImageAndTitle:10*MULTIPLYHEIGHT];
                
                if (k == 0)
                {
                    if (i != 3)
                    {
                        UIEdgeInsets titleEdgaeInsets = washBtn.titleEdgeInsets;
                        titleEdgaeInsets.right -= 10;
                        washBtn.titleEdgeInsets = titleEdgaeInsets;
                    }
                }
                
                tagValue ++;
            }
        }
        
        scrollViewWashType.contentSize = CGSizeMake(viewX+washModeSelectionView.frame.size.width, scrollViewWashType.frame.size.height);
        
        
        yPos += CGRectGetHeight(washModeSelectionView.frame);
        
        
        //float btnCX = xPos+20*MULTIPLYHEIGHT;
        float btnCX = xPos+20*MULTIPLYHEIGHT;
        float btnCWidth = screen_width-btnCX*2;
        float btnCHeight = 20*MULTIPLYHEIGHT;
        
        addOrMinusYPos = yPos-btnCHeight;
        
        LblDaysToDeliver = [[UILabel alloc] init];
        LblDaysToDeliver.frame = CGRectMake(btnCX, addOrMinusYPos, btnCWidth, btnCHeight);
        LblDaysToDeliver.textAlignment = NSTextAlignmentCenter;
        LblDaysToDeliver.backgroundColor = [UIColor clearColor];
        LblDaysToDeliver.alpha = 0.0;
        
        LblDaysToDeliver.text = [@"Pick your order type" uppercaseString];
        
        if (self.isFromUpdateOrder)
        {
            [self showDaysToDeliver];
            
//            if ([self.dictUpdateOrder objectForKey:@"pm"])
//            {
//                LblDaysToDeliver.text = [NSString stringWithFormat:@"%@ DAYS TO DELIVER", [self.dictUpdateOrder objectForKey:@"pm"]];
//            }
            
            [self GetDaysToDeliver];
        }
        
        LblDaysToDeliver.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.FONT_SIZE_CUSTOM-5];
        LblDaysToDeliver.textColor = [UIColor blackColor];
        [scheduleScreenView addSubview:LblDaysToDeliver];
        [scheduleScreenView insertSubview:LblDaysToDeliver belowSubview:imgTopStrip];
        LblDaysToDeliver.backgroundColor = RGBCOLORCODE(244, 245, 246, 1.0);
        
//        LblDaysToDeliver.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
//        LblDaysToDeliver.layer.borderWidth = 1.0;
        
        yPos += btnCHeight+15*MULTIPLYHEIGHT;
        
    }
    
    {
        UIButton *pickupDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        pickupDateBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        pickupDateBtn.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        [pickupDateBtn addTarget:self action:@selector(selectPickUpDate:) forControlEvents:UIControlEventTouchUpInside];
        [scheduleScreenView addSubview:pickupDateBtn];
        [pickupDateBtn setBackgroundImage:[AppDelegate imageWithColor:[[UIColor grayColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
        pickupDateBtn.layer.cornerRadius = 15.0;
        pickupDateBtn.clipsToBounds = YES;
        
        
        pickUpDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(xPos+20*MULTIPLYHEIGHT, 0.0, (CGRectGetWidth(pickupDateBtn.bounds) - (xPos*2)), CGRectGetHeight(pickupDateBtn.bounds))];
        
        pickUpDateLbl.textColor = [UIColor grayColor];
        pickUpDateLbl.backgroundColor = [UIColor clearColor];
        pickUpDateLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        
        if (self.isFromUpdateOrder)
        {
            pickUpDateLbl.attributedText = [self setPickupAttributedText];
        }
        else
        {
            pickUpDateLbl.text = @"PICKUP DATE : TIME";
        }
        
        pickUpDateLbl.textAlignment = NSTextAlignmentLeft;
        pickUpDateLbl.userInteractionEnabled = NO;
        [pickupDateBtn addSubview:pickUpDateLbl];
        
        UIImageView *locImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, 0.0, 10*MULTIPLYHEIGHT, CGRectGetHeight(pickupDateBtn.bounds))];
        locImgView.contentMode = UIViewContentModeScaleAspectFit;
        locImgView.image = [UIImage imageNamed:@"pickup_date_time"];
        locImgView.userInteractionEnabled = NO;
        [pickupDateBtn addSubview:locImgView];
        
        UIImageView *dropDownIconView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(pickupDateBtn.bounds) - (xPos*1.5)), 1.0, 15.0, CGRectGetHeight(pickupDateBtn.bounds))];
        dropDownIconView.contentMode = UIViewContentModeScaleAspectFit;
        dropDownIconView.image = [UIImage imageNamed:@"down_arrow"];
        dropDownIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        dropDownIconView.userInteractionEnabled = NO;
        [pickupDateBtn addSubview:dropDownIconView];
        
    }
    
    yPos += height+20*MULTIPLYHEIGHT;
    
    {
        
        UIButton *instructionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        instructionsBtn.frame = CGRectMake(xPos, yPos, 90*MULTIPLYHEIGHT, 40.0*ratio);
        instructionsBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 5*MULTIPLYHEIGHT, 0.0, 0.0);
        //instructionsBtn.backgroundColor = [UIColor redColor];
        [instructionsBtn setImage:[UIImage imageNamed:@"preferences_details_selected"] forState:UIControlStateNormal];
        instructionsBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [instructionsBtn setTitle:@"PREFERENCES" forState:UIControlStateNormal];
        [instructionsBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [instructionsBtn addTarget:self action:@selector(showPreferences) forControlEvents:UIControlEventTouchUpInside];
        instructionsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [scheduleScreenView addSubview:instructionsBtn];
        [instructionsBtn setTitleColor:[BLUE_COLOR colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        
        
        float nextWidth = 55*MULTIPLYHEIGHT;
        float minusX = 74*MULTIPLYHEIGHT;
        
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nextBtn.frame = CGRectMake((screen_width - minusX), yPos, nextWidth, 40.0*ratio);
        [nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
        nextBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1];
        [nextBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [scheduleScreenView addSubview:nextBtn];
        [nextBtn setTitleColor:[BLUE_COLOR colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        
        UIImageView *nextIcon = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nextBtn.bounds) - 10*MULTIPLYHEIGHT), 1.0, 12*MULTIPLYHEIGHT, CGRectGetHeight(nextBtn.bounds))];
        nextIcon.image = [UIImage imageNamed:@"next_arrow_blue"];
        nextIcon.userInteractionEnabled = NO;
        nextIcon.contentMode = UIViewContentModeScaleAspectFit;
        nextIcon.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        [nextBtn addSubview:nextIcon];
        
    }
}

-(void) btnOptionsSelected:(UIButton *) btn
{
    if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"orderSpeed"] intValue] == 0)
    {
        [appDel showAlertWithMessage:@"You can't update order type." andTitle:@"" andBtnTitle:@"OK"];
        
        return;
    }
    
    UIView *viewBg = btn.superview;
    
    for (id sender in viewBg.subviews)
    {
        if ([sender isKindOfClass:[UIButton class]])
        {
            UIButton *btn1 = (UIButton *) sender;
            
            if (btn1.tag == btn.tag)
            {
                btn.selected = YES;
                [viewBg bringSubviewToFront:btn];
                
                if (btn.tag == 1)
                {
                    //btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                    btn.backgroundColor = BLUE_COLOR;
                    
                    lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
                    
                    [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
                }
                else if (btn.tag == 2)
                {
                    //btn.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.7].CGColor;
                    btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                    
                    lblSwitch.text = [@"Next day Delivery" uppercaseString];
                    
                    [self.orderInfo setObject:ORDER_TYPE_EXPRESS forKey:ORDER_TYPE];
                }
            }
            else
            {
                //btn1.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
                btn1.backgroundColor = [UIColor clearColor];
                btn1.selected = NO;
            }
        }
    }
    
    if (btnSwitch != btn || !btnSwitch)
    {
        [self showlblSwitch];
        
        [timerSwitch invalidate];
        timerSwitch = nil;
        
        timerSwitch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hidelblSwitch) userInfo:nil repeats:NO];
        
        [self GetDaysToDeliver];
    }
    
    btnSwitch = btn;
    
    //viewBg.layer.borderColor = btn.backgroundColor.CGColor;
}


-(void) showDaysToDeliver
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = LblDaysToDeliver.frame;
        frame.origin.y = addOrMinusYPos+LblDaysToDeliver.frame.size.height;
        LblDaysToDeliver.frame = frame;
        
        LblDaysToDeliver.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) hideDaysToDeliver
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = LblDaysToDeliver.frame;
        frame.origin.y = addOrMinusYPos;
        LblDaysToDeliver.frame = frame;
        
        LblDaysToDeliver.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    
    CGFloat pageWidth = scrollViewWashType.frame.size.width;
    float fractionalPage = scrollViewWashType.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    [segmentCleaning setSelectedSegmentIndex:page animated:YES];
    
    float offset = 0.0;
    
    if (page == 0)
    {
        offset = -50*MULTIPLYHEIGHT;
    }
    else if (page == 1)
    {
        offset = 90*MULTIPLYHEIGHT;
    }
    else if (page == 2)
    {
        offset = 220*MULTIPLYHEIGHT;
    }
    
    [segmentCleaning.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

-(void) offsetChange
{
    [segmentCleaning.scrollView setContentOffset:CGPointMake(-50*MULTIPLYHEIGHT, 0) animated:YES];
}

-(void) segmentedControlChangedValue:(HMSegmentedControl *)segment
{
    float offset = 0.0;
    
    if (segment.selectedSegmentIndex == 0)
    {
        offset = -50*MULTIPLYHEIGHT;
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        offset = 90*MULTIPLYHEIGHT;
    }
    else if (segment.selectedSegmentIndex == 2)
    {
        offset = 220*MULTIPLYHEIGHT;
    }
    
    [scrollViewWashType setContentOffset:CGPointMake(scrollViewWashType.frame.size.width*segment.selectedSegmentIndex, 0) animated:YES];
    
    [segmentCleaning.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

-(void) didStartScroll:(HMSegmentedControl *)segmentControl Scroller:(UIScrollView *)scrollView
{
    //    float scrollViewWidth = scrollView.frame.size.width;
    //    float scrollContentSizeWidth = scrollView.contentSize.width;
    //    float scrollOffset = scrollView.contentOffset.x;
    //
    //    //    if (scrollOffset == 0)
    //    //    {
    //    //        // then we are at the top
    //    //    }
    //    if (scrollOffset + scrollViewWidth < scrollContentSizeWidth)
    //    {
    //        //viewArrow.hidden = NO;
    //    }
    //    else if (scrollOffset + scrollViewWidth >= scrollContentSizeWidth)
    //    {
    //        //viewArrow.hidden = YES;
    //    }
}

-(void) scrollAnimated
{
    float scrollViewWidth = segmentCleaning.scrollView.frame.size.width;
    float scrollContentSizeWidth = segmentCleaning.scrollView.contentSize.width;
    float scrollOffset = segmentCleaning.scrollView.contentOffset.x;
    
    segmentCleaning.scrollView.contentOffset = CGPointMake(scrollOffset+30*MULTIPLYHEIGHT, segmentCleaning.scrollView.contentOffset.y);
    
    //    if (scrollOffset == 0)
    //    {
    //        // then we are at the top
    //    }
    if (scrollOffset + scrollViewWidth < scrollContentSizeWidth)
    {
        //viewArrow.hidden = NO;
    }
    else if (scrollOffset + scrollViewWidth >= scrollContentSizeWidth)
    {
        //viewArrow.hidden = YES;
    }
}


-(void) btnShoeSelected:(UIButton *)sender
{
    [self showShoePopup];
}


-(void) showShoePopup
{
    [appDel applyCustomBlurEffetForView:self.view WithBlurRadius:5];
    
    blurEffect = [self.view viewWithTag:98765];
    blurEffect.alpha = 0.0;
    //blurEffect.dynamic = YES;
    
    [FXBlurView setUpdatesDisabled];
    
    
    float yAxis = 0;
    
    float vX = 25*MULTIPLYHEIGHT;
    float vH = 300*MULTIPLYHEIGHT;
    
    view_BG = [[UIView alloc]initWithFrame:self.view.bounds];
    view_BG.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self.view addSubview:view_BG];
    view_BG.alpha = 0.0;
    
    
    view_Popup = [[UIView alloc]initWithFrame:CGRectMake(vX, screen_height, screen_width-(vX*2), vH)];
    view_Popup.backgroundColor = [UIColor whiteColor];
    [view_BG addSubview:view_Popup];
    view_Popup.clipsToBounds = YES;
    
    imgEcoBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, yAxis, view_Popup.frame.size.width, view_Popup.frame.size.height)];
    imgEcoBG.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imgEcoBG.image = [UIImage imageNamed:@"shoe_bg"];
    [view_Popup addSubview:imgEcoBG];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20*MULTIPLYHEIGHT, view_Popup.frame.size.width, 20*MULTIPLYHEIGHT)];
    NSString *string = @"SELECT THE TYPE OF SHOE CLEANING";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    [view_Popup addSubview:titleLbl];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    titleLbl.attributedText = attributedString;
    
    
    yAxis += 20*MULTIPLYHEIGHT+30*MULTIPLYHEIGHT;
    
    CGFloat vsX = 30*MULTIPLYHEIGHT;
    
    viewSome = [[UIView alloc]initWithFrame:CGRectMake(vsX, yAxis, view_Popup.frame.size.width-vsX*2, 100*MULTIPLYHEIGHT)];
    viewSome.backgroundColor = [UIColor clearColor];
    [view_Popup addSubview:viewSome];
    
    NSArray *btnTitlesHome = @[@"SHOE\nPOLISH", @"SHOE\nCLEANING"];
    NSArray *btnIconsHome = @[@"shoe_polish", @"shoe_cleaning"];
    NSArray *btnSelIconsHome = @[@"shoe_polish_selected", @"shoe_cleaning_selected"];
    
    float Width = viewSome.frame.size.width/[btnTitlesHome count];
    
    for (int i=0; i<btnTitlesHome.count; i++) {
        
        UIButton *washBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        washBtn.frame = CGRectMake(i*(Width), 0, Width, viewSome.frame.size.height);
        //washBtn.backgroundColor = [UIColor redColor];
        washBtn.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-4];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[btnTitlesHome objectAtIndex:i]];
        
        NSMutableAttributedString *attrSel = [[NSMutableAttributedString alloc] initWithString:[btnTitlesHome objectAtIndex:i]];
        
        if (i == 1)
        {
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, [attr length])];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:BLUE_COLOR} range:NSMakeRange(0, [attr length])];
        }
        else
        {
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, [attr length])];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:BLUE_COLOR} range:NSMakeRange(0, [attr length])];
        }
        
        [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
        [attr addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attr length])];
        
        [attrSel addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrSel length])];
        [attrSel addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attrSel length])];
        
        [washBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [washBtn setAttributedTitle:attrSel forState:UIControlStateSelected];
        
        [washBtn setImage:[UIImage imageNamed:[btnIconsHome objectAtIndex:i]] forState:UIControlStateNormal];
        [washBtn setImage:[UIImage imageNamed:[btnSelIconsHome objectAtIndex:i]] forState:UIControlStateSelected];
        [washBtn addTarget:self action:@selector(selectShoeServieType:) forControlEvents:UIControlEventTouchUpInside];
        [viewSome addSubview:washBtn];
        washBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        washBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (i == 0 && ([arraySelectedServiceTypes containsObject:SERVICETYPE_SHOE_POLISH]))
        {
            washBtn.selected = YES;
        }
        else if (i == 1 && ([arraySelectedServiceTypes containsObject:SERVICETYPE_SHOE_CLEAN]))
        {
            washBtn.selected = YES;
        }
        else
        {
            washBtn.selected = NO;
        }
        
        [washBtn centerImageAndTitle:10*MULTIPLYHEIGHT];
    }
    
    yAxis += viewSome.frame.size.height+20*MULTIPLYHEIGHT;
    
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Popup addSubview:btnDone];
    //[btnDone setImage:[UIImage imageNamed:@"done_icon"] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3];
    [btnDone addTarget:self action:@selector(saveServiceType) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"DONE"];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, [attr length])];
    [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
    [attr addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attr length])];
    
    [btnDone setAttributedTitle:attr forState:UIControlStateNormal];
    
    //[btnDone centerImageAndTitle:5*MULTIPLYHEIGHT];
    
    btnDone.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    
    btnDone.layer.cornerRadius = 5.0;
    
    CGFloat btnDX = 23*MULTIPLYHEIGHT;
    CGFloat btnDH = 25*MULTIPLYHEIGHT;
    
    btnDone.frame = CGRectMake(btnDX, yAxis, view_Popup.frame.size.width-btnDX*2, btnDH);
    
    yAxis += btnDH+20*MULTIPLYHEIGHT;
    
    NSArray *arr = @[appDel.strShoePolish, appDel.strShoeClean];
    
    CGFloat lblDX = 20*MULTIPLYHEIGHT;
    CGFloat lblDW = view_Popup.frame.size.width-lblDX*2;
    
    for (int i = 0; i < [arr count]; i++)
    {
        
        UILabel *lblHead = [[UILabel alloc]initWithFrame:CGRectMake(lblDX, yAxis, lblDW, 20*MULTIPLYHEIGHT)];
        
        if (i == 0)
        {
            lblHead.text = @"Shoe Polish :";
        }
        else
        {
            lblHead.text = @"Shoe Cleaning :";
        }
        
        lblHead.textColor = [UIColor darkGrayColor];
        lblHead.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-4];
        [view_Popup addSubview:lblHead];
        
        yAxis += 20*MULTIPLYHEIGHT;
        
        NSString *strShoeDesc = [arr objectAtIndex:i];
        
        UILabel *lblDesc = [[UILabel alloc]initWithFrame:CGRectMake(lblDX, yAxis, lblDW, 20)];
        lblDesc.numberOfLines = 0;
        lblDesc.textAlignment = NSTextAlignmentJustified;
        lblDesc.textColor = [UIColor grayColor];
        [view_Popup addSubview:lblDesc];
        
        NSMutableAttributedString *lblAttr = [[NSMutableAttributedString alloc]initWithString:strShoeDesc];
        
        [lblAttr addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5], NSKernAttributeName : @(0.7)} range:NSMakeRange(0, lblAttr.string.length)];
        
        lblDesc.attributedText = lblAttr;
        
        CGSize size = [AppDelegate getAttributedTextHeightForText:lblAttr WithWidth:lblDesc.frame.size.width];
        
        CGRect rect = lblDesc.frame;
        rect.size.height = size.height;
        lblDesc.frame = rect;
        
        yAxis += lblDesc.frame.size.height + 10*MULTIPLYHEIGHT;
    }
    
    yAxis += 10*MULTIPLYHEIGHT;
    
    CGRect frame = view_Popup.frame;
    frame.size.height = yAxis;
    view_Popup.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = view_Popup.frame;
        rect.origin.y = screen_height/2-rect.size.height/2;
        view_Popup.frame = rect;
        
        blurEffect.alpha = 1.0;
        view_BG.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) selectShoeServieType:(UIButton *) btn
{
    NSString *strTitle = [btn currentAttributedTitle].string;
    
    if (btn.selected)
    {
        btn.selected = NO;
        
        if ([strTitle caseInsensitiveCompare:@"SHOE\nPOLISH"] == NSOrderedSame)
        {
            [arraySelectedServiceTypes removeObject:SERVICETYPE_SHOE_POLISH];
        }
        else
        {
            [arraySelectedServiceTypes removeObject:SERVICETYPE_SHOE_CLEAN];
        }
    }
    else
    {
        btn.selected = YES;
        
        if ([strTitle caseInsensitiveCompare:@"SHOE\nPOLISH"] == NSOrderedSame)
        {
            [arraySelectedServiceTypes addObject:SERVICETYPE_SHOE_POLISH];
        }
        else
        {
            [arraySelectedServiceTypes addObject:SERVICETYPE_SHOE_CLEAN];
        }
    }
    
    if ([arraySelectedServiceTypes containsObject:SERVICETYPE_SHOE_POLISH] || [arraySelectedServiceTypes containsObject:SERVICETYPE_SHOE_CLEAN])
    {
        btnShoe.selected = YES;
    }
    else
    {
        btnShoe.selected = NO;
    }
}


-(void) btnDryCleaningSelected:(UIButton *)sender
{
    [self showDryCleaningPopup];
}


-(void) showDryCleaningPopup
{
    [appDel applyCustomBlurEffetForView:self.view WithBlurRadius:5];
    
    blurEffect = [self.view viewWithTag:98765];
    blurEffect.alpha = 0.0;
    //blurEffect.dynamic = YES;
    
    [FXBlurView setUpdatesDisabled];
    
    
    float yAxis = 0;
    
    float vX = 25*MULTIPLYHEIGHT;
    float vH = 220*MULTIPLYHEIGHT;
    
    view_BG = [[UIView alloc]initWithFrame:self.view.bounds];
    view_BG.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self.view addSubview:view_BG];
    view_BG.alpha = 0.0;
    
    
    view_Popup = [[UIView alloc]initWithFrame:CGRectMake(vX, screen_height, screen_width-(vX*2), vH)];
    view_Popup.backgroundColor = [UIColor whiteColor];
    [view_BG addSubview:view_Popup];
    view_Popup.clipsToBounds = YES;
    
    imgEcoBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view_Popup.frame.size.width, view_Popup.frame.size.height)];
    imgEcoBG.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imgEcoBG.image = [UIImage imageNamed:@"dc_eco_bg"];
    [view_Popup addSubview:imgEcoBG];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15*MULTIPLYHEIGHT, view_Popup.frame.size.width, 20*MULTIPLYHEIGHT)];
    NSString *string = @"SELECT THE TYPE OF DRY CLEANING";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    [view_Popup addSubview:titleLbl];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    titleLbl.attributedText = attributedString;
    
    
    yAxis += 20*MULTIPLYHEIGHT+30*MULTIPLYHEIGHT;
    
    CGFloat vsX = 25*MULTIPLYHEIGHT;
    
    viewSome = [[UIView alloc]initWithFrame:CGRectMake(vsX, yAxis, view_Popup.frame.size.width-vsX*2, 80*MULTIPLYHEIGHT)];
    viewSome.backgroundColor = [UIColor clearColor];
    [view_Popup addSubview:viewSome];
    
    NSArray *btnTitlesHome = @[@"NORMAL\nDRY CLEANING", @"GREEN\nDRY CLEANING"];
    NSArray *btnIconsHome = @[@"dry_cleaning", @"dcg"];
    NSArray *btnSelIconsHome = @[@"dry_cleaning_selected", @"dcg_selected"];
    
    float Width = viewSome.frame.size.width/[btnTitlesHome count];
    
    for (int i=0; i<btnTitlesHome.count; i++) {
        
        UIButton *washBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        washBtn.frame = CGRectMake(i*(Width), 0, Width, viewSome.frame.size.height);
        //washBtn.backgroundColor = [UIColor redColor];
        washBtn.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-4];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[btnTitlesHome objectAtIndex:i]];
        
        NSMutableAttributedString *attrSel = [[NSMutableAttributedString alloc] initWithString:[btnTitlesHome objectAtIndex:i]];
        
        if (i == 1)
        {
            //[washBtn setTitleColor:RGBCOLORCODE(105, 151, 20, 1.0) forState:UIControlStateNormal];
            
            [attr addAttributes:@{NSForegroundColorAttributeName:RGBCOLORCODE(105, 151, 20, 1.0)} range:NSMakeRange(0, [attr length])];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:RGBCOLORCODE(105, 151, 20, 1.0)} range:NSMakeRange(0, [attr length])];
        }
        else
        {
//            [washBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [washBtn setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
            
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, [attr length])];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:BLUE_COLOR} range:NSMakeRange(0, [attr length])];
        }
        
        [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
        [attr addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attr length])];
        
        [attrSel addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrSel length])];
        [attrSel addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attrSel length])];
        
        [washBtn setAttributedTitle:attr forState:UIControlStateNormal];
        [washBtn setAttributedTitle:attrSel forState:UIControlStateSelected];
        
        //[washBtn setTitle:[btnTitlesHome objectAtIndex:i] forState:UIControlStateNormal];
        [washBtn setImage:[UIImage imageNamed:[btnIconsHome objectAtIndex:i]] forState:UIControlStateNormal];
        [washBtn setImage:[UIImage imageNamed:[btnSelIconsHome objectAtIndex:i]] forState:UIControlStateSelected];
        [washBtn addTarget:self action:@selector(selectDCServieType:) forControlEvents:UIControlEventTouchUpInside];
        [viewSome addSubview:washBtn];
        washBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        washBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (i == 0 && ([arraySelectedServiceTypes containsObject:SERVICETYPE_DC]))
        {
            washBtn.selected = YES;
        }
        if (i == 1 && ([arraySelectedServiceTypes containsObject:SERVICETYPE_DCG]))
        {
            washBtn.selected = YES;
        }
        else
        {
            washBtn.selected = NO;
        }
        
        [washBtn centerImageAndTitle:10*MULTIPLYHEIGHT];
        
        UIEdgeInsets titleEdgaeInsets = washBtn.titleEdgeInsets;
        titleEdgaeInsets.left -= 7*MULTIPLYHEIGHT;
        washBtn.titleEdgeInsets = titleEdgaeInsets;
    }
    
    yAxis += viewSome.frame.size.height+20*MULTIPLYHEIGHT;
    
    CGFloat imgX = 20*MULTIPLYHEIGHT;
    
    UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, yAxis, view_Popup.frame.size.width-imgX*2, 1)];
    imgLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [view_Popup addSubview:imgLine];
    
    yAxis += 15*MULTIPLYHEIGHT;
    
    
//    UILabel *lblOff = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, view_Popup.frame.size.width, 20*MULTIPLYHEIGHT)];
//    lblOff.numberOfLines = 0;
//    NSString *stringOff = @"GET 25% CASHBACK ON\n";
//    NSString *str2 = @"YOUR FIRST ECO DRY CLEANING";
//    
//    NSString *strApp = [NSString stringWithFormat:@"%@%@", stringOff, str2];
//    
//    lblOff.textAlignment = NSTextAlignmentCenter;
//    lblOff.backgroundColor = [UIColor clearColor];
//    [view_Popup addSubview:lblOff];
//    
//    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:strApp];
//    
//    float spacing1 = 0.7f;
//    [attributedString1 addAttribute:NSKernAttributeName value:@(spacing1) range:NSMakeRange(0, [stringOff length])];
//    
//    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
//    [paragraphStyle setLineSpacing:4.0f];
//    [paragraphStyle setMaximumLineHeight:100.0f];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    
//    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, strApp.length)];
//    
//    [attributedString1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_Heavy size:appDel.HEADER_LABEL_FONT_SIZE-6], NSForegroundColorAttributeName:RGBCOLORCODE(107, 147, 31, 1.0)} range:NSMakeRange(0, [stringOff length])];
//    
//    [attributedString1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-5], NSForegroundColorAttributeName:RGBCOLORCODE(107, 147, 31, 1.0)} range:NSMakeRange([stringOff length], [str2 length])];
//    
//    float spacing2 = 0.7f;
//    [attributedString1 addAttribute:NSKernAttributeName value:@(spacing2) range:NSMakeRange([stringOff length], [str2 length])];
//    
//    CGSize size = [AppDelegate getAttributedTextHeightForText:attributedString1 WithWidth:lblOff.frame.size.width];
//    
//    CGRect rectOff = lblOff.frame;
//    rectOff.size.height = size.height;
//    lblOff.frame = rectOff;
//    
//    lblOff.attributedText = attributedString1;
//    
//    yAxis += lblOff.frame.size.height+20*MULTIPLYHEIGHT;
    
    
    
    CGFloat lblDX = 15*MULTIPLYHEIGHT;
    
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(lblDX, yAxis, view_Popup.frame.size.width-(lblDX*2), 0)];
    
    NSString *str1 = GDC_TITLE;
    NSString *str2 = GDC_TEXT;
    NSString *str3 = GDC_FINAL;
    
    NSString *strTo = [NSString stringWithFormat:@"%@%@%@", str1, str2, str3];
    
    lblDesc.textAlignment = NSTextAlignmentCenter;
    lblDesc.numberOfLines = 0;
    lblDesc.textColor = [UIColor lightGrayColor];
    //lblDesc.backgroundColor = [UIColor redColor];
    lblDesc.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-6];
    [view_Popup addSubview:lblDesc];
    
    NSMutableAttributedString *attrDesc = [[NSMutableAttributedString alloc] initWithString:strTo];
    
    NSMutableParagraphStyle *paragraphStyleDes = NSMutableParagraphStyle.new;
    [paragraphStyleDes setLineSpacing:3.0f];
    [paragraphStyleDes setMaximumLineHeight:100.0f];
    paragraphStyleDes.alignment = NSTextAlignmentCenter;
    
    [attrDesc addAttribute:NSParagraphStyleAttributeName value:paragraphStyleDes range:NSMakeRange(0, strTo.length)];
    
    spacing = 1.0f;
    [attrDesc addAttribute:NSKernAttributeName  value:@(spacing) range:NSMakeRange(0, [strTo length])];
    
    [attrDesc addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-4], NSForegroundColorAttributeName:RGBCOLORCODE(107, 147, 31, 1.0)} range:NSMakeRange(0, [str1 length])];
    
    [attrDesc addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange([str1 length], [str2 length])];
    
    [attrDesc addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD_ITALIC size:appDel.FONT_SIZE_CUSTOM-4], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange([str1 length]+[str2 length], [str3 length])];
    
    lblDesc.attributedText = attrDesc;
    
    CGSize sizeDesc = [AppDelegate getAttributedTextHeightForText:attrDesc WithWidth:lblDesc.frame.size.width];
    
    CGRect rectDesc = lblDesc.frame;
    rectDesc.size.height = sizeDesc.height;
    lblDesc.frame = rectDesc;
    
    
    yAxis += lblDesc.frame.size.height+10*MULTIPLYHEIGHT;
    
    UIButton *btnPL = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Popup addSubview:btnPL];
    //btnPL.backgroundColor = [UIColor redColor];
    btnPL.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-6];
    [btnPL addTarget:self action:@selector(btnPriceListClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *attrPL = [[NSMutableAttributedString alloc] initWithString:@"SEE PRICE LIST"];
    
    [attrPL addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, [attrPL length])];
    [attrPL addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrPL length])];
    [attrPL addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attrPL length])];
    
    [attrPL addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:(NSRange){0,[attrPL length]}];
    
    [btnPL setAttributedTitle:attrPL forState:UIControlStateNormal];
    
    float btnPLW = 100*MULTIPLYHEIGHT;
    
    btnPL.frame = CGRectMake(view_Popup.frame.size.width/2-btnPLW/2, yAxis, btnPLW, 25*MULTIPLYHEIGHT);
    
    yAxis += 25*MULTIPLYHEIGHT+10*MULTIPLYHEIGHT;
    
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Popup addSubview:btnDone];
    //[btnDone setImage:[UIImage imageNamed:@"done_icon"] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3];
    [btnDone addTarget:self action:@selector(saveServiceType) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"DONE"];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, [attr length])];
    [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
    [attr addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attr length])];
    
    [btnDone setAttributedTitle:attr forState:UIControlStateNormal];
    
    //[btnDone centerImageAndTitle:5*MULTIPLYHEIGHT];
    
    btnDone.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    
    btnDone.layer.cornerRadius = 5.0;
    
    CGFloat btnDX = 23*MULTIPLYHEIGHT;
    CGFloat btnDH = 25*MULTIPLYHEIGHT;
    
    btnDone.frame = CGRectMake(btnDX, yAxis, view_Popup.frame.size.width-btnDX*2, btnDH);
    
    yAxis += btnDH+60*MULTIPLYHEIGHT;
    
    
//    UIButton *btnKM = [UIButton buttonWithType:UIButtonTypeCustom];
//    [view_Popup addSubview:btnKM];
//    [btnKM setImage:[UIImage imageNamed:@"apple_arrow_down"] forState:UIControlStateNormal];
//    btnKM.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-6];
//    [btnKM addTarget:self action:@selector(btnKnowMoreClicked) forControlEvents:UIControlEventTouchUpInside];
//    
//    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:@"KNOW MORE"];
//    
//    [attr1 addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, [attr1 length])];
//    [attr1 addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr1 length])];
//    [attr1 addAttribute:NSKernAttributeName value:@(1.0) range:NSMakeRange(0, [attr1 length])];
//    
//    [btnKM setAttributedTitle:attr1 forState:UIControlStateNormal];
//    
//    [btnKM buttonImageAndTextWithImagePosition:@"BOTTOM" WithSpacing:5*MULTIPLYHEIGHT];
//    
//    float btnKMW = 100*MULTIPLYHEIGHT;
//    
//    btnKM.frame = CGRectMake(view_Popup.frame.size.width/2-btnKMW/2, yAxis, btnKMW, 35*MULTIPLYHEIGHT);
//    
////    UIEdgeInsets titleInsets = btnKM.titleEdgeInsets;
////    titleInsets.left -= 8*MULTIPLYHEIGHT;
////    btnKM.titleEdgeInsets = titleInsets;
//    
//    UIEdgeInsets imgInsets = btnKM.imageEdgeInsets;
//    imgInsets.left += 8*MULTIPLYHEIGHT;
//    btnKM.imageEdgeInsets = imgInsets;
//    
//    yAxis += 35*MULTIPLYHEIGHT+10*MULTIPLYHEIGHT;
    
    
    CGRect frame = view_Popup.frame;
    frame.size.height = yAxis;
    view_Popup.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = view_Popup.frame;
        rect.origin.y = screen_height/2-rect.size.height/2;
        view_Popup.frame = rect;
        
        blurEffect.alpha = 1.0;
        view_BG.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void) btnKnowMoreClicked
{
    if (knowMoreExpanded)
    {
        knowMoreExpanded = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Popup.frame;
            frame.size.height -= 120*MULTIPLYHEIGHT;
            view_Popup.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        knowMoreExpanded = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
           
            CGRect frame = view_Popup.frame;
            frame.size.height += 120*MULTIPLYHEIGHT;
            view_Popup.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = view_Popup.frame;
        rect.origin.y = screen_height/2-rect.size.height/2;
        view_Popup.frame = rect;
        
        blurEffect.alpha = 1.0;
        view_BG.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) selectDCServieType:(UIButton *) btn
{
    NSString *strTitle = [btn currentAttributedTitle].string;
    
    if (btn.selected)
    {
        btn.selected = NO;
        
        if ([strTitle caseInsensitiveCompare:@"Normal\nDry cleaning"] == NSOrderedSame)
        {
            [arraySelectedServiceTypes removeObject:SERVICETYPE_DC];
        }
        else
        {
            [arraySelectedServiceTypes removeObject:SERVICETYPE_DCG];
        }
    }
    else
    {
        btn.selected = YES;
        
        if ([strTitle caseInsensitiveCompare:@"Normal\nDry cleaning"] == NSOrderedSame)
        {
            [arraySelectedServiceTypes addObject:SERVICETYPE_DC];
        }
        else
        {
            [arraySelectedServiceTypes addObject:SERVICETYPE_DCG];
        }
    }
    
    if ([arraySelectedServiceTypes containsObject:SERVICETYPE_DC] || [arraySelectedServiceTypes containsObject:SERVICETYPE_DCG])
    {
        btnDryCleaning.selected = YES;
    }
    else
    {
        btnDryCleaning.selected = NO;
    }
}

-(void) btnPriceListClicked
{
    PriceListViewController_New *pVC = [[PriceListViewController_New alloc] init];
    pVC.selectedServiceTypeId = SERVICETYPE_DCG;
    [self.navigationController pushViewController:pVC animated:YES];
}


-(void) btnCurtainsSelected:(UIButton *)sender
{
    [self showCurtainsPopup];
}

-(void) showCurtainsPopup
{
    selectedCurtainServiceType = SERVICETYPE_CC_DC;
    
    [appDel applyCustomBlurEffetForView:self.view WithBlurRadius:5];
    
    blurEffect = [self.view viewWithTag:98765];
    blurEffect.alpha = 0.0;
    //blurEffect.dynamic = YES;
    
    [FXBlurView setUpdatesDisabled];
    
    
    float yAxis = 0;
    
    float vX = 25*MULTIPLYHEIGHT;
    float vH = 220*MULTIPLYHEIGHT;
    
    view_BG = [[UIView alloc]initWithFrame:self.view.bounds];
    view_BG.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [self.view addSubview:view_BG];
    view_BG.alpha = 0.0;
    
    
    view_Popup = [[UIView alloc]initWithFrame:CGRectMake(vX, screen_height, screen_width-(vX*2), vH)];
    view_Popup.backgroundColor = [UIColor whiteColor];
    [view_BG addSubview:view_Popup];
    
    float imgBH = 80*MULTIPLYHEIGHT;
    
    UIImageView *imgBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, yAxis, view_Popup.frame.size.width, imgBH)];
    imgBg.image = [UIImage imageNamed:@"preference_bg"];
    [view_Popup addSubview:imgBg];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 15*MULTIPLYHEIGHT, view_Popup.frame.size.width, 20*MULTIPLYHEIGHT)];
    NSString *string = @"CURTAINS";
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
    [view_Popup addSubview:titleLbl];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    titleLbl.attributedText = attributedString;
    
    
    float imgWidth = 30*MULTIPLYHEIGHT;
    
    UIImageView *imgTop = [[UIImageView alloc]init];
    imgTop.contentMode = UIViewContentModeScaleAspectFit;
    imgTop.frame = CGRectMake(view_Popup.frame.size.width/2-imgWidth/2, 15*MULTIPLYHEIGHT+titleLbl.frame.size.height+5*MULTIPLYHEIGHT, imgWidth, imgWidth);
    imgTop.image = [UIImage imageNamed:@"curtains_icon"];
    [view_Popup addSubview:imgTop];
    
    
    yAxis += imgBH+20*MULTIPLYHEIGHT;
    
//    UILabel *lblType = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, view_Popup.frame.size.width, 20*MULTIPLYHEIGHT)];
//    lblType.text = @"SELECT YOUR SERVICE TYPE";
//    lblType.textAlignment = NSTextAlignmentCenter;
//    lblType.textColor = [UIColor lightGrayColor];
//    lblType.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
//    [view_Popup addSubview:lblType];
//    
//    yAxis += 20*MULTIPLYHEIGHT+20*MULTIPLYHEIGHT;
//    
//    
//    CGFloat vsX = 30*MULTIPLYHEIGHT;
//    
//    viewSome = [[UIView alloc]initWithFrame:CGRectMake(vsX, yAxis, view_Popup.frame.size.width-vsX*2, 50*MULTIPLYHEIGHT)];
//    viewSome.backgroundColor = [UIColor clearColor];
//    [view_Popup addSubview:viewSome];
//    
//    NSArray *btnTitlesHome = @[@"DRY CLEANING", @"WASH & IRON"];
//    NSArray *btnIconsHome = @[@"dry_cleaning", @"wash_and_iron"];
//    NSArray *btnSelIconsHome = @[@"dry_cleaning_selected", @"wash_and_iron_selected"];
//    
//    float Width = viewSome.frame.size.width/[btnTitlesHome count];
//    
//    for (int i=0; i<btnTitlesHome.count; i++) {
//        
//        UIButton *washBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        washBtn.frame = CGRectMake(i*(Width), 0, Width, viewSome.frame.size.height);
//        //washBtn.backgroundColor = [UIColor redColor];
//        washBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
//        [washBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [washBtn setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
//        [washBtn setTitle:[btnTitlesHome objectAtIndex:i] forState:UIControlStateNormal];
//        [washBtn setImage:[UIImage imageNamed:[btnIconsHome objectAtIndex:i]] forState:UIControlStateNormal];
//        [washBtn setImage:[UIImage imageNamed:[btnSelIconsHome objectAtIndex:i]] forState:UIControlStateSelected];
//        [washBtn addTarget:self action:@selector(selectCurtainServieType:) forControlEvents:UIControlEventTouchUpInside];
//        [viewSome addSubview:washBtn];
//        
//        
//        // CC_WI, CC_DC, CC_W_WI, CC_W_DC
//        
//        if (i == 0 && ([selectedCurtainServiceType isEqualToString:SERVICETYPE_CC_DC] || [selectedCurtainServiceType isEqualToString:SERVICETYPE_CC_W_DC]))
//        {
//            washBtn.selected = YES;
//        }
//        else if (i == 1 && ([selectedCurtainServiceType isEqualToString:SERVICETYPE_CC_WI] || [selectedCurtainServiceType isEqualToString:SERVICETYPE_CC_W_WI]))
//        {
//            washBtn.selected = YES;
//        }
//        else
//        {
//            washBtn.selected = NO;
//        }
//        
//        [washBtn centerImageAndTitle:10*MULTIPLYHEIGHT];
//    }
//    
//    yAxis += viewSome.frame.size.height+35*MULTIPLYHEIGHT;
//    
//    CGFloat imgX = 20*MULTIPLYHEIGHT;
//    
//    UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, yAxis, view_Popup.frame.size.width-imgX*2, 1)];
//    imgLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
//    [view_Popup addSubview:imgLine];
//    
//    yAxis += 12*MULTIPLYHEIGHT;
    
    CGFloat lblIX = 20*MULTIPLYHEIGHT;
    CGFloat lblIH = 30*MULTIPLYHEIGHT;
    
    lblInst = [[UILabel alloc]initWithFrame:CGRectMake(lblIX, yAxis, view_Popup.frame.size.width-lblIX*2, lblIH)];
    lblInst.textColor = [UIColor darkGrayColor];
    lblInst.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    lblInst.numberOfLines = 0;
    lblInst.textAlignment = NSTextAlignmentCenter;
    lblInst.text = @"With Removal & Installation";
    [view_Popup addSubview:lblInst];
    
    yAxis += lblIH+5*MULTIPLYHEIGHT;
    
    // Custom Switch
    
    CGFloat sgX = 50 * MULTIPLYHEIGHT;
    CGFloat sgH = 17 * MULTIPLYHEIGHT;
    
    segmentCurtain = [[UISegmentedControl alloc]initWithItems:@[@"YES", @"NO"]];
    segmentCurtain.frame = CGRectMake(sgX, yAxis, view_Popup.frame.size.width-(sgX * 2), sgH);
    [segmentCurtain setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4]} forState:UIControlStateSelected];
    [segmentCurtain setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLORCODE(64, 143, 210, 1.0), NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4]} forState:UIControlStateNormal];
    [segmentCurtain addTarget:self action:@selector(curtainPreference:) forControlEvents:UIControlEventValueChanged];
    segmentCurtain.tintColor = RGBCOLORCODE(64, 143, 210, 1.0);
    segmentCurtain.selectedSegmentIndex = 1;
    [view_Popup addSubview:segmentCurtain];
    
    
//    switchCurtain = [[SevenSwitch alloc] initWithFrame:CGRectMake(30*MULTIPLYHEIGHT+100*MULTIPLYHEIGHT+10*MULTIPLYHEIGHT,  yAxis+15*MULTIPLYHEIGHT, 35*MULTIPLYHEIGHT, 14*MULTIPLYHEIGHT)];
//    switchCurtain.onLabel.text = @"";
//    switchCurtain.offLabel.text = @"";
//    //switchCurtain.center = CGPointMake(self.view.bounds.size.width * 0.5, 30);
//    switchCurtain.inactiveColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
//    //switchCurtain.onTintColor = [UIColor colorWithRed:0.45f green:0.58f blue:0.67f alpha:1.00f];
//    [switchCurtain addTarget:self action:@selector(curtainPreference:) forControlEvents:UIControlEventValueChanged];
//    //switchCurtain.thumbImage = [UIImage imageNamed:@"round_image"];
//    //        switchCurtain.offImage = [UIImage imageNamed:@"cross.png"];
//    //        switchCurtain.onImage = [UIImage imageNamed:@"check.png"];
//    //switchCurtain.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
//    switchCurtain.onLabel.textColor = [UIColor whiteColor];
//    switchCurtain.isRounded = YES;
//    [view_Popup addSubview:switchCurtain];
//    
//    [switchCurtain setOn:NO animated:YES];
    
    
    yAxis += sgH+25*MULTIPLYHEIGHT;
    
    UIButton *btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Popup addSubview:btnDone];
    //[btnDone setImage:[UIImage imageNamed:@"done_icon"] forState:UIControlStateNormal];
    btnDone.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
    [btnDone addTarget:self action:@selector(saveServiceType) forControlEvents:UIControlEventTouchUpInside];
    btnDone.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    
    btnDone.layer.cornerRadius = 5.0;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"DONE"];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, [attr length])];
    [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
    [btnDone setAttributedTitle:attr forState:UIControlStateNormal];
    
//    [btnDone centerImageAndTitle:3*MULTIPLYHEIGHT];
//    
//    UIEdgeInsets titleInsets = btnDone.titleEdgeInsets;
//    titleInsets.left -= 3*MULTIPLYHEIGHT;
//    btnDone.titleEdgeInsets = titleInsets;
    
    
    CGFloat btnDX = 23*MULTIPLYHEIGHT;
    CGFloat btnDH = 25*MULTIPLYHEIGHT;
    
    btnDone.frame = CGRectMake(btnDX, yAxis, view_Popup.frame.size.width-btnDX*2, btnDH);
    
    yAxis += btnDH+20*MULTIPLYHEIGHT;
    
    
    NSString *strCurtainDesc = @"";
    
    if (appDel.strCurtainClean)
    {
        strCurtainDesc = appDel.strCurtainClean;
    }
    else
    {
        strCurtainDesc = @"A thorough dry cleaning of curtains & drapes to give your living spaces a clean & vibrant look, with features like Removal & Installation offering great convenience.";
    }
    
    CGFloat lblDX = 20*MULTIPLYHEIGHT;
    CGFloat lblDW = view_Popup.frame.size.width-lblDX*2;
    
    UILabel *lblDesc = [[UILabel alloc]initWithFrame:CGRectMake(lblDX, yAxis, lblDW, 20)];
    lblDesc.numberOfLines = 0;
    lblDesc.textAlignment = NSTextAlignmentCenter;
    lblDesc.textColor = [UIColor grayColor];
    [view_Popup addSubview:lblDesc];
    
    NSMutableAttributedString *lblAttr = [[NSMutableAttributedString alloc]initWithString:strCurtainDesc];
    
    [lblAttr addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5], NSKernAttributeName : @(0.7)} range:NSMakeRange(0, lblAttr.string.length)];
    
    lblDesc.attributedText = lblAttr;
    
    CGSize size = [AppDelegate getAttributedTextHeightForText:lblAttr WithWidth:lblDesc.frame.size.width];
    
    CGRect rect = lblDesc.frame;
    rect.size.height = size.height;
    lblDesc.frame = rect;
    
    yAxis += size.height+30*MULTIPLYHEIGHT;
    
    CGRect frame = view_Popup.frame;
    frame.size.height = yAxis;
    view_Popup.frame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = view_Popup.frame;
        rect.origin.y = screen_height/2-rect.size.height/2;
        view_Popup.frame = rect;
        
        blurEffect.alpha = 1.0;
        view_BG.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void) selectCurtainServieType:(UIButton *) btn
{
    for (UIButton *btn1 in viewSome.subviews)
    {
        btn1.selected = NO;
    }
    
    btn.selected = YES;
    
    NSString *strTitle = [btn currentTitle];
    
    if ([strTitle caseInsensitiveCompare:@"Dry cleaning"] == NSOrderedSame)
    {
        if (segmentCurtain.selectedSegmentIndex == 0)
        {
            selectedCurtainServiceType = SERVICETYPE_CC_W_DC;
        }
        else
        {
            selectedCurtainServiceType = SERVICETYPE_CC_DC;
        }
    }
    else
    {
        if (segmentCurtain.selectedSegmentIndex == 0)
        {
            selectedCurtainServiceType = SERVICETYPE_CC_W_WI;
        }
        else
        {
            selectedCurtainServiceType = SERVICETYPE_CC_WI;
        }
    }
    
    btnCurtain.selected = YES;
}


-(void) curtainPreference:(UISegmentedControl *)switch1
{
    if (switch1.selectedSegmentIndex == 0)
    {
        selectedCurtainServiceType = SERVICETYPE_CC_W_DC;
    }
    else
    {
        selectedCurtainServiceType = SERVICETYPE_CC_DC;
    }
}

//-(void) curtainPreference:(UISegmentedControl *)switch1
//{
//    if (switch1.selectedSegmentIndex == 0)
//    {
//        for (UIButton *btn1 in viewSome.subviews)
//        {
//            if (btn1.selected)
//            {
//                NSString *strTitle = [btn1 currentTitle];
//                
//                if ([strTitle caseInsensitiveCompare:@"Dry cleaning"] == NSOrderedSame)
//                {
//                    selectedCurtainServiceType = SERVICETYPE_CC_W_DC;
//                }
//                else
//                {
//                    selectedCurtainServiceType = SERVICETYPE_CC_W_WI;
//                }
//            }
//        }
//    }
//    else
//    {
//        for (UIButton *btn1 in viewSome.subviews)
//        {
//            if (btn1.selected)
//            {
//                NSString *strTitle = [btn1 currentTitle];
//                
//                if ([strTitle caseInsensitiveCompare:@"Dry cleaning"] == NSOrderedSame)
//                {
//                    selectedCurtainServiceType = SERVICETYPE_CC_DC;
//                }
//                else
//                {
//                    selectedCurtainServiceType = SERVICETYPE_CC_WI;
//                }
//            }
//        }
//    }
//}

-(void) saveServiceType
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = view_Popup.frame;
        rect.origin.y = screen_height;
        view_Popup.frame = rect;
        
        blurEffect.alpha = 0.0;
        view_BG.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [viewSome removeFromSuperview];
        viewSome = nil;
        
        [view_Popup removeFromSuperview];
        view_Popup = nil;
        
        [view_BG removeFromSuperview];
        view_BG = nil;
        
        [blurEffect removeFromSuperview];
        blurEffect = nil;
        
    }];
    
    if ([selectedCurtainServiceType length])
    {
        btnCurtain.selected = YES;
        
        if (![arraySelectedServiceTypes containsObject:selectedCurtainServiceType])
        {
            [arraySelectedServiceTypes addObject:selectedCurtainServiceType];
        }
    }
    else
    {
//        btnCurtain.selected = NO;
//        btnDryCleaning.selected = NO;
//        btnShoe.selected = NO;
    }
    
    if (btnCurtain.selected || btnDryCleaning.selected || btnShoe.selected)
    {
        if (btnDryCleaning.selected)
        {
            if ([arraySelectedServiceTypes containsObject:SERVICETYPE_DC] && [arraySelectedServiceTypes containsObject:SERVICETYPE_DCG])
            {
                [btnDryCleaning setImage:[UIImage imageNamed:@"dc_dcg_selected"] forState:UIControlStateSelected];
                [btnDryCleaning setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
            }
            else if ([arraySelectedServiceTypes containsObject:SERVICETYPE_DC])
            {
                [btnDryCleaning setImage:[UIImage imageNamed:@"dry_cleaning_selected"] forState:UIControlStateSelected];
                [btnDryCleaning setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
            }
            else
            {
                [btnDryCleaning setImage:[UIImage imageNamed:@"dcg_selected"] forState:UIControlStateSelected];
                [btnDryCleaning setTitleColor:RGBCOLORCODE(105, 151, 20, 1.0) forState:UIControlStateSelected];
            }
            
            [btnDryCleaning centerImageAndTitle:10*MULTIPLYHEIGHT];
        }
        
        if (![pickUpDateLbl.text isEqualToString:@"PICKUP DATE : TIME"])
        {
            [self fetchPickUpDates:NO];
        }
        
        [self showDaysToDeliver];
        
        [self GetDaysToDeliver];
    }
    
    selectedCurtainServiceType = @"";
}



-(void) showPreferences
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:PREFERENCES_OPENED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    PreferencesViewController *objPre = [[PreferencesViewController alloc]init];
    objPre.delegate = self;
    objPre.strPrefs = [self.orderInfo objectForKey:PREFERENCES_SELECTED];
    objPre.isFromUpdateOrder = self.isFromUpdateOrder;
    
    if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"preferences"] intValue] == 0)
    {
        objPre.notEditable = YES;
    }
    
    [self presentViewController:objPre animated:YES completion:nil];
}

-(void) didAddPreferences:(NSString *) strPrefs
{
    [self.orderInfo setObject:strPrefs forKey:PREFERENCES_SELECTED];
    
    if (prefsOpenedAutomatically)
    {
        prefsOpenedAutomatically = NO;
        
        [self gotoDeliveryScreen];
    }
}

-(NSMutableAttributedString *) setPickupAttributedText
{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *date = [dtFormatter dateFromString:[self.orderInfo objectForKey:ORDER_PICKUP_DATE]];
    
    [dtFormatter setDateFormat:@"dd MMM, EEE"];
    NSString *strDate = [dtFormatter stringFromDate:date];
    
    
    NSString *str1 = @"PICKUP ";
    NSString *str2 = [[NSString stringWithFormat:@"%@ : %@", strDate, [self.orderInfo objectForKey:ORDER_PICKUP_SLOT]]uppercaseString];
    
    NSString *strTotal = [NSString stringWithFormat:@"%@ %@", str1, str2];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:strTotal];
    
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, str1.length)];
    
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2], NSForegroundColorAttributeName : BLUE_COLOR} range:NSMakeRange(str1.length+1, str2.length)];
    
    float spacing = 0.6f;
    [attrStr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrStr length])];
    
    return attrStr;
}

-(void) hidelblSwitch
{
    lblSwitch.alpha = 1.0;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        lblSwitch.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) showlblSwitch
{
    lblSwitch.alpha = 0.0;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        lblSwitch.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

//-(void) switchChanged:(SevenSwitch *)switch1
//{
//    if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"orderSpeed"] intValue] == 0)
//    {
//        [appDel showAlertWithMessage:@"You can't update order type." andTitle:@"" andBtnTitle:@"OK"];
//        
//        if ([[self.orderInfo objectForKey:ORDER_TYPE] caseInsensitiveCompare:@"R"] == NSOrderedSame)
//        {
//            [switch1 setOn:NO animated:YES];
//        }
//        else
//        {
//            [switch1 setOn:YES animated:YES];
//        }
//        
//        return;
//    }
//    
//    if(switch1.on)
//    {
//        lblSwitch.text = [@"Next day Delivery" uppercaseString];
//        
//        //switch1.thumbImage = [UIImage imageNamed:@"thumb_selected"];
//        
//        [self.orderInfo setObject:ORDER_TYPE_EXPRESS forKey:ORDER_TYPE];
//    }
//    else
//    {
//        lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
//        
//        //switch1.thumbImage = [UIImage imageNamed:@"thumb_nonselected"];
//        
//        [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
//    }
//    
//    [self showlblSwitch];
//    
//    [timerSwitch invalidate];
//    timerSwitch = nil;
//    
//    timerSwitch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hidelblSwitch) userInfo:nil repeats:NO];
//    
//    [self GetDaysToDeliver];
//}

//-(void) switchChanged:(UISegmentedControl *)switch1
//{
//    if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"orderSpeed"] intValue] == 0)
//    {
//        [appDel showAlertWithMessage:@"You can't update order type." andTitle:@"" andBtnTitle:@"OK"];
//        
//        if ([[self.orderInfo objectForKey:ORDER_TYPE] caseInsensitiveCompare:@"R"] == NSOrderedSame)
//        {
//            switch1.selectedSegmentIndex = 0;
//            segmentSwitch.tintColor = RGBCOLORCODE(64, 143, 210, 1.0);
//        }
//        else
//        {
//            switch1.selectedSegmentIndex = 1;
//            segmentSwitch.tintColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
//        }
//        
//        return;
//    }
//    
//    if(switch1.selectedSegmentIndex == 1)
//    {
//        lblSwitch.text = [@"Next day Delivery" uppercaseString];
//        segmentSwitch.tintColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
//        
//        [self.orderInfo setObject:ORDER_TYPE_EXPRESS forKey:ORDER_TYPE];
//    }
//    else
//    {
//        lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
//        segmentSwitch.tintColor = RGBCOLORCODE(64, 143, 210, 1.0);
//        
//        [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
//    }
//    
//    [self showlblSwitch];
//    
//    [timerSwitch invalidate];
//    timerSwitch = nil;
//    
//    timerSwitch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hidelblSwitch) userInfo:nil repeats:NO];
//    
//    [self GetDaysToDeliver];
//}


#pragma mark - Action Event Handler
- (void) handleExpressSwitch:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if(sender.selected) {
        [self.orderInfo setObject:ORDER_TYPE_EXPRESS forKey:ORDER_TYPE];
    }
    else {
        [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
    }
    
    [self GetDaysToDeliver];
    
}

-(NSString *) setTitleForAddress
{
    NSMutableString *str = [[NSMutableString alloc]init];
    
    if ([[selectedAddress objectForKey:@"name"]length])
    {
        [str appendString:[selectedAddress objectForKey:@"name"]];
    }
    
    if ([[selectedAddress  objectForKey:@"line1"]length] > 1)
    {
        [str appendString:[NSString stringWithFormat:@", %@", [selectedAddress  objectForKey:@"line1"]]];
    }
    else if ([[selectedAddress  objectForKey:@"line2"]length])
    {
        [str appendString:[NSString stringWithFormat:@", %@", [selectedAddress  objectForKey:@"line2"]]];
    }
    
    if ([[selectedAddress  objectForKey:@"zipcode"]length])
    {
        [str appendString:[NSString stringWithFormat:@", %@", [selectedAddress  objectForKey:@"zipcode"]]];
    }
    
    return str;
}

- (void)selectPickUpAddress:(UIButton *)sender {
    
    if (self.isFromUpdateOrder)
    {
        if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"pickupAddress"] intValue] == 0)
        {
            [appDel showAlertWithMessage:@"You can't update pickup address now." andTitle:@"" andBtnTitle:@"OK"];
            return;
        }
    }
    
    if ([addressBtn isSelected])
    {
        [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
            
            customPopOverView.alpha = 0.0;
            
            CGRect frame = addressBtn.frame;
            frame.origin.y = previousAddressYAxis;
            addressBtn.frame = frame;
            
            
        } completion:^(BOOL finished) {
            
            [customPopOverView removeFromSuperview];
            customPopOverView = nil;
            
            addressBtn.selected = NO;
            
            [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }];
        
        return;
    }
    
    previousAddressYAxis = addressBtn.frame.origin.y;
    
    addressBtn.selected = YES;
    
    customPopOverView = [[CustomPopoverView alloc]initWithArray:self.userAddresses IsAddressType:YES];
    customPopOverView.delegate = self;
    customPopOverView.isFromTag = 2;
    [scheduleScreenView addSubview:customPopOverView];
    customPopOverView.alpha = 0.0;
    
    int yVal = 70*MULTIPLYHEIGHT;
    
    customPopOverView.frame = CGRectMake(0, yVal+addressBtn.frame.size.height, screen_width, screen_height-(yVal+addressBtn.frame.size.height));
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        customPopOverView.alpha = 1.0;
        
        CGRect frame = addressBtn.frame;
        frame.origin.y = yVal;
        addressBtn.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [addressBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }];
    
}


#pragma mark FPPopover Delegate Method
-(void) didSelectFromList:(NSString *) string AtIndex:(NSInteger)row
{
    
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        
        customPopOverView.alpha = 0.0;
        
        CGRect frame = addressBtn.frame;
        frame.origin.y = previousAddressYAxis;
        addressBtn.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
        addressBtn.selected = NO;
        
        [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
    }];
    
    selectedAddress = [self.userAddresses objectAtIndex:row];
    
    if (![[addressBtn titleForState:UIControlStateNormal] isEqualToString:string])
    {
        [self.orderInfo removeObjectForKey:ORDER_PICKUP_DATE];
        pickUpDateLbl.text = @"PICKUP DATE : TIME";
        
        [self.orderInfo removeObjectForKey:ORDER_PICKUP_SLOT];
    }
    
    [addressBtn setTitle:string forState:UIControlStateNormal];
    addressBtn.selected = NO;
}


- (void)selectPickUpDate:(UIButton *)sender
{
    if (self.isFromUpdateOrder)
    {
        if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"pickupDate"] intValue] == 0)
        {
            [appDel showAlertWithMessage:@"You can't update service type." andTitle:@"" andBtnTitle:@"OK"];
            return;
        }
    }
    
    if ([arraySelectedServiceTypes count])
    {
        [self fetchPickUpDates:YES];
    }
    else
    {
        [appDel showAlertWithMessage:@"Please select service type" andTitle:@"" andBtnTitle:@"OK"];
    }
}

-(void) clickedOnPickupdate
{
    NSMutableArray *list = nil;
    
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter *toDtFormatter = [[NSDateFormatter alloc] init];
    [toDtFormatter setDateFormat:@"dd MMM, EEE"];
    
    list = [NSMutableArray arrayWithCapacity:0];
    NSArray *givenList = arraAlldata;
    for (NSDictionary *dict in givenList) {
        NSMutableDictionary *dtInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        [dtInfo setObject:[dict objectForKey:@"date"] forKey:@"actValue"];
        
        NSArray *arrSlots = [dict objectForKey:@"slots"];
        
        for (NSDictionary *dictSlot in arrSlots) {
            
            if ([[dictSlot objectForKey:@"dis"] length] > 1)
            {
                [dtInfo setObject:[dictSlot objectForKey:@"dis"] forKey:@"discountValue"];
                break;
            }
        }
        
        //[dtInfo setObject:[dict objectForKey:@"dis"] forKey:@"discountValue"];
        
        [dtInfo setObject:[toDtFormatter stringFromDate:[dtFormatter dateFromString:[dict objectForKey:@"date"]]] forKey:@"title"];
        
        CGRect frame = [[dtInfo objectForKey:@"title"] boundingRectWithSize:CGSizeMake(170, 44)
                                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                                 attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-1] }
                                                                    context:nil];
        
        [dtInfo setObject:[NSString stringWithFormat:@"%f", frame.size.width] forKey:@"TextWidth"];
        
        [list addObject:dtInfo];
    }
    
    if (![self.pickUpDates count])
    {
        [appDel showAlertWithMessage:@"Pickup dates are not available at this time." andTitle:@"" andBtnTitle:@"OK"];
        
        return;
    }
    
    DateTimeViewController *objDt = [[DateTimeViewController alloc]init];
    objDt.delegate = self;
    objDt.dictAllowFields = [[NSMutableDictionary alloc]initWithDictionary:self.dictAllowFields];
    objDt.isFromUpdateOrder = self.isFromUpdateOrder;
    objDt.arrayDates = [[NSMutableArray alloc]initWithArray:list];
    objDt.selectedAddress = [[NSMutableDictionary alloc]initWithDictionary:selectedAddress];
    objDt.orderInfo = [[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    
    objDt.dictDatesAndTimes = [[NSMutableDictionary alloc]initWithDictionary:dictPickupDatesAndTimes];
    
    objDt.selectedDate = [self.orderInfo objectForKey:ORDER_PICKUP_DATE];
    objDt.strSelectedTimeSlot = [self.orderInfo objectForKey:ORDER_PICKUP_SLOT];
    
    [self presentViewController:objDt animated:YES completion:nil];
}

//- (void) handlePickUpDateScreenWithStatus:(BOOL)isHidden withList:(NSArray *)list {
//
//    [UIView animateWithDuration:0.3 animations:^{
//
//        [listView setItems:list];
//        listView.frame = CGRectMake(isHidden ? screen_width : screen_width - 220.0, 0.0, 220.0, CGRectGetHeight(self.view.bounds));
//
//    } completion:^(BOOL finished) {
//
//
//    }];
//
//}

-(void) didSelectDateAndTime:(NSArray *)array
{
    [self.orderInfo setObject:[array objectAtIndex:0] forKey:ORDER_PICKUP_DATE];
    [self.orderInfo setObject:[array objectAtIndex:1] forKey:ORDER_PICKUP_SLOT];
    
    pickUpDateLbl.attributedText = [self setPickupAttributedText];
}

- (void)selectWashType:(UIButton *)sender {
    
    if (self.isFromUpdateOrder)
    {
        if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"serviceType"] intValue] == 0)
        {
            [appDel showAlertWithMessage:@"You can't update service type." andTitle:@"" andBtnTitle:@"OK"];
            return;
        }
    }
    
    
    /// Shoes Code
    
    shoeSelected  = NO;
    
    if([[sender.currentTitle lowercaseString] containsString:@"shoes"])
    {
        if (!sender.selected)
        {
            shoeSelected = YES;
            [self btnShoeSelected:sender];
        }
        else
        {
            shoeSelected = NO;
            
            [sender setTitle:@"SHOES" forState:UIControlStateNormal];
            [sender centerImageAndTitle:10*MULTIPLYHEIGHT];
            
            if ([arraySelectedServiceTypes containsObject:SERVICETYPE_SHOE_POLISH])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_SHOE_POLISH];
            }
            else if ([arraySelectedServiceTypes containsObject:SERVICETYPE_SHOE_CLEAN])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_SHOE_CLEAN];
            }
        }
        
        btnShoe = sender;
    }
    
    
    /// Curtains Code
    
    curtainSelected  = NO;
    
    if([sender.currentTitle caseInsensitiveCompare:@"Curtains"] == NSOrderedSame)
    {
        if (!sender.selected)
        {
            curtainSelected = YES;
            [self btnCurtainsSelected:sender];
        }
        else
        {
            curtainSelected = NO;
            
            if ([arraySelectedServiceTypes containsObject:SERVICETYPE_CC_WI])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_CC_WI];
            }
            else if ([arraySelectedServiceTypes containsObject:SERVICETYPE_CC_W_WI])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_CC_W_WI];
            }
            else if ([arraySelectedServiceTypes containsObject:SERVICETYPE_CC_DC])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_CC_DC];
            }
            else if ([arraySelectedServiceTypes containsObject:SERVICETYPE_CC_W_DC])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_CC_W_DC];
            }
        }
        
        btnCurtain = sender;
    }
    
    
    /// Dry Cleaning Code
    
    dryCleaningSelected = NO;
    
    if([sender.currentTitle caseInsensitiveCompare:@"Dry Cleaning"] == NSOrderedSame)
    {
        selected_DC_Tag = sender.tag;
        
        if (!sender.selected)
        {
            dryCleaningSelected = YES;
            [self btnDryCleaningSelected:sender];
        }
        else
        {
            dryCleaningSelected = NO;
            
            if ([arraySelectedServiceTypes containsObject:SERVICETYPE_DC])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_DC];
            }
            if ([arraySelectedServiceTypes containsObject:SERVICETYPE_DCG])
            {
                [arraySelectedServiceTypes removeObject:SERVICETYPE_DCG];
            }
        }
        
        btnDryCleaning = sender;
        
        [btnDryCleaning centerImageAndTitle:10*MULTIPLYHEIGHT];
    }
    
    
    if (sender.selected)
    {
        sender.selected = NO;
        
        [arraySelectedServiceTypes removeObject:[dictServiceType objectForKey:sender.currentTitle]];
    }
    else
    {
        if([sender.currentTitle caseInsensitiveCompare:@"Dry Cleaning"] != NSOrderedSame && [sender.currentTitle caseInsensitiveCompare:@"Curtains"] != NSOrderedSame && ![[sender.currentTitle lowercaseString] containsString:@"shoes"])
        {
            sender.selected = YES;
            
            [arraySelectedServiceTypes addObject:[dictServiceType objectForKey:sender.currentTitle]];
        }
    }
    
    if([arraySelectedServiceTypes count])
    {
        [self showDaysToDeliver];
        
        if (![pickUpDateLbl.text isEqualToString:@"PICKUP DATE : TIME"])
        {
            if (!curtainSelected && !dryCleaningSelected)
            {
                [self fetchPickUpDates:NO];
            }
        }
    }
    else
    {
        [self hideDaysToDeliver];
    }
    
    if (!curtainSelected && !dryCleaningSelected && !shoeSelected)
    {
        [self GetDaysToDeliver];
    }
}

-(void)GetDaysToDeliver
{
    if ([arraySelectedServiceTypes count])
    {
        NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", @"B", @"orderType", arraySelectedServiceTypes, @"serviceTypes", [self.orderInfo objectForKey:ORDER_TYPE], @"orderSpeed", nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@order/estimatedays", BASE_URL];
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
            
            if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                
                if ([[responseObj objectForKey:@"days"] intValue] == 1)
                {
                    LblDaysToDeliver.text = [NSString stringWithFormat:@"%d DAY TO DELIVER", [[responseObj objectForKey:@"days"]intValue]];
                }
                else
                {
                    LblDaysToDeliver.text = [NSString stringWithFormat:@"%d DAYS TO DELIVER", [[responseObj objectForKey:@"days"]intValue]];
                }
            }
            else {
                
                if ([[responseObj objectForKey:@"s"] intValue] != 100)
                {
                    //[mySwitch2 setOn:NO animated:YES];
                    //segmentSwitch.selectedSegmentIndex = 0;
                    
                    UIView *viewBg = btnSwitch.superview;
                    
                    for (id sender in viewBg.subviews)
                    {
                        if ([sender isKindOfClass:[UIButton class]])
                        {
                            UIButton *btn = (UIButton *) sender;
                            
                            if (btn.tag == 1)
                            {
                                //btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                                btn.backgroundColor = BLUE_COLOR;
                                
                                btnSwitch = btn;
                            }
                            else if (btn.tag == 2)
                            {
                                //btn.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
                                btn.backgroundColor = [UIColor clearColor];
                                btn.selected = NO;
                            }
                        }
                    }
                    
                    [self btnOptionsSelected:btnSwitch];
                    
                    lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
                    
                    [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
                    
                    [self GetDaysToDeliver];
                }
                
                [appDel displayErrorMessagErrorResponse:responseObj];
            }
        }];
    }
    else
    {
        LblDaysToDeliver.text = [@"Pick your order type" uppercaseString];
    }
}


- (void)showPricing:(UIButton *)sender
{
    
    PriceListViewController_New *pVC = [[PriceListViewController_New alloc] init];
    [self.navigationController pushViewController:pVC animated:YES];
    
    //    UINavigationController *navPVC = [[UINavigationController alloc]initWithRootViewController:pVC];
    //    navPVC.navigationBarHidden = YES;
    //
    //    [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
    //
    //        [self addChildViewController:navPVC];
    //        [self.view addSubview:navPVC.view];
    //
    //    } completion:nil];
    
}



- (void) nextBtnTapped:(UIButton *)sender {
    
    [self.orderInfo setObject:[selectedAddress objectForKey:@"_id"] forKey:ORDER_PICKUP_ADDRESS_ID];
    
    if ([arraySelectedServiceTypes count])
    {
        [self.orderInfo setObject:arraySelectedServiceTypes forKey:ORDER_JOB_TYPE];
    }
    
    if ([self.orderInfo objectForKey:ORDER_PICKUP_DATE] && [self.orderInfo objectForKey:ORDER_PICKUP_SLOT] && [arraySelectedServiceTypes count]) {
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:PREFERENCES_OPENED])
        {
            prefsOpenedAutomatically = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:PREFERENCES_OPENED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self showPreferences];
            
            return;
        }
        
        [self gotoDeliveryScreen];
        
    }
    
    else {
        
        if (![self.orderInfo objectForKey:ORDER_PICKUP_DATE]) {
            
            [appDel showAlertWithMessage:@"Please select a pick-up date" andTitle:@"" andBtnTitle:@"OK"];
            
        }
        else if (![self.orderInfo objectForKey:ORDER_PICKUP_SLOT]) {
            
            [appDel showAlertWithMessage:@"Please select your preferred time slot" andTitle:@"" andBtnTitle:@"OK"];
            
        }
        else if (![arraySelectedServiceTypes count]) {
            
            [appDel showAlertWithMessage:@"Please select order type" andTitle:@"" andBtnTitle:@"OK"];
            
        }
    }
}

-(void) gotoDeliveryScreen
{
    DeliveryViewController_New *vc = [[DeliveryViewController_New alloc] init];
    vc.orderInfo = [[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    
    if (self.isFromUpdateOrder)
    {
        vc.isFromUpdateOrder = YES;
        vc.dictAllowFields = [[NSMutableDictionary alloc]initWithDictionary:self.dictAllowFields];
        vc.dictChangedValues = [[NSMutableDictionary alloc]initWithDictionary:self.dictChangedValues];
        vc.arrayAllOrderDetails = [[NSMutableDictionary alloc]initWithDictionary:self.arrayAllOrderDetails];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)closeScheduleScreen:(UIButton *)sender {
    
    
    if ([addressBtn isSelected])
    {
        [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
            
            customPopOverView.alpha = 0.0;
            
            CGRect frame = addressBtn.frame;
            frame.origin.y = previousAddressYAxis;
            addressBtn.frame = frame;
            
            
        } completion:^(BOOL finished) {
            
            [customPopOverView removeFromSuperview];
            customPopOverView = nil;
            
            addressBtn.selected = NO;
            
            [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }];
    }
    else
    {
        if (self.isFromUpdateOrder)
        {
            
            [UIView transitionWithView:self.navigationController.view.superview duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                
                [self.navigationController removeFromParentViewController];
                [self.navigationController.view removeFromSuperview];
                
            } completion:^(BOOL finished) {
                
                
            }];
        }
        else
        {
            [appDel showTabBar:appDel.customTabBarController];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.navigationController.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                
            } completion:^(BOOL finished) {
                
                self.isScheduleLaterOpened = NO;
                
                [self.navigationController.parentViewController viewWillAppear:YES];
                [self.navigationController.view removeFromSuperview];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


