//
//  DeliveryViewController.m
//  Piing
//
//  Created by Piing on 10/24/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "DeliveryViewController_New.h"
#import "ListViewController.h"
#import "RecurringListController.h"
#import "DemoTableController.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "BookViewController.h"
#import "CustomPopoverView.h"
#import "RecurringViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CardIO.h>
#import "UIButton+CenterImageAndTitle.h"
#import "ScheduleLaterViewController_New.h"
#import "DateTimeViewController.h"
#import <FirebaseAnalytics/FIRAnalytics.h>



#define PLACE_HOLDER_COLOR_INSTEAD_IMAGE [UIColor clearColor]

#define DELIVERY_VIEW_TAG 100

#define REDEEM_VIEW_TAG 200


@interface DeliveryViewController_New () <DemoTableControllerDelegate, UITextFieldDelegate, CustomPopoverViewDelegate, DateTimeViewControllerDelegate> {
    
    ListViewController *listView;
    NSDictionary *selectedAddress;
    NSDictionary *selectedCard;
    
    FPPopoverKeyboardResponsiveController *popover;
    AppDelegate *appDel;
    
    UIView *view_Popup;
    
    UILabel *lblPromocode;
    
    CustomPopoverView *customPopOverView;
    UIView *view_Tourist;
    float previousAddressYAxis;
    UIButton *backBtn;
    
    UIButton *promocodeBtn;
    
    UIImageView *cardIconView;
    
    NSString *brainTreeClientToken;
    
    UIView *view_OrderBooked;
    
    NSMutableDictionary *dictDeliveryDatesAndTimes;
    
    NSMutableArray *arraAlldata;
}

@property (nonatomic, strong) NSMutableArray *deliveryDates;

@property (nonatomic, strong) MPMoviePlayerController *backGroundplayer;


@end


@implementation DeliveryViewController_New

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
    
    dictDeliveryDatesAndTimes = [[NSMutableDictionary alloc]init];
    self.deliveryDates = [[NSMutableArray alloc]init];
    
    arraAlldata = [[NSMutableArray alloc]init];
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    float yPos = 27*MULTIPLYHEIGHT;;
    
    float ratio = MULTIPLYHEIGHT;
    
    NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:self.userAddresses];
    NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.orderInfo objectForKey:ORDER_PICKUP_ADDRESS_ID]]];
    sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
    
    if ([sortedArray count] > 0)
    {
        selectedAddress = [sortedArray objectAtIndex:0];
    }
    
    NSPredicate *getDefaultAddPredicate1 = [NSPredicate predicateWithFormat:@"default == %d", 1];
    NSArray *sortedArray1 = [self.userSavedCards filteredArrayUsingPredicate:getDefaultAddPredicate1];
    
    if(sortedArray1.count > 0)
    {
        selectedCard = [sortedArray1 objectAtIndex:0];
    }
    else
    {
        selectedCard = [self.userSavedCards objectAtIndex:0];
    }
    
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, CGRectGetWidth(screenBounds), 40.0)];
    NSString *string = @"DELIVERY";
    [appDel spacingForTitle:titleLbl TitleString:string];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor grayColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    [self.view addSubview:titleLbl];
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, yPos, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
    [self.view addSubview:backBtn];
    
    if (!self.isFromRecurring)
    {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(CGRectGetWidth(screenBounds) - 50.0, yPos, 40.0, 40.0);
        [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        [self.view addSubview:closeBtn];
    }
    
    yPos = 90*ratio;
    
    float xPos = 14.4*MULTIPLYHEIGHT;;
    
    float height = 35*ratio;
    
    {
        UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addressBtn.tag = DELIVERY_VIEW_TAG + 2;
        addressBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        addressBtn.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        [addressBtn setTitle:@"SILOSO BEACH, SINGAPORE" forState:UIControlStateNormal];
        [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        addressBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 35*MULTIPLYHEIGHT, 0.0, 26*MULTIPLYHEIGHT);
        [addressBtn addTarget:self action:@selector(selectDeliveryAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addressBtn];
        [addressBtn setBackgroundImage:[AppDelegate imageWithColor:[[UIColor grayColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
        addressBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        addressBtn.layer.cornerRadius = 15.0;
        addressBtn.clipsToBounds = YES;
        
        if (self.isFromUpdateOrder)
        {
            
            NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:self.userAddresses];
            NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.orderInfo objectForKey:ORDER_DELIVERY_ADDRESS_ID]]];
            sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
            
            if ([sortedArray count] > 0)
            {
                selectedAddress = [sortedArray objectAtIndex:0];
            }
            
            NSPredicate *getDefaultAddPredicate1 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.orderInfo objectForKey:ORDER_CARD_ID]]];
            NSArray *sortedArray1 = [self.userSavedCards filteredArrayUsingPredicate:getDefaultAddPredicate1];
            
            if(sortedArray1.count > 0)
            {
                selectedCard = [sortedArray1 objectAtIndex:0];
            }
        }
        
        [addressBtn setTitle:[self setTitleForAddress] forState:UIControlStateNormal];
        
        [self.orderInfo setObject:[selectedCard objectForKey:@"_id"] forKey:ORDER_CARD_ID];
        
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
        UIButton *deliveryDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deliveryDateBtn.tag = DELIVERY_VIEW_TAG + 3;
        deliveryDateBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        deliveryDateBtn.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        [deliveryDateBtn addTarget:self action:@selector(selectDeliveryDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deliveryDateBtn];
        [deliveryDateBtn setBackgroundImage:[AppDelegate imageWithColor:[[UIColor grayColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
        deliveryDateBtn.layer.cornerRadius = 15.0;
        deliveryDateBtn.clipsToBounds = YES;
        
        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(xPos+20*MULTIPLYHEIGHT, 0.0, CGRectGetWidth(deliveryDateBtn.bounds), CGRectGetHeight(deliveryDateBtn.bounds))];
        dateLbl.tag = DELIVERY_VIEW_TAG + 4;
        
        dateLbl.textAlignment = NSTextAlignmentLeft;
        dateLbl.textColor = [UIColor grayColor];
        dateLbl.backgroundColor = [UIColor clearColor];
        dateLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        dateLbl.userInteractionEnabled = NO;
        
        if (self.isFromRecurring)
        {
            dateLbl.text = @"DELIVERY DAY : TIME";
        }
        else
        {
            if (self.isFromUpdateOrder)
            {
                if ([[self.dictChangedValues objectForKey:ORDER_PICKUP_DATE] isEqualToString:[self.orderInfo objectForKey:ORDER_PICKUP_DATE]] && [[self.dictChangedValues objectForKey:ORDER_TYPE] isEqualToString:[self.orderInfo objectForKey:ORDER_TYPE]] && [[self.dictChangedValues objectForKey:ORDER_JOB_TYPE] isEqualToArray:[self.orderInfo objectForKey:ORDER_JOB_TYPE]])
                {
                    dateLbl.attributedText = [self setDeliveryAttributedText];
                }
                else
                {
                    [self.orderInfo removeObjectForKey:ORDER_DELIVERY_DATE];
                    [self.orderInfo removeObjectForKey:ORDER_DELIVERY_SLOT];
                    
                    dateLbl.text = @"DELIVERY DATE : TIME";
                }
            }
            else
            {
                dateLbl.text = @"DELIVERY DATE : TIME";
            }
        }
        
        [deliveryDateBtn addSubview:dateLbl];
        
        UIImageView *locImgView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, 0.0, 10*MULTIPLYHEIGHT, CGRectGetHeight(deliveryDateBtn.bounds))];
        locImgView.contentMode = UIViewContentModeScaleAspectFit;
        locImgView.image = [UIImage imageNamed:@"pickup_date_time"];
        locImgView.userInteractionEnabled = NO;
        [deliveryDateBtn addSubview:locImgView];
        
        UIImageView *dropDownIconView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(deliveryDateBtn.bounds) - (xPos*1.5)), 1.0, 15.0, CGRectGetHeight(deliveryDateBtn.bounds))];
        dropDownIconView.contentMode = UIViewContentModeScaleAspectFit;
        dropDownIconView.image = [UIImage imageNamed:@"down_arrow"];
        dropDownIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        dropDownIconView.userInteractionEnabled = NO;
        [deliveryDateBtn addSubview:dropDownIconView];
        
    }
    
    yPos += height+25*MULTIPLYHEIGHT;
    
    {
        UIButton *cardBtnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cardBtnBtn.tag = DELIVERY_VIEW_TAG + 7;
        cardBtnBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        cardBtnBtn.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [cardBtnBtn addTarget:self action:@selector(selectDeliveryAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cardBtnBtn];
        [cardBtnBtn setBackgroundImage:[AppDelegate imageWithColor:[[UIColor grayColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
        cardBtnBtn.layer.cornerRadius = 15.0;
        cardBtnBtn.clipsToBounds = YES;
        
        float ciWidth = 20*MULTIPLYHEIGHT;
        
        cardIconView = [[UIImageView alloc] initWithFrame:CGRectMake(xPos, 0.0, ciWidth, CGRectGetHeight(cardBtnBtn.bounds))];
        cardIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        cardIconView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cardIconView sd_setImageWithURL:[NSURL URLWithString:[selectedCard objectForKey:@"cardTypeImage"]]
                          placeholderImage:[UIImage imageNamed:@"cash_icon"]];
        
        cardIconView.userInteractionEnabled = NO;
        [cardBtnBtn addSubview:cardIconView];
        
        UILabel *lblCard = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetMaxX(cardIconView.frame) + 10.0), 0.0, CGRectGetWidth(cardBtnBtn.bounds), CGRectGetHeight(cardBtnBtn.bounds))];
        lblCard.tag = DELIVERY_VIEW_TAG + 8;
        lblCard.text = [selectedCard objectForKey:@"maskedCardNo"];
        lblCard.textAlignment = NSTextAlignmentLeft;
        lblCard.textColor = [UIColor grayColor];
        lblCard.backgroundColor = [UIColor clearColor];
        lblCard.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        lblCard.userInteractionEnabled = NO;
        [cardBtnBtn addSubview:lblCard];
        
        UIImageView *dropDownIconView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(cardBtnBtn.bounds) - (xPos*1.5)), 0.0, 10*MULTIPLYHEIGHT, CGRectGetHeight(cardBtnBtn.bounds))];
        dropDownIconView.contentMode = UIViewContentModeScaleAspectFit;
        dropDownIconView.image = [UIImage imageNamed:@"edit_icon"];
        dropDownIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        dropDownIconView.userInteractionEnabled = NO;
        [cardBtnBtn addSubview:dropDownIconView];
        
    }
    
    yPos += height + 20*MULTIPLYHEIGHT;
    
    if (!self.isFromRecurring)
    {
        
        promocodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        promocodeBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        promocodeBtn.backgroundColor = [UIColor clearColor];
        [promocodeBtn setBackgroundImage:[UIImage imageNamed:@"promocode_bg"] forState:UIControlStateNormal];
        [promocodeBtn addTarget:self action:@selector(selectPromocode:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:promocodeBtn];
        [promocodeBtn setImage:[UIImage imageNamed:@"promocode_icon"] forState:UIControlStateNormal];
        promocodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        float leftEdge = 36*MULTIPLYHEIGHT;
        promocodeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, leftEdge, 0, 0);
        
        
        lblPromocode = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.0, CGRectGetWidth(promocodeBtn.bounds), CGRectGetHeight(promocodeBtn.bounds))];
        lblPromocode.text = @"ENTER PROMO CODE";
        lblPromocode.textAlignment = NSTextAlignmentCenter;
        lblPromocode.textColor = BLUE_COLOR;
        lblPromocode.backgroundColor = [UIColor clearColor];
        lblPromocode.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
        lblPromocode.userInteractionEnabled = NO;
        [promocodeBtn addSubview:lblPromocode];
        
        if ([[self.dictChangedValues objectForKey:PROMO_CODE] length])
        {
            float leftEdge = 28*MULTIPLYHEIGHT;
            promocodeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, leftEdge, 0, 0);
            
            promocodeBtn.enabled = NO;
            lblPromocode.text = [self.dictChangedValues objectForKey:@"pcmsg"];
        }
    }
    
    yPos += height + 20*MULTIPLYHEIGHT;
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(xPos, yPos, screen_width - (xPos*2), height);
    confirmBtn.backgroundColor = APPLE_BLUE_COLOR;
    
    if (self.isFromUpdateOrder)
    {
        [confirmBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"UPDATE ORDER" uppercaseString] andWithColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] andFont:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-2]] forState:UIControlStateNormal];
    }
    else
    {
        [confirmBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"PIING!" uppercaseString] andWithColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] andFont:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-2]] forState:UIControlStateNormal];
    }
    
    [confirmBtn addTarget:self action:@selector(confirmPiing:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    [confirmBtn setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    confirmBtn.layer.cornerRadius = 15.0;
    confirmBtn.clipsToBounds = YES;
    
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, screen_width/2, 2.0)];
    progressView.backgroundColor = APPLE_BLUE_COLOR;
    //[self.view addSubview:progressView];
    
    [UIView animateWithDuration:0.3 delay:0.2 options:0 animations:^{
        
        progressView.frame = CGRectMake(0, 0.0, screen_width, 2.0);
        
    } completion:^(BOOL finished) {
        
    }];
    
//    listView = (ListViewController *)appDel.sideMenuViewController.rightMenuViewController;
//    listView.delegate = self;
//    {
//        NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
//        for (int i=0; i<10; i++) {
//            
//            Item *obj = [[Item alloc] init];
//            obj.name = @"6:00 - 7:00 am";
//            obj.isSelected = NO;
//            [list addObject:obj];
//            
//        }
//        listView.itemList = nil;
//    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(NSMutableAttributedString *) setDeliveryAttributedText
{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *date = [dtFormatter dateFromString:[self.orderInfo objectForKey:ORDER_DELIVERY_DATE]];
    
    if (self.isFromRecurring)
    {
        [dtFormatter setDateFormat:@"EEEE"];
    }
    else
    {
        [dtFormatter setDateFormat:@"dd MMM, EEE"];
    }
    
    NSString *strDate = [dtFormatter stringFromDate:date];
    
    NSString *str1 = @"DELIVERY ";
    NSString *str2 = [[NSString stringWithFormat:@"%@ : %@", strDate, [self.orderInfo objectForKey:ORDER_DELIVERY_SLOT]]uppercaseString];
    
    NSString *strTotal = [NSString stringWithFormat:@"%@ %@", str1, str2];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:strTotal];
    
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2], NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, str1.length)];
    
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2], NSForegroundColorAttributeName : BLUE_COLOR} range:NSMakeRange(str1.length+1, str2.length)];
    
    float spacing = 0.5f;
    [attrStr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrStr length])];
    
    return attrStr;
}


-(void) selectPromocode:(UIButton *) sender
{
    
    view_Popup = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //view_Popup.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:view_Popup];
    view_Popup.alpha = 0.0;
    [appDel applyBlurEffectForView:view_Popup Style:BLUR_EFFECT_STYLE_DARK];
    
    
    float vtX = 12*MULTIPLYHEIGHT;
    
    view_Tourist = [[UIView alloc]initWithFrame:CGRectMake(vtX, 0, screen_width-(vtX*2), 190)];
    view_Tourist.backgroundColor = [UIColor clearColor];
    view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
    [view_Popup addSubview:view_Tourist];
    view_Tourist.tag = REDEEM_VIEW_TAG;
    
    
    UIView *view_Top = [[UIView alloc]initWithFrame:CGRectMake(vtX, vtX, view_Tourist.frame.size.width-(vtX*2), view_Tourist.frame.size.height-(vtX*2))];
    view_Top.backgroundColor = [UIColor clearColor];
    view_Top.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view_Tourist addSubview:view_Top];
    view_Top.layer.cornerRadius = 5.0;
    view_Top.layer.masksToBounds = YES;
    view_Top.center = CGPointMake(view_Tourist.frame.size.width/2, view_Tourist.frame.size.height/2);
    [appDel applyBlurEffectForView:view_Top Style:BLUR_EFFECT_STYLE_EXTRA_LIGHT];
    
    
    float viewWidth = view_Tourist.frame.size.width;
    
    
    float piingiconHeight = 45*MULTIPLYHEIGHT;
    
    UIImageView *imgPiing = [[UIImageView alloc]init];
    imgPiing.image = [UIImage imageNamed:@"Piing_icon_reg"];
    imgPiing.backgroundColor = [UIColor clearColor];
    [view_Tourist addSubview:imgPiing];
    imgPiing.contentMode = UIViewContentModeScaleAspectFit;
    imgPiing.frame = CGRectMake(0, 0, piingiconHeight, piingiconHeight);
    imgPiing.center = CGPointMake(view_Tourist.frame.size.width/2, vtX);
    
    float closeHeight = 33*MULTIPLYHEIGHT;
    
    UIButton *closePCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closePCBtn.tag = REDEEM_VIEW_TAG + 1;
    closePCBtn.frame = CGRectMake(viewWidth-closeHeight, 0.0, closeHeight, closeHeight);
    closePCBtn.center = CGPointMake(vtX, vtX);
    [closePCBtn setImage:[UIImage imageNamed:@"cancel_popup"] forState:UIControlStateNormal];
    [closePCBtn addTarget:self action:@selector(closePopupScreen) forControlEvents:UIControlEventTouchUpInside];
    [view_Tourist addSubview:closePCBtn];
    
    
    float yAxis = piingiconHeight/2+(10*MULTIPLYHEIGHT);
    
    UILabel *LblTourist = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, view_Tourist.frame.size.width, 40)];
    LblTourist.text = @"REDEEM CODE";
    LblTourist.tag = REDEEM_VIEW_TAG + 2;
    LblTourist.textAlignment = NSTextAlignmentCenter;
    LblTourist.textColor = [UIColor colorFromHexString:@"#585858"];
    LblTourist.backgroundColor = [UIColor clearColor];
    LblTourist.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-2];
    [view_Tourist addSubview:LblTourist];
    
    CGSize lblSize = [AppDelegate getLabelSizeForBoldText:LblTourist.text WithWidth:viewWidth-40 FontSize:LblTourist.font.pointSize];
    
    CGRect frameLbl = LblTourist.frame;
    frameLbl.size.height = lblSize.height+(10*MULTIPLYHEIGHT);
    LblTourist.frame = frameLbl;
    
    yAxis += frameLbl.size.height;
    
    UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(((viewWidth)/2)-(lblSize.width/2), yAxis, lblSize.width, 1)];
    imgLine.tag = REDEEM_VIEW_TAG + 10;
    imgLine.backgroundColor = [UIColor lightGrayColor];
    [view_Tourist addSubview:imgLine];
    
    yAxis += 10*MULTIPLYHEIGHT;
    
    float imgX = 36*MULTIPLYHEIGHT;
    
    UILabel *lblError = [[UILabel alloc]initWithFrame:CGRectMake(imgX, yAxis-10, view_Tourist.frame.size.width-(imgX*2), 50)];
    lblError.tag = REDEEM_VIEW_TAG + 7;
    lblError.numberOfLines = 3;
    lblError.textAlignment = NSTextAlignmentCenter;
    lblError.textColor = [UIColor redColor];
    lblError.backgroundColor = [UIColor clearColor];
    lblError.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
    [view_Tourist addSubview:lblError];
    lblError.hidden = YES;
    
    
    UITextField *tfPC = [[UITextField alloc]initWithFrame:CGRectMake(imgX, yAxis, view_Tourist.frame.size.width-(imgX*2), 40)];
    UIColor *color = APPLE_BLUE_COLOR;
    tfPC.delegate = self;
    tfPC.tag = REDEEM_VIEW_TAG + 3;
    tfPC.textAlignment = NSTextAlignmentCenter;
    //tfPC.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    tfPC.textColor = APPLE_BLUE_COLOR;
    tfPC.backgroundColor = [UIColor clearColor];
    tfPC.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM+1];
    [view_Tourist addSubview:tfPC];
    tfPC.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter promo code" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]}];
    [tfPC becomeFirstResponder];
    
    CALayer *bottomLayer = [[CALayer alloc]init];
    bottomLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    bottomLayer.frame = CGRectMake(imgX, tfPC.frame.size.height-1, tfPC.frame.size.width-imgX*2, 1);
    [tfPC.layer addSublayer:bottomLayer];
    
    float imgWidth = 40*MULTIPLYHEIGHT;
    
    UIImageView *imgPic = [[UIImageView alloc]initWithFrame:CGRectMake(view_Tourist.frame.size.width/2-(imgWidth/2), yAxis+5, imgWidth, imgWidth)];
    imgPic.backgroundColor = [UIColor clearColor];
    imgPic.contentMode = UIViewContentModeScaleAspectFit;
    imgPic.image = [UIImage imageNamed:@"gift_box"];
    //imgPic.image = [UIImage imageNamed:@"shirt_icon"];
    imgPic.tag = REDEEM_VIEW_TAG + 6;
    [view_Tourist addSubview:imgPic];
    imgPic.hidden = YES;
    
    
    yAxis += imgWidth+10;
    
    float lblDiscountHeight = 20*MULTIPLYHEIGHT;
    
    UILabel *LblDiscount = [[UILabel alloc] initWithFrame:CGRectMake(imgX, yAxis, view_Tourist.frame.size.width-(imgX*2), lblDiscountHeight)];
    LblDiscount.text = @"";
    LblDiscount.numberOfLines = 0;
    LblDiscount.tag = REDEEM_VIEW_TAG + 5;
    LblDiscount.textAlignment = NSTextAlignmentCenter;
    LblDiscount.textColor = [UIColor grayColor];
    LblDiscount.backgroundColor = [UIColor clearColor];
    LblDiscount.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
    [view_Tourist addSubview:LblDiscount];
    LblDiscount.hidden = YES;
    
    
    float btnHeight = 25*MULTIPLYHEIGHT;
    
    UIButton *btnYes = [UIButton buttonWithType:UIButtonTypeCustom];
    btnYes.frame = CGRectMake(imgX, yAxis-(10*MULTIPLYHEIGHT), view_Tourist.frame.size.width-(imgX*2), btnHeight);
    btnYes.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-2];
    [btnYes setTitle:@"REDEEM" forState:UIControlStateNormal];
    btnYes.tag = REDEEM_VIEW_TAG + 4;
    [btnYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnYes.backgroundColor = APPLE_BLUE_COLOR;
    [btnYes addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view_Tourist addSubview:btnYes];
    [btnYes setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    
    
    yAxis += btnHeight+5*MULTIPLYHEIGHT+vtX;
    
    CGRect frameView = view_Tourist.frame;
    frameView.size.height = yAxis;
    view_Tourist.frame = frameView;
    
    
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Popup.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
}

- (void) buttonPressed:(id) sender
{
//    UIButton *button = (UIButton *) sender;
//    UIColor *color = [UIColor blackColor];
//    button.layer.shadowColor = [color CGColor];
//    button.layer.shadowRadius = 20.0f;
//    button.layer.shadowOpacity = 0.9;
//    button.layer.cornerRadius = button.frame.size.width/2;
//    button.layer.shadowOffset = CGSizeZero;
//    button.layer.masksToBounds = NO;
//    button.backgroundColor = [UIColor whiteColor];
}

-(void) btnSubmitClicked:(UIButton *) sender
{
    [self.view endEditing:YES];
    
    UIView *view_UnderPopup = (UIView *) [view_Popup viewWithTag:REDEEM_VIEW_TAG];
    //UIButton *btnClose = (UIButton *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+1];
    UILabel *lblTitle = (UILabel *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+2];
    UITextField *tfPC = (UITextField *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+3];
    UILabel *lblError = (UILabel *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+7];
    UIButton *btnSubmit = (UIButton *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+4];
    UILabel *lblDiscount = (UILabel *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+5];
    UIImageView *imgPic = (UIImageView *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+6];
    UIImageView *imgLine = (UIImageView *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+10];
    
    if (![tfPC.text length])
    {
        [appDel showAlertWithMessage:@"Please enter promo code" andTitle:@"" andBtnTitle:@"OK"];
        
        return;
    }
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", tfPC.text, @"promoCode", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@promo/check", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            [self.orderInfo setObject:[responseObj objectForKey:@"code"] forKey:PROMO_CODE];
            
            lblError.hidden = YES;
            
            //btnClose.hidden = YES;
            btnSubmit.hidden = YES;
            tfPC.hidden = YES;
            lblTitle.text = @"CONGRATULATIONS!";
            lblDiscount.hidden = NO;
            imgPic.hidden = NO;
            
            CGSize lblSize = [AppDelegate getLabelSizeForBoldText:lblTitle.text WithWidth:lblTitle.frame.size.width FontSize:lblTitle.font.pointSize];
            
            imgLine.frame = CGRectMake(((view_UnderPopup.frame.size.width)/2)-(lblSize.width/2), imgLine.frame.origin.y, lblSize.width, 1);
            
            lblPromocode.text = [responseObj objectForKey:@"desc"];
            lblDiscount.text = [responseObj objectForKey:@"desc"];
            
            float leftEdge = 28*MULTIPLYHEIGHT;
            promocodeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, leftEdge, 0, 0);
            
            [UIView animateKeyframesWithDuration:0.3 delay:3.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^
             {
                 view_Popup.alpha = 0.0;
                 
             } completion:^(BOOL finished) {
                 
                 [view_Popup removeFromSuperview];
                 view_Popup = nil;
                 
             }];
        }
        else {
            
            lblPromocode.text = @"ENTER PROMO CODE";
            [self.orderInfo setObject:@"" forKey:PROMO_CODE];
            
            lblError.text = [responseObj objectForKey:@"error"];
            
            lblError.hidden = NO;
            
            tfPC.text = @"";
            UIColor *color = [UIColor redColor];
            tfPC.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]}];
        }
        
    }];
}

-(void) closePopupScreen
{
    [self.view endEditing:YES];
    
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Popup.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [view_Popup removeFromSuperview];
        view_Popup = nil;
    }];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/3);
        
    } completion:^(BOOL finished) {
        
    }];
    
    UILabel *lblError = (UILabel *) [view_Tourist viewWithTag:REDEEM_VIEW_TAG+7];
    lblError.hidden = YES;
    
    textField.text = @"";
    UIColor *color = APPLE_BLUE_COLOR;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter promo code" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]}];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - action event handlers

- (void)confirmPiing:(UIButton *)sender {
    
    if (self.isFromRecurring)
    {
        [FIRAnalytics logEventWithName:@"book_recurring_order_button" parameters:nil];
        
        [self.orderInfo setObject:@"R" forKey:ORDER_FROM];
        
        [self.orderInfo setObject:[selectedAddress objectForKey:@"_id"] forKey:ORDER_DELIVERY_ADDRESS_ID];
        
        if([self.orderInfo objectForKey:ORDER_DELIVERY_DATE] && [self.orderInfo objectForKey:ORDER_DELIVERY_SLOT]){
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            id type = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
            
            if ([type isKindOfClass:[NSArray class]])
            {
                NSArray *arrayServiceType = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
                
                NSString *strJobType = @"";
                
                for (int i = 0; i < [arrayServiceType count]; i++)
                {
                    strJobType = [strJobType stringByAppendingString:[NSString stringWithFormat:@"%@,", [arrayServiceType objectAtIndex:i]]];
                }
                
                if ([strJobType hasSuffix:@","])
                {
                    strJobType = [strJobType substringToIndex:[strJobType length]-1];
                }
                
                [self.orderInfo setObject:strJobType forKey:ORDER_JOB_TYPE];
            }
            
            NSString *urlStr = [NSString stringWithFormat:@"%@order/book", BASE_URL];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:self.orderInfo andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                {
                    [self orderBookedGif];
                    
                    UINavigationController *navvVc = (UINavigationController *) self.parentViewController;
                    
                    if ([navvVc.parentViewController isKindOfClass:[RecurringListController class]])
                    {
                        RecurringListController *recurringVC = (RecurringListController *) navvVc.parentViewController;
                        
                        [recurringVC viewWillAppear:YES];
                        
                        [navvVc.view removeFromSuperview];
                        [navvVc removeFromParentViewController];
                    }
                    
                }
                else {
                    [appDel displayErrorMessagErrorResponse:responseObj];
                }
                
            }];
            
        }
        else {
            
            if (![self.orderInfo objectForKey:ORDER_DELIVERY_DATE]) {
                
                [appDel showAlertWithMessage:@"Please select delivery date" andTitle:@"" andBtnTitle:@"OK"];
                
            }
            else if (![self.orderInfo objectForKey:ORDER_DELIVERY_SLOT]) {
                
                [appDel showAlertWithMessage:@"Please select delivery time slot" andTitle:@"" andBtnTitle:@"OK"];
                
            }
        }
    }
    else if (self.isFromUpdateOrder)
    {
        [FIRAnalytics logEventWithName:@"book_update_order_button" parameters:nil];
        
        [self.orderInfo setObject:[selectedAddress objectForKey:@"_id"] forKey:ORDER_DELIVERY_ADDRESS_ID];
        
        if([self.orderInfo objectForKey:ORDER_DELIVERY_DATE] && [self.orderInfo objectForKey:ORDER_DELIVERY_SLOT]){
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            id type = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
            
            if ([type isKindOfClass:[NSArray class]])
            {
                NSArray *arrayServiceType = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
                
                NSString *strJobType = @"";
                
                for (int i = 0; i < [arrayServiceType count]; i++)
                {
                    strJobType = [strJobType stringByAppendingString:[NSString stringWithFormat:@"%@,", [arrayServiceType objectAtIndex:i]]];
                }
                
                if ([strJobType hasSuffix:@","])
                {
                    strJobType = [strJobType substringToIndex:[strJobType length]-1];
                }
                
                [self.orderInfo setObject:strJobType forKey:ORDER_JOB_TYPE];
            }
            
            NSString *urlStr = [NSString stringWithFormat:@"%@order/update", BASE_URL];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:self.orderInfo andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                {
                    [appDel showAlertWithMessage:@"Order Updated successfully" andTitle:@"Success" andBtnTitle:@"OK"];
                    
                    NSArray *arrayVC = self.navigationController.viewControllers;
                    
                    for (id VC in arrayVC)
                    {
                        if ([VC isKindOfClass:[ScheduleLaterViewController_New class]])
                        {
                            ScheduleLaterViewController_New *scheduleVC = (ScheduleLaterViewController_New *) VC;
                            
                            [UIView animateWithDuration:0.3 animations:^{
                                
                                scheduleVC.navigationController.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                                
                            } completion:^(BOOL finished) {
                                
                                BookViewController *objBook = (BookViewController *) self.navigationController.parentViewController;
                                [objBook updateOrderDetails];
                                
                                scheduleVC.isScheduleLaterOpened = NO;
                                [scheduleVC.navigationController.view removeFromSuperview];
                                
                                
                            }];
                        }
                    }
                    
                }
                else {
                    [appDel displayErrorMessagErrorResponse:responseObj];
                }
                
            }];
            
        }
        else {
            if (![self.orderInfo objectForKey:ORDER_DELIVERY_DATE]) {
                
                [appDel showAlertWithMessage:@"Please select delivery date" andTitle:@"" andBtnTitle:@"OK"];
                
            }
            else if (![self.orderInfo objectForKey:ORDER_DELIVERY_SLOT]) {
                
                [appDel showAlertWithMessage:@"Please select delivery time slot" andTitle:@"" andBtnTitle:@"OK"];
                
            }
        }
    }
    else
    {
        [FIRAnalytics logEventWithName:@"book_schedule_later_button" parameters:nil];
        
        [self.orderInfo setObject:@"S" forKey:ORDER_FROM];
        
        [self.orderInfo setObject:[selectedAddress objectForKey:@"_id"] forKey:ORDER_DELIVERY_ADDRESS_ID];
        
        if([self.orderInfo objectForKey:ORDER_DELIVERY_DATE] && [self.orderInfo objectForKey:ORDER_DELIVERY_SLOT] && [self.orderInfo objectForKey:ORDER_CARD_ID]){
            
            id type = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
            
            if ([type isKindOfClass:[NSArray class]])
            {
                NSArray *arrayServiceType = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
                
                NSString *strJobType = @"";
                
                for (int i = 0; i < [arrayServiceType count]; i++)
                {
                    strJobType = [strJobType stringByAppendingString:[NSString stringWithFormat:@"%@,", [arrayServiceType objectAtIndex:i]]];
                }
                
                if ([strJobType hasSuffix:@","])
                {
                    strJobType = [strJobType substringToIndex:[strJobType length]-1];
                }
                
                [self.orderInfo setObject:strJobType forKey:ORDER_JOB_TYPE];
            }
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@order/book", BASE_URL];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:self.orderInfo andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                appDel.isBookNowPending = NO;
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                {
                    
                    [self orderBookedGif];
                    
                    NSArray *arrayVC = self.navigationController.viewControllers;
                    
                    for (id VC in arrayVC)
                    {
                        if ([VC isKindOfClass:[ScheduleLaterViewController_New class]])
                        {
                            ScheduleLaterViewController_New *scheduleVC = (ScheduleLaterViewController_New *) VC;
                            
                            [UIView animateWithDuration:0.3 animations:^{
                                
                                scheduleVC.navigationController.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                                
                            } completion:^(BOOL finished) {
                                
                                scheduleVC.isScheduleLaterOpened = NO;
                                [scheduleVC.navigationController.view removeFromSuperview];
                                
                            }];
                        }
                    }
                    
                    appDel.directlyGotoOrderDetails = YES;
                    appDel.customTabBarController.selectedIndex = 1;
                    //[self gotoOrderDetails:[[responseObj objectForKey:@"r"]objectAtIndex:0]];
                    
                }
                else {
                    [appDel displayErrorMessagErrorResponse:responseObj];
                }
                
            }];
        }
        else {
            if (![self.orderInfo objectForKey:ORDER_DELIVERY_DATE]) {
                
                [appDel showAlertWithMessage:@"Please select delivery date" andTitle:@"" andBtnTitle:@"OK"];
                
            }
            else if (![self.orderInfo objectForKey:ORDER_DELIVERY_SLOT]) {
                
                [appDel showAlertWithMessage:@"Please select delivery time slot" andTitle:@"" andBtnTitle:@"OK"];
                
            }
            else if (![self.orderInfo objectForKey:ORDER_CARD_ID]) {
                
                [appDel showAlertWithMessage:@"Please select Card" andTitle:@"" andBtnTitle:@"OK"];
                
            }
        }
    }
}

-(void) orderBookedGif
{
    appDel.isAfterBookingOrder = YES;
    
    //[NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    view_OrderBooked = [[UIView alloc]initWithFrame:appDel.window.bounds];
    view_OrderBooked.backgroundColor = [UIColor whiteColor];
    [appDel.window addSubview:view_OrderBooked];
    
    NSString*thePath = [[NSBundle mainBundle] pathForResource:@"order_booked" ofType:@"mp4"];
    NSURL *theurl = [NSURL fileURLWithPath:thePath];
    
    self.backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
    
    float bgImgHeight = 130*MULTIPLYHEIGHT;
    self.backGroundplayer.view.frame = CGRectMake(0, screen_height/2-(bgImgHeight/1.5), screen_width, bgImgHeight);
    
    self.backGroundplayer.repeatMode = YES;
    self.backGroundplayer.view.userInteractionEnabled = YES;
    self.backGroundplayer.controlStyle = MPMovieControlStyleNone;
    [self.backGroundplayer prepareToPlay];
    [self.backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
    //self.backGroundplayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.backGroundplayer.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundplayer.view.backgroundColor = [UIColor whiteColor];
    [view_OrderBooked addSubview:self.backGroundplayer.view];
    [self.backGroundplayer setScalingMode:MPMovieScalingModeAspectFit];
    
    [self.backGroundplayer stop];
    [self.backGroundplayer performSelector:@selector(play) withObject:nil afterDelay:0.5];
    
    
    if (!self.isFromRecurring)
    {
        
        UILabel *lblOrder = [[UILabel alloc] init];
        lblOrder.numberOfLines = 0;
        lblOrder.textAlignment = NSTextAlignmentCenter;
        lblOrder.textColor = [UIColor grayColor];
        lblOrder.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [view_OrderBooked addSubview:lblOrder];
        
        NSString *str1 = @"Your order has been successfully placed!\nWe'll take care of everything else!\nOur staff will enter the garment information\ninto the app during pick-up.";
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", str1]];
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.alignment = NSTextAlignmentCenter;
        [paragrapStyle setLineSpacing:3.0f];
        [paragrapStyle setMaximumLineHeight:100.0f];
        
        [attrString addAttributes:@{NSKernAttributeName:@(0.7), NSParagraphStyleAttributeName:paragrapStyle, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]} range:NSMakeRange(0, attrString.length)];
        
        CGFloat width = screen_width-30*MULTIPLYHEIGHT;
        
        CGSize lblSize = [AppDelegate getAttributedTextHeightForText:attrString WithWidth:width];
        
        lblOrder.frame = CGRectMake(screen_width/2-width/2, CGRectGetMaxY(self.backGroundplayer.view.frame)+15*MULTIPLYHEIGHT, width, lblSize.height);
        lblOrder.attributedText = attrString;
        
        
        CGFloat yPos = screen_height-80*MULTIPLYHEIGHT;
        
        float btnWidth = screen_width/2-(20*MULTIPLYHEIGHT);
        float btnHeight = 50*MULTIPLYHEIGHT;
        
        UIView *bottomViewForOrder = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2-((btnWidth*2)/2.2), yPos, btnWidth*2, btnHeight)];
        bottomViewForOrder.backgroundColor = [UIColor clearColor];
        [view_OrderBooked addSubview:bottomViewForOrder];
        
        
        NSArray *normalIcons = [NSArray arrayWithObjects:@"add_calendar", @"done_booking", nil];
        NSArray *normalText = [NSArray arrayWithObjects:@"ADD TO CALENDAR", @"DONE", nil];
        
        CGFloat xPos = 0;
        
        
        for (int i=0; i<[normalIcons count]; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(xPos, 1, btnWidth, btnHeight);
            [btn setImage:[UIImage imageNamed:[normalIcons objectAtIndex:i]] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor clearColor];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
            btn.tag = i+1;
            [btn addTarget:self action:@selector(addToCalenderOrDone:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:[normalText objectAtIndex:i] forState:UIControlStateNormal];
            [bottomViewForOrder addSubview:btn];
            
            [btn centerImageAndTitle:10*MULTIPLYHEIGHT];
            
            xPos += btnWidth;
            
        }
    }
    else
    {
        [self performSelector:@selector(orderBookedClicked:) withObject:view_OrderBooked afterDelay:3.0];
    }
}


-(void) addToCalenderOrDone:(UIButton *) sender
{
    if (sender.tag == 1)
    {
        if (appDel.hasOpenedOrderDetails)
        {
            appDel.hasOpenedOrderDetails = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToCalendar" object:nil];
        }
        else
        {
            appDel.automaticAddtoCalendar = YES;
        }
    }
    
    [self.backGroundplayer stop];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayVideo" object:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = view_OrderBooked.frame;
        frame.origin.y = screen_height;
        view_OrderBooked.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [view_OrderBooked removeFromSuperview];
        view_OrderBooked = nil;
        
    }];
}

-(void) orderBookedClicked:(id) sender
{
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = view_OrderBooked.frame;
        frame.origin.y = screen_height;
        view_OrderBooked.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [view_OrderBooked removeFromSuperview];
        view_OrderBooked = nil;
        
    }];
}


-(void) gotoOrderDetails:(NSDictionary *) dict
{
    
    BookViewController *bookVC = [[BookViewController alloc] init];
    bookVC.bookNowCobID = [dict objectForKey:@"cobid"];
    bookVC.isFromOrdersList = YES;
    
    NSString *userSession = [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@clientorderdetails/services.do?cobid=%@&t=%@", BASE_URL, [dict objectForKey:@"cobid"], userSession];
    
    //[NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"GET" withDetailsDictionary:nil andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame){
            
            NSDictionary *obj = [[responseObj objectForKey:@"r"] lastObject];
            bookVC.orderEditDetails = [[NSMutableDictionary alloc]initWithDictionary:obj];
            
            bookVC.view.frame = CGRectMake(0.0, 0, screen_width, (CGRectGetHeight(self.view.bounds)));
            
            NSArray *arrayVC = self.navigationController.viewControllers;
            
            for (id VC in arrayVC)
            {
                if ([VC isKindOfClass:[ScheduleLaterViewController_New class]])
                {
                    ScheduleLaterViewController_New *scheduleVC = (ScheduleLaterViewController_New *) VC;
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        scheduleVC.navigationController.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                        
                    } completion:^(BOOL finished) {
                        
                        [scheduleVC.navigationController.parentViewController addChildViewController:bookVC];
                        [scheduleVC.navigationController.parentViewController.view addSubview:bookVC.view];
                        
                        scheduleVC.isScheduleLaterOpened = NO;
                        [scheduleVC.navigationController.view removeFromSuperview];
                        
                    }];
                }
            }
            
            appDel.isDeleteBookView = YES;
            
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
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

- (void)selectDeliveryAddress:(UIButton *)sender {
    
    UIButton *addressBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 2];
    
    UIButton *cardBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 7];
    UILabel *lblCard = (UILabel *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 8];
    
    if (addressBtn == sender)
    {
        if (self.isFromUpdateOrder)
        {
            if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"deliveryAddress"] intValue] == 0)
            {
                [appDel showAlertWithMessage:@"You can't update delivery address now." andTitle:@"" andBtnTitle:@"OK"];
                return;
            }
        }
    }
    
    if (sender.selected)
    {
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
                
                backBtn.hidden = NO;
                
                [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            }];
        }
        else if ([cardBtn isSelected])
        {
            [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
                
                customPopOverView.alpha = 0.0;
                
                CGRect frame = cardBtn.frame;
                frame.origin.y = previousAddressYAxis;
                cardBtn.frame = frame;
                
                
            } completion:^(BOOL finished) {
                
                [customPopOverView removeFromSuperview];
                customPopOverView = nil;
                
                cardBtn.selected = NO;
                
                backBtn.hidden = NO;
                
                lblCard.textColor = [UIColor grayColor];
                
            }];
        }
        
        return;
    }
    
    sender.selected = YES;
    
    backBtn.hidden = YES;
    
    
    if (addressBtn == sender)
    {
        previousAddressYAxis = addressBtn.frame.origin.y;
        
        customPopOverView = [[CustomPopoverView alloc]initWithArray:self.userAddresses IsAddressType:YES];
    }
    else if (cardBtn == sender)
    {
        previousAddressYAxis = cardBtn.frame.origin.y;
        
        customPopOverView = [[CustomPopoverView alloc]initWithArray:self.userSavedCards IsPaymentType:YES];
    }
    
    customPopOverView.isFromTag = 1;
    customPopOverView.delegate = self;
    [self.view addSubview:customPopOverView];
    customPopOverView.alpha = 0.0;
    
    int yVal = 70*MULTIPLYHEIGHT;
    
    customPopOverView.frame = CGRectMake(0, yVal+addressBtn.frame.size.height, screen_width, screen_height-(yVal+addressBtn.frame.size.height));
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        customPopOverView.alpha = 1.0;
        
        if (addressBtn == sender)
        {
            CGRect frame = addressBtn.frame;
            frame.origin.y = yVal;
            addressBtn.frame = frame;
        }
        else if (cardBtn == sender)
        {
            CGRect frame = cardBtn.frame;
            frame.origin.y = yVal;
            cardBtn.frame = frame;
        }
      
        
        
    } completion:^(BOOL finished) {
        
        if (addressBtn == sender)
        {
            [addressBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        else if (cardBtn == sender)
        {
            lblCard.textColor = [UIColor darkGrayColor];
        }
        
    }];
    
}

#pragma mark FPPopover Delegate Method
-(void) didSelectFromList:(NSString *) string AtIndex:(NSInteger)row
{
    UIButton *addressBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 2];
    
    UIButton *cardBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 7];
    UILabel *lblCard = (UILabel *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 8];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        
        customPopOverView.alpha = 0.0;
        
        if (addressBtn.selected)
        {
            CGRect frame = addressBtn.frame;
            frame.origin.y = previousAddressYAxis;
            addressBtn.frame = frame;
        }
        else if (cardBtn.selected)
        {
            CGRect frame = cardBtn.frame;
            frame.origin.y = previousAddressYAxis;
            cardBtn.frame = frame;
        }
        
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
    }];
    
    
    if (addressBtn.selected)
    {
        selectedAddress = [self.userAddresses objectAtIndex:row];
        
        if (![[addressBtn titleForState:UIControlStateNormal] isEqualToString:string])
        {
            UILabel *deliveryDateLbl = (UILabel *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 4];
            
            [self.orderInfo removeObjectForKey:ORDER_DELIVERY_DATE];
            [self.orderInfo removeObjectForKey:ORDER_DELIVERY_SLOT];
            
            deliveryDateLbl.text = @"DELIVERY DATE : TIME";
        }
        
        [addressBtn setTitle:string forState:UIControlStateNormal];
        [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        addressBtn.selected = NO;
        backBtn.hidden = NO;
    }
    
    else if (cardBtn.selected)
    {
        cardBtn.selected = NO;
        backBtn.hidden = NO;
        
        selectedCard = [self.userSavedCards objectAtIndex:row];
        
        [cardIconView sd_setImageWithURL:[NSURL URLWithString:[selectedCard objectForKey:@"cardTypeImage"]]
                        placeholderImage:[UIImage imageNamed:@"cash_icon"]];
        
        lblCard.text = [selectedCard objectForKey:@"maskedCardNo"];
        lblCard.textColor = [UIColor grayColor];
        
        [self.orderInfo setObject:[selectedCard objectForKey:@"_id"] forKey:ORDER_CARD_ID];
    }
}

-(void) didAddNewAddress
{
    [self closeCustomPopover];
    
    [self getAddress];
}

-(void) closeCustomPopover
{
    UIButton *addressBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 2];
    UIButton *cardBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 7];
    UILabel *lblCard = (UILabel *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 8];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        
        customPopOverView.alpha = 0.0;
        
        if (addressBtn.selected)
        {
            addressBtn.selected = NO;
            backBtn.hidden = NO;
            
            CGRect frame = addressBtn.frame;
            frame.origin.y = previousAddressYAxis;
            addressBtn.frame = frame;
            
            [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        else if (cardBtn.selected)
        {
            cardBtn.selected = NO;
            backBtn.hidden = NO;
            
            CGRect frame = cardBtn.frame;
            frame.origin.y = previousAddressYAxis;
            cardBtn.frame = frame;
            
            lblCard.textColor = [UIColor grayColor];
        }
        
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
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


- (void)backToPreviousScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeScheduleScreen:(UIButton *)sender {
    
    UIButton *addressBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 2];
    
    UIButton *cardBtn = (UIButton *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 7];
    UILabel *lblCard = (UILabel *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 8];
    
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
            
            backBtn.hidden = NO;
            
            [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
        }];
    }
    else if ([cardBtn isSelected])
    {
        [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
            
            customPopOverView.alpha = 0.0;
            
            CGRect frame = cardBtn.frame;
            frame.origin.y = previousAddressYAxis;
            cardBtn.frame = frame;
            
            
        } completion:^(BOOL finished) {
            
            [customPopOverView removeFromSuperview];
            customPopOverView = nil;
            
            cardBtn.selected = NO;
            
            backBtn.hidden = NO;
            
            lblCard.textColor = [UIColor grayColor];
            
        }];
    }
    else
    {
        NSArray *arrayVC = self.navigationController.viewControllers;
        
        for (id VC in arrayVC)
        {
            if ([VC isKindOfClass:[ScheduleLaterViewController_New class]])
            {
                ScheduleLaterViewController_New *scheduleVC = (ScheduleLaterViewController_New *) VC;
                
                if (self.isFromUpdateOrder)
                {
                    
                }
                else
                {
                    [appDel showTabBar:appDel.customTabBarController];
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    scheduleVC.navigationController.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                    
                } completion:^(BOOL finished) {
                    
                    scheduleVC.isScheduleLaterOpened = NO;
                    [scheduleVC.navigationController.parentViewController viewWillAppear:YES];
                    [scheduleVC.navigationController.view removeFromSuperview];
                    
                }];
            }
        }
    }
}

-(void) clickedOnDeliverydate
{
    if (![self.deliveryDates count])
    {
        [appDel showAlertWithMessage:@"No delivery dates available for selected pickup date." andTitle:@"" andBtnTitle:@"OK"];
        return;
    }
    
    NSMutableArray *list = nil;
    
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"dd-MM-yyyy"];
    
    list = [NSMutableArray arrayWithCapacity:0];
    NSArray *givenList = arraAlldata;
    
    if (self.isFromRecurring)
    {
        NSDateFormatter *toDtFormatter = [[NSDateFormatter alloc] init];
        [toDtFormatter setDateFormat:@"EEEE"];
        
        for (NSDictionary *dict in givenList) {
            NSMutableDictionary *dtInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            [dtInfo setObject:[dict objectForKey:@"date"] forKey:@"actValue"];
            //[dtInfo setObject:[dict objectForKey:@"dis"] forKey:@"discountValue"];
            
            NSArray *arrSlots = [dict objectForKey:@"slots"];
            
            for (NSDictionary *dictSlot in arrSlots) {
                
                if ([[dictSlot objectForKey:@"dis"] length] > 1)
                {
                    [dtInfo setObject:[dictSlot objectForKey:@"dis"] forKey:@"discountValue"];
                    break;
                }
            }
            
            [dtInfo setObject:[toDtFormatter stringFromDate:[dtFormatter dateFromString:[dict objectForKey:@"date"]]] forKey:@"title"];
            
            CGRect frame = [[dtInfo objectForKey:@"title"] boundingRectWithSize:CGSizeMake(170, 44)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-1] }
                                                                        context:nil];
            
            [dtInfo setObject:[NSString stringWithFormat:@"%f", frame.size.width] forKey:@"TextWidth"];
            
            [list addObject:dtInfo];
        }
    }
    else
    {
        NSDateFormatter *toDtFormatter = [[NSDateFormatter alloc] init];
        [toDtFormatter setDateFormat:@"dd MMM, EEE"];
        
        for (NSDictionary *dict in givenList) {
            NSMutableDictionary *dtInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            [dtInfo setObject:[dict objectForKey:@"date"] forKey:@"actValue"];
            //[dtInfo setObject:[dict objectForKey:@"dis"] forKey:@"discountValue"];
            
            NSArray *arrSlots = [dict objectForKey:@"slots"];
            
            for (NSDictionary *dictSlot in arrSlots) {
                
                if ([[dictSlot objectForKey:@"dis"] length] > 1)
                {
                    [dtInfo setObject:[dictSlot objectForKey:@"dis"] forKey:@"discountValue"];
                    break;
                }
            }
            
            [dtInfo setObject:[toDtFormatter stringFromDate:[dtFormatter dateFromString:[dict objectForKey:@"date"]]] forKey:@"title"];
            
            CGRect frame = [[dtInfo objectForKey:@"title"] boundingRectWithSize:CGSizeMake(170, 44)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-1] }
                                                                        context:nil];
            
            [dtInfo setObject:[NSString stringWithFormat:@"%f", frame.size.width] forKey:@"TextWidth"];
            
            [list addObject:dtInfo];
        }
    }
    
    if (![self.deliveryDates count])
    {
        [appDel showAlertWithMessage:@"Delivery dates are not available at this time." andTitle:@"" andBtnTitle:@"OK"];
        
        return;
    }
    
    DateTimeViewController *objDt = [[DateTimeViewController alloc]init];
    
    if (self.isFromRecurring)
    {
        objDt.isFromRecurring = YES;
    }
    else
    {
        objDt.isFromDelivery = YES;
    }
    
    objDt.delegate = self;
    objDt.dictAllowFields = [[NSMutableDictionary alloc]initWithDictionary:self.dictAllowFields];
    objDt.isFromUpdateOrder = self.isFromUpdateOrder;
    objDt.arrayDates = [[NSMutableArray alloc]initWithArray:list];
    objDt.selectedAddress = [[NSMutableDictionary alloc]initWithDictionary:selectedAddress];
    objDt.orderInfo = [[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    
    objDt.dictDatesAndTimes = [[NSMutableDictionary alloc]initWithDictionary:dictDeliveryDatesAndTimes];
    
    objDt.selectedDate = [self.orderInfo objectForKey:ORDER_DELIVERY_DATE];
    objDt.strSelectedTimeSlot = [self.orderInfo objectForKey:ORDER_DELIVERY_SLOT];
    
    [self presentViewController:objDt animated:YES completion:nil];
}

- (void)selectDeliveryDate:(UIButton *)sender
{
    if (self.isFromUpdateOrder)
    {
        if ([self.dictAllowFields count] && [[self.dictAllowFields objectForKey:@"deliveryDate"] intValue] == 0)
        {
            [appDel showAlertWithMessage:@"You can't update delivery date now." andTitle:@"" andBtnTitle:@"OK"];
            return;
        }
    }
    
    [self fetchDeliveryDates];
}


-(void) didSelectDateAndTime:(NSArray *)array
{
    [self.orderInfo setObject:[array objectAtIndex:0] forKey:ORDER_DELIVERY_DATE];
    [self.orderInfo setObject:[array objectAtIndex:1] forKey:ORDER_DELIVERY_SLOT];
    
    UILabel *deliveryDateLbl = (UILabel *)[self.view viewWithTag:DELIVERY_VIEW_TAG + 4];
    
    deliveryDateLbl.attributedText = [self setDeliveryAttributedText];
}


#pragma mark - API implementation

- (void)fetchDeliveryDates
{
    NSString *strFromScreen;
    
    if (self.isFromRecurring)
    {
        strFromScreen = @"R";
    }
    else
    {
        strFromScreen = @"S";
    }
    
    NSString *pickUDate = [self.orderInfo objectForKey:ORDER_PICKUP_DATE];
    NSString *pickUSlot = [self.orderInfo objectForKey:ORDER_PICKUP_SLOT];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [selectedAddress objectForKey:@"_id"], @"deliveryAddressId", [self.orderInfo objectForKey:ORDER_JOB_TYPE], @"serviceTypes", pickUDate, @"pickUpDate", pickUSlot, @"pickUpSlotId", [self.orderInfo objectForKey:ORDER_TYPE], @"orderSpeed", strFromScreen, @"orderType", nil];
    
    if (self.isFromUpdateOrder)
    {
        [detailsDic setObject:[self.orderInfo objectForKey:@"oid"] forKey:@"oid"];
        [detailsDic setObject:[self.arrayAllOrderDetails objectForKey:@"dpid"] forKey:@"dpid"];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/deliverydates", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            [arraAlldata removeAllObjects];
            [self.deliveryDates removeAllObjects];
            [dictDeliveryDatesAndTimes removeAllObjects];
            
            NSArray *arrayData = [NSArray arrayWithArray:[responseObj objectForKey:@"dates"]];
            
            //[arraAlldata addObjectsFromArray:[responseObj objectForKey:@"dates"]];
            
            for (int i = 0; i < [arrayData count]; i++)
            {
                if ([[[arrayData objectAtIndex:i] objectForKey:@"slots"] count])
                {
                    [arraAlldata addObject:[arrayData objectAtIndex:i]];
                    
                    [self.deliveryDates addObject:[[arrayData objectAtIndex:i]objectForKey:@"date"]];
                    
                    [dictDeliveryDatesAndTimes setObject:[[arrayData objectAtIndex:i]objectForKey:@"slots"] forKey:[[arrayData objectAtIndex:i]objectForKey:@"date"]];
                }
            }
            
            [self clickedOnDeliverydate];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


#pragma mark - CardIOPaymentViewControllerDelegate
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@payment/gettoken", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            brainTreeClientToken = [responseObj objectForKey:@"token"];
            
            self.braintree = [[BTAPIClient alloc]initWithAuthorization:brainTreeClientToken];
            
            BTCardClient *cardClient = [[BTCardClient alloc] initWithAPIClient:self.braintree];
            
            BTCard *card = [[BTCard alloc] initWithNumber:info.cardNumber
                                          expirationMonth:[NSString stringWithFormat:@"%lu",(unsigned long)info.expiryMonth]
                                           expirationYear:[NSString stringWithFormat:@"%lu",(unsigned long)info.expiryYear]
                                                      cvv:info.cvv];
            
            [cardClient tokenizeCard:card
                          completion:^(BTCardNonce *nonce, NSError *error) {
                              // Communicate the nonce to your server, or handle error
                              
                              if (!error)
                              {
                                  DLog(@"Nounce %@",nonce.nonce);
                                  
                                  NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nonce.nonce, @"paymentMethodNonce", nil];
                                  
                                  NSString *urlStr = [NSString stringWithFormat:@"%@payment/save", BASE_URL];
                                  
                                  [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                                      
                                      if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                                      {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
                                          
                                          [self closeCustomPopover];
                                          [self fetchCards];
                                      }
                                      else {
                                          
                                          [appDel displayErrorMessagErrorResponse:responseObj];
                                      }
                                  }];
                              }
                              else
                              {
                                  
                                  [appDel showAlertWithMessage:[error localizedDescription] andTitle:@"" andBtnTitle:@"OK"];
                                  
                                  [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                              }
                              
                          }];
            
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"User cancelled scan");
    [paymentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) fetchCards
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@payment/getallpaymentmethods", BASE_URL];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            NSDictionary *dict = [responseObj objectForKey:@"paymentMethod"];
            
            NSMutableArray *arrayCards = [appDel getAllSavedCards:dict];
            
            [PiingHandler sharedHandler].userSavedCards = arrayCards;
            
            self.userSavedCards = [PiingHandler sharedHandler].userSavedCards;
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
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
