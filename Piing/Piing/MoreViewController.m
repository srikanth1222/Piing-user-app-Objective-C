//
//  MenuViewController.m
//  Ping
//
//  Created by SHASHANK on 25/02/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "MoreViewController.h"

#import "HomePageViewController.h"
#import "ShareViewController.h"
#import "RecurringViewController.h"

#import "AddressListViewController.h"

#import "MyBookingViewController.h"
#import "MyProfileDetailsViewController.h"
#import "UIButton+CenterImageAndTitle.h"

#import "RecurringListController.h"
#import "PromotionsViewController.h"
#import "PaymentViewController_More.h"
#import "PaymentListViewController.h"
#import "ForgetPasswordViewController.h"
#import "AddressListViewController_Map.h"
#import "FAQViewController.h"
#import "FXBlurView.h"
#import "PreferencesViewController.h"
#import <FirebaseAnalytics/FIRAnalytics.h>



@interface MoreViewController () <UITextFieldDelegate>
{
    BOOL isAccountOpen;
    AppDelegate *appdel;
    NSArray *titlesSecOne, *titlesImagesSecOne;
    NSArray *titlesSecTwo, *titlesImagesSecTwo;
    NSArray *titlesSecThree, *titlesImagesSecThree;
    NSArray *subTitlesImages, *subTitles;
    
    long int selectedIndex,selectedRowIndex;
    
    UIImageView *bgImageView;
    UIButton *piingPinTitleLbl;
    
    UILabel *userNameLbl;
    UIView *view_Popup;
    UIView *view_Pin_Popup;
    UIView *view_Tourist;
    
    UILabel *LblEnterText;
    UIButton *btnSubmit;
    
    UITextField *paswordTF, *PinpaswordTF;
    
    MPMoviePlayerController *backGroundplayer;
    
    NSMutableDictionary *dictUserDetails;
    
    UIView *view_Share;
    
    FXBlurView *blurEffect;
    UIView *view_UnderShare;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation MoreViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    dictUserDetails = [[NSMutableDictionary alloc]init];
    
    appdel = [PiingHandler sharedHandler].appDel;
    
    ///////
    
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"more_bg" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    
    backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
    backGroundplayer.view.frame = CGRectMake(0, 0, screen_width, screen_height);
    backGroundplayer.repeatMode = YES;
    backGroundplayer.view.userInteractionEnabled = YES;
    backGroundplayer.controlStyle = MPMovieControlStyleNone;
    [backGroundplayer prepareToPlay];
    [backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
    [self.view addSubview:backGroundplayer.view];
    [backGroundplayer play];
    [backGroundplayer setScalingMode:MPMovieScalingModeAspectFill];
    
//    UIView *blackTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
//    //blackTransparentView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
//    //blackTransparentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    [appdel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
//    [self.view addSubview:blackTransparentView];
    
    
    ////////
    
    
    
    bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    bgImageView.image = [UIImage imageNamed:@"More_BG"];
    //[self.view addSubview:bgImageView];
    
    UIView *view_BG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //view_BG.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    view_BG.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    //[self.view addSubview:view_BG];
    
    isAccountOpen = NO;
    
    CGFloat ypos = 35*MULTIPLYHEIGHT;
    
    float logoX = 58*MULTIPLYHEIGHT;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-(logoX/2), ypos, logoX, logoX)];
    logoImageView.image = [UIImage imageNamed:@"bellicon.png"];
    [self.view addSubview: logoImageView];
    
    ypos += logoX+5*MULTIPLYHEIGHT;
    
    
    float piingpinHeight = 22*MULTIPLYHEIGHT;
    
    piingPinTitleLbl = [UIButton buttonWithType:UIButtonTypeCustom];
    piingPinTitleLbl.frame = CGRectMake(screen_width/2-100, ypos, 200, piingpinHeight);
    piingPinTitleLbl.backgroundColor = [UIColor clearColor];
    [piingPinTitleLbl setTitle:@"PIING PIN #" forState:UIControlStateNormal];
    [piingPinTitleLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    piingPinTitleLbl.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appdel.FONT_SIZE_CUSTOM];
    [self.view addSubview:piingPinTitleLbl];
    [piingPinTitleLbl setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
    piingPinTitleLbl.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    piingPinTitleLbl.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    piingPinTitleLbl.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [piingPinTitleLbl addTarget:self action:@selector(editPiingPin) forControlEvents:UIControlEventTouchUpInside];
    
    titlesSecOne = @[@"MY PROFILE", @"ADDRESSES"];
    titlesImagesSecOne = @[@"profile", @"addressM"];
    
    titlesSecTwo = @[@"RECURRING WASH"];
    titlesImagesSecTwo = @[@"recurringM"];
    
    titlesSecThree = @[@"PAYMENT", @"PROMOTIONS", @"PREFERENCES"];
    titlesImagesSecThree = @[@"payment", @"promotionsM", @"settings_icon"];
    
    ypos += piingpinHeight+20*MULTIPLYHEIGHT;
    
    float minusHeight = 110*MULTIPLYHEIGHT;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ypos, screen_width, screen_height-ypos-minusHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor clearColor];
    //self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    
    ypos += self.tableView.frame.size.height+10*MULTIPLYHEIGHT;
    
    
    float viewBX = 15*MULTIPLYHEIGHT;
    float viewBHeight = 44*MULTIPLYHEIGHT;
    
    UIView *view_Bottom = [[UIView alloc]initWithFrame:CGRectMake(viewBX, ypos, screen_width-(viewBX*2), viewBHeight)];
    view_Bottom.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_Bottom];
    
    float Width = view_Bottom.frame.size.width/3;
    
    float gapHeight = 6*MULTIPLYHEIGHT;
    
    UIButton *callPingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callPingBtn.frame = CGRectMake(0, 0, Width, viewBHeight);
    [callPingBtn setTitle:@"PIING! US" forState:UIControlStateNormal];
    callPingBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM];
    [callPingBtn setImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [callPingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callPingBtn addTarget:self action:@selector(CallPiingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view_Bottom addSubview:callPingBtn];
    [callPingBtn centerImageAndTitle:gapHeight];
    
    UIButton *feedBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    feedBackBtn.frame = CGRectMake(Width, 0, Width, viewBHeight);
    [feedBackBtn setTitle:@"FAQs" forState:UIControlStateNormal];
    feedBackBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM];
    [feedBackBtn setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    [feedBackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [feedBackBtn addTarget:self action:@selector(faqClicked) forControlEvents:UIControlEventTouchUpInside];
    [view_Bottom addSubview:feedBackBtn];
    [feedBackBtn centerImageAndTitle:gapHeight];
    
    
    UIButton *abtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    abtBtn.frame = CGRectMake(Width+Width, 0, Width, viewBHeight);
    [abtBtn setTitle:@"ABOUT" forState:UIControlStateNormal];
    abtBtn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM];
    [abtBtn setImage:[UIImage imageNamed:@"about"] forState:UIControlStateNormal];
    [abtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [abtBtn addTarget:self action:@selector(aboutClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view_Bottom addSubview:abtBtn];
    [abtBtn centerImageAndTitle:gapHeight];
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (appdel.isStatusBarFrameChanged)
    {
        appdel.isStatusBarFrameChanged = NO;
        
        [self.view setNeedsLayout];
        [self.view setNeedsDisplay];
        [self.view setNeedsUpdateConstraints];
    }
}


-(void) getUserDetails
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    NSDictionary *verificationDetailsDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/get", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            [dictUserDetails removeAllObjects];
            
            [dictUserDetails addEntriesFromDictionary:[responseObj objectForKey:@"user"]];
            
            [piingPinTitleLbl setTitle:[NSString stringWithFormat:@"PIING PIN # %@  ", [dictUserDetails objectForKey:@"TransactionPin"]] forState:UIControlStateNormal];
        }
    }];
}

-(void) editPiingPin
{
    if (!view_Popup)
    {
        
        view_Popup = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        view_Popup.backgroundColor = [UIColor clearColor];
        [appdel.window addSubview:view_Popup];
        view_Popup.alpha = 0.0;
        [appdel applyBlurEffectForView:view_Popup Style:BLUR_EFFECT_STYLE_DARK Alpha:1.0];
        
        
        float vtX = 12*MULTIPLYHEIGHT;
        
        view_Tourist = [[UIView alloc]initWithFrame:CGRectMake(vtX, 0, screen_width-(vtX*2), 190)];
        view_Tourist.backgroundColor = [UIColor clearColor];
        view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
        [view_Popup addSubview:view_Tourist];
        
        UIView *view_Top = [[UIView alloc]initWithFrame:CGRectMake(vtX, vtX, view_Tourist.frame.size.width-(vtX*2), view_Tourist.frame.size.height-vtX)];
        view_Top.backgroundColor = [UIColor clearColor];
        view_Top.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view_Tourist addSubview:view_Top];
        view_Top.layer.cornerRadius = 5.0;
        view_Top.layer.masksToBounds = YES;
        //view_Top.center = CGPointMake(view_Tourist.frame.size.width/2, view_Tourist.frame.size.height/2);
        [appdel applyBlurEffectForView:view_Top Style:BLUR_EFFECT_STYLE_EXTRA_LIGHT];
        
        float viewWidth = view_Top.frame.size.width;
        
        
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
        closePCBtn.frame = CGRectMake(viewWidth-closeHeight, 0.0, closeHeight, closeHeight);
        closePCBtn.center = CGPointMake(vtX, vtX);
        [closePCBtn setImage:[UIImage imageNamed:@"cancel_popup"] forState:UIControlStateNormal];
        [closePCBtn addTarget:self action:@selector(closePopupScreen) forControlEvents:UIControlEventTouchUpInside];
        [view_Tourist addSubview:closePCBtn];
        
        
        float yAxis = piingiconHeight/2;
        
        UILabel *LblTourist = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, viewWidth, 40)];
        LblTourist.text = @"VERIFY ACCOUNT";
        LblTourist.textAlignment = NSTextAlignmentCenter;
        LblTourist.textColor = [UIColor colorFromHexString:@"#585858"];
        LblTourist.backgroundColor = [UIColor clearColor];
        LblTourist.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.HEADER_LABEL_FONT_SIZE-2];
        [view_Top addSubview:LblTourist];
        
        CGSize lblSize = [AppDelegate getLabelSizeForBoldText:LblTourist.text WithWidth:viewWidth FontSize:LblTourist.font.pointSize];
        
        CGRect frameLbl = LblTourist.frame;
        frameLbl.size.height = lblSize.height+(10*MULTIPLYHEIGHT);
        LblTourist.frame = frameLbl;
        
        yAxis += frameLbl.size.height;
        
        UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(((viewWidth)/2)-(lblSize.width/2), yAxis, lblSize.width, 1)];
        imgLine.backgroundColor = [UIColor lightGrayColor];
        [view_Top addSubview:imgLine];
        
        yAxis += 10*MULTIPLYHEIGHT;
        
        float letHeight = 18*MULTIPLYHEIGHT;
        float lblX = 20*MULTIPLYHEIGHT;
        
        LblEnterText = [[UILabel alloc] initWithFrame:CGRectMake(lblX, yAxis, view_Top.frame.size.width-(lblX*2), letHeight)];
        LblEnterText.text = @"ENTER YOUR PASSWORD";
        LblEnterText.textAlignment = NSTextAlignmentLeft;
        LblEnterText.numberOfLines = 0;
        LblEnterText.textColor = [UIColor grayColor];
        LblEnterText.backgroundColor = [UIColor clearColor];
        LblEnterText.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-4];
        [view_Top addSubview:LblEnterText];
        
        yAxis += letHeight;
        
        
        float tfHeight = 26*MULTIPLYHEIGHT;
        
        paswordTF = [[UITextField alloc] initWithFrame:CGRectMake(lblX, yAxis, viewWidth-(lblX*2), tfHeight)];
        paswordTF.borderStyle = UITextBorderStyleNone;
        paswordTF.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-2];
        paswordTF.placeholder = @"Enter Password";
        paswordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        paswordTF.returnKeyType = UIReturnKeyDone;
        paswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        paswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        paswordTF.delegate = self;
        paswordTF.secureTextEntry = YES;
        [view_Top addSubview:paswordTF];
        paswordTF.layer.borderWidth = 0.6;
        paswordTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        paswordTF.leftView = paddingView;
        paswordTF.leftViewMode = UITextFieldViewModeAlways;
        [paswordTF becomeFirstResponder];
        
        yAxis += tfHeight;
        
        
        UIButton *frgBut = [UIButton buttonWithType:UIButtonTypeCustom];
        frgBut.frame = CGRectMake(lblX, yAxis, viewWidth-(lblX*2), 25*MULTIPLYHEIGHT);
        frgBut.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appdel.FONT_SIZE_CUSTOM-3];
        [frgBut setTitle:@"FORGOT PASSWORD" forState:UIControlStateNormal];
        [frgBut setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        frgBut.backgroundColor = [UIColor clearColor];
        [frgBut addTarget:self action:@selector(ForgotButton_or_YES_or_No_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        frgBut.tag = 1;
        [view_Top addSubview:frgBut];
        
        
        yAxis += 25*MULTIPLYHEIGHT+(5*MULTIPLYHEIGHT);
        
        CGFloat btnHeight = 30*MULTIPLYHEIGHT;
        
        UIButton *btnYes = [UIButton buttonWithType:UIButtonTypeCustom];
        btnYes.frame = CGRectMake(0, yAxis, viewWidth/2-1, btnHeight);
        btnYes.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM];
        [btnYes setTitle:@"CANCEL" forState:UIControlStateNormal];
        [btnYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnYes.backgroundColor = APPLE_BLUE_COLOR;
        [btnYes addTarget:self action:@selector(ForgotButton_or_YES_or_No_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        btnYes.tag = 2;
        [view_Top addSubview:btnYes];
        [btnYes setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSubmit.frame = CGRectMake(viewWidth/2, yAxis, viewWidth/2, btnHeight);
        btnSubmit.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM];
        [btnSubmit setTitle:@"SUBMIT" forState:UIControlStateNormal];
        btnSubmit.backgroundColor = APPLE_BLUE_COLOR;
        [btnSubmit addTarget:self action:@selector(ForgotButton_or_YES_or_No_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        btnSubmit.tag = 3;
        [view_Top addSubview:btnSubmit];
        btnSubmit.userInteractionEnabled = NO;
        [btnSubmit setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        [btnSubmit setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        
        yAxis += btnHeight+vtX;
        
        CGRect frameView = view_Tourist.frame;
        frameView.size.height = yAxis;
        view_Tourist.frame = frameView;
        
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void) closePopupScreen
{
    [self.view endEditing:YES];
    
    if (view_Pin_Popup)
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Pin_Popup.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [view_Pin_Popup removeFromSuperview];
            view_Pin_Popup = nil;
        }];
    }
    else
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [view_Popup removeFromSuperview];
            view_Popup = nil;
        }];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserDetails];
    
    [backGroundplayer play];
    
    [appdel showTabBar:appdel.customTabBarController];
    
    [appdel setBottomTabBarColor:TABBAR_COLOR_WHITE BlurEffectStyle:BLUR_EFFECT_STYLE_LIGHT HideBlurEffect:YES];
    
    [appdel setBottomTabBarColorForTab:3];
    
    //[self callBackgroundImageService];
    
    if (appdel.hasAdCode == 1)
    {
//        [appdel hideTabBar:appdel.customTabBarController];
//        
//        appdel.hasAdCode = 0;
        [self.navigationController pushViewController:[[PromotionsViewController alloc] init] animated:YES];
    }
    else if (appdel.hasAdCode == 2)
    {
//        [appdel hideTabBar:appdel.customTabBarController];
//        
//        appdel.hasAdCode = 0;
        [self.navigationController pushViewController:[[ShareViewController alloc] init] animated:YES];
    }
    else if (appdel.hasAdCode == 3)
    {
//        [appdel hideTabBar:appdel.customTabBarController];
//        
//        appdel.hasAdCode = 0;
        [self.navigationController pushViewController:[[RecurringListController alloc] init] animated:YES];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    if (view_Popup)
    {
        [view_Popup removeFromSuperview];
        view_Popup = nil;
    }
}

-(void) callBackgroundImageService
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", @"MT", @"order", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@getorderstatusimages/services.do?", BASE_URL];
    NSString *str = @"";
    for (NSString *key in [detailsDic allKeys])
        
    {
        if(str.length > 0)
            str = [str stringByAppendingString:@"&"];
        // NSString *key = [[parametersDic allKeys] objectAtIndex:i];
        NSString *value = [detailsDic objectForKey:key];
        
        str = [str stringByAppendingFormat:@"%@=%@",key,value];
        
    }
    if(str.length > 0)
        urlStr = [urlStr stringByAppendingString:str];
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"GET" withDetailsDictionary:nil andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame){
            
            if(responseObj &&[[responseObj objectForKey:@"r"] count]){
                
                if ([[responseObj objectForKey:@"r"]count])
                {
                    
                    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[responseObj objectForKey:@"r"]objectAtIndex:0]objectForKey:@"imgpath"]]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                        
                        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
                        
                        bgImageView.image = [UIImage imageWithData:data];
                        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
                        bgImageView.clipsToBounds = YES;
                        
                    }];
                    
                }
                
            }
        }
        else {
            
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
                
    }];
    
}

-(void)CallPiingBtnClicked:(id) sender
{    
    
    [appdel applyCustomBlurEffetForView:self.view WithBlurRadius:5];
    
    blurEffect = [self.view viewWithTag:98765];
    blurEffect.alpha = 0.0;
    //blurEffect.dynamic = YES;
    
    [FXBlurView setUpdatesDisabled];
    
    view_Share = [[UIView alloc]initWithFrame:appdel.window.bounds];
    view_Share.alpha = 0.0;
    view_Share.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    [appdel.window addSubview:view_Share];
    
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
    
    
    CGFloat yAxis = 0;
    
//    float lblHeight = 20*MULTIPLYHEIGHT;
//    
//    UILabel *lblShare = [[UILabel alloc]init];
//    lblShare.frame = CGRectMake(0, yAxis, view_details.frame.size.width, lblHeight);
//    
//    NSMutableAttributedString *strAttrSha = [appdel getAttributedStringWithString:[@"select" uppercaseString] WithSpacing:0.3];
//    [strAttrSha addAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor]colorWithAlphaComponent:0.8]} range:NSMakeRange(0, strAttrSha.length)];
//    
//    lblShare.attributedText = strAttrSha;
//    lblShare.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM-2];
//    lblShare.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
//    lblShare.textAlignment = NSTextAlignmentCenter;
//    [view_details addSubview:lblShare];
//    
//    yAxis += lblHeight+5*MULTIPLYHEIGHT;
    
    float btnaHeight = 35*MULTIPLYHEIGHT;
    
    NSArray *array = @[@"Call", @"Email"];
    
    for (int i = 0; i < [array count]; i++)
    {
        UIImageView *imgLine = [[UIImageView alloc]init];
        imgLine.frame = CGRectMake(0, yAxis, view_details.frame.size.width, 1);
        imgLine.backgroundColor = RGBCOLORCODE(200, 200, 200, 1.0);
        [view_details addSubview:imgLine];
        
        UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCall.tag = i+1;
        
        NSMutableAttributedString *strAttrCal = [appdel getAttributedStringWithString:[[array objectAtIndex:i]uppercaseString] WithSpacing:0.4];
        
        [btnCall setAttributedTitle:strAttrCal forState:UIControlStateNormal];
        
        [btnCall setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [btnCall setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btnCall.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM-2];
        btnCall.frame = CGRectMake(0, yAxis, view_details.frame.size.width, btnaHeight);
        [btnCall addTarget:self action:@selector(btnOptionsClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view_details addSubview:btnCall];
        
        [strAttrCal addAttributes:@{NSForegroundColorAttributeName:[[UIColor blackColor]colorWithAlphaComponent:1.0]} range:NSMakeRange(0, strAttrCal.length)];
        
        yAxis += btnaHeight;
    }
    
    
    CGRect rect = view_details.frame;
    rect.size.height = yAxis;
    view_details.frame = rect;
    
    
    yAxis += 10*MULTIPLYHEIGHT;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSMutableAttributedString *strAttrClose = [appdel getAttributedStringWithString:@"CANCEL" WithSpacing:1.0];
    [strAttrClose addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, strAttrClose.length)];
    
    [btnClose setAttributedTitle:strAttrClose forState:UIControlStateNormal];
    [btnClose setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnClose.backgroundColor = [UIColor whiteColor];
    btnClose.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM];
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

-(void) btnOptionsClicked:(UIButton *) sender
{
    if (sender.tag == 1)
    {
        NSLog(@"Call to PIING");
        
        [FIRAnalytics logEventWithName:@"call_to_crm_button" parameters:nil];
        
        NSString *phNo = [NSString stringWithFormat:@"+65%@", [dictUserDetails objectForKey:@"csn"]];
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }
    else
    {
        [FIRAnalytics logEventWithName:@"mail_to_crm_button" parameters:nil];
        
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
            
            mailCompose.mailComposeDelegate = self;
            [mailCompose setSubject:@"Feedback"];
            [mailCompose setToRecipients:@[@"PiingUs@piing.com.sg"]];
            
            [self presentViewController:mailCompose animated:YES completion:nil];
        }
        else
        {
            [appdel showAlertWithMessage:@"Your device could not send e-mail. Please check e-mail configuration and try again." andTitle:@"" andBtnTitle:@"OK"];
        }
    }
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
        
        [appdel removeCustomBlurEffectToView:appdel.window];
    }];
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
            
            //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //[alert show];
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


#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectedIndex = indexPath.section;
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self.navigationController pushViewController:[[MyProfileDetailsViewController alloc] init] animated:YES];
        }
        else if (indexPath.row == 1)
        {
            AddressListViewController_Map *listAddVC = [[AddressListViewController_Map alloc] initWithNibName:nil bundle:nil andWithType:YES];
            [self.navigationController pushViewController:listAddVC animated:YES];
        }
    }
    else if(indexPath.section == 1)
    {
         if (indexPath.row == 0)
         {
              [self.navigationController pushViewController:[[RecurringListController alloc] init] animated:YES];
         }
    }
    else if(indexPath.section == 2)
    {
        if (indexPath.row == 1)
        {
            [self.navigationController pushViewController:[[PromotionsViewController alloc] init] animated:YES];
        }
        else if (indexPath.row == 0)
        {
            [self.navigationController pushViewController:[[PaymentViewController_More alloc] init] animated:YES];
        }
        else if (indexPath.row == 2)
        {
            PreferencesViewController *objPre = [[PreferencesViewController alloc] init];
            
            NSMutableString *strPref = [@"" mutableCopy];
            
            if ([[dictUserDetails objectForKey:PREFERENCES_SELECTED] count])
            {
                NSDictionary *dict1 = [dictUserDetails objectForKey:PREFERENCES_SELECTED];
                
                NSMutableDictionary *dictMain  = [[NSMutableDictionary alloc]init];
                
                for (NSDictionary *dict2 in dict1)
                {
                    [dictMain setObject:[dict2 objectForKey:@"value"] forKey:[dict2 objectForKey:@"name"]];
                }
                
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
            }
            else
            {
                strPref = [appdel.strGlobalPreferenes mutableCopy];
            }
            
            appdel.strGlobalPreferenes = strPref;
            
            objPre.strPrefs = strPref;
            objPre.isFromMoreScreen = YES;
            
            [self.navigationController pushViewController:objPre animated:YES];
        }
    }
}


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float bgHeight = 32.3*MULTIPLYHEIGHT;
    return bgHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    float bgHeight = 15*MULTIPLYHEIGHT;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, bgHeight)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 || section == 2)
    {
        float bgHeight = 15*MULTIPLYHEIGHT;
        return bgHeight;
    }
    else
    {
        return 0;
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (section == 0) {
        return [titlesSecOne count];
    }
    else if (section == 1)
    {
        return [titlesSecTwo count];
    }
    else
    {
        return [titlesSecThree count];
    }
   
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        float bgHeight = 31.68*MULTIPLYHEIGHT;
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, bgHeight)];
        viewBG.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.40];
        [cell.contentView addSubview:viewBG];
        
        float lblX = 50*MULTIPLYHEIGHT;
        
        UILabel *lblSubText = [[UILabel alloc]initWithFrame:CGRectMake(lblX, 0, screen_width-lblX, bgHeight)];
        lblSubText.tag = 500;
        lblSubText.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM];
        lblSubText.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:lblSubText];
        
        
        float imgX = 18*MULTIPLYHEIGHT;
        float imgHeight = 16*MULTIPLYHEIGHT;
        
        UIImageView *imgSub = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, bgHeight/2-(imgHeight/2), imgHeight, imgHeight)];
        imgSub.tag = 501;
        [cell.contentView addSubview:imgSub];
        
        
        float arrowHeight = 8*MULTIPLYHEIGHT;
        
        UIImageView *imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width-imgX, bgHeight/2-(arrowHeight/2), arrowHeight, arrowHeight)];
        imgArrow.image = [UIImage imageNamed:@"right_arrow_white"];
        imgArrow.alpha = 0.8;
        imgArrow.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:imgArrow];
        
    }
    
    UILabel *lblSubText = (UILabel *) [cell.contentView viewWithTag:500];
    UIImageView *imgSub = (UIImageView *) [cell.contentView viewWithTag:501];
    imgSub.contentMode = UIViewContentModeScaleAspectFit;
    
    if (indexPath.section == 0) {
         lblSubText.text = titlesSecOne[indexPath.row];
        imgSub.image = [UIImage imageNamed:titlesImagesSecOne[indexPath.row]];

    }
    else if (indexPath.section == 1) {
        lblSubText.text = titlesSecTwo[indexPath.row];
        imgSub.image = [UIImage imageNamed:titlesImagesSecTwo[indexPath.row]];
        
    }
    else if (indexPath.section == 2){
        lblSubText.text = titlesSecThree[indexPath.row];
        imgSub.image = [UIImage imageNamed:titlesImagesSecThree[indexPath.row]];

    }
    
    return cell;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:paswordTF])
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/3);
            
        } completion:^(BOOL finished) {
            
        }];
        
        if (![btnSubmit isUserInteractionEnabled])
        {
            textField.text = @"";
        }
    }
    else if ([textField isEqual:PinpaswordTF])
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Tourist.center = CGPointMake(view_Pin_Popup.frame.size.width/2, view_Pin_Popup.frame.size.height/3);
            
        } completion:^(BOOL finished) {
            
        }];
        
        if (![btnSubmit isUserInteractionEnabled])
        {
            textField.text = @"";
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:paswordTF])
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
            
        } completion:^(BOOL finished) {
            
        }];
    }
    else if ([textField isEqual:PinpaswordTF])
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Tourist.center = CGPointMake(view_Pin_Popup.frame.size.width/2, view_Pin_Popup.frame.size.height/2);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.placeholder isEqualToString:@"Enter Password"])
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
    }
    
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
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)ForgotButton_or_YES_or_No_Clicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (btn.tag == 1) {
        ForgetPasswordViewController *forgetPwdVC = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:forgetPwdVC animated:YES];
    }
    else if (btn.tag == 2){
        NSLog(@"Cancel");
        
        [paswordTF resignFirstResponder];
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [view_Popup removeFromSuperview];
            view_Popup = nil;
        }];
        
    }
    else if (btn.tag == 3){
        NSLog(@"Submit");
        
        NSString *strForgot = paswordTF.text;
        
        if (strForgot.length == 0) {
            [appdel showAlertWithMessage:@"Please enter Password" andTitle:@"" andBtnTitle:@"OK"];
        }
        else{
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",strForgot,@"password",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@user/authprofileupdate", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:params andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
                
                if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                    
                    [self openPiingPinPopup];
                }
                else
                {
                    NSLog(@"Failure verification");
                    
                    paswordTF.text = @"";
                    
                    LblEnterText.text = @"EROR VERIFYING PASSWORD";
                    LblEnterText.textColor = [[UIColor redColor]colorWithAlphaComponent:0.7];
                    
                    btnSubmit.userInteractionEnabled = NO;
                    [btnSubmit setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
                    
                    paswordTF.layer.borderColor = [[UIColor redColor]colorWithAlphaComponent:0.7].CGColor;
                }
//                else {
//                    [appdel displayErrorMessagErrorResponse:responseObj];
//                }
                
            }];
        }
        
    }
    
}

-(void) openPiingPinPopup
{
    if (!view_Pin_Popup)
    {
        
        view_Pin_Popup = [[UIView alloc]initWithFrame:CGRectMake(screen_width, 0, screen_width, screen_height)];
        view_Pin_Popup.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view_Pin_Popup];
        view_Pin_Popup.alpha = 1.0;
        [appdel applyBlurEffectForView:view_Pin_Popup Style:BLUR_EFFECT_STYLE_DARK Alpha:1.0];
        
        float vtX = 12*MULTIPLYHEIGHT;
        
        view_Tourist = [[UIView alloc]initWithFrame:CGRectMake(vtX, 0, screen_width-(vtX*2), 190)];
        view_Tourist.backgroundColor = [UIColor clearColor];
        view_Tourist.center = CGPointMake(view_Pin_Popup.frame.size.width/2, view_Pin_Popup.frame.size.height/2);
        [view_Pin_Popup addSubview:view_Tourist];
        
        
        UIView *view_Top = [[UIView alloc]initWithFrame:CGRectMake(vtX, vtX, view_Tourist.frame.size.width-(vtX*2), view_Tourist.frame.size.height-vtX)];
        view_Top.backgroundColor = [UIColor clearColor];
        view_Top.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [view_Tourist addSubview:view_Top];
        view_Top.layer.cornerRadius = 5.0;
        view_Top.layer.masksToBounds = YES;
        //view_Top.center = CGPointMake(view_Tourist.frame.size.width/2, view_Tourist.frame.size.height/2);
        [appdel applyBlurEffectForView:view_Top Style:BLUR_EFFECT_STYLE_EXTRA_LIGHT];
        
        float viewWidth = view_Top.frame.size.width;
        
        
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
        closePCBtn.frame = CGRectMake(viewWidth-closeHeight, 0.0, closeHeight, closeHeight);
        closePCBtn.center = CGPointMake(vtX, vtX);
        [closePCBtn setImage:[UIImage imageNamed:@"cancel_popup"] forState:UIControlStateNormal];
        [closePCBtn addTarget:self action:@selector(closePopupScreen) forControlEvents:UIControlEventTouchUpInside];
        [view_Tourist addSubview:closePCBtn];
        
        
        float yAxis = piingiconHeight/2;
        
        UILabel *LblTourist = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, viewWidth, 40)];
        LblTourist.text = @"ENTER NEW PIING PIN";
        LblTourist.textAlignment = NSTextAlignmentCenter;
        LblTourist.textColor = [UIColor colorFromHexString:@"#585858"];
        LblTourist.backgroundColor = [UIColor clearColor];
        LblTourist.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.HEADER_LABEL_FONT_SIZE-2];
        [view_Top addSubview:LblTourist];
        
        CGSize lblSize = [AppDelegate getLabelSizeForBoldText:LblTourist.text WithWidth:viewWidth FontSize:LblTourist.font.pointSize];
        
        CGRect frameLbl = LblTourist.frame;
        frameLbl.size.height = lblSize.height+(10*MULTIPLYHEIGHT);
        LblTourist.frame = frameLbl;
        
        yAxis += frameLbl.size.height;
        
        UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(((viewWidth)/2)-(lblSize.width/2), yAxis, lblSize.width, 1)];
        imgLine.backgroundColor = [UIColor lightGrayColor];
        [view_Top addSubview:imgLine];
        
        yAxis += 10*MULTIPLYHEIGHT;
        
        float letHeight = 18*MULTIPLYHEIGHT;
        
        LblEnterText = [[UILabel alloc] initWithFrame:CGRectMake(20, yAxis, view_Top.frame.size.width-40, letHeight)];
        LblEnterText.text = @"ENTER YOUR NEW PIING PIN";
        LblEnterText.textAlignment = NSTextAlignmentLeft;
        LblEnterText.numberOfLines = 0;
        LblEnterText.textColor = [UIColor grayColor];
        LblEnterText.backgroundColor = [UIColor clearColor];
        LblEnterText.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-4];
        [view_Top addSubview:LblEnterText];
        
        
        yAxis += letHeight;
        
        PinpaswordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, yAxis, viewWidth-40, 35)];
        PinpaswordTF.borderStyle = UITextBorderStyleNone;
        PinpaswordTF.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-2];
        PinpaswordTF.placeholder = @"Enter New Pin";
        PinpaswordTF.autocorrectionType = UITextAutocorrectionTypeNo;
        PinpaswordTF.returnKeyType = UIReturnKeyDone;
        PinpaswordTF.keyboardType = UIKeyboardTypeNumberPad;
        PinpaswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        PinpaswordTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        PinpaswordTF.delegate = self;
        PinpaswordTF.secureTextEntry = YES;
        [view_Top addSubview:PinpaswordTF];
        PinpaswordTF.layer.borderWidth = 0.6;
        PinpaswordTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        PinpaswordTF.leftView = paddingView;
        PinpaswordTF.leftViewMode = UITextFieldViewModeAlways;
        [PinpaswordTF becomeFirstResponder];
        
        
        yAxis += 35+(10*MULTIPLYHEIGHT);
        
        CGFloat btnHeight = 30*MULTIPLYHEIGHT;
        
        UIButton *btnYes = [UIButton buttonWithType:UIButtonTypeCustom];
        btnYes.frame = CGRectMake(0, yAxis, viewWidth/2-1, btnHeight);
        btnYes.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM];
        [btnYes setTitle:@"CANCEL" forState:UIControlStateNormal];
        [btnYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnYes.backgroundColor = APPLE_BLUE_COLOR;
        [btnYes addTarget:self action:@selector(updatePiingPin:) forControlEvents:UIControlEventTouchUpInside];
        btnYes.tag = 2;
        [view_Top addSubview:btnYes];
        [btnYes setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSubmit.frame = CGRectMake(viewWidth/2, yAxis, viewWidth/2, btnHeight);
        btnSubmit.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM];
        [btnSubmit setTitle:@"SUBMIT" forState:UIControlStateNormal];
        btnSubmit.backgroundColor = APPLE_BLUE_COLOR;
        [btnSubmit addTarget:self action:@selector(updatePiingPin:) forControlEvents:UIControlEventTouchUpInside];
        btnSubmit.tag = 3;
        [view_Top addSubview:btnSubmit];
        btnSubmit.userInteractionEnabled = NO;
        [btnSubmit setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
        [btnSubmit setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        
        yAxis += btnHeight+vtX;
        
        CGRect frameView = view_Tourist.frame;
        frameView.size.height = yAxis;
        view_Tourist.frame = frameView;
        
        
        [UIView animateKeyframesWithDuration:0.6 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            CGRect frame = view_Popup.frame;
            frame.origin.x = -screen_width;
            
            view_Popup.frame = frame;
            
            view_Pin_Popup.frame = CGRectMake(0, 0, screen_width, screen_height);
            
            
        } completion:^(BOOL finished) {
            
            [view_Popup removeFromSuperview];
            view_Popup = nil;
        }];
    }
}

-(void) updatePiingPin:(UIButton *) sender
{
    if (sender.tag == 2)
    {
        [PinpaswordTF resignFirstResponder];
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Pin_Popup.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            [view_Pin_Popup removeFromSuperview];
            view_Pin_Popup = nil;
        }];
    }
    else
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",PinpaswordTF.text,@"transactionPin",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user/transactionpin", BASE_URL];
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:params andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
            
            if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [appdel showAlertWithMessage:@"Your Piing pin has been updated successfully." andTitle:@"" andBtnTitle:@"OK"];
                    
                    [piingPinTitleLbl setTitle:[NSString stringWithFormat:@"PIING PIN # %@  ", PinpaswordTF.text] forState:UIControlStateNormal];
                    
                    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                        
                        view_Pin_Popup.alpha = 0.0;
                        
                    } completion:^(BOOL finished) {
                        
                        [view_Pin_Popup removeFromSuperview];
                        view_Pin_Popup = nil;
                    }];
                    
                }];
            }
            
            else
            {
                NSLog(@"Failure verification");
                
                PinpaswordTF.text = @"";
                
                LblEnterText.text = @"EROR VALID PIING PIN";
                LblEnterText.textColor = [[UIColor redColor]colorWithAlphaComponent:0.7];
                
                btnSubmit.userInteractionEnabled = NO;
                [btnSubmit setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
                
                PinpaswordTF.layer.borderColor = [[UIColor redColor]colorWithAlphaComponent:0.7].CGColor;
            }
            
        }];
    }
}

-(void) faqClicked
{
    [appdel hideTabBar:appdel.customTabBarController];
    
    FAQViewController *faq = [[FAQViewController alloc]init];
    faq.code = 1;
    
    [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        [self addChildViewController:faq];
        [self.view addSubview:faq.view];
        
    } completion:nil];
}

-(void) aboutClicked:(id)sender
{
    [appdel hideTabBar:appdel.customTabBarController];
    
    FAQViewController *faq = [[FAQViewController alloc]init];
    faq.code = 2;
    
    [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        [self addChildViewController:faq];
        [self.view addSubview:faq.view];
        
    } completion:nil];
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
