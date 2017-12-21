//
//  HomePageViewController.m
//  Ping
//
//  Created by SHASHANK on 23/02/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "HomePageViewController.h"
#import "CustomSegmentControl.h"

#import "MyBookingViewController.h"

#import "CircularBtnView.h"
#import "GoogleMapView2.h"

#import "BookViewController.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "CustomPopoverView.h"
#import "ILTranslucentView.h"
#import "FXBlurView.h"
#import "ScheduleLaterViewController_New.h"
#import "PriceListViewController_New.h"
#import <FirebaseAnalytics/FIRAnalytics.h>



#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

#define zoomLevel 0.0
#define TEXT_COLOR_PIINGDETAIL [UIColor colorWithRed:81.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0]
#define PLACE_HOLDER_COLOR_INSTEAD_IMAGE [UIColor clearColor]

@interface HomePageViewController () <CustomPopoverViewDelegate>
{
    
    GoogleMapView2 *piingoMapView;
    UIButton *schduleLaterButton;
    
    AppDelegate *appDel;
    
    CircularBtnView *timerView;
    NSTimer *intervalTime;
    int countDownTime;
    
    UIView *schduleView;
    
    NSMutableArray *userAddresses;
    NSDictionary *selectedAddressDic;
    
    long int selectedAddressIndex;
    
    UIButton *addressBtn;
    
    UIView *piingBgView;
    UIImageView *piingUserView;
    UILabel *etaLabel,*piingName;
    NSDictionary *piinfDetailDic;
    NSDictionary *dictOrderDetails;
    NSString *bookNowETAStr;
    UILabel *etaTimer, *lblTopDesc;
    
    UIView *backGroundTemView;
    
    BookViewController *bookVC;
    
    FPPopoverKeyboardResponsiveController *popover;
    
    CustomPopoverView *customPopOverView;
    
    BOOL isFirstTimeScheduleLaterClicked;
    
    BOOL isCurrentScreenAppearing;
    
    UIView *view_Popup;
    
    NSString *strErrorMessage;
    
    UIView *view_DemoScreen;
    
    UIView *view_addr;
    
    ScheduleLaterViewController_New *scheduleVC;
    
    NSString *strPiingoId;
    
    FXBlurView *blurEffect;
    
    UIView *view_BagShoes, *viewUnderBagShoe;
}

@property (nonatomic, strong) GMSMapView *mapView;

@end

@implementation HomePageViewController


-(void) showDemoScreens
{
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    view_DemoScreen = [[UIView alloc]initWithFrame:appDel.window.bounds];
    view_DemoScreen.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    [appDel.window addSubview:view_DemoScreen];
    
    view_DemoScreen.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        view_DemoScreen.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    float yPos = addressBtn.frame.origin.y+addressBtn.frame.size.height;
    
    //float addrWidth = 100*MULTIPLYHEIGHT;
    float addrHeight = 59*MULTIPLYHEIGHT;
    
    view_addr = [[UIView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, addrHeight)];
    //view_addr.backgroundColor = [[UIColor clearColor]colorWithAlphaComponent:0.3];
    [view_DemoScreen addSubview:view_addr];
    
    
    view_addr.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
        
        view_addr.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    float imgLine1Height = 15*MULTIPLYHEIGHT;
    
    UIImageView *imgLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(view_addr.frame.size.width/2, 0, 1, imgLine1Height)];
    imgLine1.backgroundColor = [UIColor whiteColor];
    [view_addr addSubview:imgLine1];
    
    
    UIImageView *imgRound1 = [[UIImageView alloc]initWithFrame:CGRectMake(view_addr.frame.size.width/2-(5/2), imgLine1Height, 5, 5)];
    imgRound1.layer.cornerRadius = imgRound1.frame.size.width/2;
    imgRound1.backgroundColor = BLUE_COLOR;
    [view_addr addSubview:imgRound1];
    
    
    float lblAddrHeight = 25*MULTIPLYHEIGHT;
    
    CGFloat lbl1Y = imgLine1Height+5*MULTIPLYHEIGHT;
    
    UILabel *lbl1 = [[UILabel alloc]initWithFrame:CGRectMake(0, lbl1Y, view_addr.frame.size.width, lblAddrHeight)];
    lbl1.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    lbl1.textColor = [UIColor whiteColor];
    //lbl1.backgroundColor = [UIColor whiteColor];
    lbl1.numberOfLines = 0;
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.text = [@"Where do you\nwant your pick-up?" uppercaseString];
    [view_addr addSubview:lbl1];
    
    CGFloat lbl1Height = [AppDelegate getLabelHeightForMediumText:lbl1.text WithWidth:view_addr.frame.size.width FontSize:lbl1.font.pointSize];
    
    CGRect lbl1Rect = lbl1.frame;
    lbl1Rect.size.height = lbl1Height;
    lbl1.frame = lbl1Rect;
    
    CGRect addrRect = view_addr.frame;
    addrRect.size.height = imgLine1Height+lbl1.frame.size.height;
    view_addr.frame = addrRect;
    
    
    yPos = timerView.frame.origin.y-48*MULTIPLYHEIGHT;
    
    float middleWidth = 100*MULTIPLYHEIGHT;
    float middleHeight = 59*MULTIPLYHEIGHT;
    
    UIView *view_Middle = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2+(timerView.frame.origin.x/3), yPos, middleWidth, middleHeight)];
    //view_Middle.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
    [view_DemoScreen addSubview:view_Middle];
    
    view_Middle.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 delay:2.5 options:0 animations:^{
        
        view_Middle.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    float imgLine2Height = 15*MULTIPLYHEIGHT;
    
    UIImageView *imgLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, view_Middle.frame.size.height-imgLine2Height, 1, imgLine2Height)];
    imgLine2.backgroundColor = [UIColor whiteColor];
    [view_Middle addSubview:imgLine2];
    
    UIImageView *imgHorLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, imgLine2.frame.origin.y, imgLine2Height, 1)];
    imgHorLine2.backgroundColor = [UIColor whiteColor];
    [view_Middle addSubview:imgHorLine2];
    
    UIImageView *imgRound2 = [[UIImageView alloc]initWithFrame:CGRectMake(imgHorLine2.frame.origin.x+imgHorLine2.frame.size.width, imgLine2.frame.origin.y-(5/2), 5, 5)];
    imgRound2.layer.cornerRadius = imgRound2.frame.size.width/2;
    imgRound2.backgroundColor = BLUE_COLOR;
    [view_Middle addSubview:imgRound2];
    
    UILabel *lbl2 = [[UILabel alloc]initWithFrame:CGRectMake(imgRound2.frame.origin.x+imgRound2.frame.size.width+5, imgLine2.frame.origin.y-5, view_Middle.frame.size.width, 35)];
    lbl2.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    lbl2.textColor = [UIColor whiteColor];
    lbl2.numberOfLines = 0;
    lbl2.textAlignment = NSTextAlignmentCenter;
    //lbl2.text = [@"Tap here within\n15 seconds\nto book now" uppercaseString];
    lbl2.text = [@"Tap here\nto book now" uppercaseString];
    [view_Middle addSubview:lbl2];
    
    CGSize lbl2Size = [AppDelegate getLabelSizeForMediumText:lbl2.text WithWidth:view_Middle.frame.size.width FontSize:lbl2.font.pointSize];
    
    CGRect lbl2Rect = lbl2.frame;
    lbl2Rect.size.width = lbl2Size.width;
    lbl2Rect.size.height = lbl2Size.height;
    lbl2.frame = lbl2Rect;
    
    
//    
//    yPos = timerView.frame.origin.y-60*MULTIPLYHEIGHT;
//    
//    float timerWidth = 155*MULTIPLYHEIGHT;
//    float timerHeight = 60*MULTIPLYHEIGHT;
//    
//    UIView *view_Timer = [[UIView alloc]initWithFrame:CGRectMake(0, yPos, timerWidth, timerHeight)];
//    //view_Timer.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.8];
//    [view_DemoScreen addSubview:view_Timer];
//    
//    view_Timer.alpha = 0.0;
//    
//    [UIView animateWithDuration:0.3 delay:4.0 options:0 animations:^{
//        
//        view_Timer.alpha = 1.0;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//    
//    UILabel *lbl3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view_Timer.frame.size.width, 35)];
//    lbl3.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
//    lbl3.textColor = [UIColor whiteColor];
//    lbl3.numberOfLines = 0;
//    lbl3.textAlignment = NSTextAlignmentCenter;
//    lbl3.text = [@"Tap within 15 seconds\nto confirm your\non-demand pickup" uppercaseString];
//    [view_Timer addSubview:lbl3];
//    
//    CGFloat lbl3Height = [AppDelegate getLabelHeightForMediumText:lbl3.text WithWidth:lbl3.frame.size.width FontSize:lbl3.font.pointSize];
//    
//    CGRect lbl3Rect = lbl3.frame;
//    lbl3Rect.size.height = lbl3Height;
//    lbl3.frame = lbl3Rect;
//    
//    UIImageView *imgRound3 = [[UIImageView alloc]initWithFrame:CGRectMake(view_Timer.frame.size.width/2-(5/2), lbl3Rect.size.height+5, 5, 5)];
//    imgRound3.layer.cornerRadius = imgRound3.frame.size.width/2;
//    imgRound3.backgroundColor = BLUE_COLOR;
//    [view_Timer addSubview:imgRound3];
//    
//    float imgLine3Height = 10*MULTIPLYHEIGHT;
//    
//    UIImageView *imgLine3 = [[UIImageView alloc]initWithFrame:CGRectMake(view_Timer.frame.size.width/2, lbl3Rect.size.height+10, 1, imgLine3Height)];
//    imgLine3.backgroundColor = [UIColor whiteColor];
//    [view_Timer addSubview:imgLine3];
//    
//    CGRect timerRect = view_Timer.frame;
//    timerRect.size.height = imgLine3Height+lbl3.frame.size.height+10;
//    timerRect.origin.y = timerView.frame.origin.y-timerRect.size.height;
//    view_Timer.frame = timerRect;
//    
    
    
    yPos = schduleLaterButton.frame.origin.y-70;
    
    float scheduleHeight = 59*MULTIPLYHEIGHT;
    
    UIView *view_Schedule = [[UIView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, scheduleHeight)];
    //view_Schedule.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.2];
    [view_DemoScreen addSubview:view_Schedule];
    
    view_Schedule.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 delay:4.0 options:0 animations:^{
        
        view_Schedule.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(demoscreensClicked:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [view_DemoScreen addGestureRecognizer:tap];
        
    }];
    
    float lbl4X = 20*MULTIPLYHEIGHT;
    
    UILabel *lbl4 = [[UILabel alloc]initWithFrame:CGRectMake(lbl4X, 0, view_Schedule.frame.size.width-(lbl4X*2), 35)];
    lbl4.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    lbl4.textColor = [UIColor whiteColor];
    lbl4.numberOfLines = 0;
    lbl4.textAlignment = NSTextAlignmentCenter;
    lbl4.text = [@"Schedule a pick-up\nat a preferred time" uppercaseString];
    [view_Schedule addSubview:lbl4];
    
    CGFloat lbl4Height = [AppDelegate getLabelHeightForMediumText:lbl4.text WithWidth:lbl4.frame.size.width FontSize:lbl4.font.pointSize];
    
    CGRect lbl4Rect = lbl4.frame;
    lbl4Rect.size.height = lbl4Height;
    lbl4.frame = lbl4Rect;
    
    UIImageView *imgRound4 = [[UIImageView alloc]initWithFrame:CGRectMake(view_Schedule.frame.size.width/2-(5/2), lbl4.frame.size.height+5, 5, 5)];
    imgRound4.layer.cornerRadius = imgRound4.frame.size.width/2;
    imgRound4.backgroundColor = BLUE_COLOR;
    [view_Schedule addSubview:imgRound4];
    
    float imgLine4Height = 10*MULTIPLYHEIGHT;
    
    UIImageView *imgLine4 = [[UIImageView alloc]initWithFrame:CGRectMake(view_Schedule.frame.size.width/2, lbl4.frame.size.height+10, 1, imgLine4Height)];
    imgLine4.backgroundColor = [UIColor whiteColor];
    [view_Schedule addSubview:imgLine4];
    
    
    CGRect scheduleRect = view_Schedule.frame;
    scheduleRect.size.height = imgLine4Height+lbl4.frame.size.height+10;
    scheduleRect.origin.y = schduleLaterButton.frame.origin.y - scheduleRect.size.height;
    view_Schedule.frame = scheduleRect;
    
}



-(void) demoscreensClicked:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        view_DemoScreen.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [view_DemoScreen removeFromSuperview];
        view_DemoScreen = nil;
        
//        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"SHOW_BAG_SHOE"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
//        [self showPopupForBagAndShoe];
        
        [self searchingForNearestPiingo];
        
    }];
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isFirstTimeScheduleLaterClicked = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    appDel = [PiingHandler sharedHandler].appDel;
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    userAddresses = [[NSMutableArray alloc] init];
    userAddresses = [[PiingHandler sharedHandler].userAddress mutableCopy];
    
    self.userSavedCards = [[NSMutableArray alloc] init];
    self.userSavedCards = [PiingHandler sharedHandler].userSavedCards;
    
    bookNowETAStr = [[NSString alloc] init];
    
    selectedAddressIndex = -1;
    
    piingoMapView = [[GoogleMapView2 alloc] initWithFrame:CGRectMake(0, 0.0, screen_width, screen_height)];
    [self.view addSubview:piingoMapView];
    
    NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:userAddresses];
    NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"default == %d", 1];
    sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
    
    if ([sortedArray count] > 0)
    {
        selectedAddressDic = [sortedArray objectAtIndex:0];
    }
    else
    {
        selectedAddressDic = [userAddresses objectAtIndex:0];
    }
    
    [piingoMapView addClientMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[selectedAddressDic objectForKey:@"lat"], @"lat",[selectedAddressDic objectForKey:@"lon"], @"lon", @"home_map", @"markImage", nil]];
    [piingoMapView focusMapToShowAllMarkers];
    
    backGroundTemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0, screen_width, screen_height-TAB_BAR_HEIGHT)];
    backGroundTemView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:backGroundTemView];
    
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(screenBounds), 44.0)];
    NSString *string1 = @"BOOK";
    [appDel spacingForTitle:titleLbl TitleString:string1];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-2];
    [self.view addSubview:titleLbl];
    
    
    float yAxis = 54*MULTIPLYHEIGHT;
    
    float addressX = 22*MULTIPLYHEIGHT;
    float addressHeight = 22*MULTIPLYHEIGHT;
    
    addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.backgroundColor = [UIColor clearColor];
    addressBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
    addressBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    addressBtn.titleLabel.minimumScaleFactor = 12.0;
    addressBtn.frame = CGRectMake(addressX, yAxis, screen_width-(addressX*2), addressHeight);
    [addressBtn addTarget:self action:@selector(addressSelectionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 40.0, 0.0, 30.0);
    
    addressBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    addressBtn.layer.borderWidth = 1.0;
    addressBtn.layer.cornerRadius = 7.0;
    
    [addressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if ([selectedAddressDic count])
    {
        [addressBtn setTitle:[self setTitleForAddress] forState:UIControlStateNormal];
    }
    
    [self.view addSubview:addressBtn];
    
    UIImageView *pointerIconView = [[UIImageView alloc] initWithFrame:CGRectMake(5*MULTIPLYHEIGHT, 0.0, 20.0, CGRectGetHeight(addressBtn.bounds)-2)];
    pointerIconView.image = [UIImage imageNamed:@"location_pointer"];
    pointerIconView.backgroundColor = [UIColor clearColor];
    pointerIconView.contentMode = UIViewContentModeScaleAspectFit;
    [addressBtn addSubview:pointerIconView];
    
    
    UIImageView *dropDownIconView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(addressBtn.bounds) - (15*MULTIPLYHEIGHT)), 0.0, 10.0, CGRectGetHeight(addressBtn.bounds))];
    dropDownIconView.image = [UIImage imageNamed:@"down_arrow_white"];
    dropDownIconView.backgroundColor = [UIColor clearColor];
    dropDownIconView.contentMode = UIViewContentModeScaleAspectFit;
    [addressBtn addSubview:dropDownIconView];
    
    
    float slHeight = 29*MULTIPLYHEIGHT;
    
    float slX = 32*MULTIPLYHEIGHT;
    
    float deleteHeight = 85*MULTIPLYHEIGHT;
    
    schduleLaterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    schduleLaterButton.frame = CGRectMake(slX, CGRectGetMaxY(piingoMapView.frame) - deleteHeight, screen_width - (slX*2), slHeight);
    [schduleLaterButton setImage:[UIImage imageNamed:@"schedule_later_icon"] forState:UIControlStateNormal];
    [schduleLaterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [schduleLaterButton.titleLabel setFont:[UIFont fontWithName:APPFONT_BLACK size:appDel.FONT_SIZE_CUSTOM-1]];
    schduleLaterButton.backgroundColor = [UIColor clearColor];
    
    [schduleLaterButton setAttributedTitle:[appDel spacingForString:@"SCHEDULE LATER" WithSpace:0.8 withAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}] forState:UIControlStateNormal];
    
    schduleLaterButton.imageEdgeInsets = UIEdgeInsetsMake(0, -34*MULTIPLYHEIGHT, 0, 0);
    schduleLaterButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10*MULTIPLYHEIGHT, 0, 0);
    schduleLaterButton.layer.borderWidth = 1.5f;
    schduleLaterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    schduleLaterButton.layer.cornerRadius = 15.0;
    
    [schduleLaterButton addTarget:self action:@selector(schduleLaterBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backGroundTemView addSubview:schduleLaterButton];
    
    float timerHeight = 140*MULTIPLYHEIGHT;
    float minusWidth = (65*MULTIPLYHEIGHT);
    float minusHeight = (42*MULTIPLYHEIGHT);
    
    timerView = [[CircularBtnView alloc] initWithFrame:CGRectMake((screen_width-timerHeight-minusWidth)/2.0, (screen_height-timerHeight-minusHeight)/2, timerHeight, timerHeight) andDelegate:self];
    timerView.backgroundColor = [UIColor clearColor];
    timerView.center = CGPointMake(screen_width/2-(3*MULTIPLYHEIGHT), screen_height/2);
    [backGroundTemView addSubview:timerView];
    
    
    //float minusLblHeight = 50*MULTIPLYHEIGHT;
    
    float lblY = addressBtn.frame.origin.y+addressBtn.frame.size.height;
    float lblX = 30*MULTIPLYHEIGHT;
    
    float clickLblHeight = timerView.frame.origin.y-lblY;
    
    lblTopDesc = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, screen_width-(lblX*2), clickLblHeight)];
    lblTopDesc.backgroundColor = [UIColor clearColor];
    lblTopDesc.numberOfLines = 3;
    lblTopDesc.textAlignment = NSTextAlignmentCenter;
    lblTopDesc.textColor = [UIColor whiteColor];
    lblTopDesc.text = @"SEARCHING FOR YOUR NEAREST PIINGO";
    lblTopDesc.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-5];
    [backGroundTemView addSubview:lblTopDesc];
    
    etaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timerView.frame) + 40.0, screen_width, 60)];
    etaLabel.backgroundColor = [UIColor clearColor];
    etaLabel.textColor = [UIColor whiteColor];
    etaLabel.numberOfLines = 2;
    etaLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *str1 = @"PIINGO WILL ARRIVE IN\n";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str1];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-3]} range:NSMakeRange(0, str1.length)];
    NSString *str2 = @"15 MINS";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", str1, str2]];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [paragrapStyle setLineSpacing:10.0f];
    [paragrapStyle setMaximumLineHeight:100.0f];
    
    [string addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, string.length)];
    
    UIFont *font1 = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-5];
    [string addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, str1.length)];
    
    UIFont *font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(str1.length, str2.length)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
    
    etaLabel.attributedText = string;
    
    CGSize size = [AppDelegate getAttributedTextHeightForText:string WithWidth:screen_width];
    
    CGRect frameETA = etaLabel.frame;
    frameETA.origin.y = screen_height/1.5;
    frameETA.size.height = size.height;
    etaLabel.frame = frameETA;
    
    [backGroundTemView addSubview:etaLabel];
    etaLabel.hidden = YES;
    
    
    
    //PiingDetails
    piingBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(piingoMapView.frame) - 130.0, screen_width, 130.0)];
    
    UIImageView *pingBgimgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130.0-88.0, screen_width, 88.0)];
    pingBgimgView.image = [UIImage imageNamed:@"pingo_bg"];
    
    piingUserView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 95)];
    piingUserView.center = CGPointMake(screen_width/2.0, 95/2.0);
    piingUserView.layer.cornerRadius = 95.2/2.0;
    piingUserView.clipsToBounds = YES;
    piingUserView.contentMode =  UIViewContentModeScaleAspectFill;
    //piingUserView.imageURL = [NSURL URLWithString:@""];
    piingUserView.backgroundColor = [UIColor clearColor];
    
    //Piing UserName
    piingName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(pingBgimgView.frame)-24-10.0, screen_width, 24.0)];
    piingName.backgroundColor = [UIColor clearColor];
    piingName.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
    piingName.textAlignment = NSTextAlignmentCenter;
    piingName.textColor = [TEXT_COLOR_PIINGDETAIL colorWithAlphaComponent:0.97];
    [pingBgimgView addSubview:piingName];
    
    piingBgView.userInteractionEnabled = NO;
    [piingBgView addSubview:pingBgimgView];
    
    [self.view addSubview:piingBgView];
    
    piingBgView.hidden = YES;
    
    
    if (view_Popup)
    {
        [self.view bringSubviewToFront:view_Popup];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //dispaly the bottom bar when home page is visible
    
    //[appDel hideTabBar:appDel.customTabBarController];
    
    if (appDel.isBookNowPending)
    {
        for (id viewCon in self.childViewControllers)
        {
            if ([viewCon isKindOfClass:[BookViewController class]])
            {
                [appDel hideTabBar:appDel.customTabBarController];
                
                return;
            }
        }
        
        return;
    }
    
    if (scheduleVC && scheduleVC.isScheduleLaterOpened)
    {
        return;
    }
    
    if (bookVC && bookVC.isBookNowStarted)
    {
        return;
    }
    
    isCurrentScreenAppearing = YES;
    
    if (customPopOverView)
    {
        return;
    }
    
    [appDel showTabBar:appDel.customTabBarController];
    
    userAddresses = [[PiingHandler sharedHandler].userAddress mutableCopy];
    
    if (![selectedAddressDic count])
    {
        NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:userAddresses];
        NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"default == %d", 1];
        sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
        
        if ([sortedArray count] > 0)
        {
            selectedAddressDic = [sortedArray objectAtIndex:0];
        }
        else
        {
            selectedAddressDic = [userAddresses objectAtIndex:0];
        }
        
        [piingoMapView addClientMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[selectedAddressDic objectForKey:@"lat"], @"lat",[selectedAddressDic objectForKey:@"lon"], @"lon", @"home_map", @"markImage", nil]];
        [piingoMapView focusMapToShowAllMarkers];
    }
    
    if ([selectedAddressDic count])
    {
        [addressBtn setTitle:[self setTitleForAddress] forState:UIControlStateNormal];
    }
    
    [appDel setBottomTabBarColor:TABBAR_COLOR_WHITE BlurEffectStyle:BLUR_EFFECT_STYLE_DARK HideBlurEffect:NO];
    [appDel setBottomTabBarColorForTab:1];
    
    if (appDel.openWelcomePopup)
    {
        [self getAddress];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"SHOW_DEMO"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"SHOW_DEMO"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        // FOR DEMO SCREENS, UNCOMMENT THIS
        
        [timerView offWaves];
        [timerView setDetails:1];
        
        lblTopDesc.text = @"";
        
        [self showDemoScreens];
    }
//    else if (![[NSUserDefaults standardUserDefaults] objectForKey:@"SHOW_BAG_SHOE"])
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"SHOW_BAG_SHOE"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//
//        [self showPopupForBagAndShoe];
//    }
    else
    {
        if (appDel.isBookNowPending)
        {
            
        }
        else
        {
            if (!intervalTime)
            {
                [self searchingForNearestPiingo];
            }
        }
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    isCurrentScreenAppearing = NO;
}

-(void) showPopupForBagAndShoe
{
    [appDel applyCustomBlurEffetForView:appDel.window WithBlurRadius:5];
    
    blurEffect = [appDel.window viewWithTag:98765];
    blurEffect.alpha = 0.0;
    //blurEffect.dynamic = YES;
    
    [FXBlurView setUpdatesDisabled];
    
    view_BagShoes = [[UIView alloc]initWithFrame:appDel.window.bounds];
    view_BagShoes.alpha = 0.0;
    view_BagShoes.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [appDel.window addSubview:view_BagShoes];
    
    CGFloat vX = 15*MULTIPLYHEIGHT;
    CGFloat vW = screen_width-vX*2;
    
    viewUnderBagShoe = [[UIView alloc]initWithFrame:CGRectMake(vX, 0, vW, 10)];
    viewUnderBagShoe.backgroundColor = [UIColor whiteColor];
    viewUnderBagShoe.layer.cornerRadius = 8.0;
    [view_BagShoes addSubview:viewUnderBagShoe];
    
    CGFloat btnX = viewUnderBagShoe.frame.size.width-50;
    CGFloat btnY = 7*MULTIPLYHEIGHT;
    CGFloat btnW = 40;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(btnX, btnY, btnW, btnW);
    [btnClose setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
    btnClose.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnClose addTarget:self action:@selector(closeBagShoePopup) forControlEvents:UIControlEventTouchUpInside];
    [viewUnderBagShoe addSubview:btnClose];
    
    
    CGFloat yAxis = 55*MULTIPLYHEIGHT;
    
    UILabel *lblIntro = [[UILabel alloc]init];
    lblIntro.numberOfLines = 0;
    lblIntro.frame = CGRectMake(0, yAxis, viewUnderBagShoe.frame.size.width, 10);
    [viewUnderBagShoe addSubview:lblIntro];
    
    NSString *strIntr = @"INTRODUCING";
    NSString *strBagShoe = @"SHOE & BAG CLEANING";
    
    NSString *strFull = [NSString stringWithFormat:@"%@\n%@", strIntr, strBagShoe];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:strFull];
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, strIntr.length)];
    
    [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_Heavy size:appDel.HEADER_LABEL_FONT_SIZE], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(strIntr.length+1, strBagShoe.length)];
    
    [attrStr addAttributes:@{NSKernAttributeName:@(1.0)} range:NSMakeRange(0, attrStr.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setLineSpacing:10.0f];
    [paragraphStyle setMaximumLineHeight:100.0f];
    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    
    lblIntro.attributedText = attrStr;
    
    CGSize size = [AppDelegate getAttributedTextHeightForText:attrStr WithWidth:lblIntro.frame.size.width];
    
    CGRect rect = lblIntro.frame;
    rect.size.height = size.height;
    lblIntro.frame = rect;
    
    yAxis += rect.size.height+20*MULTIPLYHEIGHT;
    
    
    CGFloat vIX = 17*MULTIPLYHEIGHT;
    CGFloat vIW = viewUnderBagShoe.frame.size.width-vIX*2;
    CGFloat vIH = 160*MULTIPLYHEIGHT;
    
    UIView *viewImages = [[UIView alloc]initWithFrame:CGRectMake(vIX, yAxis, vIW, vIH)];
    viewImages.backgroundColor = [UIColor clearColor];
    [viewUnderBagShoe addSubview:viewImages];
    
    CGFloat btnIW = viewImages.frame.size.width/2;
    
    NSArray *arrI = @[@"shoe_Start", @"bag_Start"];
    
    //NSArray *arrPri = @[[NSString stringWithFormat:@"STARTS FROM\n$%@", appDel.strShoeStartPrice], [NSString stringWithFormat:@"STARTS FROM\n$%@", appDel.strBagStartPrice]];
    
    for (int i = 0; i < 2; i++)
    {
        CGFloat btnIH = 90*MULTIPLYHEIGHT;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnIW*i, 0, btnIW, btnIH);
        btn.backgroundColor = [UIColor clearColor];
        [btn setImage:[UIImage imageNamed:[arrI objectAtIndex:i]] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [viewImages addSubview:btn];
        
        btnIH += 15*MULTIPLYHEIGHT;
        
//        UILabel *lblPrice = [[UILabel alloc]init];
//        lblPrice.numberOfLines = 0;
//        lblPrice.frame = CGRectMake(btnIW*i, btnIH, btnIW, 10);
//        [viewImages addSubview:lblPrice];
//        
//        
//        NSString *strStart = [[[arrPri objectAtIndex:i] componentsSeparatedByString:@"\n"] objectAtIndex:0];
//        NSString *strPrice = [[[arrPri objectAtIndex:i] componentsSeparatedByString:@"\n"] objectAtIndex:1];
//        
//        NSString *strFull = [NSString stringWithFormat:@"%@\n%@", strStart, strPrice];
//        
//        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:strFull];
//        [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-3], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(0, strStart.length)];
//        
//        [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_Heavy size:appDel.FONT_SIZE_CUSTOM+3], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(strStart.length+1, strPrice.length)];
//        
//        [attrStr addAttributes:@{NSKernAttributeName:@(1.0)} range:NSMakeRange(0, attrStr.length)];
//        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setAlignment:NSTextAlignmentCenter];
//        [paragraphStyle setLineSpacing:4.0f];
//        [paragraphStyle setMaximumLineHeight:100.0f];
//        
//        [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
//        
//        lblPrice.attributedText = attrStr;
//        
//        CGSize size = [AppDelegate getAttributedTextHeightForText:attrStr WithWidth:lblPrice.frame.size.width];
//        
//        CGRect rect = lblPrice.frame;
//        rect.size.height = size.height;
//        lblPrice.frame = rect;
//        
//        btnIH += size.height+20*MULTIPLYHEIGHT;
        
        CGFloat btnPX = i*btnIW+18*MULTIPLYHEIGHT;
        CGFloat btnPW = btnIW-(18*MULTIPLYHEIGHT * 2);
        CGFloat btnPH = 18*MULTIPLYHEIGHT;
        
        UIButton *btnPrice = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPrice.tag = i+1;
        btnPrice.frame = CGRectMake(btnPX, btnIH, btnPW, btnPH);
        [btnPrice setTitle:@"PRICE LIST" forState:UIControlStateNormal];
        [btnPrice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnPrice.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-6];
        btnPrice.backgroundColor = RGBCOLORCODE(91, 167, 250, 1.0);
        btnPrice.layer.cornerRadius = 9.0;
        [btnPrice addTarget:self action:@selector(btnPriceClicked:) forControlEvents:UIControlEventTouchUpInside];
        [viewImages addSubview:btnPrice];
    }
    
    yAxis += vIH+20*MULTIPLYHEIGHT;
    
    CGRect rectUn = viewUnderBagShoe.frame;
    rectUn.origin.y = screen_height;
    rectUn.size.height = yAxis;
    viewUnderBagShoe.frame = rectUn;
    
    [UIView animateWithDuration:0.3 animations:^{
       
        view_BagShoes.alpha = 1.0;
        blurEffect.alpha = 1.0;
        
        CGRect rectUn = viewUnderBagShoe.frame;
        rectUn.origin.y = screen_height/2-yAxis/2;
        viewUnderBagShoe.frame = rectUn;
        
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) btnPriceClicked:(UIButton *) btn
{
    appDel.isPriceListFromTab = YES;
    
    if (btn.tag == 1)
    {
        appDel.strServiceTypeFromHomeage = SERVICETYPE_SHOE_CLEAN;
    }
    else if (btn.tag == 2)
    {
        appDel.strServiceTypeFromHomeage = SERVICETYPE_BAG;
    }
    
    appDel.customTabBarController.selectedIndex = 2;
    
    [self closeBagShoePopup];
}

-(void) closeBagShoePopup
{
    [UIView animateWithDuration:0.3 animations:^{
        
        view_BagShoes.alpha = 0.0;
        blurEffect.alpha = 0.0;
        
        CGRect rectUn = viewUnderBagShoe.frame;
        rectUn.origin.y = screen_height;
        viewUnderBagShoe.frame = rectUn;
        
        
    } completion:^(BOOL finished) {
        
        [viewUnderBagShoe removeFromSuperview];
        viewUnderBagShoe = nil;
        
        [view_BagShoes removeFromSuperview];
        view_BagShoes = nil;
        
        [appDel removeCustomBlurEffectToView:appDel.window];
        
        [self searchingForNearestPiingo];
        
    }];
}

- (void) loadAPIForBookNowStatus
{
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/orderbookingavailable", BASE_URL];
    
    strErrorMessage = @"";
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if (!isCurrentScreenAppearing)
        {
            timerView.userInteractionEnabled = YES;
            addressBtn.userInteractionEnabled = YES;
            
            [intervalTime invalidate];
            intervalTime = nil;
            
            [timerView offWaves];
            [timerView setDetails:2];
            [timerView stopRotate2];
            
            return;
        }
        
        if ([[[responseObj objectForKey:@"order"] objectForKey:@"bookNow"] boolValue])
        {
            [self performSelectorOnMainThread:@selector(getETA) withObject:nil waitUntilDone:NO];
        }
        else if ([[[responseObj objectForKey:@"order"] objectForKey:@"sheduleLater"] boolValue])
        {
            timerView.userInteractionEnabled = YES;
            addressBtn.userInteractionEnabled = YES;
            
            [timerView offWaves];
            [timerView setDetails:2];
            
            lblTopDesc.text = [responseObj objectForKey:@"error"];
            
            etaLabel.hidden = YES;
            
            if (isFirstTimeScheduleLaterClicked || appDel.openScheduleLater)
            {
                isFirstTimeScheduleLaterClicked = NO;
                appDel.openScheduleLater = NO;
                
                if (!isCurrentScreenAppearing)
                {
                    return;
                }
                
                //addressBtn.userInteractionEnabled = NO;
                
                strErrorMessage = [responseObj objectForKey:@"em"];
                
                [self performSelector:@selector(schduleLaterBtnClicked) withObject:nil afterDelay:0.1];
            }
        }
        
        else {
            
            addressBtn.userInteractionEnabled = YES;
            timerView.userInteractionEnabled = YES;
            
            [timerView offWaves];
            [timerView setDetails:2];
            
            lblTopDesc.text = [responseObj objectForKey:@"error"];
            
            etaLabel.hidden = YES;
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
                
    }];

}

-(void) getAddress
{
    [appDel showLoader];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/get", BASE_URL];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            
            userAddresses = [responseObj objectForKey:@"addresses"];
            
            [PiingHandler sharedHandler].userAddress = userAddresses;
            
            if (appDel.openWelcomePopup)
            {
                appDel.openWelcomePopup = NO;
                
                NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:userAddresses];
                NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"default == %d", 1];
                sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
                
                if ([sortedArray count] > 0)
                {
                    selectedAddressDic = [sortedArray objectAtIndex:0];
                    
                    if ([selectedAddressDic count])
                    {
                        [addressBtn setTitle:[self setTitleForAddress] forState:UIControlStateNormal];
                    }
                    
                    [piingoMapView addClientMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[selectedAddressDic objectForKey:@"lat"], @"lat",[selectedAddressDic objectForKey:@"lon"], @"lon", @"home_map", @"markImage", nil]];
                    [piingoMapView focusMapToShowAllMarkers];
                    
                }
                else
                {
                    selectedAddressDic = [userAddresses objectAtIndex:0];
                }
                
                [self getSavedCards];
            }
            else
            {
                [appDel hideLoader];
            }
        }
        else
        {
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void) getSavedCards
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@payment/getallpaymentmethods", BASE_URL];
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            NSDictionary *dict = [responseObj objectForKey:@"paymentMethod"];
            
            NSMutableArray *arrayCards = [appDel getAllSavedCards:dict];
            
            [PiingHandler sharedHandler].userSavedCards = arrayCards;
            
            {
                
                // FOR DEMO SCREENS, UNCOMMENT THIS
                
                [timerView offWaves];
                [timerView setDetails:1];
                
                lblTopDesc.text = @"";
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SHOW_DEMO"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self showDemoScreens];
                
            }
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


#pragma mark UIControl Methods

-(NSString *) setTitleForAddress
{
    NSMutableString *str = [[NSMutableString alloc]init];
    
    if ([[selectedAddressDic objectForKey:@"name"]length])
    {
        [str appendString:[selectedAddressDic objectForKey:@"name"]];
    }
    
    if ([[selectedAddressDic objectForKey:@"line1"]length] > 1)
    {
        [str appendString:[NSString stringWithFormat:@", %@", [selectedAddressDic objectForKey:@"line1"]]];
    }
    else if ([[selectedAddressDic objectForKey:@"line2"]length])
    {
        [str appendString:[NSString stringWithFormat:@", %@", [selectedAddressDic objectForKey:@"line2"]]];
    }
    
    if ([[selectedAddressDic objectForKey:@"zipcode"]length])
    {
        [str appendString:[NSString stringWithFormat:@", %@", [selectedAddressDic objectForKey:@"zipcode"]]];
    }
    
    return str;
}

-(void) addressSelectionBtnClicked:(UIButton *) sender
{
    if ([addressBtn isSelected])
    {
        [self closeCustomPopover];
        
        return;
    }
    
    [appDel applyCustomBlurEffetForView:appDel.customTabBarController.tabBar WithBlurRadius:5];
    [appDel applyCustomBlurEffetForView:self.view WithBlurRadius:5];
    
    blurEffect = [self.view viewWithTag:98765];
    //blurEffect.dynamic = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnBlur:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [blurEffect addGestureRecognizer:tap];
    
    [FXBlurView setUpdatesDisabled];
    
    [UIView animateWithDuration:0.0 delay:0.0 options:0 animations:^{
       
        CGRect frame = backGroundTemView.frame;
        frame.size.height = screen_height;
        backGroundTemView.frame = frame;
        
    } completion:^(BOOL finished) {

        blurEffect.dynamic = NO;
        
    }];
    
    addressBtn.selected = YES;
    
    customPopOverView = [[CustomPopoverView alloc]initWithArray:userAddresses IsAddressType:YES];
    customPopOverView.delegate = self;
    customPopOverView.isFromTag = 1;
    [self.view addSubview:customPopOverView];
    customPopOverView.alpha = 0.0;
    customPopOverView.backgroundColor = [UIColor clearColor];
    
    [self.view bringSubviewToFront:addressBtn];
    [self.view bringSubviewToFront:customPopOverView];
    
    int yVal = addressBtn.frame.origin.y;
    
    customPopOverView.frame = CGRectMake(addressBtn.frame.origin.x, yVal+addressBtn.frame.size.height, addressBtn.frame.size.width, screen_height-(yVal+addressBtn.frame.size.height));
    
    [customPopOverView reloadPopOverViewWithTag:1];
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        customPopOverView.alpha = 1.0;
        
        CGRect frame = addressBtn.frame;
        frame.origin.y = yVal;
        addressBtn.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) tapOnBlur:(UITapGestureRecognizer *) tap
{
    [self closeCustomPopover];
}


#pragma mark FPPopover Delegate Method
-(void) didSelectFromList:(NSString *) string AtIndex:(NSInteger)row
{
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        CGRect frame = backGroundTemView.frame;
        frame.size.height = screen_height-TAB_BAR_HEIGHT;
        backGroundTemView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [appDel removeCustomBlurEffectToView:appDel.customTabBarController.tabBar];
    [appDel removeCustomBlurEffectToView:self.view];
    
    [customPopOverView reloadPopOverViewWithTag:2];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        
        customPopOverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
        addressBtn.selected = NO;
        
        [piingoMapView addClientMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[selectedAddressDic objectForKey:@"lat"], @"lat",[selectedAddressDic objectForKey:@"lon"], @"lon", @"home_map", @"markImage", nil]];
        [piingoMapView focusMapToShowAllMarkers];
        
        etaLabel.hidden = YES;
        
        [addressBtn setTitle:[self setTitleForAddress] forState:UIControlStateNormal];
        
        [self searchingForNearestPiingo];
        
    }];
    
    addressBtn.selected = NO;
    
    selectedAddressDic = [userAddresses objectAtIndex:row];
}

-(void) searchingForNearestPiingo
{
    [timerView showOnlyWaves];
    
    lblTopDesc.text = @"SEARCHING FOR YOUR NEAREST PIINGO";
    lblTopDesc.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-5];
    
    timerView.userInteractionEnabled = NO;
    addressBtn.userInteractionEnabled = NO;
    
    [self performSelector:@selector(loadAPIForBookNowStatus) withObject:nil afterDelay:2.5];
}

-(void) closeCustomPopover
{
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        CGRect frame = backGroundTemView.frame;
        frame.size.height = screen_height-TAB_BAR_HEIGHT;
        backGroundTemView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    [appDel showTabBar:appDel.customTabBarController];
    
    [appDel removeCustomBlurEffectToView:appDel.customTabBarController.tabBar];
    [appDel removeCustomBlurEffectToView:self.view];
    
    [customPopOverView reloadPopOverViewWithTag:2];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        
        customPopOverView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
        addressBtn.selected = NO;
        addressBtn.userInteractionEnabled = YES;
        
    }];
}


-(void) didAddNewAddress
{
    [self closeCustomPopover];
    
    [self getAddress];
}



-(void) segmentChange:(CustomSegmentControl *) sender
{
    if (sender.selectedIndex == 0)
    {
    }
    else if (sender.selectedIndex == 1)
    {
        MyBookingViewController *myBookingVC = [[MyBookingViewController alloc] init];
        [self.navigationController pushViewController:myBookingVC animated:YES];
    }
}

-(void) getETA
{
    NSString *versionNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [selectedAddressDic objectForKey:@"_id"], @"pickupAddressId", @"WF", @"serviceTypes", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", versionNumber, @"ver", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/eta", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        timerView.userInteractionEnabled = YES;
        addressBtn.userInteractionEnabled = YES;
        
        strErrorMessage = @"";
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            //piinfDetailDic = [responseObj objectForKey:@"order"];
            
            piinfDetailDic = [NSDictionary dictionaryWithDictionary:responseObj];
            
            [timerView offWaves];
            [timerView setDetails:1];
            
            if (intervalTime) {
                [intervalTime invalidate];
                intervalTime = nil;
            }
            
            timerView.countdownLabel.text = [NSString stringWithFormat:@"%d", [[responseObj objectForKey:@"rTime"] intValue]];
            
            intervalTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            countDownTime = [[responseObj objectForKey:@"rTime"] intValue];
            
            [timerView rotate2:countDownTime];
            
            bookNowETAStr = [NSString stringWithFormat:@"%@", [responseObj objectForKey:@"slot"]];
            strPiingoId = [NSString stringWithFormat:@"%d", [[responseObj objectForKey:@"pid"] intValue]];
            
            DLog(@"bookNowETAStr:%@",bookNowETAStr);
            
            NSString *str1 = @"";
            
            if ([responseObj objectForKey:@"name"])
            {
                str1 = [NSString stringWithFormat:@"%@ WILL ARRIVE BETWEEN\n", [[responseObj objectForKey:@"name"] uppercaseString]];
            }
            else
            {
                str1 = @"PIINGO WILL ARRIVE BETWEEN\n";
            }
            
            NSString *str2 = [NSString stringWithFormat:@"%@", bookNowETAStr];
            
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", str1, str2]];
            NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
            paragrapStyle.alignment = NSTextAlignmentCenter;
            [paragrapStyle setLineSpacing:10.0f];
            [paragrapStyle setMaximumLineHeight:100.0f];
            
            [attrString addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, attrString.length)];
            
            UIFont *font1 = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE-5];
            [attrString addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, str1.length)];
            
            UIFont *font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE];
            [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(str1.length, str2.length)];
            
            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
            
            etaLabel.attributedText = attrString;
            
            etaLabel.hidden = NO;
            lblTopDesc.text = [@"TAP TO BOOK NOW" uppercaseString];
            
            lblTopDesc.font = [UIFont fontWithName:APPFONT_Heavy size:appDel.HEADER_LABEL_FONT_SIZE-3];
        }
        else {
            
            if (isFirstTimeScheduleLaterClicked  || appDel.openScheduleLater)
            {
                isFirstTimeScheduleLaterClicked = NO;
                appDel.openScheduleLater = NO;
                
                if (!isCurrentScreenAppearing)
                {
                    return;
                }
                
                strErrorMessage = [responseObj objectForKey:@"error"];
                
                [self performSelector:@selector(schduleLaterBtnClicked) withObject:nil afterDelay:0.1];
            }
            
            [timerView offWaves];
            [timerView setDetails:2];
            
            lblTopDesc.text = [responseObj objectForKey:@"error"];
            etaLabel.hidden = YES;
        }
    }];
}



-(void) confirmBookOrderNow
{
    if ([bookNowETAStr length] == 0)
    {
        [appDel showAlertWithMessage:@"ETA is not available." andTitle:@"" andBtnTitle:@"OK"];
        
        return;
    }
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [selectedAddressDic objectForKey:@"_id"], @"pickupAddressId", @"B", @"orderType", @"WF", @"serviceTypes", @"R", @"orderSpeed", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", strPiingoId, @"pid", bookNowETAStr, @"pickUpSlotId", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/book", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            if(intervalTime)
            {
                [intervalTime invalidate];
                intervalTime = nil;
            }
            
            dictOrderDetails = [responseObj objectForKey:@"em"];
            
            piingBgView.hidden = NO;
            
            [self performSelector:@selector(bookOrderNowConform) withObject:nil afterDelay:1.0];
        }
        else
        {
            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
    
}


-(void) bookOrderNowConform
{
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    if (!isCurrentScreenAppearing)
    {
        return;
    }
    
    isCurrentScreenAppearing = NO;
    
    AddressFeild *objAddress = [[AddressFeild alloc] init];
    
    objAddress.addressID = [selectedAddressDic objectForKey:@"_id"];
    objAddress.addressName = [selectedAddressDic objectForKey:@"name"];
    objAddress.isAddressDefault = [selectedAddressDic objectForKey:@"default"];
    objAddress.zipCode = [selectedAddressDic objectForKey:@"zipcode"];
    objAddress.notes = [selectedAddressDic objectForKey:@"landMark"];
    
    bookVC = nil;
    bookVC = [[BookViewController alloc] init];
    bookVC.isBookNowStarted = YES;
    bookVC.isFromBookNow = YES;
    bookVC.bookNowCobID = [dictOrderDetails objectForKey:@"oid"];
    bookVC.bookNowETAStr = bookNowETAStr;
    bookVC.addressField = objAddress;
    bookVC.selectedAddress = selectedAddressDic;
    bookVC.dictBookNowDetails = [[NSDictionary alloc]initWithDictionary:dictOrderDetails];
    bookVC.piingoImg = [piinfDetailDic objectForKey:@"image"];
    bookVC.piingoName = [piinfDetailDic objectForKey:@"name"];
    bookVC.piingoId = [piinfDetailDic objectForKey:@"pid"];
    bookVC.isCurrentTimeSlot = [[piinfDetailDic objectForKey:@"isItCurrentSlot"] boolValue];
    
    bookVC.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
    [self addChildViewController:bookVC];
    [self.view addSubview:bookVC.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        bookVC.view.frame = self.view.bounds;
        
    } completion:^(BOOL finished) {
        
        
    }];
}


-(void) schduleLaterBtnClicked
{
    if (!isCurrentScreenAppearing)
    {
        return;
    }
    
    [FIRAnalytics logEventWithName:@"Schedule_later_button" parameters:nil];
    
    isCurrentScreenAppearing = NO;
    
    [appDel hideTabBar:appDel.customTabBarController];
    
    scheduleVC = nil;
    scheduleVC = [[ScheduleLaterViewController_New alloc] init];
    scheduleVC.isScheduleLaterOpened = YES;
    
    if ([strErrorMessage length])
    {
        scheduleVC.strPopupMessage = strErrorMessage;
    }
    
    UINavigationController *navSL = [[UINavigationController alloc]initWithRootViewController:scheduleVC];
    navSL.navigationBarHidden = YES;
    
    navSL.view.frame = CGRectMake(0.0, screen_height-50, screen_width, screen_height);
    [self addChildViewController:navSL];
    [self.view addSubview:navSL.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        navSL.view.frame = self.view.bounds;
        //self.view.transform = CGAffineTransformMakeScale(1.0, 0.9);
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void) updateTime
{
    countDownTime = countDownTime - 1;
    timerView.countdownLabel.text = [NSString stringWithFormat:@"%d", countDownTime];
    
    if (countDownTime == 0)
    {
        [intervalTime invalidate];
        intervalTime = nil;
        
        [timerView setDetails:2];
        [timerView stopRotate2];
        
        etaLabel.hidden = YES;
        lblTopDesc.text = @"TAP TO REFRESH";
        lblTopDesc.font = [UIFont fontWithName:APPFONT_Heavy size:appDel.HEADER_LABEL_FONT_SIZE-3];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
