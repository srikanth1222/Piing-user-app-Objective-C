//
//  BookViewController.m
//  Piing
//
//  Created by Piing on 10/31/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "BookViewController.h"
#import "GoogleMapView2.h"
#import "DeliveryViewController_New.h"
#import "ListViewController.h"
#import "ViewBillController.h"
#import "DragView2.h"
#import "FPPopoverKeyboardResponsiveController.h"
#import "DemoTableController.h"
#import "CustomPopoverView.h"
#import "UIButton+CenterImageAndTitle.h"
#import "PriceEstimatorViewController_New.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FXBlurView.h"
#import "DropAtDoorViewController.h"
#import <CardIO.h>
#import <MessageUI/MessageUI.h>
#import "ScheduleLaterViewController_New.h"
//#import <SocketIOClient.h>

#import "Piing_Obj_C-Swift.h"
#import "DateTimeViewController.h"
#import "PreferencesViewController.h"
#import "PriceListViewController_New.h"
#import "PartialAndRewashViewController.h"
#import <FirebaseAnalytics/FIRAnalytics.h>



@import EventKit;



#define PLACE_HOLDER_COLOR_INSTEAD_IMAGE [UIColor clearColor]

#define BOOK_VIEW_TAG 150
#define REDEEM_VIEW_TAG 300

#define TEXT_COLOR [UIColor colorWithRed:128/255.0 green:127/255.0 blue:126/255.0 alpha:1.0]

@interface BookViewController ()<DragViewDelegate, UITextFieldDelegate, DemoTableControllerDelegate, CustomPopoverViewDelegate, UIWebViewDelegate, UIScrollViewDelegate, DropAtDoorViewControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, DateTimeViewControllerDelegate, PreferencesViewControllerDelegate, HMSegmentedControlDelegate>
{
    
    UIView *pingoBgView;
    //UIView *pingoDetailsView;
    DragView2 *pingoDetailsView;
    
    UIView *washTypesView;
    UIView *deliveryDetailsView;
    
    UIButton *backBtn;
    
    UILabel *pickUpDateLbl;
    UILabel *deliveryDateEstLbl;
    
    UIButton *addressBtn;
    
    int selectedTableIndex;
    UILabel *trackStatusLbl;
    
    UIScrollView *bottomViewForOrder;
    AppDelegate *appDel;
    
    UIView *view_Popup;
    
    UILabel *lblPromocode;
    FPPopoverKeyboardResponsiveController *popover;
    
    GoogleMapView2 *piingoMapView;
    
    
    CustomPopoverView *customPopOverView;
    
    UILabel *LblDaysToDeliver;
    
    UIView *navBarView;
    UIView *orderTrackingView;
    
    BOOL isFromReloadOrder;
    
    NSTimer *etaTimerCountDown;
    NSUInteger countDownTime, intervalTime;
    UILabel *btnTitleLbl; // shashank checkt for ETA
    
    UIView *etaBgVew;
    
    UIView *view_Tourist;
    
    UIButton *closeBtn;
    
    NSDictionary *selectedCard;
    
    UILabel *LblEnterText;
    UIButton *btnSubmit;
    UITextField *passwordTF;
    
    UIButton *btnDropAtDoor;
    
    UIScrollView *scrollViewBottom;
    UIPageControl *pageControlBottom;
    
    UIView *progressView_Blue, *progressView_Grey;
    
    NSString *strDurationTime;
    UILabel *LblETA;
    
    NSTimer *timerTracking;
    
    __block UIView *view_Message;
    
    __block UIButton *btn_UpdateOrder;
    
    SocketIOClient* socketMain;
    
    float previousAddressYAxis;
    
    DragView2 *view_Bottom;
    
    BOOL touchChanges;
    
    UIView *view_ZigZag;
    
    UIImageView *profilePicView;
    UILabel *lblPiingoName;
    UIView *view_Tracking;
    BOOL isViewAtTop;
    
    UIButton *btnDown;
    UIImageView *imgArrow;
    
    UIView *view_BlurBGForBookNow;
    
    FXBlurView *blur;
    
    UIView *view_Image_Text;
    UIView *viewDownDates;
    
    UILabel *pingNameLbl;
    
    UIImageView *cardIconView;
    
    BOOL isPiingoConnected;
    
    UIButton *promocodeBtn;
    
    UILabel *lblSwitch;
    NSTimer *timerSwitch;
    
    NSString *brainTreeClientToken;
    
    UILabel *lblPaymentType;
    
    UIView *view_BG;
    
    UIButton *btnShare;
    
    CGRect originalShareRect;
    
    UIView *view_Share;
    
    FXBlurView *blurEffect;
    UIView *view_UnderShare;
    
    UIView *view_OrderBooked;
    
    UILabel *lblOrderType;
    
    CGFloat previousSliderValue;
    
    UIButton *btnArrow;
    UIButton *btnArrowType;
    
    BOOL prefsOpenedAutomatically;
    
    UIView *view_Curtains;
    
    UILabel *lblInst;
    
    UIScrollView *view_WashTypes;
    
    HMSegmentedControl *segmentCleaning;
    
    UIScrollView *scrollViewWashType;
    
    NSDictionary *dictJobTypes;
    
    //SevenSwitch *mySwitch2;
    //UISegmentedControl *segmentSwitch;
    
    CGFloat addOrMinusYPos;
    
    NSMutableDictionary *dictServiceType;
    
    NSMutableArray *arraAlldata;
    NSMutableDictionary *dictDeliveryDatesAndTimes;
    
    NSDictionary *dictPickupAddress;
    NSDictionary *dictDeliveryAddress;
    
    BOOL curtainSelected, dryCleaningSelected, shoeSelected;
    
    //SevenSwitch *switchCurtain;
    UISegmentedControl *segmentCurtain;
    
    NSString *selectedCurtainServiceType;
    
    UIView *viewSome;
    
    UIButton *btnCurtain, *btnDryCleaning, *btnShoe;
    
    UIImageView *imgEcoBG;
    
    BOOL knowMoreExpanded;
    
    NSMutableArray *arraySelectedServiceTypes;
    
    UIButton *btnSwitch;
}

@property (strong, nonatomic) EKCalendar *calendar;
@property (strong, nonatomic) EKEventStore *eventStore;

@property (nonatomic, strong) MPMoviePlayerController *backGroundplayer;

@property BOOL socketIsConnected;

@property (nonatomic, strong) NSMutableArray *deliveryDates;

@property (nonatomic, strong) NSMutableDictionary *orderInfo;

@end


@implementation BookViewController

@synthesize orderInfo;

-(void) connectToSocket
{
    //http://52.74.59.25:9009 Old Service
    //addMeCustomer
    //PickupLatLongDetails
    
    
    view_Message = [[UIView alloc]init];
    view_Message.backgroundColor = BLUE_COLOR;
    
    UIActivityIndicatorView *ac = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [ac startAnimating];
    [view_Message addSubview:ac];
    
    float viewMHeight = 30*MULTIPLYHEIGHT;
    
    if (pingoDetailsView)
    {
        [self.view addSubview:view_Message];
        
        [self.view bringSubviewToFront:pingoDetailsView];
        view_Message.frame = CGRectMake(0, pingoDetailsView.frame.origin.y, screen_width, viewMHeight);
    }
    else
    {
        [view_BG addSubview:view_Message];
        
        [view_BG bringSubviewToFront:view_Bottom];
        view_Message.frame = CGRectMake(0, view_Bottom.frame.origin.y, screen_width, viewMHeight);
    }
    
    float acX = 15*MULTIPLYHEIGHT;
    
    ac.center = CGPointMake(acX, view_Message.frame.size.height/2);
    
    //view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    float lblWX = 30*MULTIPLYHEIGHT;
    float lblWWidth = 35*MULTIPLYHEIGHT;
    
    UILabel *lblErrorMessage = [[UILabel alloc] initWithFrame:CGRectMake(lblWX, 0, screen_width-lblWWidth, viewMHeight)];
    lblErrorMessage.text = @"Locating your Piingo...";
    lblErrorMessage.textAlignment = NSTextAlignmentLeft;
    lblErrorMessage.numberOfLines = 0;
    lblErrorMessage.textColor = [UIColor whiteColor];
    lblErrorMessage.backgroundColor = [UIColor clearColor];
    lblErrorMessage.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    [view_Message addSubview:lblErrorMessage];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        CGRect frame = view_Message.frame;
        frame.origin.y -= viewMHeight;
        view_Message.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
    }];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", self.bookNowCobID, @"orderId", self.piingoName, @"name", @"IOS", @"device", [self.selectedAddress objectForKey:@"lat"], @"lat", [self.selectedAddress objectForKey:@"lon"], @"lon", self.piingoId, @"pid", nil];
    
    NSURL* url = [[NSURL alloc] initWithString:BASE_TRACKING_URL];
    
    SocketIOClient* socket = [[SocketIOClient alloc] initWithSocketURL:url config:nil];
    
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        NSLog(@"socket connected");
        
        socketMain = socket;
        
        [socket emitWithAck:@"connect user" with:@[dic]](0, ^(NSArray* data) {
            
            NSLog(@"EMIT ACK");
            
            if ([data count])
            {
                NSDictionary *dicResponse = [data objectAtIndex:0];
                
                if ([[dicResponse objectForKey:@"s"] intValue] == 1)
                {
                    [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
                        
                        CGRect frame = view_Message.frame;
                        frame.origin.y += viewMHeight;
                        view_Message.frame = frame;
                        
                        
                    } completion:^(BOOL finished) {
                        
                        [view_Message removeFromSuperview];
                        view_Message = nil;
                    }];
                }
                else
                {
                    lblErrorMessage.text = @"Oops! Something tore. We are working on it right now. Please check back.";
                    
                    [UIView animateWithDuration:0.3 delay:5.0 options:0 animations:^{
                        
                        CGRect frame = view_Message.frame;
                        frame.origin.y += viewMHeight;
                        view_Message.frame = frame;
                        
                        
                    } completion:^(BOOL finished) {
                        
                        [view_Message removeFromSuperview];
                        view_Message = nil;
                    }];
                }
            }
            
        });
        
        [socket on:@"waypoint change" callback:^(NSArray* data, SocketAckEmitter* ack) {
            
            NSLog(@"waypoint change");
            
            if ([data count])
            {
                NSDictionary *dicResponse = [data objectAtIndex:0];
                
                if ([[dicResponse objectForKey:@"s"]intValue] == 1)
                {
                    piingoMapView.delegate = self;
                    
                    NSDictionary *dicCoordinates = [dicResponse objectForKey:@"piingwp"];
                    
                    appDel.headingInDegrees = [[dicCoordinates objectForKey:@"heading"] floatValue];
                    
                    if ([dicResponse objectForKey:@"eta"])
                    {
                        strDurationTime = [NSString stringWithFormat:@"%d", [[dicResponse objectForKey:@"eta"] intValue]];
                        
                        NSString *strStatusCode = [self.orderEditDetails objectForKey:@"statusCode"];
                        
                        [self updateTime];
                        
                        NSString *strName;
                        
                        NSString *strRoute;
                        
                        int minutes = (int) [[dicResponse objectForKey:@"eta"] longLongValue];
                        
                        NSString *strETA = [NSString stringWithFormat:@"%d mins", minutes];
                        
                        if (self.isFromOrdersList)
                        {
                            strName = [self.piingoName uppercaseString];
                            
                            if ([strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"AD-P"])
                            {
                                strRoute = [[NSString stringWithFormat:@" will arrive in\n%@ for pick-up", strETA] uppercaseString];
                            }
                            else if ([strStatusCode isEqualToString:@"PO-D"] || [strStatusCode isEqualToString:@"AD-D"] || [strStatusCode isEqualToString:@"OB-RS-D"])
                            {
                                strRoute = [[NSString stringWithFormat:@" will arrive in\n%@ for delivery", strETA] uppercaseString];
                            }
                        }
                        else
                        {
                            strName = [self.piingoName uppercaseString];
                            
                            int minutes = (int) [[dicResponse objectForKey:@"eta"] longLongValue];
                            
                            NSString *strETA = [NSString stringWithFormat:@"%d mins", minutes];
                            
                            strRoute = [[NSString stringWithFormat:@" will arrive in\n%@ for pick-up", strETA] uppercaseString];
                        }
                        
                        NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:strName];
                        [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM]} range:NSMakeRange(0, [strName length])];
                        
                        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:strRoute];
                        [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5]} range:NSMakeRange(0, [strRoute length])];
                        
                        NSRange range = [attr1.string rangeOfString:[strETA uppercaseString]];
                        
                        [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:BLUE_COLOR} range:range];
                        
                        [mainAttr appendAttributedString:attr1];
                        
                        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
                        
                        if (self.isFromBookNow)
                        {
                            paragrapStyle.alignment = NSTextAlignmentLeft;
                        }
                        else
                        {
                            if (isViewAtTop)
                            {
                                paragrapStyle.alignment = NSTextAlignmentCenter;
                            }
                            else
                            {
                                paragrapStyle.alignment = NSTextAlignmentLeft;
                            }
                        }
                        
                        [paragrapStyle setLineSpacing:6.0f];
                        [paragrapStyle setMaximumLineHeight:100.0f];
                        
                        [mainAttr addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, mainAttr.length)];
                        
                        if (lblPiingoName)
                        {
                            lblPiingoName.attributedText = mainAttr;
                        }
                        else
                        {
                            pingNameLbl.attributedText = mainAttr;
                        }
                        
                        mainAttr = nil;
                    }
                    
                    [piingoMapView addPiingoMarkder:dicCoordinates];
                    
                    if (!isPiingoConnected)
                    {
                        isPiingoConnected = YES;
                        [piingoMapView focusMapToShowAllMarkers];
                    }
                }
            }
//            if (!timerTracking)
//            {
//                timerTracking = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(updateIntervalTime) userInfo:nil repeats:YES];
//
//                if ([data count])
//                {
//                    NSDictionary *dicResponse = [data objectAtIndex:0];
//
//                    if ([[dicResponse objectForKey:@"s"]intValue] == 1)
//                    {
//                        piingoMapView.delegate = self;
//
//                        NSDictionary *dicCoordinates = [dicResponse objectForKey:@"piingwp"];
//
//                        appDel.headingInDegrees = [[dicCoordinates objectForKey:@"heading"] floatValue];
//
//                        if ([dicResponse objectForKey:@"eta"])
//                        {
//                            strDurationTime = [NSString stringWithFormat:@"%d", [[dicResponse objectForKey:@"eta"] intValue]];
//
//                            NSString *strStatusCode = [self.orderEditDetails objectForKey:@"statusCode"];
//
//                            [self updateTime];
//
//                            NSString *strName;
//
//                            NSString *strRoute;
//
//                            int minutes = (int) [[dicResponse objectForKey:@"eta"] longLongValue];
//
//                            NSString *strETA = [NSString stringWithFormat:@"%d mins", minutes];
//
//                            if (self.isFromOrdersList)
//                            {
//                                strName = [self.piingoName uppercaseString];
//
//                                if ([strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"AD-P"])
//                                {
//                                    strRoute = [[NSString stringWithFormat:@" will arrive in\n%@ for pick-up", strETA] uppercaseString];
//                                }
//                                else if ([strStatusCode isEqualToString:@"PO-D"] || [strStatusCode isEqualToString:@"AD-D"] || [strStatusCode isEqualToString:@"OB-RS-D"])
//                                {
//                                    strRoute = [[NSString stringWithFormat:@" will arrive in\n%@ for delivery", strETA] uppercaseString];
//                                }
//                            }
//                            else
//                            {
//                                strName = [self.piingoName uppercaseString];
//
//                                int minutes = (int) [[dicResponse objectForKey:@"eta"] longLongValue];
//
//                                NSString *strETA = [NSString stringWithFormat:@"%d mins", minutes];
//
//                                strRoute = [[NSString stringWithFormat:@" will arrive in\n%@ for pick-up", strETA] uppercaseString];
//                            }
//
//                            NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:strName];
//                            [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM]} range:NSMakeRange(0, [strName length])];
//
//                            NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:strRoute];
//                            [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5]} range:NSMakeRange(0, [strRoute length])];
//
//                            NSRange range = [attr1.string rangeOfString:[strETA uppercaseString]];
//
//                            [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:BLUE_COLOR} range:range];
//
//                            [mainAttr appendAttributedString:attr1];
//
//                            NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
//
//                            if (self.isFromBookNow)
//                            {
//                                paragrapStyle.alignment = NSTextAlignmentLeft;
//                            }
//                            else
//                            {
//                                if (isViewAtTop)
//                                {
//                                    paragrapStyle.alignment = NSTextAlignmentCenter;
//                                }
//                                else
//                                {
//                                    paragrapStyle.alignment = NSTextAlignmentLeft;
//                                }
//                            }
//
//                            [paragrapStyle setLineSpacing:6.0f];
//                            [paragrapStyle setMaximumLineHeight:100.0f];
//
//                            [mainAttr addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, mainAttr.length)];
//
//                            if (lblPiingoName)
//                            {
//                                lblPiingoName.attributedText = mainAttr;
//                            }
//                            else
//                            {
//                                pingNameLbl.attributedText = mainAttr;
//                            }
//
//                            mainAttr = nil;
//                        }
//
//                        [piingoMapView addPiingoMarkder:dicCoordinates];
//
//                        if (!isPiingoConnected)
//                        {
//                            isPiingoConnected = YES;
//                            [piingoMapView focusMapToShowAllMarkers];
//                        }
//                    }
//                }
//            }
            
        }];
    }];
    
    [socket connect];
    
}


-(void) durationResponse:(id) durationResponse
{
    
}


-(void) updateIntervalTime
{
    [timerTracking invalidate];
    timerTracking = nil;
}


-(void) updateTime
{
    
    NSString *strETAName = @"ETA";
    
    NSMutableAttributedString *mainETAAttr = [[NSMutableAttributedString alloc]initWithString:strETAName];
    [mainETAAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE], NSForegroundColorAttributeName:[UIColor colorFromHexString:@"939393"]} range:NSMakeRange(0, [strETAName length])];
    
    NSString *strMins;
    
    if ([strDurationTime length])
    {
        int minutes = (int) [strDurationTime longLongValue] / 60;
        
        strMins = [[NSString stringWithFormat:@" %d minutes", minutes] uppercaseString];
    }
    else
    {
        //strMins = [@" 15 mins" uppercaseString];
        strMins = @"";
    }
    
    NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:strMins];
    [attr2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE], NSForegroundColorAttributeName:[UIColor colorFromHexString:@"0faee8"]} range:NSMakeRange(0, [strMins length])];
    
    [mainETAAttr appendAttributedString:attr2];
    
    LblETA.attributedText = mainETAAttr;
    
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    if (![[self.orderEditDetails objectForKey:@"statusCode"] isEqualToString:@"OD"])
    {
        UIPreviewAction *op1 = [UIPreviewAction actionWithTitle:@"Update order" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            
            [self.delegate callParentControll:@"Update order"];
            
        }];
        
        [arr addObject:op1];
    }
    
    UIPreviewAction *op2 = [UIPreviewAction actionWithTitle:@"View bill" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [self.delegate callParentControll:@"View bill"];
    }];
    
    [arr addObject:op2];
    
    if (![[self.orderEditDetails objectForKey:@"statusCode"] isEqualToString:@"OD"])
    {
        UIPreviewAction *op3 = [UIPreviewAction actionWithTitle:@"Preferences" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
            
            [self.delegate callParentControll:@"Preferences"];
        }];
        
        [arr addObject:op3];
    }
    
    UIPreviewAction *op4 = [UIPreviewAction actionWithTitle:@"Cancel" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        [appDel setBottomTabBarColor:TABBAR_COLOR_GREY BlurEffectStyle:BLUR_EFFECT_STYLE_LIGHT HideBlurEffect:NO];
        [appDel setBottomTabBarColorForTab:2];
        
        [appDel showTabBar:appDel.customTabBarController];
        
    }];
    
    [arr addObject:op4];
    
    //UIPreviewActionGroup *actionGroup = [UIPreviewActionGroup actionGroupWithTitle:<#(nonnull NSString *)#> style:<#(UIPreviewActionStyle)#> actions:<#(nonnull NSArray<UIPreviewAction *> *)#>
    
    return arr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [[PiingHandler sharedHandler] appDel];
    
    if (self.isFromOrdersList)
    {
        [self getOrderDetailsFromService];
    }
    else
    {
        [self loadNormaldata];
    }
}

-(void) getOrderDetailsFromService
{
    NSDictionary *dictDetail = [NSDictionary dictionaryWithObjectsAndKeys:self.bookNowCobID, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/get/byid", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dictDetail andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            self.orderEditDetails = [[NSMutableDictionary alloc]initWithDictionary:[[responseObj objectForKey:@"em"] objectAtIndex:0]];
            
            NSMutableArray *arrayServiceTypes = [[NSMutableArray alloc]initWithArray:[self.orderEditDetails objectForKey:ORDER_JOB_TYPE]];
            
            if ([arrayServiceTypes containsObject:SERVICETYPE_HL_WI])
            {
                if (![arrayServiceTypes containsObject:SERVICETYPE_WI])
                {
                    [arrayServiceTypes replaceObjectAtIndex:[arrayServiceTypes indexOfObject:SERVICETYPE_HL_WI] withObject:SERVICETYPE_WI];
                }
                else
                {
                    [arrayServiceTypes removeObject:SERVICETYPE_HL_WI];
                }
            }
            
            if ([arrayServiceTypes containsObject:SERVICETYPE_HL_DC])
            {
                if (![arrayServiceTypes containsObject:SERVICETYPE_DC])
                {
                    [arrayServiceTypes replaceObjectAtIndex:[arrayServiceTypes indexOfObject:SERVICETYPE_HL_DC] withObject:SERVICETYPE_DC];
                }
                else
                {
                    [arrayServiceTypes removeObject:SERVICETYPE_HL_DC];
                }
            }
            
            if ([arrayServiceTypes containsObject:SERVICETYPE_HL_DCG])
            {
                if (![arrayServiceTypes containsObject:SERVICETYPE_DCG])
                {
                    [arrayServiceTypes replaceObjectAtIndex:[arrayServiceTypes indexOfObject:SERVICETYPE_HL_DCG] withObject:SERVICETYPE_DCG];
                }
                else
                {
                    [arrayServiceTypes removeObject:SERVICETYPE_HL_DCG];
                }
            }
            
//            if ([arrayServiceTypes containsObject:SERVICETYPE_DCG] && [arrayServiceTypes containsObject:SERVICETYPE_DC])
//            {
//                [arrayServiceTypes removeObject:SERVICETYPE_DCG];
//            }
            
            [self.orderEditDetails setObject:arrayServiceTypes forKey:ORDER_JOB_TYPE];
            
            self.dictAllowUpdates = [[NSMutableDictionary alloc]initWithDictionary:[responseObj objectForKey:@"allowdUpdate"]];
            
            if ([[self.orderEditDetails objectForKey:@"billStatus"] caseInsensitiveCompare:@"NA"] == NSOrderedSame)
            {
                NSString *strPiingoId = @"";
                
                if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Delivery"] == NSOrderedSame)
                {
                    strPiingoId = [NSString stringWithFormat:@"%d", [[self.orderEditDetails objectForKey:@"dpid"] intValue]];
                }
                else
                {
                    strPiingoId = [NSString stringWithFormat:@"%d", [[self.orderEditDetails objectForKey:@"ppid"] intValue]];
                }
                
                if ([strPiingoId intValue] > 0)
                {
                    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", strPiingoId, @"pid", nil];
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@piingo/get", BASE_URL];
                    
                    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                        
                        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                        
                        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                            
                            NSDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[responseObj objectForKey:@"em"]];
                            
                            if ([[dict objectForKey:@"image"] containsString:@"http"])
                            {
                                self.piingoImg = [dict objectForKey:@"image"];
                            }
                            else
                            {
                                self.piingoImg = [NSString stringWithFormat:@"%@%@", BASE_TRACKING_URL, [dict objectForKey:@"image"]];
                            }
                            
                            self.piingoName = [[dict objectForKey:@"name"] uppercaseString];
                            self.piingoId = [[dict objectForKey:@"pid"] stringValue];
                            
                            [self loadNormaldata];
                        }
                        else {
                            
                            [appDel displayErrorMessagErrorResponse:responseObj];
                        }
                        
                    }];
                }
                else
                {
                    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                    
                    if ([[self.orderEditDetails objectForKey:@"piingoImg"] length])
                    {
                        self.piingoImg = [NSString stringWithFormat:@"%@%@", BASE_TRACKING_URL, [self.orderEditDetails objectForKey:@"piingoImg"]];
                    }
                    
                    self.piingoName = [[self.orderEditDetails objectForKey:@"piingoName"] uppercaseString];
                    
                    [self loadNormaldata];
                }
            }
            else
            {
                NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [self.orderEditDetails objectForKey:@"oid"], @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
                
                NSString *urlStr = @"";
                
                if ([[self.orderEditDetails objectForKey:@"partial"] boolValue])
                {
                    urlStr = [NSString stringWithFormat:@"%@order/get/billpartial", BASE_URL];
                }
                else
                {
                    urlStr = [NSString stringWithFormat:@"%@order/get/bill", BASE_URL];
                }
                
                [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                    
                    if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                        
                        NSDictionary *dictNow;
                        
                        if ([[responseObj objectForKey:@"em"] isKindOfClass:[NSArray class]])
                        {
                            dictNow = [[responseObj objectForKey:@"em"] objectAtIndex:0];
                        }
                        else
                        {
                            dictNow = [responseObj objectForKey:@"em"];
                        }
                        
                        if ([dictNow objectForKey:@"totalSum"])
                        {
                            NSDictionary *dictAll = [dictNow objectForKey:@"totalSum"];
                            
                            if ([[dictAll objectForKey:@"totalAmount"] floatValue] == 0.0)
                            {
                                self.strFinalAmount = [NSString stringWithFormat:@"$%.2f", [[dictAll objectForKey:@"amountPaid"] floatValue]];
                            }
                            else
                            {
                                self.strFinalAmount = [NSString stringWithFormat:@"$%.2f", [[dictAll objectForKey:@"totalAmount"] floatValue]];
                            }
                        }
                        else
                        {
                            self.strFinalAmount = [NSString stringWithFormat:@"$%.2f", [[dictNow objectForKey:@"billAmount"] floatValue]];
                        }
                        
                        NSString *strPiingoId = @"";
                        
                        if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Delivery"] == NSOrderedSame)
                        {
                            strPiingoId = [NSString stringWithFormat:@"%d", [[self.orderEditDetails objectForKey:@"dpid"] intValue]];
                        }
                        else
                        {
                            strPiingoId = [NSString stringWithFormat:@"%d", [[self.orderEditDetails objectForKey:@"ppid"] intValue]];
                        }
                        
                        if ([strPiingoId intValue] > 0)
                        {
                            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", strPiingoId, @"pid", nil];
                            
                            NSString *urlStr = [NSString stringWithFormat:@"%@piingo/get", BASE_URL];
                            
                            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                                
                                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                                
                                if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                                    
                                    NSDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[responseObj objectForKey:@"em"]];
                                    
                                    if ([[dict objectForKey:@"image"] containsString:@"http"])
                                    {
                                        self.piingoImg = [dict objectForKey:@"image"];
                                    }
                                    else
                                    {
                                        self.piingoImg = [NSString stringWithFormat:@"%@%@", BASE_TRACKING_URL, [dict objectForKey:@"image"]];
                                    }
                                    
                                    self.piingoName = [[dict objectForKey:@"name"] uppercaseString];
                                    self.piingoId = [[dict objectForKey:@"pid"] stringValue];
                                    
                                    [self loadNormaldata];
                                }
                                else {
                                    
                                    [appDel displayErrorMessagErrorResponse:responseObj];
                                }
                                
                            }];
                        }
                        else
                        {
                            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                            
                            if ([[self.orderEditDetails objectForKey:@"piingoImg"] length])
                            {
                                self.piingoImg = [NSString stringWithFormat:@"%@%@", BASE_TRACKING_URL, [self.orderEditDetails objectForKey:@"piingoImg"]];
                            }
                            
                            self.piingoName = [[self.orderEditDetails objectForKey:@"piingoName"] uppercaseString];
                            
                            [self loadNormaldata];
                        }
                    }
                    else {
                        
                        [appDel displayErrorMessagErrorResponse:responseObj];
                    }
                }];
            }
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}

-(void) loadNormaldata
{
    
    appDel.isDeleteBookView = NO;
    appDel.hasOpenedOrderDetails = YES;
    
    [appDel setBottomTabBarColor:TABBAR_COLOR_GREY BlurEffectStyle:BLUR_EFFECT_STYLE_LIGHT HideBlurEffect:NO];
    
    self.userAddresses = [PiingHandler sharedHandler].userAddress;
    self.userSavedCards = [PiingHandler sharedHandler].userSavedCards;
    
    self.deliveryDates = [[NSMutableArray alloc]init];
    arraAlldata = [[NSMutableArray alloc]init];
    dictDeliveryDatesAndTimes = [[NSMutableDictionary alloc]init];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    selectedTableIndex = 0;
    
    //Initialization
    {
        self.orderInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        
        [self.orderInfo setValue:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
        [self.orderInfo setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:ORDER_USER_ID];
        [self.orderInfo setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN] forKey:@"t"];
        
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
        
        [self.orderInfo setObject:[selectedCard objectForKey:@"_id"] forKey:ORDER_CARD_ID];
        
        if(self.isFromOrdersList) {
            
            if (appDel.isAfterBookingOrder)
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAuthorizationStatusToAccessEventStore) name:@"AddToCalendar" object:nil];
            }
            
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"CALENDAR_ACCESS_GRANTED"])
            {
                [self updateAuthorizationStatusToAccessEventStore];
            }
            else if (appDel.automaticAddtoCalendar)
            {
                appDel.automaticAddtoCalendar = NO;
                
                [self saveNewEvent];
            }
            
            NSArray *sortedArray1 = [[NSMutableArray alloc]initWithArray:self.userAddresses];
            NSPredicate *getDefaultAddPredicate1 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.orderEditDetails objectForKey:ORDER_PICKUP_ADDRESS_ID]]];
            
            sortedArray1 = [sortedArray1 filteredArrayUsingPredicate:getDefaultAddPredicate1];
            
            if ([sortedArray1 count] > 0)
            {
                dictPickupAddress = [sortedArray1 objectAtIndex:0];
            }
            
            NSArray *sortedArray2 = [[NSMutableArray alloc]initWithArray:self.userAddresses];
            NSPredicate *getDefaultAddPredicate2 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.orderEditDetails objectForKey:ORDER_DELIVERY_ADDRESS_ID]]];
            
            sortedArray2 = [sortedArray2 filteredArrayUsingPredicate:getDefaultAddPredicate2];
            
            if ([sortedArray2 count] > 0)
            {
                dictDeliveryAddress = [sortedArray2 objectAtIndex:0];
            }
            
            if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Pickup"] == NSOrderedSame)
            {
                self.selectedAddress = dictPickupAddress;
            }
            else
            {
                self.selectedAddress = dictDeliveryAddress;
            }
            
            [self.orderInfo setObject:self.bookNowCobID forKey:@"oid"];
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT] forKey:ORDER_PICKUP_SLOT];
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_PICKUP_DATE] forKey:ORDER_PICKUP_DATE];
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT] forKey:ORDER_DELIVERY_SLOT];
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE] forKey:ORDER_DELIVERY_DATE];
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_DELIVERY_ADDRESS_ID] forKey:ORDER_DELIVERY_ADDRESS_ID];
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_PICKUP_ADDRESS_ID] forKey:ORDER_PICKUP_ADDRESS_ID];
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_TYPE] forKey:ORDER_TYPE];
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_CARD_ID] forKey:ORDER_CARD_ID];
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_JOB_TYPE] forKey:ORDER_JOB_TYPE];
            
            if ([self.orderEditDetails objectForKey:PROMO_CODE])
            {
                [self.orderInfo setObject:[self.orderEditDetails objectForKey:PROMO_CODE] forKey:PROMO_CODE];
            }
            else
            {
                [self.orderInfo setObject:@"" forKey:PROMO_CODE];
            }
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_NOTES] forKey:ORDER_NOTES];
            
            NSDictionary *dict1 = [self.orderEditDetails objectForKey:PREFERENCES_SELECTED];
            
            NSMutableDictionary *dictMain  = [[NSMutableDictionary alloc]init];
            
            for (NSDictionary *dict2 in dict1)
            {
                if ([dict2 objectForKey:@"value"])
                {
                    [dictMain setObject:[dict2 objectForKey:@"value"] forKey:[dict2 objectForKey:@"name"]];
                }
                else
                {
                    [dictMain setObject:@"" forKey:[dict2 objectForKey:@"name"]];
                }
            }
            
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
            
            [self.orderInfo setObject:strPref forKey:PREFERENCES_SELECTED];
            
            [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_FROM] forKey:ORDER_FROM];
        }
        else if (self.isFromBookNow)
        {
            arraySelectedServiceTypes = [[NSMutableArray alloc]init];
            
            NSArray *sortedArray = [[NSMutableArray alloc]initWithArray:self.userAddresses];
            NSPredicate *getDefaultAddPredicate = [NSPredicate predicateWithFormat:@"default == %d", 1];
            sortedArray = [sortedArray filteredArrayUsingPredicate:getDefaultAddPredicate];
            
            if ([sortedArray count] > 0)
            {
                self.selectedAddress = [sortedArray objectAtIndex:0];
            }
            else
            {
                self.selectedAddress = [self.userAddresses objectAtIndex:0];
            }
            
            [self.orderInfo setObject:@"B" forKey:ORDER_FROM];
            [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
            
            [self.orderInfo setObject:[self.selectedAddress objectForKey:@"_id"] forKey:ORDER_PICKUP_ADDRESS_ID];
            [self.orderInfo setObject:[self.selectedAddress objectForKey:@"_id"] forKey:ORDER_DELIVERY_ADDRESS_ID];
            
            [self.orderInfo setObject:[self.dictBookNowDetails objectForKey:ORDER_PICKUP_DATE] forKey:ORDER_PICKUP_DATE];
            [self.orderInfo setObject:[self.dictBookNowDetails objectForKey:ORDER_PICKUP_SLOT] forKey:ORDER_PICKUP_SLOT];
            
            
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
            
            
            [self.orderInfo setObject:@"" forKey:PROMO_CODE];
            [self.orderInfo setObject:@"FROM IOS" forKey:ORDER_NOTES];
            
            [self.orderInfo setObject:[self.dictBookNowDetails objectForKey:@"oid"] forKey:@"oid"];
        }
    }
    
    view_BG = [[UIView alloc]initWithFrame:self.view.bounds];
    view_BG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_BG];
    
    piingoMapView = [[GoogleMapView2 alloc] initWithFrame:CGRectMake(0.0, 0.0, screen_width, screen_height-(72*MULTIPLYHEIGHT))];
    //piingoMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    piingoMapView.delegate = self;
    [view_BG addSubview:piingoMapView];
    
    if ([self.selectedAddress count])
    {
        [piingoMapView addClientMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[self.selectedAddress objectForKey:@"lat"], @"lat", [self.selectedAddress objectForKey:@"lon"], @"lon", @"home_map", @"markImage", @"no", @"clearAll", nil]];
    }
    
    [piingoMapView focusMapToShowAllMarkers];
    
    if (self.isFromOrdersList)
    {
        if ([[self.orderEditDetails objectForKey:@"trackingStatus"] intValue] == 0)
        {
            piingoMapView.hidden = YES;
        }
        else
        {
            [self performSelectorOnMainThread:@selector(connectToSocket) withObject:nil waitUntilDone:NO];
        }
        
        [self loadOrderDetails];
    }
    
    else if (self.isFromBookNow)
    {
        if (self.isCurrentTimeSlot)
        {
            [self performSelectorOnMainThread:@selector(connectToSocket) withObject:nil waitUntilDone:NO];
        }
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(screen_width - 55.0, 21*MULTIPLYHEIGHT, 40, 40);
        [closeBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
        
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(10.0, 21*MULTIPLYHEIGHT, 40.0, 40.0);
        [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
        backBtn.hidden = YES;
        backBtn.backgroundColor = [UIColor whiteColor];
        backBtn.layer.cornerRadius = backBtn.frame.size.width/2;
        
        
        
        float piingHeight = 72*MULTIPLYHEIGHT;
        
        pingoDetailsView = [[DragView2 alloc] initWithFrame:CGRectMake(0.0, screen_height - piingHeight, screen_width, screen_height)];
        pingoDetailsView.tag = 200;
        pingoDetailsView.delegate = self;
        pingoDetailsView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:pingoDetailsView];
        pingoDetailsView.userInteractionEnabled = NO;
        
        
        pingoBgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screen_width, piingHeight)];
        pingoBgView.backgroundColor = [UIColor whiteColor];
        [pingoDetailsView addSubview:pingoBgView];
        
        
        float imgHeight = 58*MULTIPLYHEIGHT;
        
        profilePicView = [[UIImageView alloc] initWithFrame:CGRectMake(15*MULTIPLYHEIGHT , piingHeight/2-(imgHeight/2), imgHeight, imgHeight)];
        profilePicView.backgroundColor = [UIColor whiteColor];
        
        [profilePicView sd_setImageWithURL:[NSURL URLWithString:self.piingoImg]
                          placeholderImage:[UIImage imageNamed:@"piingo_cap"]];
        
        profilePicView.layer.borderColor = [[[UIColor lightGrayColor]colorWithAlphaComponent:0.5] CGColor];
        profilePicView.layer.borderWidth = 1.0;
        profilePicView.layer.cornerRadius = CGRectGetWidth(profilePicView.bounds)/2;
        profilePicView.clipsToBounds = YES;
        
        profilePicView.contentMode = UIViewContentModeScaleAspectFill;
        
        [pingoBgView addSubview:profilePicView];
        
        float lblNameX = profilePicView.frame.origin.x+profilePicView.frame.size.width+10;
        
        pingNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(lblNameX, 15*MULTIPLYHEIGHT, screen_width-lblNameX, 35*MULTIPLYHEIGHT)];
        pingNameLbl.numberOfLines = 0;
        pingNameLbl.textAlignment = NSTextAlignmentLeft;
        pingNameLbl.textColor = TEXT_COLOR;
        pingNameLbl.backgroundColor = [UIColor clearColor];
        pingNameLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
        [pingoBgView addSubview:pingNameLbl];
        
        NSString *strName;
        
        if ([self.piingoName length])
        {
            strName = [self.piingoName uppercaseString];
        }
        else
        {
            strName = @"PIINGO";
        }
        
        NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:strName];
        [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-1]} range:NSMakeRange(0, [strName length])];
        
        NSString *strRoute;
        
        NSRange range;
        
        if ([self.bookNowETAStr length])
        {
            strRoute = [[NSString stringWithFormat:@" will arrive\nbetween %@ for pick-up", self.bookNowETAStr] uppercaseString];
            range = [strRoute rangeOfString:self.bookNowETAStr];
        }
        else
        {
            strRoute = [[NSString stringWithFormat:@" will arrive\nbetween %@ for pick-up", [self.orderInfo objectForKey:ORDER_PICKUP_SLOT]] uppercaseString];
            range = [strRoute rangeOfString:[self.orderInfo objectForKey:ORDER_PICKUP_SLOT]];
        }
        
        //NSString *strRoute = [@" is en route" uppercaseString];
        
        NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:strRoute];
        
        [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4], NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:NSMakeRange(0, [strRoute length])];
        
        [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:BLUE_COLOR} range:range];
        
        [mainAttr appendAttributedString:attr1];
        
        pingNameLbl.attributedText = mainAttr;
        
        
        //ETA
        
        LblETA = [[UILabel alloc] initWithFrame:CGRectMake(120.0, pingNameLbl.frame.origin.y+pingNameLbl.frame.size.height+5, screen_width-150.0, 20)];
        LblETA.textAlignment = NSTextAlignmentLeft;
        LblETA.textColor = TEXT_COLOR;
        LblETA.backgroundColor = [UIColor clearColor];
        LblETA.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
        //[pingoBgView addSubview:LblETA];
        
        NSString *strETAName = @"ETA";
        
        NSMutableAttributedString *mainETAAttr = [[NSMutableAttributedString alloc]initWithString:strETAName];
        [mainETAAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE], NSForegroundColorAttributeName:[UIColor colorFromHexString:@"939393"]} range:NSMakeRange(0, [strETAName length])];
        
        NSString *strMins;
        
        if ([self.bookNowETAStr length])
        {
            strMins = [[NSString stringWithFormat:@" %@ mins", self.bookNowETAStr] uppercaseString];
        }
        else
        {
            //strMins = [@" 15 mins" uppercaseString];
            strMins = @"";
        }
        
        NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:strMins];
        [attr2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE], NSForegroundColorAttributeName:[UIColor colorFromHexString:@"0faee8"]} range:NSMakeRange(0, [strMins length])];
        
        [mainETAAttr appendAttributedString:attr2];
        
        LblETA.attributedText = mainETAAttr;
        
        
        view_BlurBGForBookNow = [[UIView alloc]initWithFrame:self.view.bounds];
        view_BlurBGForBookNow.backgroundColor = [UIColor blackColor];
        [self.view addSubview:view_BlurBGForBookNow];
        view_BlurBGForBookNow.alpha = 0.0;
        
        [self.view insertSubview:pingoDetailsView aboveSubview:view_BlurBGForBookNow];
        
        [self createWashTypesView];
        [self createDeliveryDetailsView];
        
        [self.view bringSubviewToFront:pingoDetailsView];
        [self.view bringSubviewToFront:closeBtn];
        [self.view bringSubviewToFront:backBtn];
        
        [self performSelector:@selector(automaticSwipeUpDetailsView) withObject:nil afterDelay:2];
        
    }
    
}


-(void) automaticSwipeUpDetailsView
{
    
    [UIView animateWithDuration:0.3 delay:2 options:0 animations:^{
        
        float piingViewX = 90*MULTIPLYHEIGHT;
        
        CGRect rectview = pingoDetailsView.frame;
        rectview.origin.y = piingViewX;
        pingoDetailsView.frame = rectview;
        
        if (view_Message)
        {
            CGRect frame = view_Message.frame;
            frame.origin.y = pingoDetailsView.frame.origin.y;
            view_Message.frame = frame;
        }
        
        view_BlurBGForBookNow.alpha = 0.7;
        //blur.alpha = 1.0;
        
        
    } completion:^(BOOL finished) {
        
        pingoDetailsView.userInteractionEnabled = YES;
        
    }];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appDel hideTabBar:appDel.customTabBarController];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}



-(void) loadOrderDetails
{
    if (view_BG && [[self.orderEditDetails objectForKey:@"trackingStatus"] intValue] == 0)
    {
        [view_BG removeFromSuperview];
        view_BG = nil;
        
        view_BG = [[UIView alloc]initWithFrame:self.view.bounds];
        view_BG.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view_BG];
    }
    
    for (id view in view_BG.subviews)
    {
        if ([view isKindOfClass:[piingoMapView class]])
        {
            
        }
        else
        {
            [view removeFromSuperview];
        }
    }
    
    
    float navHeight = 110*MULTIPLYHEIGHT;
    
    navBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screen_width, navHeight)];
    navBarView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    [view_BG addSubview:navBarView];
    
    piingoMapView.frame = CGRectMake(0.0, navHeight, screen_width, screen_height-(72*MULTIPLYHEIGHT + navHeight));
    piingoMapView.clipsToBounds = YES;
    //[piingoMapView focusMapToShowAllMarkers];
    
    float backBtnY = 31.7*MULTIPLYHEIGHT;
    
    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, backBtnY, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:backBtn];
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(screen_width - 48.0, backBtnY, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
    //[navBarView addSubview:closeBtn];
    
    if ([self.dictAllowUpdates count] && [[self.dictAllowUpdates objectForKey:@"cancel"] intValue] == 0)
    {
        closeBtn.hidden = YES;
    }
    
    float scrollHeight = 72*MULTIPLYHEIGHT;
    
    view_Bottom = [[DragView2 alloc]initWithFrame:CGRectMake(0, screen_height-scrollHeight, screen_width, screen_height)];
    view_Bottom.backgroundColor = [UIColor whiteColor];
    view_Bottom.tag = 400;
    view_Bottom.delegate = self;
    [view_BG addSubview:view_Bottom];
    
    
    
    UIView *lineHor = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 1.5f)];
    lineHor.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
    [view_Bottom addSubview:lineHor];
    
    
    float viewDatesY = 7*MULTIPLYHEIGHT;
    
    float vtHeight = 72*MULTIPLYHEIGHT;
    
    view_Tracking = [[UIView alloc]initWithFrame:CGRectMake(0, viewDatesY, screen_width, vtHeight)];
    view_Tracking.backgroundColor = [UIColor clearColor];
    [view_Bottom addSubview:view_Tracking];
    
    btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDown setBackgroundImage:[UIImage imageNamed:@"down_button"] forState:UIControlStateNormal];
    [btnDown addTarget:self action:@selector(downBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view_Tracking addSubview:btnDown];
    //btnDown.backgroundColor = [UIColor redColor];
    
    float btnSWidth = 28*MULTIPLYHEIGHT;
    
    btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setImage:[UIImage imageNamed:@"share_order_details"] forState:UIControlStateNormal];
    btnShare.backgroundColor = RGBCOLORCODE(248, 249, 250, 1.0);
    btnShare.frame = CGRectMake(screen_width-btnSWidth, 1.5, btnSWidth, vtHeight);
    btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnShare addTarget:self action:@selector(btnShareClicked) forControlEvents:UIControlEventTouchUpInside];
    [view_Bottom addSubview:btnShare];
    
    originalShareRect = btnShare.frame;
    
    
    CGFloat btnDownWidth = 25*MULTIPLYHEIGHT;
    
    btnDown.frame = CGRectMake(8*MULTIPLYHEIGHT, 6*MULTIPLYHEIGHT, btnDownWidth, btnDownWidth);
    btnDown.userInteractionEnabled = YES;
    btnDown.alpha = 0.0;
    
    
    view_Image_Text = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, vtHeight)];
    [view_Tracking addSubview:view_Image_Text];
    
    float imgHeight = 58*MULTIPLYHEIGHT;
    
    profilePicView = [[UIImageView alloc] initWithFrame:CGRectMake(15*MULTIPLYHEIGHT , 0, imgHeight, imgHeight)];
    profilePicView.backgroundColor = [UIColor clearColor];
    
    [profilePicView sd_setImageWithURL:[NSURL URLWithString:self.piingoImg]
                      placeholderImage:[UIImage imageNamed:@"piingo_cap"]];
    
    profilePicView.layer.borderColor = [[[UIColor lightGrayColor]colorWithAlphaComponent:0.5] CGColor];
    profilePicView.layer.borderWidth = 1.0;
    profilePicView.layer.cornerRadius = CGRectGetWidth(profilePicView.bounds)/2;
    profilePicView.clipsToBounds = YES;
    
    profilePicView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [view_Image_Text addSubview:profilePicView];
    
    
    lblPiingoName = [[UILabel alloc] init];
    
    lblPiingoName.frame = CGRectMake(profilePicView.frame.origin.x+profilePicView.frame.size.width+10, 10*MULTIPLYHEIGHT, (screen_width - (profilePicView.frame.origin.x+profilePicView.frame.size.width+20)), 35*MULTIPLYHEIGHT);
    
    lblPiingoName.textAlignment = NSTextAlignmentLeft;
    lblPiingoName.textColor = TEXT_COLOR;
    lblPiingoName.numberOfLines = 0;
    lblPiingoName.backgroundColor = [UIColor clearColor];
    lblPiingoName.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    lblPiingoName.text = [@"Piingo to be assigned" uppercaseString];
    [view_Image_Text addSubview:lblPiingoName];
    
    view_Image_Text.alpha = 0.0;
    
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
    
    NSString *strStatusCode = [self.orderEditDetails objectForKey:@"statusCode"];
    
    if ([strStatusCode isEqualToString:@"OB"] || [strStatusCode isEqualToString:@"OB-RS-P"])
    {
        lblPiingoName.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
        
        viewDownDates = [[UIView alloc]init];
        [view_Tracking addSubview:viewDownDates];
        
        float pickupIconHeight = 25.2*MULTIPLYHEIGHT;
        
        float pickupIconX = 8*MULTIPLYHEIGHT;
        
        UIImageView *pickupIconView = [[UIImageView alloc] initWithFrame:CGRectMake(pickupIconX, 15.0*MULTIPLYHEIGHT, pickupIconHeight, pickupIconHeight)];
        pickupIconView.image = [UIImage imageNamed:@"mywashes_pickup"];
        pickupIconView.contentMode = UIViewContentModeScaleAspectFit;
        pickupIconView.backgroundColor = [UIColor clearColor];
        [viewDownDates addSubview:pickupIconView];
        
        pickUpDateLbl = [[UILabel alloc] init];
        pickUpDateLbl.textAlignment = NSTextAlignmentCenter;
        pickUpDateLbl.textColor = TEXT_COLOR;
        pickUpDateLbl.backgroundColor = [UIColor clearColor];
        pickUpDateLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
        pickUpDateLbl.numberOfLines = 0;
        [viewDownDates addSubview:pickUpDateLbl];
        
        NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
        [dtFormatter setDateFormat:@"dd-MM-yyyy"];
        
        NSDateFormatter *toDtFormatter = [[NSDateFormatter alloc] init];
        [toDtFormatter setDateFormat:@"dd MMM"];
        
        NSString *strDate = [toDtFormatter stringFromDate:[dtFormatter dateFromString:[self.orderEditDetails objectForKey:ORDER_PICKUP_DATE]]];
        
        NSString *strPickup = [NSString stringWithFormat:@"PICKUP - %@", [[dictPickupAddress objectForKey:@"name"]uppercaseString]];
        
        NSMutableAttributedString *mainPickupAttr = [[NSMutableAttributedString alloc]initWithString:strPickup];
        [mainPickupAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]} range:NSMakeRange(0, [strPickup length])];
        
        NSString *strPickupDate = [[NSString stringWithFormat:@"\n%@", strDate]uppercaseString];
        
        NSMutableAttributedString *attrPickup1 = [[NSMutableAttributedString alloc]initWithString:strPickupDate];
        [attrPickup1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+7]} range:NSMakeRange(0, [strPickupDate length])];
        
        [mainPickupAttr appendAttributedString:attrPickup1];
        
        NSString *strPickupSlot = [NSString stringWithFormat:@"\n%@", [self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT]];
        
        NSMutableAttributedString *attrPickup2 = [[NSMutableAttributedString alloc]initWithString:strPickupSlot];
        [attrPickup2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]} range:NSMakeRange(0, [strPickupSlot length])];
        
        [mainPickupAttr appendAttributedString:attrPickup2];
        
        CGSize pickupSize = [AppDelegate getAttributedTextHeightForText:mainPickupAttr WithWidth:screen_width/2];
        
        float pickupX = pickupIconX+pickupIconHeight;
        
        pickUpDateLbl.frame = CGRectMake(pickupX, viewDatesY, pickupSize.width, pickupSize.height);
        
        pickUpDateLbl.attributedText = mainPickupAttr;
        
        
        
        UIImageView *deliveryIconView = [[UIImageView alloc] init];
        deliveryIconView.image = [UIImage imageNamed:@"mywashes_delivery"];
        deliveryIconView.contentMode = UIViewContentModeScaleAspectFit;
        deliveryIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        [viewDownDates addSubview:deliveryIconView];
        
        
        deliveryDateEstLbl = [[UILabel alloc] init];
        deliveryDateEstLbl.textAlignment = NSTextAlignmentCenter;
        deliveryDateEstLbl.textColor = TEXT_COLOR;
        deliveryDateEstLbl.backgroundColor = [UIColor clearColor];
        deliveryDateEstLbl.font = pickUpDateLbl.font;
        deliveryDateEstLbl.numberOfLines = 0;
        [viewDownDates addSubview:deliveryDateEstLbl];
        
        if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Pickup"] == NSOrderedSame)
        {
            deliveryDateEstLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
        }
        
        
        NSString *strDelivery = [NSString stringWithFormat:@"DELIVERY - %@", [[dictDeliveryAddress objectForKey:@"name"]uppercaseString]];
        
        NSMutableAttributedString *mainDeliveryAttr = [[NSMutableAttributedString alloc]initWithString:strDelivery];
        [mainDeliveryAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]} range:NSMakeRange(0, [strDelivery length])];
        
        NSString *strDropDate = [toDtFormatter stringFromDate:[dtFormatter dateFromString:[self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE]]];
        NSString *strDeliveryDate = [[NSString stringWithFormat:@"\n%@", strDropDate]uppercaseString];
        
        NSMutableAttributedString *attrDelivery1 = [[NSMutableAttributedString alloc]initWithString:strDeliveryDate];
        [attrDelivery1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+7]} range:NSMakeRange(0, [strDeliveryDate length])];
        
        [mainDeliveryAttr appendAttributedString:attrDelivery1];
        
        NSString *strDeliveySlot = [NSString stringWithFormat:@"\n%@", [self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT]];
        
        NSMutableAttributedString *attrDelivery2 = [[NSMutableAttributedString alloc]initWithString:strDeliveySlot];
        [attrDelivery2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]} range:NSMakeRange(0, [strDeliveySlot length])];
        
        [mainDeliveryAttr appendAttributedString:attrDelivery2];
        
        CGSize deliverySize = [AppDelegate getAttributedTextHeightForText:mainDeliveryAttr WithWidth:screen_width/2];
        
        float diX = screen_width/2+10*MULTIPLYHEIGHT-15*MULTIPLYHEIGHT;
        
        float deliveryX = diX+pickupIconHeight+2*MULTIPLYHEIGHT;
        
        deliveryIconView.frame = CGRectMake(diX, pickupIconView.frame.origin.y, pickupIconHeight, pickupIconHeight);
        
        deliveryDateEstLbl.frame = CGRectMake(deliveryX, viewDatesY, deliverySize.width, deliverySize.height);
        
        deliveryDateEstLbl.attributedText = mainDeliveryAttr;
        
        viewDownDates.frame = CGRectMake(0, 0, screen_width, deliverySize.height+20*MULTIPLYHEIGHT);
    }
    
    else if ([strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"AD-P"] || [strStatusCode isEqualToString:@"PO-D"] || [strStatusCode isEqualToString:@"AD-D"] || [strStatusCode isEqualToString:@"OB-RS-D"])
    {
        
        view_Image_Text.alpha = 1.0;
        
        NSString *strName;
        
        if (self.piingoName)
        {
            strName = self.piingoName;
        }
        else
        {
            strName = @"Piingo";
        }
        
        NSString *strRoute;
        
        NSRange range;
        
        NSString *strT;
        
        if ([strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"AD-P"])
        {
            strRoute = [[NSString stringWithFormat:@" will arrive\nbetween %@ for pick-up", [self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT]] uppercaseString];
            
            strT = [NSString stringWithFormat:@"%@ %@", strName, strRoute];
            
            range = [strT rangeOfString:[[self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT] uppercaseString]];
        }
        else {
            strRoute = [[NSString stringWithFormat:@" will arrive\nbetween %@ for delivery", [self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT]] uppercaseString];
            
            strT = [NSString stringWithFormat:@"%@ %@", strName, strRoute];
            
            range = [strT rangeOfString:[[self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT] uppercaseString]];
        }
        
        NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:strT];
        [mainAttr addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM]} range:NSMakeRange(0, [strName length])];
        
        [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5]} range:NSMakeRange([strName length]+1, [strRoute length])];
        
        [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:BLUE_COLOR} range:range];
        
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.alignment = NSTextAlignmentLeft;
        [paragrapStyle setLineSpacing:6.0f];
        [paragrapStyle setMaximumLineHeight:100.0f];
        
        [mainAttr addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, mainAttr.length)];
        
        lblPiingoName.attributedText = mainAttr;
    }
    
    else
    {
        
        lblPiingoName.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
        
        NSString *strName;
        
        if (self.piingoName)
        {
            strName = self.piingoName;
        }
        else
        {
            strName = @"Piingo";
        }
        
        if (![strName length])
        {
            strName = [@"Piingo"uppercaseString];
        }
        
        NSString *strText;
        
        if ([strStatusCode isEqualToString:@"OP"] || [strStatusCode isEqualToString:@"WA-REC"] || [strStatusCode isEqualToString:@"WIMZ"] || [strStatusCode isEqualToString:@"LW"] || [strStatusCode isEqualToString:@"WA-RE"] || [strStatusCode isEqualToString:@"RL"] || [strStatusCode isEqualToString:@"SL"] || [strStatusCode isEqualToString:@"RECE-L"] || [strStatusCode isEqualToString:@"WC"] || [strStatusCode isEqualToString:@"SEND-W"] || [strStatusCode isEqualToString:@"RECE-L-W"] || [strStatusCode isEqualToString:@"LIMZ"])
        {
            strText = [[NSString stringWithFormat:@"%@ has picked-up\nyour garments", strName]uppercaseString];
        }
        else if ([strStatusCode isEqualToString:@"OD"])
        {
            strText = [[[NSString stringWithFormat:@"%@ has delivered\nyour garments", strName]uppercaseString]uppercaseString];
        }
        else if ([strStatusCode isEqualToString:@"OD-PA"])
        {
            strText = [[NSString stringWithFormat:@"%@ has partially\ndelivered your garments", strName]uppercaseString];
        }
        else
        {
            strName = @"";
            strText = [@"Piingo to be assigned" uppercaseString];
            
            profilePicView.image = [UIImage imageNamed:@"piingo_cap"];
        }
        
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc]initWithString:strText];
        
        [attrText addAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1]} range:NSMakeRange(0, strName.length)];
        
        [attrText addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor], NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4]} range:NSMakeRange(strName.length, strText.length-(strName.length))];
        
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.alignment = NSTextAlignmentLeft;
        [paragrapStyle setLineSpacing:6.0f];
        [paragrapStyle setMaximumLineHeight:100.0f];
        
        [attrText addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, attrText.length)];
        
        lblPiingoName.attributedText = attrText;
        
        //        CGSize sizeLbl = [AppDelegate getAttributedTextHeightForText:attrText WithWidth:lblPiingoName.frame.size.width];
        //
        //        CGRect rectLbl = lblPiingoName.frame;
        //        rectLbl.size.height = sizeLbl.height;
        //        lblPiingoName.frame = rectLbl;
        
        viewDownDates = [[UIView alloc]init];
        [view_Tracking addSubview:viewDownDates];
        
        float pickupIconHeight = 25.2*MULTIPLYHEIGHT;
        
        float pickupIconX = 10*MULTIPLYHEIGHT;
        
        UIImageView *pickupIconView = [[UIImageView alloc] initWithFrame:CGRectMake(pickupIconX, 15.0*MULTIPLYHEIGHT, pickupIconHeight, pickupIconHeight)];
        pickupIconView.image = [UIImage imageNamed:@"mywashes_pickup"];
        pickupIconView.contentMode = UIViewContentModeScaleAspectFit;
        pickupIconView.backgroundColor = [UIColor clearColor];
        [viewDownDates addSubview:pickupIconView];
        
        pickUpDateLbl = [[UILabel alloc] init];
        pickUpDateLbl.textAlignment = NSTextAlignmentCenter;
        
        pickUpDateLbl.textColor = TEXT_COLOR;
        
        if ([strStatusCode isEqualToString:@"OD"])
        {
            pickUpDateLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
        }
        
        pickUpDateLbl.backgroundColor = [UIColor clearColor];
        pickUpDateLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
        pickUpDateLbl.numberOfLines = 0;
        [viewDownDates addSubview:pickUpDateLbl];
        
        NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
        [dtFormatter setDateFormat:@"dd-MM-yyyy"];
        
        NSDateFormatter *toDtFormatter = [[NSDateFormatter alloc] init];
        [toDtFormatter setDateFormat:@"dd MMM"];
        
        NSString *strDate = [toDtFormatter stringFromDate:[dtFormatter dateFromString:[self.orderEditDetails objectForKey:ORDER_PICKUP_DATE]]];
        
        NSString *strPickup = [NSString stringWithFormat:@"PICKUP - %@", [[dictPickupAddress objectForKey:@"name"]uppercaseString]];
        
        NSMutableAttributedString *mainPickupAttr = [[NSMutableAttributedString alloc]initWithString:strPickup];
        [mainPickupAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]} range:NSMakeRange(0, [strPickup length])];
        
        NSString *strPickupDate = [[NSString stringWithFormat:@"\n%@", strDate]uppercaseString];
        
        NSMutableAttributedString *attrPickup1 = [[NSMutableAttributedString alloc]initWithString:strPickupDate];
        [attrPickup1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+7]} range:NSMakeRange(0, [strPickupDate length])];
        
        [mainPickupAttr appendAttributedString:attrPickup1];
        
        NSString *strPickupSlot = [NSString stringWithFormat:@"\n%@", [self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT]];
        
        NSMutableAttributedString *attrPickup2 = [[NSMutableAttributedString alloc]initWithString:strPickupSlot];
        [attrPickup2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]} range:NSMakeRange(0, [strPickupSlot length])];
        
        [mainPickupAttr appendAttributedString:attrPickup2];
        
        CGSize pickupSize = [AppDelegate getAttributedTextHeightForText:mainPickupAttr WithWidth:screen_width/2];
        
        float pickupX = pickupIconX+pickupIconHeight+MULTIPLYHEIGHT;
        
        pickUpDateLbl.frame = CGRectMake(pickupX, viewDatesY, pickupSize.width, pickupSize.height);
        
        pickUpDateLbl.attributedText = mainPickupAttr;
        
        
        
        UIImageView *deliveryIconView = [[UIImageView alloc] init];
        deliveryIconView.image = [UIImage imageNamed:@"mywashes_delivery"];
        deliveryIconView.contentMode = UIViewContentModeScaleAspectFit;
        deliveryIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
        [viewDownDates addSubview:deliveryIconView];
        
        
        deliveryDateEstLbl = [[UILabel alloc] init];
        deliveryDateEstLbl.textAlignment = NSTextAlignmentCenter;
        deliveryDateEstLbl.textColor = TEXT_COLOR;
        
        if ([strStatusCode isEqualToString:@"OD"])
        {
            deliveryDateEstLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
        }
        
        deliveryDateEstLbl.backgroundColor = [UIColor clearColor];
        deliveryDateEstLbl.font = pickUpDateLbl.font;
        deliveryDateEstLbl.numberOfLines = 0;
        [viewDownDates addSubview:deliveryDateEstLbl];
        
        
        NSString *strDelivery = [NSString stringWithFormat:@"DELIVERY - %@", [[dictDeliveryAddress objectForKey:@"name"]uppercaseString]];
        
        NSMutableAttributedString *mainDeliveryAttr = [[NSMutableAttributedString alloc]initWithString:strDelivery];
        [mainDeliveryAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]} range:NSMakeRange(0, [strDelivery length])];
        
        NSString *strDropDate = [toDtFormatter stringFromDate:[dtFormatter dateFromString:[self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE]]];
        NSString *strDeliveryDate = [[NSString stringWithFormat:@"\n%@", strDropDate]uppercaseString];
        
        NSMutableAttributedString *attrDelivery1 = [[NSMutableAttributedString alloc]initWithString:strDeliveryDate];
        [attrDelivery1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+7]} range:NSMakeRange(0, [strDeliveryDate length])];
        
        [mainDeliveryAttr appendAttributedString:attrDelivery1];
        
        NSString *strDeliveySlot = [NSString stringWithFormat:@"\n%@", [self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT]];
        
        NSMutableAttributedString *attrDelivery2 = [[NSMutableAttributedString alloc]initWithString:strDeliveySlot];
        [attrDelivery2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]} range:NSMakeRange(0, [strDeliveySlot length])];
        
        [mainDeliveryAttr appendAttributedString:attrDelivery2];
        
        CGSize deliverySize = [AppDelegate getAttributedTextHeightForText:mainDeliveryAttr WithWidth:screen_width/2];
        
        
        float diX = screen_width/2+10*MULTIPLYHEIGHT-10*MULTIPLYHEIGHT;
        
        float deliveryX = diX+pickupIconHeight+2*MULTIPLYHEIGHT;
        
        deliveryIconView.frame = CGRectMake(diX, pickupIconView.frame.origin.y, pickupIconHeight, pickupIconHeight);
        
        deliveryDateEstLbl.frame = CGRectMake(deliveryX, viewDatesY, deliverySize.width, deliverySize.height);
        
        deliveryDateEstLbl.attributedText = mainDeliveryAttr;
        
        viewDownDates.frame = CGRectMake(0, 0, screen_width, deliverySize.height+20*MULTIPLYHEIGHT);
        
        if ([strStatusCode isEqualToString:@"OD"] || [strStatusCode isEqualToString:@"OD-PA"])
        {
            
        }
        else
        {
            if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Pickup"] == NSOrderedSame)
            {
                deliveryDateEstLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
            }
            
            else if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Delivery"] == NSOrderedSame)
            {
                pickUpDateLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
            }
        }
    }
    
    [view_Tracking bringSubviewToFront:btnDown];
    
    
    float yAxis = vtHeight;
    
    view_ZigZag = [[UIView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, view_Bottom.frame.size.height-yAxis)];
    [view_Bottom addSubview:view_ZigZag];
    
    yAxis = 0;
    
    UIImageView *imgZigzag = [[UIImageView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 2)];
    //imgZigzag.image = [UIImage imageNamed:@"zigzag_gray"];
    imgZigzag.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    //imgZigzag.contentMode = UIViewContentModeScaleAspectFill;
    [view_ZigZag addSubview:imgZigzag];
    
    yAxis += imgZigzag.frame.size.height+6*MULTIPLYHEIGHT;
    
    
    UILabel *lblTotalAmountText = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 15*MULTIPLYHEIGHT)];
    lblTotalAmountText.text = @"TOTAL AMOUNT";
    lblTotalAmountText.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    lblTotalAmountText.textColor = [UIColor lightGrayColor];
    lblTotalAmountText.textAlignment = NSTextAlignmentCenter;
    [view_ZigZag addSubview:lblTotalAmountText];
    
    yAxis += 15*MULTIPLYHEIGHT;
    
    float lblTAHeight = 20*MULTIPLYHEIGHT;
    
    UILabel *lblTotalAmountValue = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblTAHeight)];
    //lblTotalAmountValue.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE+5];
    lblTotalAmountValue.textColor = [UIColor colorFromHexString:@"00acec"];
    //lblTotalAmountValue.textAlignment = NSTextAlignmentCenter;
    [view_ZigZag addSubview:lblTotalAmountValue];
    
    CGSize lblTSize = CGSizeZero;
    
    if (![[self.orderEditDetails objectForKey:@"billStatus"] isEqualToString:@"NA"])
    {
        NSString *str1 = @"SGD ";
        
        NSString *strTotal = [NSString stringWithFormat:@"%@%@", str1, self.strFinalAmount];
        
        NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc]initWithString:strTotal];
        
        NSRange range = NSMakeRange(0, str1.length);
        
        [attrPrice addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE]} range:range];
        
        [attrPrice addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE+5]} range:NSMakeRange(str1.length, self.strFinalAmount.length)];
        
        lblTSize = [AppDelegate getAttributedTextHeightForText:attrPrice WithWidth:screen_width];
        
        lblTotalAmountValue.attributedText = attrPrice;
    }
    else
    {
        NSString *strPrice = @"N/A";
        lblTotalAmountValue.text = strPrice;
        
        lblTSize = [AppDelegate getLabelSizeForRegularText:lblTotalAmountValue.text WithWidth:screen_width FontSize:lblTotalAmountValue.font.pointSize];
    }
    
    CGRect rectAmount = lblTotalAmountValue.frame;
    rectAmount.size.width = lblTSize.width;
    rectAmount.origin.x = screen_width/2-lblTSize.width/2-(15*MULTIPLYHEIGHT);
    lblTotalAmountValue.frame = rectAmount;
    
    
    lblPaymentType = [[UILabel alloc]initWithFrame:CGRectMake(lblTotalAmountValue.frame.origin.x+lblTotalAmountValue.frame.size.width+10, yAxis+lblTAHeight/2-((12*MULTIPLYHEIGHT)/2), 30*MULTIPLYHEIGHT, 12*MULTIPLYHEIGHT)];
    
    if ([[self.orderEditDetails objectForKey:ORDER_CARD_ID] caseInsensitiveCompare:@"Cash"] == NSOrderedSame)
    {
        lblPaymentType.text = @"CASH";
    }
    else
    {
        lblPaymentType.text = @"CARD";
    }
    
    lblPaymentType.font = [UIFont fontWithName:APPFONT_ITALIC size:appDel.FONT_SIZE_CUSTOM-6];
    lblPaymentType.textColor = [UIColor grayColor];
    lblPaymentType.textAlignment = NSTextAlignmentCenter;
    lblPaymentType.layer.borderColor = [UIColor lightGrayColor].CGColor;
    lblPaymentType.layer.borderWidth = 1.0f;
    [view_ZigZag addSubview:lblPaymentType];
    lblPaymentType.layer.cornerRadius = 4.0;
    
    
    yAxis += lblTAHeight+30*MULTIPLYHEIGHT;
    
    
    
    UIView *viewDates = [[UIView alloc]init];
    [view_ZigZag addSubview:viewDates];
    
    float pickupIconHeight = 25.2*MULTIPLYHEIGHT;
    
    float pickupIconX = 10*MULTIPLYHEIGHT;
    
    UIImageView *pickupIconView = [[UIImageView alloc] initWithFrame:CGRectMake(pickupIconX, 15.0*MULTIPLYHEIGHT, pickupIconHeight, pickupIconHeight)];
    pickupIconView.image = [UIImage imageNamed:@"mywashes_pickup"];
    pickupIconView.contentMode = UIViewContentModeScaleAspectFit;
    pickupIconView.backgroundColor = [UIColor clearColor];
    [viewDates addSubview:pickupIconView];
    
    pickUpDateLbl = [[UILabel alloc] init];
    pickUpDateLbl.textAlignment = NSTextAlignmentCenter;
    pickUpDateLbl.textColor = TEXT_COLOR;
    
    if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Delivery"] == NSOrderedSame)
    {
        pickUpDateLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
    }
    
    pickUpDateLbl.backgroundColor = [UIColor clearColor];
    pickUpDateLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    pickUpDateLbl.numberOfLines = 0;
    [viewDates addSubview:pickUpDateLbl];
    
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDateFormatter *toDtFormatter = [[NSDateFormatter alloc] init];
    [toDtFormatter setDateFormat:@"dd MMM"];
    
    NSString *strDate = [toDtFormatter stringFromDate:[dtFormatter dateFromString:[self.orderEditDetails objectForKey:ORDER_PICKUP_DATE]]];
    
    NSString *strPickup = [NSString stringWithFormat:@"PICKUP - %@", [[dictPickupAddress objectForKey:@"name"]uppercaseString]];
    
    NSMutableAttributedString *mainPickupAttr = [[NSMutableAttributedString alloc]initWithString:strPickup];
    [mainPickupAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]} range:NSMakeRange(0, [strPickup length])];
    
    NSString *strPickupDate = [[NSString stringWithFormat:@"\n%@", strDate]uppercaseString];
    
    NSMutableAttributedString *attrPickup1 = [[NSMutableAttributedString alloc]initWithString:strPickupDate];
    [attrPickup1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+7]} range:NSMakeRange(0, [strPickupDate length])];
    
    [mainPickupAttr appendAttributedString:attrPickup1];
    
    NSString *strPickupSlot = [NSString stringWithFormat:@"\n%@", [self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT]];
    
    NSMutableAttributedString *attrPickup2 = [[NSMutableAttributedString alloc]initWithString:strPickupSlot];
    [attrPickup2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1]} range:NSMakeRange(0, [strPickupSlot length])];
    
    [mainPickupAttr appendAttributedString:attrPickup2];
    
    CGSize pickupSize = [AppDelegate getAttributedTextHeightForText:mainPickupAttr WithWidth:screen_width/2];
    
    float pickupX = pickupIconX+pickupIconHeight+MULTIPLYHEIGHT;
    
    pickUpDateLbl.frame = CGRectMake(pickupX, viewDatesY, pickupSize.width, pickupSize.height);
    
    pickUpDateLbl.attributedText = mainPickupAttr;
    
    
    
    UIImageView *deliveryIconView = [[UIImageView alloc] init];
    deliveryIconView.image = [UIImage imageNamed:@"mywashes_delivery"];
    deliveryIconView.contentMode = UIViewContentModeScaleAspectFit;
    deliveryIconView.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
    [viewDates addSubview:deliveryIconView];
    
    
    deliveryDateEstLbl = [[UILabel alloc] init];
    deliveryDateEstLbl.textAlignment = NSTextAlignmentCenter;
    
    deliveryDateEstLbl.textColor = TEXT_COLOR;
    
    if ([[self.orderEditDetails objectForKey:@"direction"] caseInsensitiveCompare:@"Pickup"] == NSOrderedSame)
    {
        deliveryDateEstLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
    }
    
    else if ([strStatusCode isEqualToString:@"OD"])
    {
        deliveryDateEstLbl.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
    }
    
    deliveryDateEstLbl.backgroundColor = [UIColor clearColor];
    deliveryDateEstLbl.font = pickUpDateLbl.font;
    deliveryDateEstLbl.numberOfLines = 0;
    [viewDates addSubview:deliveryDateEstLbl];
    
    
    NSString *strDelivery = [NSString stringWithFormat:@"DELIVERY - %@", [[dictDeliveryAddress objectForKey:@"name"]uppercaseString]];
    
    NSMutableAttributedString *mainDeliveryAttr = [[NSMutableAttributedString alloc]initWithString:strDelivery];
    [mainDeliveryAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]} range:NSMakeRange(0, [strDelivery length])];
    
    NSString *strDropDate = [toDtFormatter stringFromDate:[dtFormatter dateFromString:[self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE]]];
    NSString *strDeliveryDate = [[NSString stringWithFormat:@"\n%@", strDropDate]uppercaseString];
    
    NSMutableAttributedString *attrDelivery1 = [[NSMutableAttributedString alloc]initWithString:strDeliveryDate];
    [attrDelivery1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+7]} range:NSMakeRange(0, [strDeliveryDate length])];
    
    [mainDeliveryAttr appendAttributedString:attrDelivery1];
    
    NSString *strDeliveySlot = [NSString stringWithFormat:@"\n%@", [self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT]];
    
    NSMutableAttributedString *attrDelivery2 = [[NSMutableAttributedString alloc]initWithString:strDeliveySlot];
    [attrDelivery2 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]} range:NSMakeRange(0, [strDeliveySlot length])];
    
    [mainDeliveryAttr appendAttributedString:attrDelivery2];
    
    CGSize deliverySize = [AppDelegate getAttributedTextHeightForText:mainDeliveryAttr WithWidth:screen_width/2];
    
    float diX = screen_width/2+10*MULTIPLYHEIGHT;
    
    float deliveryX = diX+pickupIconHeight+2*MULTIPLYHEIGHT;
    
    deliveryIconView.frame = CGRectMake(diX, pickupIconView.frame.origin.y, pickupIconHeight, pickupIconHeight);
    
    deliveryDateEstLbl.frame = CGRectMake(deliveryX, viewDatesY, deliverySize.width, deliverySize.height);
    
    deliveryDateEstLbl.attributedText = mainDeliveryAttr;
    
    viewDates.frame = CGRectMake(0, yAxis, screen_width, deliverySize.height+20*MULTIPLYHEIGHT);
    
    yAxis += viewDates.frame.size.height+15*MULTIPLYHEIGHT;
    
    NSMutableArray *arrayWashTypes = [[NSMutableArray alloc]init];
    
    NSArray *arrayServiceTypes = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
    
    if ([arrayServiceTypes containsObject:SERVICETYPE_WF])
    {
        [arrayWashTypes addObject:@"LOAD WASH"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_WI])
    {
        [arrayWashTypes addObject:@"WASH & IRON"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_IR])
    {
        [arrayWashTypes addObject:@"IRONING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_DC])
    {
        [arrayWashTypes addObject:@"DRY CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_DCG])
    {
        [arrayWashTypes addObject:@"GREEN DRY CLEANING"];
    }
//    if ([arrayServiceTypes containsObject:@"HL_DC"])
//    {
//        [arrayWashTypes addObject:@"HOME LINEN - DRY CLEANING"];
//    }
//    if ([arrayServiceTypes containsObject:@"HL_DCG"])
//    {
//        [arrayWashTypes addObject:@"HOME LINEN - GREEN DRY CLEANING"];
//    }
//    if ([arrayServiceTypes containsObject:@"HL_WI"])
//    {
//        [arrayWashTypes addObject:@"HOME LINEN - WASH & IRON"];
//    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_LE])
    {
        [arrayWashTypes addObject:@"LEATHER CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CA])
    {
        [arrayWashTypes addObject:@"CARPET CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_W_DC])
    {
        [arrayWashTypes addObject:@"CURTAINS WITH INSTALLATION - DRY CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_DC])
    {
        [arrayWashTypes addObject:@"CURTAINS WITHOUT INSTALLATION - DRY CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_WI])
    {
        [arrayWashTypes addObject:@"CURTAINS WITHOUT INSTALLATION - WASH & IRON"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_W_WI])
    {
        [arrayWashTypes addObject:@"CURTAINS WITH INSTALLATION - WASH & IRON"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_BAG])
    {
        [arrayWashTypes addObject:@"BAGS CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_SHOE_CLEAN])
    {
        [arrayWashTypes addObject:@"SHOE CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_SHOE_POLISH])
    {
        [arrayWashTypes addObject:@"SHOE POLISH"];
    }
    
    float lblWTHeight = 26*MULTIPLYHEIGHT;
    
    int xAxisWT = 20*MULTIPLYHEIGHT;
    
    view_WashTypes = [[UIScrollView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblWTHeight)];
    view_WashTypes.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    [view_ZigZag addSubview:view_WashTypes];
    view_WashTypes.delegate = self;
    
    
    for (int i=0; i<[arrayWashTypes count]; i++)
    {
        UILabel *lblWashTypes = [[UILabel alloc] init];
        lblWashTypes.textAlignment = NSTextAlignmentCenter;
        lblWashTypes.text = [arrayWashTypes objectAtIndex:i];
        
        lblWashTypes.textColor = [UIColor grayColor];
        
        if ([strStatusCode isEqualToString:@"OD"])
        {
            lblWashTypes.textColor = [UIColor lightGrayColor];
        }
        
        //lblWashTypes.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
        lblWashTypes.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
        [view_WashTypes addSubview:lblWashTypes];
        
        NSString *strType = [arrayWashTypes objectAtIndex:i];
        
        CGSize size = [AppDelegate getLabelSizeForRegularText:strType WithWidth:screen_width FontSize:lblWashTypes.font.pointSize];
        lblWashTypes.frame = CGRectMake(xAxisWT, 0, size.width, lblWTHeight);
        
        
        xAxisWT += size.width+20*MULTIPLYHEIGHT;
    }
    
    view_WashTypes.contentSize = CGSizeMake(xAxisWT+10*MULTIPLYHEIGHT, view_WashTypes.frame.size.height);
    
    float btnAWidth = 25*MULTIPLYHEIGHT;
    
    btnArrowType = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArrowType.frame = CGRectMake((screen_width-btnAWidth)+5*MULTIPLYHEIGHT, view_WashTypes.frame.origin.y, btnAWidth, view_WashTypes.frame.size.height);
    //btnArrowType.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnArrowType setImage:[UIImage imageNamed:@"right_arrow1"] forState:UIControlStateNormal];
    btnArrowType.backgroundColor = view_WashTypes.backgroundColor;
    [view_ZigZag addSubview:btnArrowType];
    
    if (view_WashTypes.contentSize.width < view_WashTypes.frame.size.width)
    {
        btnArrowType.hidden = YES;
    }
    
    yAxis += lblWTHeight+20*MULTIPLYHEIGHT;;
    
    float bvHeight = 60*MULTIPLYHEIGHT;
    
    float btnWidth = screen_width/3-(10*MULTIPLYHEIGHT);
    
    bottomViewForOrder = [[UIScrollView alloc]initWithFrame:CGRectMake(screen_width/2-((btnWidth*3)/2), yAxis, btnWidth*3, bvHeight)];
    bottomViewForOrder.delegate = self;
    bottomViewForOrder.backgroundColor = [UIColor clearColor];
    [view_ZigZag addSubview:bottomViewForOrder];
    
    
    float btnHeight = bvHeight;
    float xPos = 0;
    
    NSArray *normalIcons;
    
    if ([[self.orderEditDetails objectForKey:@"deliverAtDoor"] intValue] == 0)
    {
        normalIcons = [NSArray arrayWithObjects:@"orderupdate.png", @"viewbill.png", @"preferences_details", @"dropatdoor.png",nil];
    }
    else
    {
        normalIcons = [NSArray arrayWithObjects:@"orderupdate.png", @"viewbill.png", @"dropatdoor.png", @"preferences_details", nil];
    }
    
    for (int i=0; i<4; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(xPos, 1, btnWidth, btnHeight);
        [btn setImage:[UIImage imageNamed:[normalIcons objectAtIndex:i]] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [btn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [btn setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
        
        btn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
        
        if (i == 0) {
            
            [btn addTarget:self action:@selector(editOrder:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"UPDATE ORDER" forState:UIControlStateNormal];
            
            if ([strStatusCode isEqualToString:@"OD"])
            {
                //btn.enabled = NO;
                btn.alpha = 0.5;
            }
        }
        else if (i == 1) {
            
            [btn addTarget:self action:@selector(showBill:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([[self.orderEditDetails objectForKey:@"billStatus"] caseInsensitiveCompare:@"NA"] == NSOrderedSame)
            {
                [btn setTitle:@"ESTIMATE BILL" forState:UIControlStateNormal];
            }
            else
            {
                [btn setTitle:@"VIEW BILL" forState:UIControlStateNormal];
            }
        }
        else if (i == 2)
        {
            if ([[self.orderEditDetails objectForKey:@"deliverAtDoor"] intValue] == 1)
            {
                btn.selected = YES;
                
                [btn addTarget:self action:@selector(dropAtDoor:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"DELIVER AT DOOR" forState:UIControlStateNormal];
            }
            else
            {
                [btn addTarget:self action:@selector(preferencesClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [btn setTitle:@"PREFERENCES" forState:UIControlStateNormal];
            }
        }
        else if (i == 3)
        {
            if ([[self.orderEditDetails objectForKey:@"deliverAtDoor"] intValue] == 0)
            {
                //[btn setTitleColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
                //btn.enabled = NO;
                
                [btn addTarget:self action:@selector(dropAtDoor:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTitle:@"DELIVER AT DOOR" forState:UIControlStateNormal];
            }
            else
            {
                [btn addTarget:self action:@selector(preferencesClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [btn setTitle:@"PREFERENCES" forState:UIControlStateNormal];
            }
        }
        
        [bottomViewForOrder addSubview:btn];
        
        [btn centerImageAndTitle:10*MULTIPLYHEIGHT];
        
        xPos += btnWidth;
        
        if (i == 3)
        {
            
        }
        else
        {
            UIImageView *imgLine = [[UIImageView alloc]init];
            imgLine.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
            imgLine.frame = CGRectMake(xPos, 10*MULTIPLYHEIGHT, 1, 22*MULTIPLYHEIGHT);
            [bottomViewForOrder addSubview:imgLine];
        }
    }
    
    bottomViewForOrder.contentSize = CGSizeMake(xPos+15*MULTIPLYHEIGHT, bottomViewForOrder.frame.size.height);
    
    btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArrow.frame = CGRectMake(screen_width-btnAWidth, bottomViewForOrder.frame.origin.y, btnAWidth, bottomViewForOrder.frame.size.height-15*MULTIPLYHEIGHT);
    //btnArrow.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnArrow setImage:[UIImage imageNamed:@"right_arrow1"] forState:UIControlStateNormal];
    btnArrow.backgroundColor = [UIColor whiteColor];
    [view_ZigZag addSubview:btnArrow];
    
    
    yAxis += bvHeight+20*MULTIPLYHEIGHT;
    
    
    float btnCancelX = 30*MULTIPLYHEIGHT;
    
    float btnCancelHeight = 25*MULTIPLYHEIGHT;
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.frame = CGRectMake(btnCancelX, yAxis, screen_width - (btnCancelX*2), btnCancelHeight);
    btnCancel.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:104.0/255.0 blue:114.0/255.0 alpha:1.0];
    [btnCancel setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"cancel order" uppercaseString] andWithColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] andFont:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1]] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
    [view_ZigZag addSubview:btnCancel];
    [btnCancel setBackgroundImage:[AppDelegate imageWithColor:[UIColor colorFromHexString:@"fc3743"]] forState:UIControlStateHighlighted];
    btnCancel.layer.cornerRadius = 15.0;
    btnCancel.clipsToBounds = YES;
    
    
    if ([self.dictAllowUpdates count] && [[self.dictAllowUpdates objectForKey:@"cancel"] intValue] == 0)
    {
        btnCancel.alpha = 0.2;
        btnCancel.enabled = NO;
    }
    
    
    imgArrow = [[UIImageView alloc]init];
    imgArrow.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
    imgArrow.layer.cornerRadius = 2.7;
    imgArrow.layer.masksToBounds = YES;
    imgArrow.frame = CGRectMake(screen_width/2-(40/2), 5, 40, 5);
    [view_Bottom addSubview:imgArrow];
    
    
    [appDel applyBlurEffectForView:navBarView Style:BLUR_EFFECT_STYLE_LIGHT];
    
    orderTrackingView = [[UIView alloc] initWithFrame:CGRectMake(60.0, 20, screen_width-80*MULTIPLYHEIGHT, navBarView.frame.size.height-20)];
    //orderTrackingView.backgroundColor = [UIColor redColor];
    [navBarView addSubview:orderTrackingView];
    
    //[navBarView insertSubview:closeBtn aboveSubview:orderTrackingView];
    [navBarView insertSubview:backBtn aboveSubview:orderTrackingView];
    
    btnWidth = orderTrackingView.frame.size.width/7;
    btnHeight = orderTrackingView.frame.size.width/7;
    
    xPos = 0;
    
    NSMutableDictionary *dictStatuses = [[NSMutableDictionary alloc]init];
    
    [dictStatuses setObject:@"order_placed" forKey:@"OB"];
    [dictStatuses setObject:@"order_placed" forKey:@"OB-RS-P"];
    
    [dictStatuses setObject:@"out_for_pickup" forKey:@"PO-P"];
    [dictStatuses setObject:@"out_for_pickup" forKey:@"AD-P"];
    
    [dictStatuses setObject:@"garments_pickedup" forKey:@"OP"];
    [dictStatuses setObject:@"garments_pickedup" forKey:@"WA-RE"];
    [dictStatuses setObject:@"garments_pickedup" forKey:@"WA-REC"];
    [dictStatuses setObject:@"garments_pickedup" forKey:@"WIMZ"];
    [dictStatuses setObject:@"garments_pickedup" forKey:@"RL"];
    
    [dictStatuses setObject:@"washing_in_progress" forKey:@"LW"];
    [dictStatuses setObject:@"washing_in_progress" forKey:@"SL"];
    [dictStatuses setObject:@"washing_in_progress" forKey:@"RECE-L"];
    [dictStatuses setObject:@"washing_in_progress" forKey:@"WC"];
    [dictStatuses setObject:@"washing_in_progress" forKey:@"SEND-W"];
    [dictStatuses setObject:@"washing_in_progress" forKey:@"LIMZ"];
    
    [dictStatuses setObject:@"ready_for_delivery" forKey:@"RECE-L-W"];
   
    [dictStatuses setObject:@"out_for_delivery" forKey:@"PO-D"];
    [dictStatuses setObject:@"out_for_delivery" forKey:@"AD-D"];
    [dictStatuses setObject:@"out_for_delivery" forKey:@"OB-RS-D"];
    
    [dictStatuses setObject:@"delivered" forKey:@"OD"];
    
    [dictStatuses setObject:@"partially_delivered" forKey:@"OD-PA"];
    
    [dictStatuses setObject:@"pick_failed" forKey:@"PF"];
    
    [dictStatuses setObject:@"delivery_failed" forKey:@"DF"];
    
    UILabel *lblGifText;
    
    if ([[self.orderEditDetails objectForKey:@"trackingStatus"] intValue] == 0)
    {
        NSString *thePath;
        
        if ([dictStatuses objectForKey:strStatusCode])
        {
            thePath = [[NSBundle mainBundle] pathForResource:[dictStatuses objectForKey:strStatusCode] ofType:@"mp4"];
        }
        else
        {
           // [appDel showAlertWithMessage:@"Proper status code not coming from server" andTitle:@"" andBtnTitle:@"OK"];
            
            thePath = [[NSBundle mainBundle] pathForResource:[dictStatuses objectForKey:@"OB"] ofType:@"mp4"];
        }
        
        NSURL *theurl = [NSURL fileURLWithPath:thePath];
        
        if (self.backGroundplayer)
        {
            [self.backGroundplayer.view removeFromSuperview];
            self.backGroundplayer = NULL;
        }
        
        self.backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
        
        NSString *strText = [self.orderEditDetails objectForKey:@"displayMessage"];
        
        strText = [strText stringByReplacingOccurrencesOfString:@"^^" withString:@"\n"];
        strText = [strText stringByReplacingOccurrencesOfString:@"~~" withString:@"'"];
        
        float bgImgHeight = 130*MULTIPLYHEIGHT;
        
        self.backGroundplayer.view.frame = CGRectMake(0, screen_height/2-(bgImgHeight/2), screen_width, bgImgHeight);
        
        if (appDel.isAfterBookingOrder)
        {
            appDel.isAfterBookingOrder = NO;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo) name:@"PlayVideo" object:nil];
        }
        else
        {
            [self playVideo];
        }
        
        lblGifText = [[UILabel alloc]init];
        lblGifText.text = strText;
        lblGifText.numberOfLines = 0;
        lblGifText.textAlignment = NSTextAlignmentCenter;
        lblGifText.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
        lblGifText.textColor = [UIColor darkGrayColor];
        [view_BG addSubview:lblGifText];
        
        [view_BG bringSubviewToFront:view_Bottom];
        
    }
    
    
    if ([strStatusCode isEqualToString:@"PF"] || [strStatusCode isEqualToString:@"DF"])
    {
        btn_UpdateOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_UpdateOrder.backgroundColor = [UIColor clearColor];
        [view_BG addSubview:btn_UpdateOrder];
        //[view_BG insertSubview:btn_UpdateOrder belowSubview:view_Bottom];
        
        btn_UpdateOrder.layer.borderWidth = 1.0;
        btn_UpdateOrder.layer.borderColor = [RGBCOLORCODE(200, 200, 200, 1.0) CGColor];
        
        float viewX = 80*MULTIPLYHEIGHT;
        float viewMHeight = 25*MULTIPLYHEIGHT;
        
        [view_BG bringSubviewToFront:view_Bottom];
        btn_UpdateOrder.frame = CGRectMake(viewX, view_Bottom.frame.origin.y, screen_width-(viewX*2), viewMHeight);
        
        [btn_UpdateOrder addTarget:self action:@selector(editOrder:) forControlEvents:UIControlEventTouchUpInside];
        [btn_UpdateOrder setTitle:@"RESCHEDULE ORDER" forState:UIControlStateNormal];
        [btn_UpdateOrder setTitleColor:RGBCOLORCODE(200, 200, 200, 1.0) forState:UIControlStateNormal];
        btn_UpdateOrder.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-4];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
                
                CGRect frame = btn_UpdateOrder.frame;
                frame.origin.y -= viewMHeight+30*MULTIPLYHEIGHT;
                btn_UpdateOrder.frame = frame;
                
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
    }
    else if ([strStatusCode isEqualToString:@"OD-PA"])
    {
        btn_UpdateOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        btn_UpdateOrder.backgroundColor = [UIColor clearColor];
        [view_BG addSubview:btn_UpdateOrder];
        //[view_BG insertSubview:btn_UpdateOrder belowSubview:view_Bottom];
        
        btn_UpdateOrder.layer.borderWidth = 1.0;
        btn_UpdateOrder.layer.borderColor = [RGBCOLORCODE(200, 200, 200, 1.0) CGColor];
        
        float viewX = 40*MULTIPLYHEIGHT;
        float viewMHeight = 25*MULTIPLYHEIGHT;
        
        [view_BG bringSubviewToFront:view_Bottom];
        btn_UpdateOrder.frame = CGRectMake(viewX, view_Bottom.frame.origin.y, screen_width-(viewX*2), viewMHeight);
        
        [btn_UpdateOrder addTarget:self action:@selector(partialOrRewashScreen) forControlEvents:UIControlEventTouchUpInside];
        [btn_UpdateOrder setTitle:@"UNDELIVERED/REWASH GARMENTS" forState:UIControlStateNormal];
        [btn_UpdateOrder setTitleColor:RGBCOLORCODE(200, 200, 200, 1.0) forState:UIControlStateNormal];
        btn_UpdateOrder.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-4];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
                
                CGRect frame = btn_UpdateOrder.frame;
                frame.origin.y -= viewMHeight+30*MULTIPLYHEIGHT;
                btn_UpdateOrder.frame = frame;
                
                
            } completion:^(BOOL finished) {
                
            }];
            
        }];
    }
    
    
    NSArray *normalStatusIcons = [NSArray arrayWithObjects:@"track_grey_1", @"track_line_grey", @"track_grey_2", @"track_line_grey", @"track_grey_3", @"track_line_grey", @"track_grey_4", nil];
    
    NSArray *selectionStatusIcons = [NSArray arrayWithObjects:@"track_blue_1", @"track_line_blue", @"track_blue_2", @"track_line_blue", @"track_blue_3",@"track_line_blue",  @"track_blue_4",nil];
    
    //NSInteger CountStatus = [arrayStatusCode indexOfObject:strStatusCode]+1;
    
    float topY = 18*MULTIPLYHEIGHT;
    
    float minus = 4*MULTIPLYHEIGHT;
    
    NSInteger someCount = 0;
    
    for (int i=0; i<[normalStatusIcons count]; i++) {
        
        UIImageView *btn = [[UIImageView alloc]init];
        btn.frame =  CGRectMake(btnWidth * i, topY, btnWidth, btnHeight);
        btn.contentMode = UIViewContentModeScaleAspectFit;
        btn.image = [UIImage imageNamed:[normalStatusIcons objectAtIndex:i]];
        btn.backgroundColor = [UIColor clearColor];
        btn.highlightedImage = [UIImage imageNamed:[selectionStatusIcons objectAtIndex:i]];
        [orderTrackingView addSubview:btn];
        btn.tag = i+1;
        
        if (i == 0 && ([strStatusCode isEqualToString:@"OB"] || [strStatusCode isEqualToString:@"OB-RS-P"]))
        {
            someCount++;
            btn.highlighted = YES;
            btn.frame =  CGRectMake(btnWidth * i-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
        }
        else if (i == 1 && ([strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"AD-P"] || [strStatusCode isEqualToString:@"PF"]))
        {
            for (int j = 0; j < i; j++)
            {
                UIImageView *btn1 = (UIImageView *) [orderTrackingView viewWithTag:j+1];
                btn1.highlighted = YES;
                btn1.frame =  CGRectMake(btnWidth * j-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
            }
            
            someCount++;
            btn.highlighted = YES;
            btn.frame =  CGRectMake(btnWidth * i, topY-minus, btnWidth, btnHeight+((minus*2)));
        }
        else if (i == 2 && ([strStatusCode isEqualToString:@"OP"]))
        {
            for (int j = 0; j < i; j++)
            {
                UIImageView *btn1 = (UIImageView *) [orderTrackingView viewWithTag:j+1];
                btn1.highlighted = YES;
                btn1.frame =  CGRectMake(btnWidth * j-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
            }
            
            someCount++;
            btn.highlighted = YES;
            btn.frame =  CGRectMake(btnWidth * i-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
        }
        else if (i == 3 && ([strStatusCode isEqualToString:@"WA-RE"] || [strStatusCode isEqualToString:@"WA-REC"] || [strStatusCode isEqualToString:@"WIMZ"] || [strStatusCode isEqualToString:@"RL"]))
        {
            for (int j = 0; j < i; j++)
            {
                UIImageView *btn1 = (UIImageView *) [orderTrackingView viewWithTag:j+1];
                btn1.highlighted = YES;
                btn1.frame =  CGRectMake(btnWidth * j-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
            }
            
            someCount++;
            btn.highlighted = YES;
            btn.frame =  CGRectMake(btnWidth * i, topY-minus, btnWidth, btnHeight+((minus*2)));
        }
        else if (i == 4 && ([strStatusCode isEqualToString:@"LW"] || [strStatusCode isEqualToString:@"SL"] || [strStatusCode isEqualToString:@"RECE-L"] || [strStatusCode isEqualToString:@"WC"] || [strStatusCode isEqualToString:@"LIMZ"] || [strStatusCode isEqualToString:@"SEND-W"]))
        {
            for (int j = 0; j < i; j++)
            {
                UIImageView *btn1 = (UIImageView *) [orderTrackingView viewWithTag:j+1];
                btn1.highlighted = YES;
                btn1.frame =  CGRectMake(btnWidth * j-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
            }
            
            someCount++;
            btn.highlighted = YES;
            btn.frame =  CGRectMake(btnWidth * i-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
        }
        else if (i == 5 && ([strStatusCode isEqualToString:@"RECE-L-W"] || [strStatusCode isEqualToString:@"PO-D"] || [strStatusCode isEqualToString:@"DF"] || [strStatusCode isEqualToString:@"AD-D"] || [strStatusCode isEqualToString:@"OB-RS-D"]))
        {
            for (int j = 0; j < i; j++)
            {
                UIImageView *btn1 = (UIImageView *) [orderTrackingView viewWithTag:j+1];
                btn1.highlighted = YES;
                btn1.frame =  CGRectMake(btnWidth * j-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
            }
            
            someCount++;
            btn.highlighted = YES;
            btn.frame =  CGRectMake(btnWidth * i, topY-minus, btnWidth, btnHeight+((minus*2)));
        }
        else if (i == 6 && ([strStatusCode isEqualToString:@"OD"] || [strStatusCode isEqualToString:@"OD-PA"]))
        {
            for (int j = 0; j < i; j++)
            {
                UIImageView *btn1 = (UIImageView *) [orderTrackingView viewWithTag:j+1];
                btn1.highlighted = YES;
                btn1.frame =  CGRectMake(btnWidth * j-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
            }
            
            someCount++;
            btn.highlighted = YES;
            btn.frame =  CGRectMake(btnWidth * i-minus, topY-minus, btnWidth+(minus*2), btnHeight+((minus*2)));
        }
        
        if (someCount > i)
        {
            [orderTrackingView sendSubviewToBack:btn];
        }
        
        someCount++;
    }
    
    topY += btnHeight+10*MULTIPLYHEIGHT;
    
    trackStatusLbl = [[UILabel alloc] initWithFrame:CGRectMake(-CGRectGetMinX(orderTrackingView.frame), topY, screen_width, 18*MULTIPLYHEIGHT)];
    //trackStatusLbl.text = [self.orderEditDetails objectForKey:@"statusMsg"];
    trackStatusLbl.textAlignment = NSTextAlignmentCenter;
    trackStatusLbl.textColor = BLUE_COLOR;
    trackStatusLbl.backgroundColor = [UIColor clearColor];
    trackStatusLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2];
    [orderTrackingView addSubview:trackStatusLbl];
    
    topY += trackStatusLbl.frame.size.height+2*MULTIPLYHEIGHT;
    
    UILabel *lblOrderNo = [[UILabel alloc] initWithFrame:CGRectMake(-CGRectGetMinX(orderTrackingView.frame), topY, screen_width, 18*MULTIPLYHEIGHT)];
    lblOrderNo.text = [NSString stringWithFormat:@"ORDER ID # %@", [self.orderEditDetails objectForKey:@"oid"]];
    lblOrderNo.textAlignment = NSTextAlignmentCenter;
    lblOrderNo.textColor = [UIColor lightGrayColor];
    lblOrderNo.backgroundColor = [UIColor clearColor];
    lblOrderNo.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    [orderTrackingView addSubview:lblOrderNo];
    
    NSString *strGifMsg = @"";
    
    if ([strStatusCode isEqualToString:@"OB"] || [strStatusCode isEqualToString:@"OB-RS-P"])
    {
        trackStatusLbl.text = @"Order booked";
        
        //strGifMsg = @"Now, all that's left to\ndo is a TV-series in Netflix and chill.";
        
        strGifMsg = @"Now, all that's left to\ndo is Netflix and chill.";
    }
    else if ([strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"AD-P"])
    {
        trackStatusLbl.text = @"Out for pickup";
        
        strGifMsg = @"Sit back, relax and\nsip on a cuppa. We got this for you.";
    }
    else if ([strStatusCode isEqualToString:@"OP"] || [strStatusCode isEqualToString:@"WA-RE"] || [strStatusCode isEqualToString:@"WA-REC"] || [strStatusCode isEqualToString:@"WIMZ"] || [strStatusCode isEqualToString:@"RL"])
    {
        trackStatusLbl.text = @"Garments pickedup";
        
        strGifMsg = @"Wohoo! Now that a load has been\ntaken off, go Instagram your free time!";
    }
    else if ([strStatusCode isEqualToString:@"LW"] || [strStatusCode isEqualToString:@"SL"] || [strStatusCode isEqualToString:@"RECE-L"] || [strStatusCode isEqualToString:@"WC"] || [strStatusCode isEqualToString:@"SEND-W"] || [strStatusCode isEqualToString:@"LIMZ"])
    {
        trackStatusLbl.text = @"Washing in progress";
        
        strGifMsg = @"While we are having 'loads'\nof fun, you can shop till you drop.";
    }
    else if ([strStatusCode isEqualToString:@"RECE-L-W"])
    {
        trackStatusLbl.text = @"Ready for delivery";
        
        strGifMsg = @"Go catch a Friends rerun,\nwe'll be there before you know it!";
    }
    else if ([strStatusCode isEqualToString:@"PO-D"] || [strStatusCode isEqualToString:@"AD-D"] || [strStatusCode isEqualToString:@"OB-RS-D"])
    {
        trackStatusLbl.text = @"Out for delivery";
        
        strGifMsg = @"Go catch a Friends rerun,\nwe'll be there before you know it!";
    }
    else if ([strStatusCode isEqualToString:@"OD"])
    {
        trackStatusLbl.text = @"Delivered";
        
        strGifMsg = @"Hope we helped you chill a little.\nSpread the joy!";
    }
    else if ([strStatusCode isEqualToString:@"PF"])
    {
        trackStatusLbl.text = @"Pickup attempt failed";
        
        strGifMsg = @"Oops! We could’t reach you to\ncomplete your pick-up. Let’s reschedule!";
    }
    else if ([strStatusCode isEqualToString:@"DF"])
    {
        trackStatusLbl.text = @"Delivery attempt failed";
        
        strGifMsg = @"Oops! We could’t reach you\nto complete your delivery. Let’s reschedule!";
    }
    else if ([strStatusCode isEqualToString:@"OD-PA"])
    {
        trackStatusLbl.text = @"Partially delivered";
        
        strGifMsg = @"Some of your fabrics need extra care & time.\nWe'll have them ready for you real soon!";
    }
    
    NSString *strSta = [trackStatusLbl.text uppercaseString];
    
    trackStatusLbl.text = strSta;
    
    if (lblGifText)
    {
        lblGifText.text = strGifMsg;
        
        float lGX = 40*MULTIPLYHEIGHT;
        
        CGFloat height = [AppDelegate getLabelHeightForRegularText:strGifMsg WithWidth:screen_width-(lGX*2) FontSize:lblGifText.font.pointSize];
        
        lblGifText.frame = CGRectMake(0, self.backGroundplayer.view.frame.origin.y+self.backGroundplayer.view.frame.size.height+MULTIPLYHEIGHT, screen_width, height);
    }
    
    
    if (appDel.openBillAuto)
    {
        appDel.openBillAuto = NO;
        
        lblPiingoName.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Bottom.frame;
            frame.origin.y = 20;
            view_Bottom.frame = frame;
            
        } completion:^(BOOL finished) {
            
            isViewAtTop = YES;
            [self changeViewTrackingframe];
            
            [self showBill:nil];
            
        }];
        
        [self changeAnimationDidComplete];
    }
}

-(void) callPreviewAction:(NSString *) strActionType
{
    if ([strActionType isEqualToString:@"Update order"])
    {
        lblPiingoName.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Bottom.frame;
            frame.origin.y = 20;
            view_Bottom.frame = frame;
            
        } completion:^(BOOL finished) {
            
            isViewAtTop = YES;
            [self changeViewTrackingframe];
            
            [self editOrder:nil];
            
        }];
        
        [self changeAnimationDidComplete];
    }
    else if ([strActionType isEqualToString:@"View bill"])
    {
        lblPiingoName.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Bottom.frame;
            frame.origin.y = 20;
            view_Bottom.frame = frame;
            
        } completion:^(BOOL finished) {
            
            isViewAtTop = YES;
            [self changeViewTrackingframe];
            
            [self showBill:nil];
            
        }];
        
        [self changeAnimationDidComplete];
    }
    else if ([strActionType isEqualToString:@"Preferences"])
    {
        lblPiingoName.alpha = 0.0;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Bottom.frame;
            frame.origin.y = 20;
            view_Bottom.frame = frame;
            
        } completion:^(BOOL finished) {
            
            isViewAtTop = YES;
            [self changeViewTrackingframe];
            
            [self preferencesClicked:nil];
            
        }];
        
        [self changeAnimationDidComplete];
    }
}

-(void) partialOrRewashScreen
{
    PartialAndRewashViewController *objPar = [[PartialAndRewashViewController alloc]init];
    objPar.strCobID = [self.orderEditDetails objectForKey:@"oid"];
    objPar.strUserId = [self.orderEditDetails objectForKey:@"uid"];
    [self presentViewController:objPar animated:YES completion:nil];
}


-(void) btnShareClicked
{
    [appDel applyCustomBlurEffetForView:self.view WithBlurRadius:5];
    
    blurEffect = [self.view viewWithTag:98765];
    blurEffect.alpha = 0.0;
    //blurEffect.dynamic = YES;
    
    [FXBlurView setUpdatesDisabled];
    
    view_Share = [[UIView alloc]initWithFrame:self.view.bounds];
    view_Share.alpha = 0.0;
    view_Share.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [self.view addSubview:view_Share];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnCloseClicked)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view_Share addGestureRecognizer:tap];
    
    
    view_UnderShare = [[UIView alloc]init];
    view_UnderShare.frame = view_Share.frame;
    view_UnderShare.backgroundColor = [UIColor clearColor];
    [view_Share addSubview:view_UnderShare];
    
    
    float vdx = 13*MULTIPLYHEIGHT;
    
    UIView *view_details = [[UIView alloc]init];
    view_details.frame = CGRectMake(vdx, 0, screen_width-(vdx*2), 200);
    view_details.backgroundColor = [UIColor whiteColor];
    [view_UnderShare addSubview:view_details];
    
    
    CGFloat yAxis = 16*MULTIPLYHEIGHT;
    
    float lblHeight = 20*MULTIPLYHEIGHT;
    
    UILabel *lblShare = [[UILabel alloc]init];
    lblShare.frame = CGRectMake(0, yAxis, view_details.frame.size.width, lblHeight);
    
    NSMutableAttributedString *strAttrSha = [appDel getAttributedStringWithString:[@"Share Order Details" uppercaseString] WithSpacing:0.3];
    [strAttrSha addAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor]colorWithAlphaComponent:0.8]} range:NSMakeRange(0, strAttrSha.length)];
    
    lblShare.attributedText = strAttrSha;
    lblShare.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
    lblShare.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    lblShare.textAlignment = NSTextAlignmentCenter;
    [view_details addSubview:lblShare];
    
    yAxis += lblHeight+5*MULTIPLYHEIGHT;
    
    float vbX = 60*MULTIPLYHEIGHT;
    float vbHeight = 30*MULTIPLYHEIGHT;
    
    UIView *view_Btn = [[UIView alloc]init];
    view_Btn.frame = CGRectMake(vbX, yAxis, view_details.frame.size.width-(vbX*2), vbHeight);
    [view_details addSubview:view_Btn];
    
    float Width = view_Btn.frame.size.width/3;
    
    NSArray *arrayImages = [NSArray arrayWithObjects:@"share_whatsapp", @"share_mail", @"share_message", nil];
    
    for (int i=0; i<[arrayImages count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*Width, 0, Width, vbHeight);
        [btn setImage:[UIImage imageNamed:[arrayImages objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = i+1;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn addTarget:self action:@selector(shareOrderDetails:) forControlEvents:UIControlEventTouchUpInside];
        [view_Btn addSubview:btn];
        
        float insets = 3*MULTIPLYHEIGHT;
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(insets, insets, insets, insets);
    }
    
    yAxis += vbHeight+15*MULTIPLYHEIGHT;
    
    UIImageView *imgLine = [[UIImageView alloc]init];
    imgLine.frame = CGRectMake(0, yAxis, view_details.frame.size.width, 1);
    imgLine.backgroundColor = RGBCOLORCODE(200, 200, 200, 1.0);
    [view_details addSubview:imgLine];
    
    //yAxis += 2*MULTIPLYHEIGHT;
    
    float btnaHeight = 35*MULTIPLYHEIGHT;
    
    UIButton *btnAddtoCalender = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSMutableAttributedString *strAttrCal;
    
    NSString *strStatusCode = [self.orderEditDetails objectForKey:@"statusCode"];
    
    if([self checkIfEventIsAlreadyAdded])
    {
        strAttrCal = [appDel getAttributedStringWithString:@"ADDED TO CALENDAR" WithSpacing:0.4];
        
        [btnAddtoCalender setAttributedTitle:strAttrCal forState:UIControlStateNormal];
        [strAttrCal addAttributes:@{NSForegroundColorAttributeName:BLUE_COLOR} range:NSMakeRange(0, strAttrCal.length)];
        
        btnAddtoCalender.enabled = NO;
    }
    else
    {
        strAttrCal = [appDel getAttributedStringWithString:@"ADD TO CALENDAR" WithSpacing:0.4];
        
        [btnAddtoCalender setAttributedTitle:strAttrCal forState:UIControlStateNormal];
        [strAttrCal addAttributes:@{NSForegroundColorAttributeName:[[UIColor grayColor] colorWithAlphaComponent:1.0]} range:NSMakeRange(0, strAttrCal.length)];
        
        if ([strStatusCode isEqualToString:@"OD"] || [strStatusCode isEqualToString:@"OD-PA"])
        {
            btnAddtoCalender.enabled = NO;
            btnAddtoCalender.alpha = 0.4;
        }
    }
    
    btnAddtoCalender.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
    btnAddtoCalender.frame = CGRectMake(0, yAxis, view_details.frame.size.width, btnaHeight);
    [btnAddtoCalender addTarget:self action:@selector(btnAddToCalendar) forControlEvents:UIControlEventTouchUpInside];
    [view_details addSubview:btnAddtoCalender];
    
    yAxis += btnaHeight;
    
    CGRect rect = view_details.frame;
    rect.size.height = yAxis;
    view_details.frame = rect;
    
    
    yAxis += 10*MULTIPLYHEIGHT;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSMutableAttributedString *strAttrClose = [appDel getAttributedStringWithString:@"CANCEL" WithSpacing:1.0];
    [strAttrClose addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, strAttrClose.length)];
    
    [btnClose setAttributedTitle:strAttrClose forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnClose.backgroundColor = [UIColor whiteColor];
    btnClose.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
    btnClose.frame = CGRectMake(vdx, yAxis, view_details.frame.size.width, btnaHeight);
    [btnClose addTarget:self action:@selector(btnCloseClicked) forControlEvents:UIControlEventTouchUpInside];
    [view_UnderShare addSubview:btnClose];
    
    yAxis += btnaHeight;
    
    rect = view_UnderShare.frame;
    rect.origin.y = screen_height;
    rect.size.height = yAxis;
    view_UnderShare.frame = rect;
    
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect rect = view_UnderShare.frame;
        rect.origin.y = screen_height-(rect.size.height+13*MULTIPLYHEIGHT);
        view_UnderShare.frame = rect;
        
        blurEffect.alpha = 1.0;
        view_Share.alpha = 1.0;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void) shareOrderDetails:(UIButton *) share
{
    NSMutableString *strWhatsapp = [[NSMutableString alloc]init];
    
    [strWhatsapp appendString:[NSString stringWithFormat:@"Order Id: %@\n", [self.orderEditDetails objectForKey:@"oid"]]];
    
    [strWhatsapp appendString:[NSString stringWithFormat:@"Order type: %@\n", [self.orderEditDetails objectForKey:ORDER_TYPE]]];
    
    [strWhatsapp appendString:@"Service types: "];
    
    NSMutableArray *arrayWashTypes = [[NSMutableArray alloc]init];
    
    NSArray *arrayServiceTypes = [self.orderInfo objectForKey:ORDER_JOB_TYPE];
    
    if ([arrayServiceTypes containsObject:SERVICETYPE_WF])
    {
        [arrayWashTypes addObject:@"LOAD WASH"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_WI])
    {
        [arrayWashTypes addObject:@"WASH & IRON"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_IR])
    {
        [arrayWashTypes addObject:@"IRONING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_DC])
    {
        [arrayWashTypes addObject:@"DRY CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_DCG])
    {
        [arrayWashTypes addObject:@"GREEN DRY CLEANING"];
    }
//    if ([arrayServiceTypes containsObject:@"HL_DC"])
//    {
//        [arrayWashTypes addObject:@"HOME LINEN - DRY CLEANING"];
//    }
//    if ([arrayServiceTypes containsObject:@"HL_DCG"])
//    {
//        [arrayWashTypes addObject:@"HOME LINEN - GREEN DRY CLEANING"];
//    }
//    if ([arrayServiceTypes containsObject:@"HL_WI"])
//    {
//        [arrayWashTypes addObject:@"HOME LINEN - WASH & IRON"];
//    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_LE])
    {
        [arrayWashTypes addObject:@"LEATHER CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CA])
    {
        [arrayWashTypes addObject:@"CARPET CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_W_DC])
    {
        [arrayWashTypes addObject:@"CURTAINS WITH INSTALLATION - DRY CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_DC])
    {
        [arrayWashTypes addObject:@"CURTAINS WITHOUT INSTALLATION - DRY CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_WI])
    {
        [arrayWashTypes addObject:@"CURTAINS WITHOUT INSTALLATION - WASH & IRON"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_CC_W_WI])
    {
        [arrayWashTypes addObject:@"CURTAINS WITH INSTALLATION - WASH & IRON"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_BAG])
    {
        [arrayWashTypes addObject:@"BAGS CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_SHOE_CLEAN])
    {
        [arrayWashTypes addObject:@"SHOE CLEANING"];
    }
    if ([arrayServiceTypes containsObject:SERVICETYPE_SHOE_POLISH])
    {
        [arrayWashTypes addObject:@"SHOE POLISH"];
    }
    
    
    for (int i=0; i<[arrayWashTypes count]; i++)
    {
        if (i == [arrayWashTypes count]-1)
        {
            [strWhatsapp appendString:[NSString stringWithFormat:@"%@\n", [arrayWashTypes objectAtIndex:i]]];
        }
        else
        {
            [strWhatsapp appendString:[NSString stringWithFormat:@"%@, ", [arrayWashTypes objectAtIndex:i]]];
        }
    }
    
    [strWhatsapp appendString:[NSString stringWithFormat:@"Order status: %@\n", trackStatusLbl.text]];
    
    if ([self.piingoName length] > 1)
    {
        [strWhatsapp appendString:[NSString stringWithFormat:@"Piingo name: %@\n", self.piingoName]];
    }
    else
    {
        [strWhatsapp appendString:[NSString stringWithFormat:@"Piingo name: Not assigned yet\n"]];
    }
    
    [strWhatsapp appendString:[NSString stringWithFormat:@"Pickup date & time: %@ %@\n", [self.orderEditDetails objectForKey:ORDER_PICKUP_DATE], [self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT]]];
    
    [strWhatsapp appendString:[NSString stringWithFormat:@"Delivery date & time: %@ %@\n", [self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE], [self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT]]];
    
    if (share.tag == 1)
    {
        NSString *msg = [NSString stringWithFormat:@"whatsapp://send?text=%@",strWhatsapp];
        
        msg = [msg stringByReplacingOccurrencesOfString:@"\n" withString:@"%0D"];
        msg = [msg stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        msg = [msg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL *whatsappURL = [NSURL URLWithString:msg];
        
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
        {
            [[UIApplication sharedApplication] openURL: whatsappURL];
        }
    }
    else if (share.tag == 2)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
            
            mailCompose.mailComposeDelegate = self;
            [mailCompose setSubject:@"Sharing order details"];
            [mailCompose setMessageBody:strWhatsapp isHTML:NO];
            
            [self presentViewController:mailCompose animated:YES completion:nil];
        }
        else
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support Email!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
    }
    else if (share.tag == 3)
    {
        if(![MFMessageComposeViewController canSendText]) {
            
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        //[messageController setRecipients:recipents];
        [messageController setBody:strWhatsapp];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
            
        default:
            break;
    }
    
    // Close the Mail Interface
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) btnAddToCalendar
{
    [self updateAuthorizationStatusToAccessEventStore];
}

-(void) btnCloseClicked
{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect rect = view_UnderShare.frame;
        rect.origin.y = screen_height;
        view_UnderShare.frame = rect;
        
        blurEffect.alpha = 0.0;
        view_Share.alpha = 0.0;
        
        
    } completion:^(BOOL finished) {
        
        [view_Share removeFromSuperview];
        view_Share = nil;
        
        [appDel removeCustomBlurEffectToView:self.view];
    }];
}

-(void) playVideo
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlayVideo" object:nil];
    
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    self.backGroundplayer.repeatMode = YES;
    self.backGroundplayer.view.userInteractionEnabled = YES;
    self.backGroundplayer.controlStyle = MPMovieControlStyleNone;
    [self.backGroundplayer prepareToPlay];
    [self.backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
    //self.backGroundplayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.backGroundplayer.backgroundView.backgroundColor = [UIColor whiteColor];
    self.backGroundplayer.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [view_BG addSubview:self.backGroundplayer.view];
        [view_BG sendSubviewToBack:self.backGroundplayer.view];
        
    });
    
    [self.backGroundplayer play];
    
    [self.backGroundplayer setScalingMode:MPMovieScalingModeAspectFit];
}


// For Reminders

//- (EKCalendar *)calendar {
//    if (!_calendar) {
//
//        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeReminder];
//
//        NSString *calendarTitle = @"Piing!";
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
//        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
//
//        if ([filtered count]) {
//            _calendar = [filtered firstObject];
//        } else {
//
//            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
//            _calendar.title = @"Piing!";
//            _calendar.source = self.eventStore.defaultCalendarForNewReminders.source;
//
//            NSError *calendarErr = nil;
//            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
//            if (!calendarSuccess) {
//                // Handle error
//            }
//        }
//    }
//    return _calendar;
//}
//
//- (NSDateComponents *)dateComponentsForDefaultDueDate {
//
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"dd-MM-yyyy"];
//
//    NSArray *arrayEndTimes = [[self.orderEditDetails objectForKey:@"dt"] componentsSeparatedByString:@"-"];
//
//    NSDate *endDate = [df dateFromString:[NSString stringWithFormat:@"%@",[self.orderEditDetails objectForKey:@"dd"]]];
//
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *endComp = [gregorianCalendar components:unitFlags fromDate:endDate];
//
//    if ([[arrayEndTimes objectAtIndex:0] containsString:@"PM"])
//    {
//        endComp.hour = 12+[[arrayEndTimes objectAtIndex:0]intValue];
//    }
//    else
//    {
//        endComp.hour = [[arrayEndTimes objectAtIndex:0]intValue];
//    }
//
//    return endComp;
//}
//
//
//- (NSDateComponents *)dateComponentsForDefaultStartDate {
//
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    [df setDateFormat:@"dd-MM-yyyy"];
//
//    NSArray *arrayStartTimes = [[self.orderEditDetails objectForKey:@"pt"] componentsSeparatedByString:@"-"];
//
//    NSDate *startDate = [df dateFromString:[NSString stringWithFormat:@"%@",[self.orderEditDetails objectForKey:@"pd"]]];
//
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    NSUInteger unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
//    NSDateComponents *startComp = [gregorianCalendar components:unitFlags fromDate:startDate];
//
//    if ([[arrayStartTimes objectAtIndex:0] containsString:@"PM"])
//    {
//        startComp.hour = 12+[[arrayStartTimes objectAtIndex:0]intValue];
//    }
//    else
//    {
//        startComp.hour = [[arrayStartTimes objectAtIndex:0]intValue];
//    }
//
//    startComp.minute = 0;
//    startComp.second = 0;
//
//    return startComp;
//}
//
//-(void)saveNewEvent {
//
//
//    EKReminder *startReminder = [EKReminder reminderWithEventStore:self.eventStore];
//    startReminder.title = [NSString stringWithFormat:@"Pick-up: %@", [self.orderEditDetails objectForKey:@"orno"]];
//    startReminder.calendar = self.calendar;
//    startReminder.dueDateComponents = [self dateComponentsForDefaultStartDate];
//
//    NSError *error = nil;
//    BOOL success = [self.eventStore saveReminder:startReminder commit:YES error:&error];
//    if (!success) {
//        // Handle error.
//    }
//
//
//    EKReminder *endReminder = [EKReminder reminderWithEventStore:self.eventStore];
//    endReminder.title = [NSString stringWithFormat:@"Delivery: %@", [self.orderEditDetails objectForKey:@"orno"]];
//    endReminder.calendar = self.calendar;
//    endReminder.dueDateComponents = [self dateComponentsForDefaultDueDate];
//
//    NSError *error1 = nil;
//    BOOL success1 = [self.eventStore saveReminder:endReminder commit:YES error:&error1];
//    if (!success1) {
//        // Handle error.
//    }
//
//    NSString *message = (success1) ? @"Reminder was successfully added!" : @"Failed to add reminder!";
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alertView show];
//}


- (EKCalendar *)calendar
{
    NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    
    NSString *calendarTitle = @"Piing!";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
    NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
    
    if ([filtered count]) {
        _calendar = [filtered firstObject];
    } else {
        
        _calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
        _calendar.title = @"Piing!";
        
//        NSArray *arrSources = self.eventStore.sources;
//        
//        for (EKSource *source in arrSources)
//        {
//            if (source.sourceType == EKSourceTypeLocal)
//            {
//                _calendar.source = source;
//            }
//        }
        
        _calendar.source = self.eventStore.defaultCalendarForNewEvents.source;
        
        NSError *calendarErr = nil;
        BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
        if (!calendarSuccess) {
            // Handle error
        }
    }
    
    return _calendar;
}


-(void)saveNewEvent
{
    NSString *strStatusCode = [self.orderEditDetails objectForKey:@"statusCode"];
    
    if (([strStatusCode isEqualToString:@"OB"] || [strStatusCode isEqualToString:@"PO-P"] || [strStatusCode isEqualToString:@"OB-RS-P"]) && !self.isFromBookNow)
    {
        [self addPickupEvent];
    }
    
    [self addDeliveryEvent];
}

-(void) addPickupEvent
{
    EKEvent *pikupEvent = [EKEvent eventWithEventStore:self.eventStore];
    pikupEvent.title = [NSString stringWithFormat:@"Piing! pick-up - Order # %@", [self.orderEditDetails objectForKey:@"oid"]];
    pikupEvent.calendar = self.calendar;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-MM-yyyy h aa"];
    
    NSArray *arrayPickupTimes = [[self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT] componentsSeparatedByString:@"-"];
    
    NSDate *startDate = [df dateFromString:[NSString stringWithFormat:@"%@ %@",[self.orderEditDetails objectForKey:ORDER_PICKUP_DATE], [arrayPickupTimes objectAtIndex:0]]];
    
    NSDate *endDate = [df dateFromString:[NSString stringWithFormat:@"%@ %@",[self.orderEditDetails objectForKey:ORDER_PICKUP_DATE], [arrayPickupTimes objectAtIndex:1]]];
    
    pikupEvent.startDate = startDate;
    
    pikupEvent.endDate = endDate;
    
    NSError *error = nil;
    BOOL success = [self.eventStore saveEvent:pikupEvent span:EKSpanFutureEvents commit:YES error:&error];
    
    if (!success) {
        // Handle error.
    }
    else
    {
        
    }
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeInterval:-3600 sinceDate:pikupEvent.startDate]];
    // Add the alarm to the event.
    [pikupEvent addAlarm:alarm];
}

-(void) addDeliveryEvent
{
    EKEvent *deliveryEvent = [EKEvent eventWithEventStore:self.eventStore];
    deliveryEvent.title = [NSString stringWithFormat:@"Piing! delivery - Order # %@", [self.orderEditDetails objectForKey:@"oid"]];
    deliveryEvent.calendar = self.calendar;
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd-MM-yyyy h aa"];
    
    NSArray *arrayDeliveryTimes = [[self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT] componentsSeparatedByString:@"-"];
    
    NSDate *startDate = [df dateFromString:[NSString stringWithFormat:@"%@ %@",[self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE], [arrayDeliveryTimes objectAtIndex:0]]];
    
    NSDate *endDate = [df dateFromString:[NSString stringWithFormat:@"%@ %@",[self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE], [arrayDeliveryTimes objectAtIndex:1]]];
    
    deliveryEvent.startDate = startDate;
    
    deliveryEvent.endDate = endDate;
    
    NSError *error = nil;
    BOOL success = [self.eventStore saveEvent:deliveryEvent span:EKSpanFutureEvents commit:YES error:&error];
    
    if (!success) {
        // Handle error.
    }
    else
    {
        [appDel showAlertWithMessage:@"Your order has been added to your calendar successfully!" andTitle:@"" andBtnTitle:@"OK"];
    }
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:[NSDate dateWithTimeInterval:-3600 sinceDate:deliveryEvent.startDate]];
    // Add the alarm to the event.
    [deliveryEvent addAlarm:alarm];
    
    [self btnCloseClicked];
}

-(BOOL) checkIfEventIsAlreadyAdded
{
    BOOL added = NO;
    
    NSArray *arrayEvents = [self getEventsOfSelectedCalendar];
    
    for (int i = 0; i < [arrayEvents count]; i++)
    {
        NSString *strEvent = [NSString stringWithFormat:@"%@", [self.orderEditDetails objectForKey:@"oid"]];
        
        EKEvent *event = [arrayEvents objectAtIndex:i];
        
        if ([event.title containsString:strEvent])
        {
            added = YES;
            
            break;
        }
    }
    
    return added;
}

-(NSArray *)getEventsOfSelectedCalendar{
    
    // If no selected calendar identifier exists and the calendar variable has the nil value, then all calendars will be used for retrieving events.
    NSArray *calendarsArray = nil;
    if (self.calendar != nil) {
        calendarsArray = @[self.calendar];
    }
    
    
    // Create a predicate value with start date a year before and end date a year after the current date.
    int yearSeconds = 365 * (60 * 60 * 24);
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[NSDate dateWithTimeIntervalSinceNow:-yearSeconds] endDate:[NSDate dateWithTimeIntervalSinceNow:yearSeconds] calendars:calendarsArray];
    
    // Get an array with all events.
    NSArray *eventsArray = [self.eventStore eventsMatchingPredicate:predicate];
    
    // Sort the array based on the start date.
    eventsArray = [eventsArray sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    
    // Return that array.
    return eventsArray;
}

#pragma mark - Reminders

// 1
- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}


- (void)updateAuthorizationStatusToAccessEventStore
{
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
            
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"Piing doesn't have access to your Calendar. Please go to settings to enable." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            break;
        }
            
        case EKAuthorizationStatusAuthorized:
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CALENDAR_ACCESS_GRANTED"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            appDel.automaticAddtoCalendar = NO;
            
            [self saveNewEvent];
            
            break;
            
        case EKAuthorizationStatusNotDetermined: {
            
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                    if (granted)
                                                    {
                                                        [[NSUserDefaults standardUserDefaults] setBool:granted forKey:@"CALENDAR_ACCESS_GRANTED"];
                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                        
                                                        if (appDel.automaticAddtoCalendar)
                                                        {
                                                            appDel.automaticAddtoCalendar = NO;
                                                            
                                                            [self saveNewEvent];
                                                        }
                                                    }
                                                    
                                                });
                                            }];
            break;
        }
    }
}


-(void) downBtnClicked:(id)sender
{
    lblPiingoName.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        float minusHeight = 72*MULTIPLYHEIGHT;
        
        CGRect frame = view_Bottom.frame;
        frame.origin.y = screen_height - minusHeight;
        view_Bottom.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        isViewAtTop = NO;
        [self changeViewTrackingframe];
        
    }];
    
    [self changeAnimationDidComplete];
    
}

-(void) changeAnimation
{
    
    float somee = (screen_height-(72*MULTIPLYHEIGHT))-(view_Bottom.frame.origin.y);
    
    float somePX = 44*MULTIPLYHEIGHT+(somee*0.22);
    float somePY = 29*MULTIPLYHEIGHT+(somee*0.07);
    
    profilePicView.center = CGPointMake(somePX, somePY);
    
    
    float lPX = 171.5*MULTIPLYHEIGHT;
    float lPY = 30*MULTIPLYHEIGHT+(somee*0.2);
    
    lblPiingoName.center = CGPointMake(lPX, lPY);
    
    
    float viewZX = 280*MULTIPLYHEIGHT+(somee*0.152);
    
    view_ZigZag.center = CGPointMake(view_ZigZag.center.x, viewZX);
    
    
    float viewZZ = view_Bottom.frame.origin.y-20;
    
    //NSLog(@"Zigzag alpha : %f", (viewZZ*0.0019));
    
    view_ZigZag.alpha = 1.0-(viewZZ*0.0019);
    imgArrow.alpha = 1.0-view_ZigZag.alpha;
    btnDown.alpha = view_ZigZag.alpha;
}

-(void) changeAnimationDidComplete
{
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        float somee = (screen_height-(72*MULTIPLYHEIGHT))-(view_Bottom.frame.origin.y);
        
        float someX = 44*MULTIPLYHEIGHT+(somee*0.23);
        float someY = 29*MULTIPLYHEIGHT+(somee*0.07);
        
        profilePicView.center = CGPointMake(someX, someY);
        
        
        float lPX = 171.5*MULTIPLYHEIGHT;
        float lPY = 30*MULTIPLYHEIGHT+(somee*0.2);
        
        lblPiingoName.center = CGPointMake(lPX, lPY);
        
        
        float viewZX = 280*MULTIPLYHEIGHT+(somee*0.152);
        
        view_ZigZag.center = CGPointMake(view_ZigZag.center.x, viewZX);
        
        float viewZZ = view_Bottom.frame.origin.y-20;
        
        view_ZigZag.alpha = 1.0-(viewZZ*0.0019);
        imgArrow.alpha = 1.0-view_ZigZag.alpha;
        btnDown.alpha = view_ZigZag.alpha;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            
            lblPiingoName.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
        }];
        
        if (!isViewAtTop)
        {
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"Scroll_Horizantal"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"Scroll_Horizantal"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self performSelector:@selector(moveScrollLast) withObject:nil afterDelay:0.4f];
            }
        }
    }];
}

-(void) moveScrollLast
{
    CGPoint bottomOffset = CGPointMake(bottomViewForOrder.contentSize.width - bottomViewForOrder.bounds.size.width, 0);
    
    [bottomViewForOrder setContentOffset:bottomOffset animated:YES];
    
    [self performSelector:@selector(moveScrolltoOriginal) withObject:nil afterDelay:1.0f];
}

-(void) moveScrolltoOriginal
{
    [bottomViewForOrder setContentOffset:CGPointZero animated:YES];
}

-(void) changeViewTrackingframe
{
    if (isViewAtTop)
    {
        CGRect rect = btnShare.frame;
        rect.origin.x = originalShareRect.origin.x-7*MULTIPLYHEIGHT;
        rect.size.height = originalShareRect.size.height-25*MULTIPLYHEIGHT;
        btnShare.frame = rect;
        [btnShare setImage:[UIImage imageNamed:@"share_order_details_grey"] forState:UIControlStateNormal];
        
        btnShare.backgroundColor = [UIColor clearColor];
        
        if (viewDownDates)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
                
                viewDownDates.alpha = 0.0;
                view_Image_Text.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
        
        
        float imgHeight = 58*MULTIPLYHEIGHT;
        
        float imgY = 30*MULTIPLYHEIGHT;
        
        float lblPY = imgY+imgHeight;
        
        NSString *strName;
        
        if (self.piingoName)
        {
            strName = self.piingoName;
        }
        else
        {
            strName = @"Piingo";
        }
        
        NSString *strStatusCode = [self.orderEditDetails objectForKey:@"statusCode"];
        
        if ([strName length] || ![strStatusCode isEqualToString:@"OB"] || ![strStatusCode isEqualToString:@"OB-RS-P"])
        {
            lblPiingoName.frame = CGRectMake(0, lblPY, screen_width, lblPiingoName.frame.size.height);
        }
        else
        {
            lblPiingoName.frame = CGRectMake(0, lblPY, screen_width, 25*MULTIPLYHEIGHT);
        }
        
        lblPiingoName.textAlignment = NSTextAlignmentCenter;
        
        btnDown.alpha = 1.0;
        view_ZigZag.alpha = 1.0;
        imgArrow.alpha = 0.0;
    }
    else
    {
        btnShare.frame = originalShareRect;
        btnShare.backgroundColor = RGBCOLORCODE(248, 249, 250, 1.0);
        [btnShare setImage:[UIImage imageNamed:@"share_order_details"] forState:UIControlStateNormal];
        
        if (viewDownDates)
        {
            [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
                
                viewDownDates.alpha = 1.0;
                view_Image_Text.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
            }];
        }
        
        
        NSString *strName;
        
        if ([self.piingoName length])
        {
            strName = self.piingoName;
        }
        else
        {
            strName = @"Piingo";
        }
        
        NSString *strStatusCode = [self.orderEditDetails objectForKey:@"statusCode"];
        
        if ([strName length] || ![strStatusCode isEqualToString:@"OB"] || ![strStatusCode isEqualToString:@"OB-RS-P"])
        {
            lblPiingoName.frame = CGRectMake(profilePicView.frame.origin.x+profilePicView.frame.size.width+10, 10*MULTIPLYHEIGHT, (screen_width - (profilePicView.frame.origin.x+profilePicView.frame.size.width+20)), lblPiingoName.frame.size.height);
        }
        else
        {
            lblPiingoName.frame = CGRectMake(profilePicView.frame.origin.x+profilePicView.frame.size.width+10, 10*MULTIPLYHEIGHT, (screen_width - (profilePicView.frame.origin.x+profilePicView.frame.size.width+20)), 15*MULTIPLYHEIGHT);
        }
        
        lblPiingoName.textAlignment = NSTextAlignmentLeft;
        
        btnDown.alpha = 0.0;
        view_ZigZag.alpha = 0.0;
        imgArrow.alpha = 1.0;
    }
    
    touchChanges = NO;
}


-(void) btnArrowClicked:(id)sender
{
    float minusHeight = 72*MULTIPLYHEIGHT;
    
    if (view_Bottom.frame.origin.y <= 20)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Bottom.frame;
            frame.origin.y = screen_height - minusHeight;
            view_Bottom.frame = frame;
            
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (view_Bottom.frame.origin.y >= screen_height-minusHeight)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Bottom.frame;
            frame.origin.y = 20;
            view_Bottom.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == bottomViewForOrder)
    {
        float scrollViewWidth = scrollView.frame.size.width;
        float scrollContentSizeWidth = scrollView.contentSize.width-17*MULTIPLYHEIGHT;
        float scrollOffset = scrollView.contentOffset.x;
        
        if (scrollOffset + scrollViewWidth < scrollContentSizeWidth)
        {
            btnArrow.hidden = NO;
        }
        else if (scrollOffset + scrollViewWidth >= scrollContentSizeWidth)
        {
            btnArrow.hidden = YES;
        }
    }
    else if (scrollView == view_WashTypes)
    {
        float scrollViewWidth = scrollView.frame.size.width;
        float scrollContentSizeWidth = scrollView.contentSize.width-17*MULTIPLYHEIGHT;
        float scrollOffset = scrollView.contentOffset.x;
        
        if (scrollOffset + scrollViewWidth < scrollContentSizeWidth)
        {
            btnArrowType.hidden = NO;
        }
        else if (scrollOffset + scrollViewWidth >= scrollContentSizeWidth)
        {
            btnArrowType.hidden = YES;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == scrollViewBottom)
    {
        CGFloat pageWidth = scrollViewBottom.frame.size.width;
        float fractionalPage = scrollViewBottom.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        
        pageControlBottom.currentPage = page;
        
        if (page == 0)
        {
            [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
                
                [scrollViewBottom setContentOffset:CGPointMake(screen_width, 0)];
                
            } completion:^(BOOL finished) {
                
                pageControlBottom.currentPage = 1;
                
            }];
        }
    }
    else if (scrollView == scrollViewWashType)
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
}


-(void) pagecontrolClicked:(id) sender
{
    
    [scrollViewBottom setContentOffset:CGPointMake(pageControlBottom.currentPage * screen_width, 0) animated:YES];
    
    if (pageControlBottom.currentPage == 0)
    {
        [UIView animateWithDuration:0.3 delay:1.0 options:0 animations:^{
            
            [scrollViewBottom setContentOffset:CGPointMake(screen_width, 0)];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void) updateOrderDetails
{
    NSDictionary *dictDetail = [NSDictionary dictionaryWithObjectsAndKeys:self.bookNowCobID, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/get/byid", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dictDetail andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [self.orderEditDetails removeAllObjects];
            
            [self.orderEditDetails addEntriesFromDictionary:[[responseObj objectForKey:@"em"] objectAtIndex:0]];
            
            
            NSMutableArray *arrayServiceTypes = [[NSMutableArray alloc]initWithArray:[self.orderEditDetails objectForKey:ORDER_JOB_TYPE]];
            
            if ([arrayServiceTypes containsObject:SERVICETYPE_HL_WI])
            {
                if (![arrayServiceTypes containsObject:SERVICETYPE_WI])
                {
                    [arrayServiceTypes replaceObjectAtIndex:[arrayServiceTypes indexOfObject:SERVICETYPE_HL_WI] withObject:SERVICETYPE_WI];
                }
                else
                {
                    [arrayServiceTypes removeObject:SERVICETYPE_HL_WI];
                }
            }
            
            if ([arrayServiceTypes containsObject:SERVICETYPE_HL_DC])
            {
                if (![arrayServiceTypes containsObject:SERVICETYPE_DC])
                {
                    [arrayServiceTypes replaceObjectAtIndex:[arrayServiceTypes indexOfObject:SERVICETYPE_HL_DC] withObject:SERVICETYPE_DC];
                }
                else
                {
                    [arrayServiceTypes removeObject:SERVICETYPE_HL_DC];
                }
            }
            
            if ([arrayServiceTypes containsObject:SERVICETYPE_HL_DCG])
            {
                if (![arrayServiceTypes containsObject:SERVICETYPE_DCG])
                {
                    [arrayServiceTypes replaceObjectAtIndex:[arrayServiceTypes indexOfObject:SERVICETYPE_HL_DCG] withObject:SERVICETYPE_DCG];
                }
                else
                {
                    [arrayServiceTypes removeObject:SERVICETYPE_HL_DCG];
                }
            }
            
//            if ([arrayServiceTypes containsObject:SERVICETYPE_DCG] && [arrayServiceTypes containsObject:SERVICETYPE_DC])
//            {
//                [arrayServiceTypes removeObject:SERVICETYPE_DCG];
//            }
            
            [self.orderEditDetails setObject:arrayServiceTypes forKey:ORDER_JOB_TYPE];
            
            
            [self.dictAllowUpdates removeAllObjects];
            
            [self.dictAllowUpdates addEntriesFromDictionary:[responseObj objectForKey:@"allowdUpdate"]];
            
            [self reloadOrderDetailsWhenUpdated];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
    
}

-(void) reloadOrderDetailsWhenUpdated
{
    [self.orderInfo removeAllObjects];
    
    [self.orderInfo setValue:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
    [self.orderInfo setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] forKey:ORDER_USER_ID];
    [self.orderInfo setObject:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN] forKey:@"t"];
    
    [self.orderInfo setObject:self.bookNowCobID forKey:@"oid"];
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_PICKUP_SLOT] forKey:ORDER_PICKUP_SLOT];
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_PICKUP_DATE] forKey:ORDER_PICKUP_DATE];
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_FROM] forKey:ORDER_FROM];
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_DELIVERY_SLOT] forKey:ORDER_DELIVERY_SLOT];
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_DELIVERY_DATE] forKey:ORDER_DELIVERY_DATE];
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_DELIVERY_ADDRESS_ID] forKey:ORDER_DELIVERY_ADDRESS_ID];
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_PICKUP_ADDRESS_ID] forKey:ORDER_PICKUP_ADDRESS_ID];
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_TYPE] forKey:ORDER_TYPE];
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_CARD_ID] forKey:ORDER_CARD_ID];
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_JOB_TYPE] forKey:ORDER_JOB_TYPE];
    
    if ([self.orderEditDetails objectForKey:PROMO_CODE])
    {
        [self.orderInfo setObject:[self.orderEditDetails objectForKey:PROMO_CODE] forKey:PROMO_CODE];
    }
    else
    {
        [self.orderInfo setObject:@"" forKey:PROMO_CODE];
    }
    
    [self.orderInfo setObject:[self.orderEditDetails objectForKey:ORDER_NOTES] forKey:ORDER_NOTES];
    
    NSDictionary *dict1 = [self.orderEditDetails objectForKey:PREFERENCES_SELECTED];
    
    NSMutableDictionary *dictMain  = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *dict2 in dict1)
    {
        [dictMain setObject:[dict2 objectForKey:@"value"] forKey:[dict2 objectForKey:@"name"]];
    }
    
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
    
    [self.orderInfo setObject:strPref forKey:PREFERENCES_SELECTED];
    
    NSArray *sortedArray3 = [[NSMutableArray alloc]initWithArray:self.userAddresses];
    NSPredicate *getDefaultAddPredicate3 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.orderEditDetails objectForKey:ORDER_PICKUP_ADDRESS_ID]]];
    
    sortedArray3 = [sortedArray3 filteredArrayUsingPredicate:getDefaultAddPredicate3];
    
    if ([sortedArray3 count] > 0)
    {
        dictPickupAddress = [sortedArray3 objectAtIndex:0];
    }
    
    NSArray *sortedArray2 = [[NSMutableArray alloc]initWithArray:self.userAddresses];
    NSPredicate *getDefaultAddPredicate2 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [self.orderEditDetails objectForKey:ORDER_DELIVERY_ADDRESS_ID]]];
    
    sortedArray2 = [sortedArray2 filteredArrayUsingPredicate:getDefaultAddPredicate2];
    
    if ([sortedArray2 count] > 0)
    {
        dictDeliveryAddress = [sortedArray2 objectAtIndex:0];
    }
    
    [self loadOrderDetails];
}


-(void) touchesDidChangeToView:(UIView *)view WithLocation:(CGPoint)location AndPreviousLocation:(CGPoint)previousLocation
{
    if (view.tag == 200)
    {
        touchChanges = YES;
        
        float minusHeight = 72*MULTIPLYHEIGHT;
        
        float piingViewX = 90*MULTIPLYHEIGHT;
        
        if (pingoDetailsView.frame.origin.y < piingViewX)
        {
            CGRect frame = pingoDetailsView.frame;
            frame.origin.y = piingViewX;
            pingoDetailsView.frame = frame;
            
            isViewAtTop = YES;
        }
        else if (pingoDetailsView.frame.origin.y > screen_height-minusHeight-1)
        {
            CGRect frame = pingoDetailsView.frame;
            frame.origin.y = screen_height - minusHeight;
            pingoDetailsView.frame = frame;
            
            isViewAtTop = NO;
        }
        else
        {
            [self changeAnimationForBookNow];
        }
    }
    else if (view.tag == 400)
    {
        touchChanges = YES;
        
        float minusHeight = 72*MULTIPLYHEIGHT;
        
        if (view_Bottom.frame.origin.y < 21)
        {
            CGRect frame = view_Bottom.frame;
            frame.origin.y = 20;
            view_Bottom.frame = frame;
            
            isViewAtTop = YES;
            
            [self changeViewTrackingframe];
        }
        else if (view_Bottom.frame.origin.y > screen_height-minusHeight-1)
        {
            CGRect frame = view_Bottom.frame;
            frame.origin.y = screen_height - minusHeight;
            view_Bottom.frame = frame;
            
            isViewAtTop = NO;
            
            [self changeViewTrackingframe];
        }
        else
        {
            [self changeAnimation];
            
            lblPiingoName.alpha = 0.0;
        }
    }
}


-(void) touchesDidEndToView:(UIView *)view WithLocation:(CGPoint)location AndPreviousLocation:(CGPoint)previousLocation
{
    if (view.tag == 200)
    {
        float minusHeight = 72*MULTIPLYHEIGHT;
        
        float piingViewX = 90*MULTIPLYHEIGHT;
        
        if (pingoDetailsView.frame.origin.y > screen_height-minusHeight)
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = pingoDetailsView.frame;
                frame.origin.y = screen_height - minusHeight;
                pingoDetailsView.frame = frame;
                
                
            } completion:^(BOOL finished) {
                
                isViewAtTop = NO;
                touchChanges = NO;
            }];
        }
        else if (pingoDetailsView.frame.origin.y < piingViewX)
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = pingoDetailsView.frame;
                frame.origin.y = piingViewX;
                pingoDetailsView.frame = frame;
                
            } completion:^(BOOL finished) {
                
                isViewAtTop = YES;
                touchChanges = NO;
                
            }];
        }
        else if (pingoDetailsView.frame.origin.y == screen_height-minusHeight)
        {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = pingoDetailsView.frame;
                frame.origin.y = piingViewX;
                pingoDetailsView.frame = frame;
                
            } completion:^(BOOL finished) {
                
                isViewAtTop = YES;
                
            }];
            
        }
        else if (pingoDetailsView.frame.origin.y == piingViewX)
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = pingoDetailsView.frame;
                frame.origin.y = screen_height - minusHeight;
                pingoDetailsView.frame = frame;
                
                
            } completion:^(BOOL finished) {
                
                isViewAtTop = NO;
                
            }];
            
        }
        else if (isViewAtTop)
        {
            if (location.y > previousLocation.y)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = pingoDetailsView.frame;
                    frame.origin.y = screen_height - minusHeight;
                    pingoDetailsView.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = NO;
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = pingoDetailsView.frame;
                    frame.origin.y = piingViewX;
                    pingoDetailsView.frame = frame;
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = YES;
                    
                }];
            }
        }
        else
        {
            if (location.y > previousLocation.y)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = pingoDetailsView.frame;
                    frame.origin.y = screen_height - minusHeight;
                    pingoDetailsView.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = NO;
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = pingoDetailsView.frame;
                    frame.origin.y = piingViewX;
                    pingoDetailsView.frame = frame;
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = YES;
                    
                }];
            }
        }
        
        [self changeAnimationCompleteForBookNow];
    }
    else if (view.tag == 400)
    {
        float minusHeight = 72*MULTIPLYHEIGHT;
        
        if (view_Bottom.frame.origin.y > screen_height-minusHeight)
        {
            if (touchChanges)
            {
                touchChanges = NO;
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = view_Bottom.frame;
                    frame.origin.y = screen_height - minusHeight;
                    view_Bottom.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = NO;
                    [self changeViewTrackingframe];
                    
                }];
            }
        }
        else if (view_Bottom.frame.origin.y < 20)
        {
            if (touchChanges)
            {
                touchChanges = NO;
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = view_Bottom.frame;
                    frame.origin.y = 20;
                    view_Bottom.frame = frame;
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = YES;
                    [self changeViewTrackingframe];
                    
                }];
            }
            
        }
        else if (view_Bottom.frame.origin.y == screen_height-minusHeight)
        {
            lblPiingoName.alpha = 0.0;
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect frame = view_Bottom.frame;
                frame.origin.y = 20;
                view_Bottom.frame = frame;
                
            } completion:^(BOOL finished) {
                
                isViewAtTop = YES;
                [self changeViewTrackingframe];
                
            }];
            
            [self changeAnimationDidComplete];
            
        }
        else if (view_Bottom.frame.origin.y == 20)
        {
            //            lblPiingoName.alpha = 0.0;
            //
            //            [UIView animateWithDuration:0.3 animations:^{
            //
            //                CGRect frame = view_Bottom.frame;
            //                frame.origin.y = screen_height - minusHeight;
            //                view_Bottom.frame = frame;
            //
            //
            //            } completion:^(BOOL finished) {
            //
            //                isViewAtTop = NO;
            //                [self changeViewTrackingframe];
            //
            //            }];
            //
            //            [self changeAnimationDidComplete];
            
        }
        else if (isViewAtTop)
        {
            lblPiingoName.alpha = 0.0;
            
            if (location.y > previousLocation.y)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = view_Bottom.frame;
                    frame.origin.y = screen_height - minusHeight;
                    view_Bottom.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = NO;
                    [self changeViewTrackingframe];
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = view_Bottom.frame;
                    frame.origin.y = 20;
                    view_Bottom.frame = frame;
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = YES;
                    [self changeViewTrackingframe];
                    
                }];
            }
            
            [self changeAnimationDidComplete];
        }
        else
        {
            lblPiingoName.alpha = 0.0;
            
            if (location.y > previousLocation.y)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = view_Bottom.frame;
                    frame.origin.y = screen_height - minusHeight;
                    view_Bottom.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = NO;
                    [self changeViewTrackingframe];
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    CGRect frame = view_Bottom.frame;
                    frame.origin.y = 20;
                    view_Bottom.frame = frame;
                    
                } completion:^(BOOL finished) {
                    
                    isViewAtTop = YES;
                    [self changeViewTrackingframe];
                    
                }];
            }
            
            [self changeAnimationDidComplete];
        }
    }
}

-(void) changeAnimationForBookNow
{
    view_BlurBGForBookNow.hidden = NO;
    blur.hidden = NO;
    
    float somee = pingoDetailsView.frame.origin.y-(90*MULTIPLYHEIGHT);
    
    CGRect frame = view_Message.frame;
    frame.origin.y = pingoDetailsView.frame.origin.y-40;
    view_Message.frame = frame;
    
    
    CGFloat alpha = somee*0.002;
    //NSLog(@"alpha : %f", alpha);
    
    blur.alpha = 1.0-alpha;
    
    CGFloat alpha1 = somee*0.0014;
    
    //NSLog(@"alpha1 : %f", alpha1);
    
    view_BlurBGForBookNow.alpha = 0.7-alpha1;
    
}

-(void) changeAnimationCompleteForBookNow
{
    view_BlurBGForBookNow.hidden = NO;
    blur.hidden = NO;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        float somee = pingoDetailsView.frame.origin.y-(90*MULTIPLYHEIGHT);
        
        CGRect frame = view_Message.frame;
        frame.origin.y = pingoDetailsView.frame.origin.y-40;
        view_Message.frame = frame;
        
        CGFloat alpha = somee*0.002;
        //NSLog(@"alpha : %f", alpha);
        
        blur.alpha = 1.0-alpha;
        
        CGFloat alpha1 = somee*0.0014;
        
        //NSLog(@"alpha1 : %f", alpha1);
        
        view_BlurBGForBookNow.alpha = 0.7-alpha1;
        
        
    } completion:^(BOOL finished) {
        
        if (view_BlurBGForBookNow.alpha < 0.2)
        {
            view_BlurBGForBookNow.hidden = YES;
            blur.hidden = YES;
        }
        else
        {
            view_BlurBGForBookNow.hidden = NO;
            blur.hidden = NO;
        }
    }];
    
}

- (void) reloadUI
{
    
}


-(void )showWashType
{
    
}


- (void) createWashTypesView
{
    
    float washTypeY = 72*MULTIPLYHEIGHT;
    
    washTypesView = [[UIView alloc] initWithFrame:CGRectMake(0.0, washTypeY, screen_width, pingoDetailsView.frame.size.height-washTypeY)];
    washTypesView.backgroundColor = [UIColor whiteColor];
    [pingoDetailsView addSubview:washTypesView];
    
    float yPos = 30.0+5*MULTIPLYHEIGHT;
    float ratio = MULTIPLYHEIGHT;
    {
        
        float pvY = 72*MULTIPLYHEIGHT;
        
        progressView_Blue = [[UIView alloc] initWithFrame:CGRectMake(0.0, pvY, 0.0, 2.0)];
        progressView_Blue.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.5];
        [pingoDetailsView addSubview:progressView_Blue];
        
        progressView_Grey = [[UIView alloc] initWithFrame:CGRectMake(0, pvY+1, screen_width, 1.0)];
        progressView_Grey.backgroundColor = [UIColor colorFromHexString:@"d6d6d6"];
        [pingoDetailsView addSubview:progressView_Grey];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            progressView_Blue.frame = CGRectMake(0.0, pvY, screen_width/2, 2.0);
            progressView_Grey.frame = CGRectMake(screen_width/2, pvY+1, screen_width/2, 1.0);
            
            
        } completion:^(BOOL finished) {
            
        }];
        
        
        // Custom Switch
        
        float btnX = 0;
        
        float btnHeight = 20*MULTIPLYHEIGHT;
        CGFloat viewW = 150*MULTIPLYHEIGHT;
        
        UIView *viewType = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2-viewW/2, yPos, viewW, btnHeight)];
        viewType.layer.cornerRadius = 13.0;
        viewType.backgroundColor = [UIColor clearColor];
        viewType.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
        viewType.layer.borderWidth = 0.6f;
        viewType.layer.masksToBounds = YES;
        [washTypesView addSubview:viewType];
        
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
                
                //btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                btn.backgroundColor = BLUE_COLOR;
                btn.selected = YES;
                
                btnSwitch = btn;
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
                
                [viewType sendSubviewToBack:btn];
            }
            
            //btn.layer.borderWidth = 1.0f;
            
            [btn addTarget:self action:@selector(btnOptionsSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            float btnWidth = viewW/2;
            
            btn.frame = CGRectMake(btnX, 0, btnWidth, viewType.frame.size.height);
            
            btnX += btnWidth-1;
        }
        
//        CGFloat sgX = 65 * MULTIPLYHEIGHT;
//        CGFloat sgH = 18 * MULTIPLYHEIGHT;
//        
//        segmentSwitch = [[UISegmentedControl alloc]initWithItems:@[@"REGULAR", @"EXPRESS"]];
//        segmentSwitch.frame = CGRectMake(sgX, yPos, screen_width-(sgX * 2), sgH);
//        [segmentSwitch setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateSelected];
//        [segmentSwitch setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLORCODE(64, 143, 210, 1.0), NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateNormal];
//        [segmentSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//        segmentSwitch.tintColor = RGBCOLORCODE(64, 143, 210, 1.0);
//        segmentSwitch.selectedSegmentIndex = 0;
//        [washTypesView addSubview:segmentSwitch];
        
//        mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake((screen_width/2)-(90/2),  yPos, 90, 25)];
//        //mySwitch2.center = CGPointMake(self.view.bounds.size.width * 0.5, 30);
//        //mySwitch2.inactiveColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
//        //mySwitch2.onTintColor = [UIColor colorWithRed:0.45f green:0.58f blue:0.67f alpha:1.00f];
//        [mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//        //    mySwitch2.offImage = [UIImage imageNamed:@"toggle_nonselected"];
//        //    mySwitch2.onImage = [UIImage imageNamed:@"toggle_selected"];
//        //mySwitch2.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
//        mySwitch2.activeColor = [UIColor clearColor];
//        mySwitch2.inactiveColor = [UIColor clearColor];
//        mySwitch2.onTintColor = [UIColor clearColor];
//        mySwitch2.onLabel.textColor = BLUE_COLOR;
//        mySwitch2.offLabel.textColor = [UIColor grayColor];
//        mySwitch2.isRounded = YES;
//        mySwitch2.shadowColor = [UIColor clearColor];
//        mySwitch2.activeBorderColor = BLUE_COLOR;
//        mySwitch2.inactiveBorderColor = RGBCOLORCODE(200, 200, 200, 1.0);
//        mySwitch2.onThumbImage = [UIImage imageNamed:@"thumb_selected"];
//        mySwitch2.offThumbImage = [UIImage imageNamed:@"thumb_nonselected"];
//        [mySwitch2 setOn:NO animated:YES];
//        [washTypesView addSubview:mySwitch2];
        
        
        yPos += 25+5*MULTIPLYHEIGHT;
        
        //        float lblOX = 95*MULTIPLYHEIGHT;
        //        float lblOWidth = 45*MULTIPLYHEIGHT;
        //        float lblH = 23*MULTIPLYHEIGHT;
        //
        //        lblOrderType = [[UILabel alloc]initWithFrame:CGRectMake(lblOX, yPos, lblOWidth, lblH)];
        //        lblOrderType.text = @"REGULAR";
        //        lblOrderType.textColor = RGBCOLORCODE(170, 170, 170, 1.0);
        //        lblOrderType.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
        //        [washTypesView addSubview:lblOrderType];
        //
        //        UISlider *sliderPer = [[UISlider alloc]initWithFrame:CGRectMake(lblOX+lblOWidth,  yPos, 35*MULTIPLYHEIGHT, lblH)];
        //        //sliderPer.thumbTintColor = RGBCOLORCODE(24, 157, 153, 1.0);
        //        sliderPer.tintColor = RGBCOLORCODE(24, 157, 153, 1.0);
        //        [sliderPer addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
        //        [washTypesView addSubview:sliderPer];
        //        sliderPer.continuous = NO;
        //        [sliderPer setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateNormal];
        //        [sliderPer setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateHighlighted];
        //
        //
        //        yPos += lblH+5*MULTIPLYHEIGHT;
        
        
        float lblSHeight = 16*MULTIPLYHEIGHT;
        
        lblSwitch = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, lblSHeight)];
        lblSwitch.textAlignment = NSTextAlignmentCenter;
        lblSwitch.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
        lblSwitch.textColor = RGBCOLORCODE(200, 200, 200, 1.0);
        [washTypesView addSubview:lblSwitch];
        lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
        
        lblSwitch.alpha = 0.0;
        
        [UIView animateWithDuration:0.2 delay:1.0 options:0 animations:^{
            
            lblSwitch.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
        }];
        
        timerSwitch = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(hidelblSwitch) userInfo:nil repeats:NO];
        
        
        yPos += lblSHeight + 15*MULTIPLYHEIGHT;
        
        float wmX = 11*MULTIPLYHEIGHT;
        
        UIView *washModeSelectionView = [[UIView alloc] initWithFrame:CGRectMake(wmX, yPos, (screen_width - (wmX*2)), 115.0*ratio)];
        washModeSelectionView.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        washModeSelectionView.layer.cornerRadius = 15.0;
        
        float segmentHeight = 22*MULTIPLYHEIGHT;
        
        scrollViewWashType = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10*MULTIPLYHEIGHT+segmentHeight, washModeSelectionView.frame.size.width, washModeSelectionView.frame.size.height-(10*MULTIPLYHEIGHT+segmentHeight+15*MULTIPLYHEIGHT))];
        scrollViewWashType.delegate = self;
        [washModeSelectionView addSubview:scrollViewWashType];
        //scrollViewWashType.scrollEnabled = NO;
        scrollViewWashType.showsHorizontalScrollIndicator = NO;
        scrollViewWashType.showsVerticalScrollIndicator = NO;
        scrollViewWashType.pagingEnabled = YES;
        
        UIImageView *imgTopStrip = [[UIImageView alloc]initWithFrame:CGRectMake(wmX+2*MULTIPLYHEIGHT, washModeSelectionView.frame.origin.y+washModeSelectionView.frame.size.height-4.7*MULTIPLYHEIGHT, (screen_width - ((wmX+2*MULTIPLYHEIGHT)*2)), 5*MULTIPLYHEIGHT)];
        imgTopStrip.contentMode = UIViewContentModeScaleAspectFill;
        imgTopStrip.image = [UIImage imageNamed:@"mywallet_topstrip.png"];
        //[washTypesView addSubview:imgTopStrip];
        
        [washTypesView addSubview:washModeSelectionView];
        
        
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
            
            float Width = viewType.frame.size.width/[arrTitles count];
            
            for (int i=0; i<arrTitles.count; i++) {
                
                UIButton *washBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                washBtn.frame = CGRectMake(i*(Width), 0, Width, viewType.frame.size.height);
                washBtn.tag = BOOK_VIEW_TAG + 20 + tagValue;
                //washBtn.backgroundColor = [UIColor redColor];
                washBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
                [washBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [washBtn setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
                [washBtn setTitle:[arrTitles objectAtIndex:i] forState:UIControlStateNormal];
                [washBtn setImage:[UIImage imageNamed:[arrIcons objectAtIndex:i]] forState:UIControlStateNormal];
                [washBtn setImage:[UIImage imageNamed:[arrSelIcons objectAtIndex:i]] forState:UIControlStateSelected];
                [washBtn addTarget:self action:@selector(selectWashType:) forControlEvents:UIControlEventTouchUpInside];
                [viewType addSubview:washBtn];
                
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
        
        
        float btnCX = wmX+20*MULTIPLYHEIGHT;
        float btnCWidth = screen_width-btnCX*2;
        float btnCHeight = 20*MULTIPLYHEIGHT;
        addOrMinusYPos = yPos-btnCHeight;
        
        LblDaysToDeliver = [[UILabel alloc] init];
        LblDaysToDeliver.frame = CGRectMake(btnCX, addOrMinusYPos, btnCWidth, btnCHeight);
        LblDaysToDeliver.textAlignment = NSTextAlignmentCenter;
        LblDaysToDeliver.backgroundColor = [UIColor clearColor];
        
        LblDaysToDeliver.text = [@"Pick your order type" uppercaseString];
        
        LblDaysToDeliver.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.FONT_SIZE_CUSTOM-5];
        LblDaysToDeliver.textColor = [UIColor blackColor];
        [washTypesView addSubview:LblDaysToDeliver];
        [washTypesView insertSubview:LblDaysToDeliver belowSubview:imgTopStrip];
        LblDaysToDeliver.backgroundColor = RGBCOLORCODE(244, 245, 246, 1.0);
        LblDaysToDeliver.alpha = 0.0;
        
//        LblDaysToDeliver.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
//        LblDaysToDeliver.layer.borderWidth = 1.0;
        
        yPos += btnCHeight+15*MULTIPLYHEIGHT;
        
        {
            float xPos = 14.4*MULTIPLYHEIGHT;;
            
            UIButton *instructionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            instructionsBtn.frame = CGRectMake(xPos, yPos, 90*MULTIPLYHEIGHT, 40.0*ratio);
            instructionsBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
            instructionsBtn.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
            [instructionsBtn setImage:[UIImage imageNamed:@"preferences_details_selected"] forState:UIControlStateNormal];
            instructionsBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
            [instructionsBtn setTitle:@"PREFERENCES" forState:UIControlStateNormal];
            [instructionsBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
            [instructionsBtn addTarget:self action:@selector(preferencesClicked:) forControlEvents:UIControlEventTouchUpInside];
            instructionsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [washTypesView addSubview:instructionsBtn];
            [instructionsBtn setTitleColor:[BLUE_COLOR colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
            
            
            float nextWidth = 55*MULTIPLYHEIGHT;
            float minusX = 75*MULTIPLYHEIGHT;
            
            UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nextBtn.frame = CGRectMake((screen_width - minusX), yPos, nextWidth, 40.0*ratio);
            [nextBtn setTitle:@"NEXT" forState:UIControlStateNormal];
            nextBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
            [nextBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
            [nextBtn addTarget:self action:@selector(nextBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
            [washTypesView addSubview:nextBtn];
            [nextBtn setTitleColor:[BLUE_COLOR colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
            
            UIImageView *nextIcon = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(nextBtn.bounds) - 10.0), 1.0, 16.0, CGRectGetHeight(nextBtn.bounds))];
            nextIcon.image = [UIImage imageNamed:@"next_arrow_blue"];
            nextIcon.userInteractionEnabled = NO;
            nextIcon.contentMode = UIViewContentModeScaleAspectFit;
            nextIcon.backgroundColor = PLACE_HOLDER_COLOR_INSTEAD_IMAGE;
            [nextBtn addSubview:nextIcon];
            
        }
    }
}

-(void) btnOptionsSelected:(UIButton *) btn
{
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
    btnDone.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
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
            frame.size.height -= 100*MULTIPLYHEIGHT;
            view_Popup.frame = frame;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        knowMoreExpanded = YES;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect frame = view_Popup.frame;
            frame.size.height += 100*MULTIPLYHEIGHT;
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
        
        [self showDaysToDeliver];
        
        [self GetDaysToDeliver];
    }
    
    selectedCurtainServiceType = @"";
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

//
//-(void) switchChanged:(SevenSwitch *)switch1
//{
//    if(switch1.on)
//    {
//        lblSwitch.text = [@"Next day Delivery" uppercaseString];
//        
//        [self.orderInfo setObject:ORDER_TYPE_EXPRESS forKey:ORDER_TYPE];
//    }
//    else
//    {
//        lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
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


-(void) switchChanged:(UISegmentedControl *)switch1
{
    if(switch1.selectedSegmentIndex == 1)
    {
        lblSwitch.text = [@"Next day Delivery" uppercaseString];
        
        [self.orderInfo setObject:ORDER_TYPE_EXPRESS forKey:ORDER_TYPE];
    }
    else
    {
        lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
        
        [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
    }
    
    [self showlblSwitch];
    
    [timerSwitch invalidate];
    timerSwitch = nil;
    
    timerSwitch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hidelblSwitch) userInfo:nil repeats:NO];
    
    [self GetDaysToDeliver];
}


-(NSString *) setTitleForAddress
{
    NSMutableString *str = [[NSMutableString alloc]init];
    
    if ([[self.selectedAddress objectForKey:@"name"]length])
    {
        [str appendString:[self.selectedAddress objectForKey:@"name"]];
    }
    
    if ([[self.selectedAddress  objectForKey:@"line1"]length] > 1)
    {
        [str appendString:[NSString stringWithFormat:@", %@", [self.selectedAddress  objectForKey:@"line1"]]];
    }
    else if ([[self.selectedAddress  objectForKey:@"line2"]length])
    {
        [str appendString:[NSString stringWithFormat:@", %@", [self.selectedAddress  objectForKey:@"line2"]]];
    }
    
    if ([[self.selectedAddress  objectForKey:@"zipcode"]length])
    {
        [str appendString:[NSString stringWithFormat:@", %@", [self.selectedAddress  objectForKey:@"zipcode"]]];
    }
    
    return str;
}

-(void) sliderChanged:(UISlider *)slider
{
    
    if (slider.value > previousSliderValue || previousSliderValue == 0)
    {
        lblOrderType.text = @"EXPRESS";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [slider setValue:1.0 animated:YES];
            
        } completion:^(BOOL finished) {
            
        }];
        
        [slider setThumbImage:[UIImage imageNamed:@"selected_thumb"] forState:UIControlStateNormal];
        [slider setThumbImage:[UIImage imageNamed:@"selected_thumb"] forState:UIControlStateHighlighted];
    }
    else
    {
        lblOrderType.text = @"REGULAR";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [slider setValue:0 animated:YES];
            
        } completion:^(BOOL finished) {
            
        }];
        
        [slider setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateNormal];
        [slider setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateHighlighted];
    }
    
    previousSliderValue = slider.value;
    
    if(slider.value == 1.0f)
    {
        lblSwitch.text = [@"Next day Delivery" uppercaseString];
        
        [self.orderInfo setObject:ORDER_TYPE_EXPRESS forKey:ORDER_TYPE];
    }
    else
    {
        lblSwitch.text = [@"Minimum 3 day Delivery" uppercaseString];
        
        [self.orderInfo setObject:ORDER_TYPE_REGULAR forKey:ORDER_TYPE];
    }
    
    [self showlblSwitch];
    
    [timerSwitch invalidate];
    timerSwitch = nil;
    
    timerSwitch = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hidelblSwitch) userInfo:nil repeats:NO];
    
    [self GetDaysToDeliver];
}

- (void) createDeliveryDetailsView {
    
    float ddY = 73*MULTIPLYHEIGHT;
    
    deliveryDetailsView = [[UIView alloc] initWithFrame:CGRectMake(screen_width, ddY, screen_width, pingoDetailsView.frame.size.height-ddY)];
    deliveryDetailsView.backgroundColor = [UIColor whiteColor];
    [pingoDetailsView addSubview:deliveryDetailsView];
    
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    float yPos = 10.0;
    float ratio = MULTIPLYHEIGHT;
    
    float xPos = 14.4*MULTIPLYHEIGHT;
    
    float height = 35*ratio;
    
    {
        addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addressBtn.tag = BOOK_VIEW_TAG + 6;
        addressBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        addressBtn.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [addressBtn setTitle:@"SILOSO BEACH, SINGAPORE" forState:UIControlStateNormal];
        [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        addressBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        addressBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 35*MULTIPLYHEIGHT, 0.0, 26*MULTIPLYHEIGHT);
        [addressBtn addTarget:self action:@selector(selectDeliveryAddress:) forControlEvents:UIControlEventTouchUpInside];
        [deliveryDetailsView addSubview:addressBtn];
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
    
    yPos += height+25*MULTIPLYHEIGHT;
    
    {
        UIButton *deliveryDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deliveryDateBtn.tag = BOOK_VIEW_TAG + 20;
        deliveryDateBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        deliveryDateBtn.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        [deliveryDateBtn addTarget:self action:@selector(selectDeliveryDate:) forControlEvents:UIControlEventTouchUpInside];
        [deliveryDetailsView addSubview:deliveryDateBtn];
        [deliveryDateBtn setBackgroundImage:[AppDelegate imageWithColor:[[UIColor grayColor]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
        deliveryDateBtn.layer.cornerRadius = 15.0;
        deliveryDateBtn.clipsToBounds = YES;
        
        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(xPos+20*MULTIPLYHEIGHT, 0.0, CGRectGetWidth(deliveryDateBtn.bounds), CGRectGetHeight(deliveryDateBtn.bounds))];
        dateLbl.tag = BOOK_VIEW_TAG + 8;
        dateLbl.text = @"DELIVERY DATE : TIME";
        dateLbl.textAlignment = NSTextAlignmentLeft;
        dateLbl.textColor = [UIColor grayColor];
        dateLbl.backgroundColor = [UIColor clearColor];
        dateLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        dateLbl.userInteractionEnabled = NO;
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
        cardBtnBtn.tag = BOOK_VIEW_TAG + 11;
        cardBtnBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        cardBtnBtn.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [cardBtnBtn addTarget:self action:@selector(selectDeliveryAddress:) forControlEvents:UIControlEventTouchUpInside];
        [deliveryDetailsView addSubview:cardBtnBtn];
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
        lblCard.tag = BOOK_VIEW_TAG + 12;
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
    
    {
        
        promocodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        promocodeBtn.frame = CGRectMake(xPos, yPos, (CGRectGetWidth(screenBounds) - (xPos*2)), height);
        promocodeBtn.backgroundColor = [UIColor clearColor];
        [promocodeBtn setBackgroundImage:[UIImage imageNamed:@"promocode_bg"] forState:UIControlStateNormal];
        [promocodeBtn addTarget:self action:@selector(selectPromocode:) forControlEvents:UIControlEventTouchUpInside];
        [deliveryDetailsView addSubview:promocodeBtn];
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
        
        
    }
    
    yPos += height + 20*MULTIPLYHEIGHT;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(xPos, yPos, screen_width - (xPos*2), height);
    confirmBtn.backgroundColor = APPLE_BLUE_COLOR;
    [confirmBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"PIING!" uppercaseString] andWithColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] andFont:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-2]] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmPiing:) forControlEvents:UIControlEventTouchUpInside];
    [deliveryDetailsView addSubview:confirmBtn];
    [confirmBtn setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    confirmBtn.layer.cornerRadius = 15.0;
    confirmBtn.clipsToBounds = YES;
}

-(NSMutableAttributedString *) setDeliveryAttributedText
{
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSDate *date = [dtFormatter dateFromString:[self.orderInfo objectForKey:ORDER_DELIVERY_DATE]];
    
    [dtFormatter setDateFormat:@"dd MMM, EEE"];
    
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
    //view_Popup.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view_Popup.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:view_Popup];
    view_Popup.alpha = 0.0;
    
    
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
    
    yAxis += 5;
    
    float imgX = 36*MULTIPLYHEIGHT;
    
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
    UIButton *btnClose = (UIButton *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+1];
    UILabel *lblTitle = (UILabel *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+2];
    UITextField *tfPC = (UITextField *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+3];
    UIButton *btnSubmit1 = (UIButton *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+4];
    UILabel *lblDiscount = (UILabel *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+5];
    UIImageView *imgPic = (UIImageView *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+6];
    UIImageView *imgLine = (UIImageView *) [view_UnderPopup viewWithTag:REDEEM_VIEW_TAG+10];
    
    if (![tfPC.text length])
    {
        [appDel showAlertWithMessage:@"Please enter promo code" andTitle:@"" andBtnTitle:@"OK"];
        
        return;
    }
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", tfPC.text, @"promoCode", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@promo/check", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            [self.orderInfo setObject:[responseObj objectForKey:@"code"] forKey:PROMO_CODE];
            
            btnClose.hidden = YES;
            btnSubmit1.hidden = YES;
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
            
            [UIView animateKeyframesWithDuration:0.3 delay:2.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                
                view_Popup.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                [view_Popup removeFromSuperview];
                view_Popup = nil;
                
            }];
        }
        else {
            
            lblPromocode.text = @"ENTER PROMO CODE";
            [self.orderInfo setObject:@"" forKey:PROMO_CODE];
            
            tfPC.text = @"";
            UIColor *color = [UIColor redColor];
            tfPC.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[responseObj objectForKey:@"error"] attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]}];
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
    
    
    textField.text = @"";
    UIColor *color = APPLE_BLUE_COLOR;
    
    if (textField.tag == REDEEM_VIEW_TAG + 3)
    {
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter promo code" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]}];
    }
    else if (textField == passwordTF)
    {
        if (![btnSubmit isUserInteractionEnabled])
        {
            textField.text = @"";
        }
        
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Password" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4]}];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == passwordTF)
    {
        if (![string length] && ([textField.text length] == 1))
        {
            btnSubmit.userInteractionEnabled = NO;
            [btnSubmit setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        }
        else
        {
            btnSubmit.userInteractionEnabled = YES;
            [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    return YES;
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


#pragma mark FPPopover Delegate Method
-(void) didSelectFromList:(NSString *) string AtIndex:(NSInteger)row
{
    UIButton *cardBtn = (UIButton *)[self.view viewWithTag:BOOK_VIEW_TAG + 11];
    
    UILabel *lblCard = (UILabel *)[self.view viewWithTag:BOOK_VIEW_TAG + 12];
    
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
        addressBtn.selected = NO;
        [addressBtn setTitle:string forState:UIControlStateNormal];
        [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        self.selectedAddress = [self.userAddresses objectAtIndex:row];
        
        [self.orderInfo setObject:[self.selectedAddress objectForKey:@"_id"] forKey:ORDER_DELIVERY_ADDRESS_ID];
    }
    
    else if (cardBtn.selected)
    {
        cardBtn.selected = NO;
        
        selectedCard = [self.userSavedCards objectAtIndex:row];
        
        [cardIconView sd_setImageWithURL:[NSURL URLWithString:[selectedCard objectForKey:@"cardTypeImage"]]
                        placeholderImage:[UIImage imageNamed:@"cash_icon"]];
        
        lblCard.text = [selectedCard objectForKey:@"maskedCardNo"];
        lblCard.textColor = [UIColor grayColor];
        
        [self.orderInfo setObject:[selectedCard objectForKey:@"_id"] forKey:ORDER_CARD_ID];
    }
    
}


-(void) didSelectDateAndTime:(NSArray *)array
{
    [self.orderInfo setObject:[array objectAtIndex:0] forKey:ORDER_DELIVERY_DATE];
    [self.orderInfo setObject:[array objectAtIndex:1] forKey:ORDER_DELIVERY_SLOT];
    
    UILabel *deliveryDateLbl = (UILabel *)[self.view viewWithTag:BOOK_VIEW_TAG + 8];
    
    deliveryDateLbl.attributedText = [self setDeliveryAttributedText];
}


#pragma mark - Action Event Handlers

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

- (void)selectWashType:(UIButton *)sender {
    
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
        NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", @"B", @"orderType", arraySelectedServiceTypes, @"serviceTypes", [self.orderInfo objectForKey:ORDER_TYPE], @"orderSpeed", nil];
        
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
                                btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                                btn.backgroundColor = BLUE_COLOR;
                                
                                btnSwitch = btn;
                            }
                            else if (btn.tag == 2)
                            {
                                btn.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
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
    
    backBtn.hidden = NO;
    
    if ([arraySelectedServiceTypes count]) {
        
        if (![[NSUserDefaults standardUserDefaults] objectForKey:PREFERENCES_OPENED])
        {
            prefsOpenedAutomatically = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:PREFERENCES_OPENED];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self preferencesClicked:nil];
            
            return;
        }
        
        [self gotoDeliveryScreen];
    }
    else {
        [appDel showAlertWithMessage:@"Please select wash type" andTitle:@"" andBtnTitle:@"OK"];
    }
    
}

-(void) gotoDeliveryScreen
{
    [self.orderInfo removeObjectForKey:ORDER_DELIVERY_DATE];
    [self.orderInfo removeObjectForKey:ORDER_DELIVERY_SLOT];
    
    CGRect rect = deliveryDetailsView.frame;
    rect.origin.x = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        deliveryDetailsView.frame = rect;
        
        progressView_Blue.frame = CGRectMake(0.0, 100.0, screen_width, 2.0);
        progressView_Grey.frame = CGRectMake(screen_width, 101.0, 0, 1.0);
        
        
    } completion:^(BOOL finished) {
        
        UILabel *deliveryDateLbl = (UILabel *)[self.view viewWithTag:BOOK_VIEW_TAG + 8];
        deliveryDateLbl.text = @"DELIVERY DATE : TIME";
        
    }];
}

- (void)closeScheduleScreen:(UIButton *)sender {
    
    
    if (self.isFromBookNow)
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you want to cancel the order?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alertController addAction:defaultAction];
        
        UIAlertAction* actionYes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                    {
                                        appDel.isBookNowPending = NO;
                                        
                                        NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", self.bookNowCobID, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
                                        
                                        NSString *urlStr = [NSString stringWithFormat:@"%@order/cancel", BASE_URL];
                                        
                                        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
                                        
                                        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                                            
                                            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                                            
                                            if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                                                
                                                [appDel showAlertWithMessage:@"You have canceled order successfully." andTitle:@"" andBtnTitle:@"OK"];
                                                
                                                [appDel showTabBar:appDel.customTabBarController];
                                                
                                                if (socketMain)
                                                {
                                                    [socketMain disconnect];
                                                    socketMain = nil;
                                                }
                                                
                                                [UIView animateWithDuration:0.3 animations:^{
                                                    
                                                    self.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                                                    
                                                } completion:^(BOOL finished) {
                                                    
                                                    appDel.isUpdatePiingo = YES;
                                                    
                                                    self.isBookNowStarted = NO;
                                                    [self.parentViewController viewWillAppear:YES];
                                                    [self.view removeFromSuperview];
                                                }];
                                            }
                                            else {
                                                
                                                [appDel displayErrorMessagErrorResponse:responseObj];
                                            }
                                            
                                        }];
                                        
                                    }];
        
        [alertController addAction:actionYes];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to cancel the order?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
        //        alert.tag = 500;
        //        [alert show];
        
    }
    
    else if (isFromReloadOrder)
    {
        [appDel setBottomTabBarIndex:1];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
            
        } completion:^(BOOL finished) {
            
            self.isBookNowStarted = NO;
            
            appDel.customTabBarController.selectedIndex = 1;
            [self.view removeFromSuperview];
            
        }];
    }
    else
    {
        
        UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Are you sure you want to cancel the order?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", self.bookNowCobID, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@order/cancel", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                        
                        if (socketMain)
                        {
                            [socketMain disconnect];
                            socketMain = nil;
                        }
                        
                        if (appDel.isDeleteBookView)
                        {
                            appDel.isDeleteBookView = NO;
                            appDel.customTabBarController.selectedIndex = 1;
                        }
                        else
                        {
                            [self backClicked];
                        }
                        
                        [self performSelector:@selector(popView) withObject:nil afterDelay:0.1];
                        
                    }
                    else {
                        
                        [appDel displayErrorMessagErrorResponse:responseObj];
                    }
                }];
                
            }];
            
        }];
        
        [Alert addAction:cancelAction];
        [Alert addAction:okAction];
        [self presentViewController:Alert animated:YES completion:nil];
        
    }
    
}

- (void)backToPreviousScreen {
    
    if (appDel.isDeleteBookView)
    {
        appDel.isDeleteBookView = NO;
        appDel.customTabBarController.selectedIndex = 1;
    }
    else
    {
        if (socketMain)
        {
            [socketMain disconnect];
            socketMain = nil;
        }
        
        if (self.isFromBookNow)
        {
            backBtn.hidden = YES;
            
            CGRect rect = deliveryDetailsView.frame;
            rect.origin.x = screen_width;
            [UIView animateWithDuration:0.3 animations:^{
                
                deliveryDetailsView.frame = rect;
                
                progressView_Blue.frame = CGRectMake(0.0, 100.0, screen_width/2, 2.0);
                progressView_Grey.frame = CGRectMake(screen_width/2, 101.0, screen_width/2, 1.0);
                
                
            } completion:^(BOOL finished) {
                
            }];
        }
        else
        {
            [self backClicked];
        }
    }
}

-(void) backClicked
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 500)
    {
        if (buttonIndex == 1)
        {
            appDel.isBookNowPending = NO;
            
            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", self.bookNowCobID, @"cobid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@cancelorder/services.do?", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame){
                    
                    [appDel showAlertWithMessage:@"You have canceled order successfully." andTitle:@"" andBtnTitle:@"OK"];
                    
                    [appDel showTabBar:appDel.customTabBarController];
                    
                    if (socketMain)
                    {
                        [socketMain disconnect];
                        socketMain = nil;
                    }
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        self.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                        
                    } completion:^(BOOL finished) {
                        
                        appDel.isUpdatePiingo = YES;
                        
                        self.isBookNowStarted = NO;
                        
                        [self.parentViewController viewWillAppear:YES];
                        [self.view removeFromSuperview];
                    }];
                }
                else {
                    
                    [appDel displayErrorMessagErrorResponse:responseObj];
                }
                
            }];
            
        }
        
    }
    else if (alertView.tag == 501)
    {
        if (buttonIndex == 1)
        {
            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", self.bookNowCobID, @"cobid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@cancelorder/services.do?", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame){
                        
                        [self backClicked];
                        
                        [self performSelector:@selector(popView) withObject:nil afterDelay:0.3];
                        
                    }
                    else {
                        
                        [appDel displayErrorMessagErrorResponse:responseObj];
                    }
                }];
                
            }];
        }
    }
}

-(void) popView
{
    [appDel showAlertWithMessage:@"You have canceled order successfully." andTitle:@"" andBtnTitle:@"OK"];
}


#pragma mark - Delivery Details Action Handler

- (void)selectDeliveryDate:(UIButton *)sender {
    
    [self fetchDeliveryDates];
}

- (void)selectDeliveryAddress:(UIButton *)sender
{
    UIButton *cardBtn = (UIButton *)[self.view viewWithTag:BOOK_VIEW_TAG + 11];
    UILabel *lblCard = (UILabel *)[self.view viewWithTag:BOOK_VIEW_TAG + 12];
    
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
    
    customPopOverView.isFromTag = 3;
    customPopOverView.delegate = self;
    [deliveryDetailsView addSubview:customPopOverView];
    customPopOverView.alpha = 0.0;
    
    int yVal = addressBtn.frame.origin.y;
    
    customPopOverView.frame = CGRectMake(0, yVal+addressBtn.frame.size.height, screen_width, deliveryDetailsView.frame.size.height-(yVal+addressBtn.frame.size.height+100*MULTIPLYHEIGHT));
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        customPopOverView.alpha = 1.0;
        
        if (addressBtn == sender)
        {
            CGRect frame = addressBtn.frame;
            frame.origin.y = yVal;
            //addressBtn.frame = frame;
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

-(void) didAddNewAddress
{
    [self closeCustomPopover];
    
    [self getAddress];
}

-(void) closeCustomPopover
{
    UIButton *cardBtn = (UIButton *)[self.view viewWithTag:BOOK_VIEW_TAG + 11];
    UILabel *lblCard = (UILabel *)[self.view viewWithTag:BOOK_VIEW_TAG + 12];
    
    [UIView animateWithDuration:0.2 delay:0.1 options:0 animations:^{
        
        customPopOverView.alpha = 0.0;
        
        if (addressBtn.selected)
        {
            addressBtn.selected = NO;
            [addressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            CGRect frame = addressBtn.frame;
            frame.origin.y = previousAddressYAxis;
            addressBtn.frame = frame;
        }
        else if (cardBtn.selected)
        {
            cardBtn.selected = NO;
            lblCard.textColor = [UIColor grayColor];
            
            CGRect frame = cardBtn.frame;
            frame.origin.y = previousAddressYAxis;
            cardBtn.frame = frame;
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
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", nil];
    
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

- (void)confirmPiing:(UIButton *)sender {
    
    if([self.orderInfo objectForKey:ORDER_DELIVERY_DATE] && [self.orderInfo objectForKey:ORDER_DELIVERY_SLOT] && [self.orderInfo objectForKey:ORDER_CARD_ID])
    {
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
        
        NSString *strJobType = @"";
        
        for (int i = 0; i < [arraySelectedServiceTypes count]; i++)
        {
            strJobType = [strJobType stringByAppendingString:[NSString stringWithFormat:@"%@,", [arraySelectedServiceTypes objectAtIndex:i]]];
        }
        
        if ([strJobType hasSuffix:@","])
        {
            strJobType = [strJobType substringToIndex:[strJobType length]-1];
        }
        
        [self.orderInfo setObject:strJobType forKey:ORDER_JOB_TYPE];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@order/update", BASE_URL];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:self.orderInfo andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                
                appDel.isBookNowPending = NO;
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                [self orderBookedGif];
                
                if (socketMain)
                {
                    [socketMain disconnect];
                    socketMain = nil;
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                    
                } completion:^(BOOL finished) {
                    
                    appDel.isUpdatePiingo = YES;
                    
                    self.isBookNowStarted = NO;
                    
                    [self.view removeFromSuperview];
                }];
                
                appDel.directlyGotoOrderDetails = YES;
                appDel.customTabBarController.selectedIndex = 1;
            }
            else {
                [appDel displayErrorMessagErrorResponse:responseObj];
            }
        }];
    }
    else {
        [appDel showAlertWithMessage:@"Please select required fields" andTitle:@"Error" andBtnTitle:@"OK"];
    }
}

-(void) orderBookedGif
{
    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
        
        view_OrderBooked = [[UIView alloc]initWithFrame:appDel.window.bounds];
        view_OrderBooked.backgroundColor = [UIColor whiteColor];
        [appDel.window addSubview:view_OrderBooked];
        
        NSString*thePath = [[NSBundle mainBundle] pathForResource:@"order_booked" ofType:@"mp4"];
        NSURL *theurl = [NSURL fileURLWithPath:thePath];
        
        if (self.backGroundplayer)
        {
            [self.backGroundplayer.view removeFromSuperview];
            self.backGroundplayer = NULL;
        }
        
        self.backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
        
        float bgImgHeight = 130*MULTIPLYHEIGHT;
        self.backGroundplayer.view.frame = CGRectMake(0, screen_height/2-(bgImgHeight/2), screen_width, bgImgHeight);
        
        self.backGroundplayer.repeatMode = YES;
        self.backGroundplayer.view.userInteractionEnabled = YES;
        self.backGroundplayer.controlStyle = MPMovieControlStyleNone;
        [self.backGroundplayer prepareToPlay];
        [self.backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
        //self.backGroundplayer.movieSourceType = MPMovieSourceTypeStreaming;
        self.backGroundplayer.backgroundView.backgroundColor = [UIColor whiteColor];
        self.backGroundplayer.view.backgroundColor = [UIColor whiteColor];
        [view_OrderBooked addSubview:self.backGroundplayer.view];
        
        [self.backGroundplayer play];
        
        //[self.backGroundplayer performSelector:@selector(play) withObject:nil afterDelay:0.5];
        
        [self.backGroundplayer setScalingMode:MPMovieScalingModeAspectFit];
        
        if (blur)
        {
            [blur removeFromSuperview];
            blur = nil;
        }
        
        if (view_BlurBGForBookNow)
        {
            [view_BlurBGForBookNow removeFromSuperview];
            view_BlurBGForBookNow = nil;
        }
        
        CGFloat yPos = screen_height-80*MULTIPLYHEIGHT;
        
        float btnWidth = screen_width/2-(20*MULTIPLYHEIGHT);
        float btnHeight = 50*MULTIPLYHEIGHT;
        
        UIView *bottomViewForOrder1 = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2-((btnWidth*2)/2.2), yPos, btnWidth*2, btnHeight)];
        bottomViewForOrder1.backgroundColor = [UIColor clearColor];
        [view_OrderBooked addSubview:bottomViewForOrder1];
        
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
            [bottomViewForOrder1 addSubview:btn];
            
            [btn centerImageAndTitle:10*MULTIPLYHEIGHT];
            
            xPos += btnWidth;
            
        }
        
    }];
}

-(void) addToCalenderOrDone:(UIButton *) sender
{
    if (sender.tag == 1)
    {
        appDel.automaticAddtoCalendar = YES;
        [self btnAddToCalendar];
    }
    else if (sender.tag == 2)
    {
        
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


#pragma mark - Order Details Actions
- (void)editOrder:(UIButton *)sender {
    
//    if ([[self.orderEditDetails objectForKey:@"isUpdateOrder"] caseInsensitiveCompare:@"n"] == NSOrderedSame)
//    {
//        [appDel showAlertWithMessage:@"Update Order is not available." andTitle:@"" andBtnTitle:@"OK"];
//    }
//    else
//    {
//        
//        ScheduleLaterViewController_New *scheduleVC = [[ScheduleLaterViewController_New alloc] init];
//        scheduleVC.isFromUpdateOrder = YES;
//        scheduleVC.bookNowCobID = self.bookNowCobID;
//        scheduleVC.dictUpdateOrder = [[NSMutableDictionary alloc]initWithDictionary:self.orderEditDetails];
//        scheduleVC.dictChangedValues = [[NSMutableDictionary alloc]initWithDictionary:self.orderEditDetails];
//        
//        UINavigationController *navSL = [[UINavigationController alloc]initWithRootViewController:scheduleVC];
//        navSL.navigationBarHidden = YES;
//        
//        [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
//            
//            [self addChildViewController:navSL];
//            [self.view addSubview:navSL.view];
//            
//        } completion:nil];
//        
//    }
    
    if ([[self.orderEditDetails objectForKey:@"statusCode"] isEqualToString:@"OD"])
    {
        return;
    }
    
    [FIRAnalytics logEventWithName:@"update_order_button" parameters:nil];
    
    ScheduleLaterViewController_New *scheduleVC = [[ScheduleLaterViewController_New alloc] init];
    scheduleVC.isFromUpdateOrder = YES;
    scheduleVC.bookNowCobID = self.bookNowCobID;
    scheduleVC.dictUpdateOrder = [[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    
    scheduleVC.dictChangedValues = [[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    [scheduleVC.dictChangedValues setObject:[self.orderEditDetails objectForKey:@"pcmsg"] forKey:@"pcmsg"];
    
    scheduleVC.dictAllowFields = [[NSMutableDictionary alloc]initWithDictionary:self.dictAllowUpdates];
    scheduleVC.arrayJobTypeOrg = [[NSMutableArray alloc]initWithArray:[self.orderEditDetails objectForKey:ORDER_JOB_TYPE]];
    
    scheduleVC.arrayAllOrderDetails = [[NSMutableDictionary alloc]initWithDictionary:self.orderEditDetails];
    
    UINavigationController *navSL = [[UINavigationController alloc]initWithRootViewController:scheduleVC];
    navSL.navigationBarHidden = YES;
    
    [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        [self addChildViewController:navSL];
        [self.view addSubview:navSL.view];
        
    } completion:nil];

}

- (void)showBill:(UIButton *)sender {
    
    [FIRAnalytics logEventWithName:@"show_bill_button" parameters:nil];
    
    if ([[self.orderEditDetails objectForKey:@"billStatus"] caseInsensitiveCompare:@"NA"] == NSOrderedSame)
    {
        PriceEstimatorViewController_New *vc = [[PriceEstimatorViewController_New alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden = YES;
        
        [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [self addChildViewController:nav];
            [self.view addSubview:nav.view];
            
        } completion:nil];
    }
    else
    {
        ViewBillController *vc = [[ViewBillController alloc] init];
        
        vc.strPaymentType = [self.orderEditDetails objectForKey:ORDER_CARD_ID];
        vc.strCobID = [self.orderEditDetails objectForKey:@"oid"];
        vc.strUserId = [self.orderEditDetails objectForKey:@"uid"];
        vc.isPartialBill = [[self.orderEditDetails objectForKey:@"partial"] boolValue];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        nav.navigationBarHidden = YES;
        
        [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [self addChildViewController:nav];
            [self.view addSubview:nav.view];
            
        } completion:nil];
        
        //[self presentViewController:nav animated:YES completion:nil];
    }
}

- (void)dropAtDoor:(UIButton *)sender
{
    
    btnDropAtDoor = (UIButton *)sender;
    
    if (btnDropAtDoor.selected)
    {
        UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Are you sure you want to cancel 'Deliver At Door'?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {}];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            
            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", @"", @"deliverAtDoorNote", [self.orderEditDetails objectForKey:@"oid"], @"oid", @"0", @"deliverAtDoor", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@order/deliveratdoor", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                
                if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                {
                    btnDropAtDoor.selected = NO;
                }
                
                else {
                    [appDel displayErrorMessagErrorResponse:responseObj];
                }
                
            }];
            
        }];
        
        [Alert addAction:cancelAction];
        [Alert addAction:okAction];
        [self presentViewController:Alert animated:YES completion:nil];
    }
    else
    {
        DropAtDoorViewController *obj = [[DropAtDoorViewController alloc]init];
        obj.view.frame = self.view.bounds;
        obj.orderEditDetails = [[NSMutableDictionary alloc]initWithDictionary:self.orderEditDetails];
        obj.delegate = self;
        
        [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [self addChildViewController:obj];
            [self.view addSubview:obj.view];
            
        } completion:nil];
    }
}

-(void) preferencesClicked:(UIButton *) sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:PREFERENCES_OPENED];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    PreferencesViewController *objPre = [[PreferencesViewController alloc]init];
    objPre.delegate = self;
    
    if ([self.dictAllowUpdates count] && [[self.dictAllowUpdates objectForKey:@"preferences"] intValue] == 0)
    {
        objPre.notEditable = YES;
    }
    
    objPre.strPrefs = [self.orderInfo objectForKey:PREFERENCES_SELECTED];
    
    objPre.isFromOrderDetails = self.isFromOrdersList;
    
    [self presentViewController:objPre animated:YES completion:nil];
}

-(void) didAddPreferences:(NSString *)strPrefs
{
    [self.orderInfo setObject:strPrefs forKey:PREFERENCES_SELECTED];
    
    if (prefsOpenedAutomatically)
    {
        prefsOpenedAutomatically = NO;
        
        [self gotoDeliveryScreen];
    }
}

-(void) didFinishDropAtDoor
{
    btnDropAtDoor.selected = YES;
}


#pragma mark - API implementation

- (void)fetchDeliveryDates
{
    NSString *pickUDate = [self.orderInfo objectForKey:ORDER_PICKUP_DATE];
    NSString *pickUSlot = [self.orderInfo objectForKey:ORDER_PICKUP_SLOT];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [self.selectedAddress objectForKey:@"_id"], @"deliveryAddressId", arraySelectedServiceTypes, @"serviceTypes", pickUDate, @"pickUpDate", pickUSlot, @"pickUpSlotId", [self.orderInfo objectForKey:ORDER_TYPE], @"orderSpeed", @"B", @"orderType", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/deliverydates", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            [arraAlldata removeAllObjects];
            [self.deliveryDates removeAllObjects];
            [dictDeliveryDatesAndTimes removeAllObjects];
            
            [arraAlldata addObjectsFromArray:[responseObj objectForKey:@"dates"]];
            
            for (int i = 0; i < [arraAlldata count]; i++)
            {
                [self.deliveryDates addObject:[[arraAlldata objectAtIndex:i]objectForKey:@"date"]];
                
                [dictDeliveryDatesAndTimes setObject:[[arraAlldata objectAtIndex:i]objectForKey:@"slots"] forKey:[[arraAlldata objectAtIndex:i]objectForKey:@"date"]];
            }
            
            [self clickedOnDeliverydate];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];

}

-(void) clickedOnDeliverydate
{
    
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
    NSArray *givenList = arraAlldata;
    
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
    
    if (![self.deliveryDates count])
    {
        [appDel showAlertWithMessage:@"Delivery dates are not available at this time." andTitle:@"" andBtnTitle:@"OK"];
        
        return;
    }
    
    DateTimeViewController *objDt = [[DateTimeViewController alloc]init];
    
    objDt.isFromDelivery = YES;
    objDt.isFromBookNow = YES;
    
    objDt.delegate = self;
    objDt.arrayDates = [[NSMutableArray alloc]initWithArray:list];
    objDt.selectedAddress = [[NSMutableDictionary alloc]initWithDictionary:self.selectedAddress];
    objDt.orderInfo = [[NSMutableDictionary alloc]initWithDictionary:self.orderInfo];
    
    objDt.dictDatesAndTimes = [[NSMutableDictionary alloc]initWithDictionary:dictDeliveryDatesAndTimes];
    
    objDt.selectedDate = [self.orderInfo objectForKey:ORDER_DELIVERY_DATE];
    objDt.strSelectedTimeSlot = [self.orderInfo objectForKey:ORDER_DELIVERY_SLOT];
    
    [self presentViewController:objDt animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", nil];
    
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
                                  
                                  NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nonce.nonce, @"paymentMethodNonce", nil];
                                  
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
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            NSDictionary *dict = [responseObj objectForKey:@"paymentMethod"];
            
            NSMutableArray *arrayCards = [appDel getAllSavedCards:dict];
            
            [PiingHandler sharedHandler].userSavedCards = arrayCards;
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
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
