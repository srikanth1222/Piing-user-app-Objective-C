//
//  MyWalletViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 09/01/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "MyWalletViewController.h"
#import "WelcomeScreenViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "UIView+Toast.h"
#import <MediaPlayer/MediaPlayer.h>
#import <FirebaseAnalytics/FIRAnalytics.h>

#define TABLEVIEW_HEIGHT 120*MULTIPLYHEIGHT

@interface MyWalletViewController () <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    AppDelegate *appDel;
    
    UIButton *nextBtn;
    
    NSMutableArray *arrayCards;
    
    NSString *brainTreeClientToken;
    
    UIButton *btnCashOnDelivery;
    UIView *dotViewCashOnDelivery;
    
    NSInteger selectedIndex;
    
    NSString *paymentMode;
    UISegmentedControl *segmentPayment;
    
    UIView *view_FreeWash;
    
    UITableView *tblFreeWash;
    
    NSMutableArray *arrayFreeWashes;
    
    NSMutableDictionary *dictMyWallet;
    UIView *view_Share;
    
    BOOL isTableFreeWashHidden;
    UILabel *lblGiveGet;
    UIImageView *imgZigZag;
    
    BOOL selectedAnotherPayment;
    
    UILabel *lblShareJoy;
    
    UIView *view_Hide;
    UIImageView *imgViewGift;
    
    CGRect rectOriginalGift;
    CGRect rectOriginalShareJoy;
    
    UIImageView *imgTopStrip;
    
    UIView *viewBlackBG, *viewPopup;
}

@property (nonatomic, strong) MPMoviePlayerController *backGroundplayer;

@end


@implementation MyWalletViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBarHidden = YES;
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    arrayCards = [[NSMutableArray alloc]init];
    arrayFreeWashes = [[NSMutableArray alloc]init];
    
    dictMyWallet = [[NSMutableDictionary alloc]init];
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 40)];
    NSString *string = @"MY WALLET";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.backGroundplayer)
    {
        [self.backGroundplayer play];
    }
    
    [self getFreeWashFromService];
    
    [appDel setBottomTabBarColorForTab:2];
    
    [appDel setBottomTabBarColor:TABBAR_COLOR_WHITE BlurEffectStyle:BLUR_EFFECT_STYLE_DARK HideBlurEffect:NO];
}

-(void) getFreeWashFromService
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/wallet", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            [dictMyWallet removeAllObjects];
            
            [dictMyWallet addEntriesFromDictionary:responseObj];
            
            if(responseObj &&[[responseObj objectForKey:@"creditList"] count])
            {
                [arrayFreeWashes removeAllObjects];
                [arrayFreeWashes addObjectsFromArray:[responseObj objectForKey:@"creditList"]];
            }
            
            [self loadFreeWashes];
            
            if ([arrayFreeWashes count])
            {
                if (view_Share.userInteractionEnabled || isTableFreeWashHidden)
                {
                    [self performSelector:@selector(swipeDown:) withObject:nil afterDelay:2.0];
                }
            }
            
            [tblFreeWash reloadData];
            
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
    
}

-(void) loadFreeWashes
{
    float viewPY = 57*MULTIPLYHEIGHT;
    
    if (view_FreeWash)
    {
        [view_FreeWash removeFromSuperview];
        view_FreeWash = nil;
    }
    
    view_FreeWash = [[UIView alloc]initWithFrame:CGRectMake(0, viewPY, screen_width, screen_height-viewPY-TAB_BAR_HEIGHT)];
    [self.view addSubview:view_FreeWash];
    
    float yAxis = 23*MULTIPLYHEIGHT;
    
    UILabel *lblCredit = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 50)];
    lblCredit.textAlignment = NSTextAlignmentCenter;
    lblCredit.numberOfLines = 0;
    [view_FreeWash addSubview:lblCredit];
    
    NSString *str1 = @"AVAILABLE CREDIT:\n";
    NSMutableAttributedString *attrMain = [[NSMutableAttributedString alloc]initWithString:str1];
    
    NSString *str2;
    
    NSMutableAttributedString *attr1;
    
    if ([[dictMyWallet objectForKey:@"walletAmount"]floatValue] != 0)
    {
        str2 = [NSString stringWithFormat:@"$%.2f", [[dictMyWallet objectForKey:@"walletAmount"]floatValue]];
        
        attr1 = [[NSMutableAttributedString alloc]initWithString:str2];
        
        [attrMain addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:BLUE_COLOR} range:NSMakeRange(0, str1.length)];
        
        [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+20], NSForegroundColorAttributeName:LIGHT_BLUE_COLOR} range:NSMakeRange(0, str2.length)];
        
    }
    else
    {
        str2 = @"$0.00";
        
        attr1 = [[NSMutableAttributedString alloc]initWithString:str2];
        
        [attrMain addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:BLUE_COLOR} range:NSMakeRange(0, str1.length)];
        
        [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+20], NSForegroundColorAttributeName:LIGHT_BLUE_COLOR} range:NSMakeRange(0, str2.length)];
    }
    
    [attrMain appendAttributedString:attr1];
    
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [paragrapStyle setLineSpacing:7*MULTIPLYHEIGHT];
    [paragrapStyle setMaximumLineHeight:100.0f];
    
    [attrMain addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, attrMain.length)];
    
    lblCredit.attributedText = attrMain;
    
    CGSize size = [AppDelegate getAttributedTextHeightForText:attrMain WithWidth:screen_width];
    CGRect frame = lblCredit.frame;
    frame.size.height = size.height;
    lblCredit.frame = frame;
    
    yAxis += size.height+23*MULTIPLYHEIGHT;;
    
    
    yAxis += 18*MULTIPLYHEIGHT;
    
    float minusHeight = 60*MULTIPLYHEIGHT;
    
    tblFreeWash = [[UITableView alloc] initWithFrame:CGRectMake(0, yAxis, screen_width, view_FreeWash.frame.size.height-yAxis-minusHeight)];
    tblFreeWash.delegate = self;
    tblFreeWash.dataSource = self;
    //tblFreeWash.backgroundColor = [UIColor redColor];
    
    tblFreeWash.backgroundColor = [UIColor colorFromHexString:@"f1f1f1"];
    tblFreeWash.separatorColor = [UIColor clearColor];
    tblFreeWash.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view_FreeWash addSubview:tblFreeWash];
    
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(0, tblFreeWash.frame.origin.y, screen_width, 1);
    topLayer.backgroundColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
    [view_FreeWash.layer addSublayer:topLayer];
    
    //    CALayer *layerTbl = [[CALayer alloc]init];
    //    layerTbl.frame = CGRectMake(0, 0, screen_width, 1);
    //    layerTbl.backgroundColor = [UIColor lightGrayColor].CGColor;
    //    [tblFreeWash.layer addSublayer:layerTbl];
    
    //    UIBezierPath *shadowPath1 = [UIBezierPath bezierPathWithRect:tblFreeWash.bounds];
    //    tblFreeWash.layer.masksToBounds = NO;
    //    tblFreeWash.layer.shadowColor = [UIColor blackColor].CGColor;
    //    tblFreeWash.layer.shadowOffset = CGSizeMake(0.0f, -1.0f);
    //    tblFreeWash.layer.shadowOpacity = 0.3f;
    //    tblFreeWash.layer.shadowPath = shadowPath1.CGPath;
    //    tblFreeWash.bounces = NO;
    
    isTableFreeWashHidden = YES;
    
    view_Share = [[UIView alloc]initWithFrame:CGRectMake(0, yAxis+1, screen_width, view_FreeWash.frame.size.height-yAxis-1)];
    view_Share.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    [view_FreeWash addSubview:view_Share];
    
    imgTopStrip = [[UIImageView alloc]initWithFrame:CGRectMake(0, yAxis-5*MULTIPLYHEIGHT, screen_width, 5*MULTIPLYHEIGHT)];
    imgTopStrip.contentMode = UIViewContentModeScaleAspectFill;
    imgTopStrip.image = [UIImage imageNamed:@"mywallet_topstrip.png"];
    [view_FreeWash addSubview:imgTopStrip];
    imgTopStrip.hidden = YES;
    
    float imgGX = 44*MULTIPLYHEIGHT;
    
    imgViewGift = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/2-(imgGX/2), yAxis-imgGX/1.8, imgGX, imgGX)];
    imgViewGift.contentMode = UIViewContentModeScaleAspectFit;
    imgViewGift.image = [UIImage imageNamed:@"gift_box.png"];
    [view_FreeWash addSubview:imgViewGift];
    
    rectOriginalGift = imgViewGift.frame;
    
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"free_wash_bg" ofType:@"mp4"];
    NSURL *theurl = [NSURL fileURLWithPath:thePath];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
    //                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
    //                                               object:nil];
    
    
    if (self.backGroundplayer)
    {
        [self.backGroundplayer.view removeFromSuperview];
        self.backGroundplayer = nil;
    }
    
    self.backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
    self.backGroundplayer.view.frame = CGRectMake(0, 0, screen_width, view_Share.frame.size.height);
    self.backGroundplayer.repeatMode = YES;
    self.backGroundplayer.view.userInteractionEnabled = YES;
    self.backGroundplayer.controlStyle = MPMovieControlStyleNone;
    [self.backGroundplayer prepareToPlay];
    [self.backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
    //self.backGroundplayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.backGroundplayer.backgroundView.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
    self.backGroundplayer.view.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
    [view_Share addSubview:self.backGroundplayer.view];
    [self.backGroundplayer setScalingMode:MPMovieScalingModeAspectFill];
    
    [self.backGroundplayer stop];
    [self.backGroundplayer performSelector:@selector(play) withObject:nil afterDelay:0.5];
    
    
    view_Hide = [[UIView alloc]initWithFrame:view_Share.bounds];
    view_Hide.backgroundColor = [UIColor clearColor];
    [view_Share addSubview:view_Hide];
    
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view_Share.bounds];
    view_Share.layer.masksToBounds = NO;
    view_Share.layer.shadowColor = [UIColor blackColor].CGColor;
    view_Share.layer.shadowOffset = CGSizeMake(0.0f, -1);
    view_Share.layer.shadowPath = shadowPath.CGPath;
    view_Share.layer.shadowRadius = 2.0;
    
    view_Share.layer.shadowOpacity = 0.0f;
    
    //    CALayer *layerShare = [[CALayer alloc]init];
    //    layerShare.frame = CGRectMake(0, 0, screen_width, 1);
    //    layerShare.backgroundColor = [UIColor lightGrayColor].CGColor;
    //    [view_Hide.layer addSublayer:layerShare];
    
    float yPos = 0;
    
    if ([arrayFreeWashes count])
    {
        //        CGFloat viewBAxis = 0;
        //
        //        view_Bottom = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height-TAB_BAR_HEIGHT*2.5, screen_width, minusHeight)];
        //        view_Bottom.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        //        //view_Bottom.backgroundColor = [UIColor redColor];
        //        [self.view addSubview:view_Bottom];
        //        view_Bottom.hidden = YES;
        //
        //        lblGiveGet = [[UILabel alloc]initWithFrame:CGRectMake(0, viewBAxis, screen_width, 20*MULTIPLYHEIGHT)];
        //        lblGiveGet.textAlignment = NSTextAlignmentCenter;
        //        lblGiveGet.numberOfLines = 0;
        //        lblGiveGet.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
        //        lblGiveGet.textColor = [UIColor grayColor];
        //        lblGiveGet.text = @"GIVE - GET $ 15";
        //        [view_Bottom addSubview:lblGiveGet];
        //
        //        viewBAxis += 16*MULTIPLYHEIGHT+18*MULTIPLYHEIGHT;
        //
        //        CGRect frameBottom = view_Bottom.frame;
        //        frameBottom.size.height = viewBAxis;
        //        view_Bottom.frame = frameBottom;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewShareClicked:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [view_Share addGestureRecognizer:tap];
        
        UISwipeGestureRecognizer *swipeBottom = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
        swipeBottom.direction=UISwipeGestureRecognizerDirectionDown;
        [view_Share addGestureRecognizer:swipeBottom];
        
        UISwipeGestureRecognizer *swipeTop = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
        swipeTop.direction=UISwipeGestureRecognizerDirectionUp;
        [view_Share addGestureRecognizer:swipeTop];
        
        //        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewShareClicked:)];
        //        tap1.numberOfTapsRequired = 1;
        //        tap1.numberOfTouchesRequired = 1;
        //        [view_Bottom addGestureRecognizer:tap1];
        //
        //        UISwipeGestureRecognizer *swipeBottom1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
        //        swipeBottom1.direction=UISwipeGestureRecognizerDirectionDown;
        //        [view_Bottom addGestureRecognizer:swipeBottom1];
        //
        //        UISwipeGestureRecognizer *swipeTop1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
        //        swipeTop1.direction=UISwipeGestureRecognizerDirectionUp;
        //        [view_Bottom addGestureRecognizer:swipeTop1];
    }
    
    yPos += 50*MULTIPLYHEIGHT;
    
    lblShareJoy = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 25)];
    lblShareJoy.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
    lblShareJoy.textAlignment = NSTextAlignmentCenter;
    lblShareJoy.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+12];
    [view_Share addSubview:lblShareJoy];
    lblShareJoy.textColor = [UIColor grayColor];
    
    //str1 = @"WIN HEARTS & A FREE WASH!";
    str1 = @"GET A FREE WASH";
    
    CGSize sizeJoy = [AppDelegate getLabelSizeForMediumText:str1 WithWidth:screen_width FontSize:lblShareJoy.font.pointSize];
    
    CGRect rectJoy = lblShareJoy.frame;
    rectJoy.origin.x = screen_width/2-sizeJoy.width/2;
    rectJoy.size.width = ceilf(sizeJoy.width);
    rectJoy.size.height = ceilf(sizeJoy.height);
    lblShareJoy.frame = rectJoy;
    
    rectOriginalShareJoy = rectJoy;
    
    lblShareJoy.text = str1;
    
    yPos += ceilf(sizeJoy.height)+5*MULTIPLYHEIGHT;
    
    
    UILabel *lblFreeWash = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 20)];
    lblFreeWash.textAlignment = NSTextAlignmentCenter;
    lblFreeWash.numberOfLines = 0;
    lblFreeWash.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
    lblFreeWash.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1];
    lblFreeWash.textColor = [UIColor grayColor];
    
    NSString *str = [NSString stringWithFormat:@"Refer a friend using your invite code and\nyou both get a free wash worth $%.2f", appDel.freewashAmount];
    
    lblFreeWash.text = str;
    [view_Hide addSubview:lblFreeWash];
    
    CGSize sizeFree = [AppDelegate getLabelSizeForRegularText:lblFreeWash.text WithWidth:screen_width FontSize:lblFreeWash.font.pointSize];
    
    CGRect rectLblFree = lblFreeWash.frame;
    rectLblFree.origin.x = screen_width/2-sizeFree.width/2;
    rectLblFree.size.width = ceilf(sizeFree.width);
    rectLblFree.size.height = ceilf(sizeFree.height);
    lblFreeWash.frame = rectLblFree;
    
    yPos += 65*MULTIPLYHEIGHT;
    
    //    float imgGX = 44*MULTIPLYHEIGHT;
    //
    //    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/2-(imgGX/2), yPos, imgGX, imgGX)];
    //    imgView.contentMode = UIViewContentModeScaleAspectFit;
    //    imgView.image = [UIImage imageNamed:@"gift_box.png"];
    //    [view_Share addSubview:imgView];
    //
    //    yPos += imgGX+10*MULTIPLYHEIGHT;
    
    UILabel *lblShareLove = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 20)];
    lblShareLove.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
    lblShareLove.textAlignment = NSTextAlignmentCenter;
    [view_Hide addSubview:lblShareLove];
    lblShareLove.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE];
    lblShareLove.textColor = LIGHT_BLUE_COLOR;
    
    str1 = @"SHARE THE LOVE!";
    
    CGSize sizeLove = [AppDelegate getLabelSizeForRegularText:str1 WithWidth:screen_width FontSize:lblShareLove.font.pointSize];
    
    CGRect rectLove = lblShareLove.frame;
    rectLove.origin.x = screen_width/2-sizeLove.width/2;
    rectLove.size.width = ceilf(sizeLove.width);
    rectLove.size.height = ceilf(sizeLove.height);
    lblShareLove.frame = rectLove;
    
    lblShareLove.text = str1;
    
    yPos += 20*MULTIPLYHEIGHT;
    
    
    UILabel *lblCode = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 20*MULTIPLYHEIGHT)];
    lblCode.textAlignment = NSTextAlignmentCenter;
    lblCode.numberOfLines = 0;
    lblCode.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
    //lblCode.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM+2];
    lblCode.textColor = [UIColor grayColor];
    
    str1 = @"CODE:";
    str2 = [dictMyWallet objectForKey:@"refCode"];
    
    attr1 = nil;
    attr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", str1, str2]];
    
    [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, str1.length)];
    
    [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2], NSForegroundColorAttributeName:[UIColor blackColor]} range:NSMakeRange(str1.length+1, str2.length)];
    
    CGSize sizeCode = [AppDelegate getAttributedTextHeightForText:attr1 WithWidth:screen_width];
    
    CGRect rectCode = lblCode.frame;
    rectCode.origin.x = screen_width/2-sizeCode.width/2;
    rectCode.size.width = ceilf(sizeCode.width+5*MULTIPLYHEIGHT);
    rectCode.size.height = ceilf(sizeCode.height);
    lblCode.frame = rectCode;
    
    lblCode.attributedText = attr1;
    
    [view_Hide addSubview:lblCode];
    
    yPos += 20*MULTIPLYHEIGHT+20*MULTIPLYHEIGHT;
    
    
    //NSArray *arrayIcons = [[NSArray alloc]initWithObjects:@"whatsapp_icon.png", @"fb_icon", @"twitter_icon", @"mail_icon.png", nil];
    
    NSArray *arrayIcons = [[NSArray alloc]initWithObjects:@"whatsapp_icon.png", @"message_icon", @"mail_icon.png", nil];
    
    float viewX = 40*MULTIPLYHEIGHT;
    
    float viewSHeight = 35*MULTIPLYHEIGHT;
    
    UIView *view_Add = [[UIView alloc]initWithFrame:CGRectMake(viewX, yPos, screen_width-(viewX*2), viewSHeight)];
    view_Add.backgroundColor = [UIColor clearColor];
    [view_Hide addSubview:view_Add];
    
    int Width = view_Add.frame.size.width/[arrayIcons count];
    
    for (int i=0; i<[arrayIcons count]; i++)
    {
        UIView *view_Btn = [[UIView alloc]initWithFrame:CGRectMake(i*Width, 0, Width, viewSHeight)];
        view_Btn.backgroundColor = [UIColor clearColor];
        [view_Add addSubview:view_Btn];
        
        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnShare setImage:[UIImage imageNamed:[arrayIcons objectAtIndex:i]] forState:UIControlStateNormal];
        btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnShare.frame = CGRectMake(Width/2-viewSHeight/2, 0, viewSHeight, viewSHeight);
        btnShare.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
        btnShare.tag = i+1;
        [btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view_Btn addSubview:btnShare];
    }
}


//- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
//{
//    if (self.backGroundplayer.playbackState == MPMoviePlaybackStatePlaying)
//    { //playing
//        if (!isTableFreeWashHidden)
//        {
//            lblShareJoy.backgroundColor = [UIColor colorFromHexString:@"eeeeee"];
//        }
//    }
//    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateStopped)
//    { //stopped
//
//    }
//    if (self.backGroundplayer.playbackState == MPMoviePlaybackStatePaused)
//    { //paused
//
//        lblShareJoy.backgroundColor = [UIColor clearColor];
//    }
//    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateInterrupted)
//    { //interrupted
//
//    }
//    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateSeekingForward)
//    { //seeking forward
//
//    }
//    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateSeekingBackward)
//    { //seeking backward
//
//    }
//
//}


-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    if (!isTableFreeWashHidden)
    {
        return;
    }
    
    imgTopStrip.hidden = NO;
    
    view_Share.userInteractionEnabled = NO;
    
    lblShareJoy.backgroundColor = [UIColor clearColor];
    
    float minusHeight = 60*MULTIPLYHEIGHT;
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"free_wash_bg_down" ofType:@"mp4"];
    NSURL *theurl = [NSURL fileURLWithPath:thePath];
    self.backGroundplayer.contentURL = theurl;
    [self.backGroundplayer play];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:0 animations:^{
        
        CGRect frame = view_Share.frame;
        frame.origin.y = view_FreeWash.frame.size.height-minusHeight;
        view_Share.frame = frame;
        
        CGRect rectJoy = lblShareJoy.frame;
        rectJoy.origin.x -= 20*MULTIPLYHEIGHT;
        rectJoy.origin.y = 17*MULTIPLYHEIGHT;
        lblShareJoy.frame = rectJoy;
        
        lblShareJoy.transform = CGAffineTransformScale(lblShareJoy.transform, 0.5, 0.5);
        
        CGRect rectGift = imgViewGift.frame;
        rectGift.origin.x = screen_width-100*MULTIPLYHEIGHT;
        rectGift.origin.y = view_Share.frame.origin.y+7*MULTIPLYHEIGHT;
        imgViewGift.frame = rectGift;
        
        view_Hide.alpha = 0.1;
        
        
    } completion:^(BOOL finished) {
        
        lblShareJoy.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
        
        view_Share.userInteractionEnabled = YES;
        isTableFreeWashHidden = NO;
        
        view_Share.layer.shadowOpacity = 0.3f;
        
    }];
}

-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (isTableFreeWashHidden)
    {
        return;
    }
    
    view_Share.userInteractionEnabled = NO;
    
    lblShareJoy.backgroundColor = [UIColor clearColor];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"free_wash_bg" ofType:@"mp4"];
    NSURL *theurl = [NSURL fileURLWithPath:thePath];
    self.backGroundplayer.contentURL = theurl;
    [self.backGroundplayer play];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:0 animations:^{
        
        float minusHeight = 60*MULTIPLYHEIGHT;
        
        CGRect frame = tblFreeWash.frame;
        frame.origin.y += 1;
        frame.size.height += minusHeight-1;
        view_Share.frame = frame;
        
        imgViewGift.frame = rectOriginalGift;
        
        lblShareJoy.transform = CGAffineTransformScale(lblShareJoy.transform, 2, 2);
        
        lblShareJoy.frame = rectOriginalShareJoy;
        
        view_Hide.alpha = 1.0;
        
        
    } completion:^(BOOL finished) {
        
        lblShareJoy.backgroundColor = [UIColor colorFromHexString:@"fafafa"];
        
        view_Share.userInteractionEnabled = YES;
        isTableFreeWashHidden = YES;
        
        view_Share.layer.shadowOpacity = 0.0f;
        
        imgTopStrip.hidden = YES;
        
    }];
}



-(void) viewShareClicked:(UITapGestureRecognizer *) tap
{
    if (isTableFreeWashHidden)
    {
        [self swipeDown:nil];
    }
    else
    {
        [self swipeUp:nil];
    }
}

-(void) btnShareClicked:(id)sender
{
    UIButton *btnShare = (UIButton *) sender;
    
    if (btnShare.tag == 1)
    {
        [FIRAnalytics logEventWithName:@"share_through_whatsapp_button" parameters:nil];
        
        NSString *msg = [NSString stringWithFormat:@"whatsapp://send?text=%@",appDel.strReferralMessage];
        
        //        msg = [msg stringByAppendingString:@":"];
        //        msg = [msg stringByAppendingString:@"/"];
        //        msg = [msg stringByAppendingString:@"?"];
        //        msg = [msg stringByAppendingString:@","];
        //        msg = [msg stringByAppendingString:@"="];
        //
        //        msg = [msg stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
        //        msg = [msg stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
        //        msg = [msg stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
        //        msg = [msg stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
        //        msg = [msg stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
        msg = [msg stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        msg = [msg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSURL *whatsappURL = [NSURL URLWithString:msg];
        
        if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
        {
            [[UIApplication sharedApplication] openURL: whatsappURL];
        }
        else
        {
            [appDel showAlertWithMessage:@"There is no Whatsapp account configured." andTitle:@"" andBtnTitle:@"OK"];
        }
    }
    else if (btnShare.tag == 3)
    {
        [FIRAnalytics logEventWithName:@"share_through_mail_button" parameters:nil];
        
        if ([MFMailComposeViewController canSendMail])
        {
            NSString *strFW = [NSString stringWithFormat:@"Hey! I've gifted you a free wash worth $%.2f!", appDel.freewashAmount];
            MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
            
            mailCompose.mailComposeDelegate = self;
            [mailCompose setSubject:strFW];
            [mailCompose setMessageBody:appDel.strReferralMessage isHTML:NO];
            
            [self presentViewController:mailCompose animated:YES completion:nil];
        }
        else
        {
            NSString *strFW = [NSString stringWithFormat:@"Hey! I've gifted you a free wash worth $%.2f!", appDel.freewashAmount];
            
            NSString *msg = [NSString stringWithFormat:@"googlegmail://co?subject=%@&body=%@", strFW, appDel.strReferralMessage];
            
            msg = [msg stringByReplacingOccurrencesOfString:@" & " withString:@" %26 "];
            msg = [msg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            NSURL *gmailURL = [NSURL URLWithString:msg];
            
            if ([[UIApplication sharedApplication] canOpenURL: gmailURL])
            {
                [[UIApplication sharedApplication] openURL: gmailURL];
            }
            else
            {
                [appDel showAlertWithMessage:@"There is no email account configured." andTitle:@"" andBtnTitle:@"OK"];
            }
        }
    }
    else if ([btnShare.currentImage isEqual:[UIImage imageNamed:@"fb_icon"]])
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            [FIRAnalytics logEventWithName:@"share_through_facebook_button" parameters:nil];
            
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            [controller setInitialText:[NSString stringWithFormat:@"%@", appDel.strReferralMessage]];
            [controller addURL:[NSURL URLWithString:@"http://piing.com.sg"]];
            
            [controller setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:controller animated:YES completion:Nil];
        }
        else
        {
            [appDel showAlertWithMessage:@"There is no Facebook account configured. you can add or create a Facebook account in Settings." andTitle:@"" andBtnTitle:@"OK"];
        }
    }
    else if (btnShare.tag == 2)
    {
        [FIRAnalytics logEventWithName:@"share_through_sms_button" parameters:nil];
        
        if(![MFMessageComposeViewController canSendText]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        //[messageController setRecipients:recipents];
        [messageController setBody:appDel.strReferralMessage];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
        
        
        return;
        
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@", appDel.strReferralMessage]];
            [tweetSheet addURL:[NSURL URLWithString:@"http://piing.com.sg"]];
            
            [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"Post Canceled");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"Post Sucessful");
                        break;
                        
                    default:
                        break;
                }
            }];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            [appDel showAlertWithMessage:@"There is no Twitter account configured. you can add or create a Twitter account in Settings." andTitle:@"" andBtnTitle:@"OK"];
        }
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
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayFreeWashes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"%ldFreeWashCell",(long)indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        float bgX = 29*MULTIPLYHEIGHT;
        float bgHeight = TABLEVIEW_HEIGHT-20*MULTIPLYHEIGHT;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, 0.0, tableView.frame.size.width-(bgX*2), bgHeight)];
        bgView.tag = 23;
        //bgView.backgroundColor = [UIColor colorWithRed:56.0/255.0 green:173.0/255.0 blue:225.0/255.0 alpha:1.0];
        bgView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bgView];
        
        UIImageView *img_Bg = [[UIImageView alloc]initWithFrame:bgView.bounds];
        img_Bg.image = [UIImage imageNamed:@"mywallet_strip2"];
        [bgView addSubview:img_Bg];
        
        UILabel *lblUnlock = [[UILabel alloc] init];
        lblUnlock.tag = 24;
        lblUnlock.textAlignment = NSTextAlignmentCenter;
        lblUnlock.backgroundColor = [UIColor clearColor];
        lblUnlock.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5];
        lblUnlock.textColor = [UIColor whiteColor];
        [bgView addSubview:lblUnlock];
        
        
        UILabel *lblAmount = [[UILabel alloc] initWithFrame:bgView.bounds];
        lblAmount.tag = 25;
        lblAmount.textAlignment = NSTextAlignmentCenter;
        lblAmount.backgroundColor = [UIColor clearColor];
        lblAmount.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM+1];
        lblAmount.textColor = [UIColor whiteColor];
        [bgView addSubview:lblAmount];
        
        UILabel *lblName = [[UILabel alloc] initWithFrame:bgView.bounds];
        lblName.tag = 26;
        lblName.textAlignment = NSTextAlignmentCenter;
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5];
        lblName.textColor = [UIColor whiteColor];
        [bgView addSubview:lblName];
        
        UILabel *lblExpires = [[UILabel alloc] initWithFrame:bgView.bounds];
        lblExpires.tag = 29;
        lblExpires.numberOfLines = 0;
        lblExpires.textAlignment = NSTextAlignmentCenter;
        lblExpires.backgroundColor = [UIColor clearColor];
        lblExpires.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5];
        lblExpires.textColor = [UIColor whiteColor];
        [bgView addSubview:lblExpires];
        
        UIView *bgMinOrdVal = [[UIView alloc]init];
        bgMinOrdVal.tag = 31;
        [bgView addSubview:bgMinOrdVal];
        
        UILabel *lblMinimumOrderValue = [[UILabel alloc] initWithFrame:bgView.bounds];
        lblMinimumOrderValue.tag = 30;
        lblMinimumOrderValue.textAlignment = NSTextAlignmentCenter;
        lblMinimumOrderValue.backgroundColor = [UIColor clearColor];
        lblMinimumOrderValue.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-6];
        lblMinimumOrderValue.textColor = [UIColor whiteColor];
        [bgView addSubview:lblMinimumOrderValue];
        
        UIImageView *img_Stars_Left = [[UIImageView alloc]init];
        img_Stars_Left.tag = 27;
        img_Stars_Left.backgroundColor = [UIColor clearColor];
        img_Stars_Left.contentMode = UIViewContentModeScaleAspectFit;
        img_Stars_Left.image = [UIImage imageNamed:@"stars_mywallet"];
        [bgView addSubview:img_Stars_Left];
        
        UIImageView *img_Stars_Right = [[UIImageView alloc]init];
        img_Stars_Right.tag = 28;
        img_Stars_Right.backgroundColor = [UIColor clearColor];
        img_Stars_Right.contentMode = UIViewContentModeScaleAspectFit;
        img_Stars_Right.image = [UIImage imageNamed:@"stars_mywallet"];
        [bgView addSubview:img_Stars_Right];
    }
    
    NSDictionary *dictFreeWashes = [arrayFreeWashes objectAtIndex:indexPath.row];
    
    UIView *bgView = (UIView *)[cell viewWithTag:23];
    UILabel *lblUnlock = (UILabel *)[cell viewWithTag:24];
    UILabel *lblAmount = (UILabel *)[cell viewWithTag:25];
    UILabel *lblName = (UILabel *)[cell viewWithTag:26];
    UILabel *lblExpires = (UILabel *)[cell viewWithTag:29];
    UILabel *lblMinimumOrderValue = (UILabel *)[cell viewWithTag:30];
    UIView *bgMinOrdVal = (UIView *)[cell viewWithTag:31];
    
    UIImageView *img_Stars_Left = (UIImageView *) [cell viewWithTag:27];
    UIImageView *img_Stars_Right = (UIImageView *) [cell viewWithTag:28];
    
    lblUnlock.text = @"UNLOCKED 1 FREE WASH";
    
    lblAmount.text = [NSString stringWithFormat:@"WORTH $%.2f", [[dictFreeWashes objectForKey:@"amount"] floatValue]];
    
    lblName.text = [NSString stringWithFormat:@"THANKS TO %@", [[dictFreeWashes objectForKey:@"referBy"] uppercaseString]];
    
    
    NSString *str1 = [NSString stringWithFormat:@"%d", [[dictFreeWashes objectForKey:@"referExpierDays"] intValue]];
    NSString *str2 = @"Days";
    NSString *str3 = @"\nTo Expire";
    
    NSString *strTotal = [NSString stringWithFormat:@"%@%@%@", str1, str2, str3];
    
    NSRange range1 = [strTotal rangeOfString:str1];
    NSRange range2 = [strTotal rangeOfString:str2];
    NSRange range3 = [strTotal rangeOfString:str3];
    
    NSMutableAttributedString *attrExpi = [[NSMutableAttributedString alloc]initWithString:strTotal];
    
//    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
//    paragrapStyle.alignment = NSTextAlignmentCenter;
//    [paragrapStyle setLineSpacing:10];
//    [paragrapStyle setMaximumLineHeight:100.0f];
//
//    [attrExpi addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, attrExpi.length)];
    
    [attrExpi addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BlackItalic size:appDel.FONT_SIZE_CUSTOM+7]} range:range1];
    [attrExpi addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BlackItalic size:appDel.FONT_SIZE_CUSTOM-4]} range:range2];
    [attrExpi addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BlackItalic size:appDel.FONT_SIZE_CUSTOM-4]} range:range3];
    
    //lblExpires.text = [NSString stringWithFormat:@"EXPIRES IN %d DAYS", [[dictFreeWashes objectForKey:@"referExpierDays"] intValue]];
    lblExpires.attributedText = attrExpi;
    
    CGSize sizeExp = [AppDelegate getAttributedTextHeightForText:attrExpi WithWidth:200];
    
    lblExpires.frame = CGRectMake(bgView.frame.size.width-sizeExp.width*1.4, bgView.frame.size.height-sizeExp.height*1.5, sizeExp.width, sizeExp.height);
    
    
    lblMinimumOrderValue.text = [dictFreeWashes objectForKey:@"minOrderVal"];
    
    float yAxis = 15*MULTIPLYHEIGHT;
    
    float lblUHeight = 15*MULTIPLYHEIGHT;
    
    lblUnlock.frame = CGRectMake(0, yAxis, bgView.frame.size.width, lblUHeight);
    yAxis += lblUHeight;
    
    CGSize size = [AppDelegate getLabelSizeForRegularText:lblAmount.text WithWidth:lblAmount.frame.size.width FontSize:lblAmount.font.pointSize];
    
    float lblAHeight = 18*MULTIPLYHEIGHT;
    
    lblAmount.frame = CGRectMake(0, yAxis, bgView.frame.size.width, lblAHeight);
    
    float layerWidth = size.width+10;
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(bgView.frame.size.width/2 - layerWidth/2, 1, layerWidth, 0.6f);
    topLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [lblAmount.layer addSublayer:topLayer];
    
    CALayer *bottomLayer = [[CALayer alloc]init];
    bottomLayer.frame = CGRectMake(bgView.frame.size.width/2 - layerWidth/2, lblAmount.frame.size.height-1, layerWidth, 0.6f);
    bottomLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [lblAmount.layer addSublayer:bottomLayer];
    
    
    float imgX = 22*MULTIPLYHEIGHT;
    float imgWidth = 22*MULTIPLYHEIGHT;
    
    img_Stars_Left.frame = CGRectMake(imgX, yAxis, imgWidth, lblAHeight);
    img_Stars_Right.frame = CGRectMake(bgView.frame.size.width-(imgX*2), yAxis, imgWidth, lblAmount.frame.size.height);
    
    yAxis += lblAHeight;
    
    float lblNHeight = 14*MULTIPLYHEIGHT;
    
    lblName.frame = CGRectMake(0, yAxis, bgView.frame.size.width, lblNHeight);
    
    yAxis += lblName.frame.size.height+2*MULTIPLYHEIGHT;
    
    lblMinimumOrderValue.frame = CGRectMake(0, yAxis, bgView.frame.size.width, lblNHeight);
    
    //CGSize sizeMinVal = [AppDelegate getLabelSizeForRegularText:lblMinimumOrderValue.text WithWidth:bgView.frame.size.width FontSize:lblMinimumOrderValue.font.pointSize];
    
    //lblMinimumOrderValue.frame = CGRectMake(bgView.frame.size.width/2-sizeMinVal.width/2, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    CGFloat bgX = 60*MULTIPLYHEIGHT;
    
    bgMinOrdVal.frame = CGRectMake(bgX, yAxis, bgView.frame.size.width - bgX*2, lblNHeight+2);
    bgMinOrdVal.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    bgMinOrdVal.layer.cornerRadius = bgMinOrdVal.frame.size.height/2;
    
    return cell;
}

#pragma mark TableView Delegate
-(void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //Using animation so the frame change transform will be smooth.
    
    [UIView animateWithDuration:0.1f animations:^{
        
        cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];
    
}
-(void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    [UIView animateWithDuration:0.1f animations:^{
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [appDel showAlertWithMessage:@"Your free wash will be automatically applied for your next order" andTitle:@"" andBtnTitle:@"OK"];
    //
    //    return;
    
    viewBlackBG = [[UIView alloc]initWithFrame:appDel.window.bounds];
    viewBlackBG.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [appDel.window addSubview:viewBlackBG];
    
    viewBlackBG.alpha = 0.0;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        viewBlackBG.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    CGFloat yAxis = 20*MULTIPLYHEIGHT;
    
    CGFloat vW = 200*MULTIPLYHEIGHT;
    CGFloat vH = 114*MULTIPLYHEIGHT;
    
    viewPopup = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2-vW/2, screen_height/2-vH/2, vW, vH)];
    viewPopup.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    [viewBlackBG addSubview:viewPopup];
    viewPopup.layer.masksToBounds = YES;
    viewPopup.layer.cornerRadius = 10*MULTIPLYHEIGHT;
    
    [appDel applyBlurEffectForView:viewPopup Style:BLUR_EFFECT_STYLE_EXTRA_LIGHT];
    
    UILabel *lblText = [[UILabel alloc]init];
    lblText.textColor = [UIColor blackColor];
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.numberOfLines = 0;
    lblText.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
    [viewPopup addSubview:lblText];
    
    NSString *str = @"Your free wash will be automatically\napplied for your next order";
    lblText.text = str;
    
    CGFloat lH = [AppDelegate getLabelHeightForRegularText:str WithWidth:viewPopup.frame.size.width FontSize:lblText.font.pointSize];
    
    lblText.frame = CGRectMake(0, yAxis, viewPopup.frame.size.width, lH);
    
    yAxis += lH+20*MULTIPLYHEIGHT;
    
    UIButton *btnPlace = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPlace setTitle:@"PLACE AN ORDER" forState:UIControlStateNormal];
    [btnPlace setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPlace.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
    btnPlace.backgroundColor = BLUE_COLOR;
    [btnPlace addTarget:self action:@selector(openHomePage) forControlEvents:UIControlEventTouchUpInside];
    [viewPopup addSubview:btnPlace];
    
    float bW = 100*MULTIPLYHEIGHT;
    float bH = 23*MULTIPLYHEIGHT;
    
    btnPlace.frame = CGRectMake(viewPopup.frame.size.width/2-bW/2, yAxis, bW, bH);
    
    yAxis += bH;
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setTitle:@"CANCEL" forState:UIControlStateNormal];
    [btnCancel setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
    [btnCancel addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [viewPopup addSubview:btnCancel];
    
    //    float bW = 100*MULTIPLYHEIGHT;
    //    float bH = 23*MULTIPLYHEIGHT;
    
    btnCancel.frame = CGRectMake(viewPopup.frame.size.width/2-bW/2, yAxis, bW, bH);
}

-(void) openHomePage
{
    [UIView animateWithDuration:0.2 animations:^{
        
        viewBlackBG.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [viewPopup removeFromSuperview];
        viewPopup = nil;
        
        [viewBlackBG removeFromSuperview];
        viewBlackBG = nil;
        
        appDel.customTabBarController.selectedIndex = 0;
    }];
}

-(void) cancelClicked
{
    [UIView animateWithDuration:0.2 animations:^{
        
        viewBlackBG.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [viewPopup removeFromSuperview];
        viewPopup = nil;
        
        [viewBlackBG removeFromSuperview];
        viewBlackBG = nil;
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float tableHeight = TABLEVIEW_HEIGHT;
    return tableHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height;
    
    //    if ([arrayFreeWashes count] == 1)
    //    {
    //        height = 70*MULTIPLYHEIGHT;
    //    }
    //    else
    //    {
    //        height = 55*MULTIPLYHEIGHT;
    //    }
    
    height = 40*MULTIPLYHEIGHT;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = tableView.backgroundColor;
    //footerView.backgroundColor = [UIColor redColor];
    
    float height;
    
    //    if ([arrayFreeWashes count] == 1)
    //    {
    //        height = 70*MULTIPLYHEIGHT;
    //    }
    //    else
    //    {
    //        height = 55*MULTIPLYHEIGHT;
    //    }
    
    height = 40*MULTIPLYHEIGHT;
    
    float lblHeight = 18*MULTIPLYHEIGHT;
    
    UILabel *lblFreeWashTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, height/2-lblHeight/2, tableView.frame.size.width, lblHeight)];
    lblFreeWashTitle.textAlignment = NSTextAlignmentCenter;
    NSString *str = @"FREE WASHES";
    [appDel spacingForTitle:lblFreeWashTitle TitleString:str];
    lblFreeWashTitle.backgroundColor = [UIColor clearColor];
    lblFreeWashTitle.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
    lblFreeWashTitle.textColor = [UIColor grayColor];
    [footerView addSubview:lblFreeWashTitle];
    
    
    CGSize size = [AppDelegate getAttributedTextHeightForText:[lblFreeWashTitle.attributedText mutableCopy] WithWidth:tableView.frame.size.width];
    
    float layerWidth = size.width-25;
    //    CALayer *topLayer = [[CALayer alloc]init];
    //    topLayer.frame = CGRectMake(tableView.frame.size.width/2 - layerWidth/2, 1, layerWidth, 1);
    //    topLayer.backgroundColor = LIGHT_BLUE_COLOR.CGColor;
    //    [lblFreeWashTitle.layer addSublayer:topLayer];
    
    CALayer *bottomLayer = [[CALayer alloc]init];
    bottomLayer.frame = CGRectMake(tableView.frame.size.width/2 - layerWidth/2, lblHeight-1, layerWidth, 1);
    bottomLayer.backgroundColor = LIGHT_BLUE_COLOR.CGColor;
    [lblFreeWashTitle.layer addSublayer:bottomLayer];
    
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
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
