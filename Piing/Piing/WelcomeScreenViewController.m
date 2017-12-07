//
//  WelcomeScreenViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 10/01/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "WelcomeScreenViewController.h"
#import "ListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "PriceListViewController_New.h"



@interface WelcomeScreenViewController () <RESideMenuDelegate, PriceListViewController_NewDelegate>
{
    MPMoviePlayerController *backGroundplayer;
    AppDelegate *appDel;
    UIImageView *welcomePingIcon;
    
    BOOL animating;
    
    UILabel *lblTitle;
    UILabel *lblDesc;
    UIButton *welcomeButton;
    
    UIButton *btnPrice;
}

@end

@implementation WelcomeScreenViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [PiingHandler sharedHandler].appDel;
    appDel.window.backgroundColor = [UIColor blackColor];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SHOW_DEMO"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"welcome_video" ofType:@"mp4"];
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
    [backGroundplayer setScalingMode:MPMovieScalingModeFill];
    
    
    UIView *viewBG = [[UIView alloc]init];
    //viewBG.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    viewBG.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewBG];
    viewBG.frame = CGRectMake(20, 0, screen_width-40, 100);
    
    float deleteHowmuch = 72*MULTIPLYHEIGHT;
    
    welcomePingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(viewBG.frame.size.width/2-(deleteHowmuch/2), 0, deleteHowmuch, deleteHowmuch)];
    welcomePingIcon.contentMode = UIViewContentModeScaleAspectFit;
    //welcomePingIcon.center = CGPointMake(screen_width/2, screen_height/2-(deleteHowmuch*1.5));
    welcomePingIcon.image = [UIImage imageNamed:@"piing_bell"];
    [viewBG addSubview:welcomePingIcon];
    welcomePingIcon.layer.cornerRadius = welcomePingIcon.frame.size.width/2;
    welcomePingIcon.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    
    animating = YES;
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(stopAnimation) userInfo:nil repeats:NO];
    [self performSelector:@selector(rotateRight) withObject:nil];
    
    
    
    lblTitle = [[UILabel alloc]init];
    lblTitle.frame = CGRectMake(0, 0, viewBG.frame.size.width, 40);
    lblTitle.numberOfLines = 0;
    lblTitle.backgroundColor = welcomePingIcon.backgroundColor;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor = [UIColor whiteColor];
    //lblTitle.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM+12];
    [viewBG addSubview:lblTitle];
    lblTitle.alpha = 0.0;
    
    NSString *str1 = @"THANK YOU\nFOR REGISTERING";
    
    NSMutableAttributedString *attrMain = [[NSMutableAttributedString alloc]initWithString:str1];
    [attrMain addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+10], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, str1.length)];
    
    float spacing = 3.0f;
    [attrMain addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrMain length])];
    
//    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
//    paragrapStyle.alignment = NSTextAlignmentCenter;
//    [paragrapStyle setLineSpacing:10.0f];
//    [paragrapStyle setMaximumLineHeight:100.0f];
//    
//    [attrMain addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, attrMain.length)];
    
    CGSize size = [AppDelegate getAttributedTextHeightForText:attrMain WithWidth:viewBG.frame.size.width];
    lblTitle.frame = CGRectMake(0, welcomePingIcon.frame.origin.y + welcomePingIcon.frame.size.height, viewBG.frame.size.width, size.height);
    
    //deleteHowmuch = 71*MULTIPLYHEIGHT;
    //lblTitle.center = CGPointMake(screen_width/2, screen_height/2-deleteHowmuch);
    lblTitle.attributedText = attrMain;
    
    
    lblDesc = [[UILabel alloc]init];
    lblDesc.text = @"You're one step closer to a laundry-free life!";
    lblDesc.textAlignment = NSTextAlignmentCenter;
    lblDesc.numberOfLines = 0;
    lblDesc.textColor = [UIColor whiteColor];
    lblDesc.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
    [viewBG addSubview:lblDesc];
    lblDesc.backgroundColor = welcomePingIcon.backgroundColor;
    lblDesc.alpha = 0.0;
    
    CGSize sizeheight = [AppDelegate getLabelSizeForRegularText:lblDesc.text WithWidth:viewBG.frame.size.width FontSize:lblDesc.font.pointSize];
    lblDesc.frame = CGRectMake(0, lblTitle.frame.origin.y+lblTitle.frame.size.height, viewBG.frame.size.width, sizeheight.height+10);
    
    viewBG.frame = CGRectMake(20, welcomePingIcon.frame.origin.y, screen_width-40, (lblDesc.frame.origin.y+lblDesc.frame.size.height+20)-welcomePingIcon.frame.origin.y);
    
    
    
    viewBG.center = CGPointMake(screen_width/2, screen_height/2-deleteHowmuch);
    viewBG.layer.cornerRadius = viewBG.frame.size.width/4;
    
    viewBG.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6 delay:1.0 options:0 animations:^{
        
        viewBG.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    
    welcomeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [welcomeButton addTarget:self action:@selector(welcomeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [welcomeButton setTitle:@"" forState:UIControlStateNormal];
    welcomeButton.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM];
    [welcomeButton setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"BOOK A PICK-UP SLOT" uppercaseString] andWithColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] andFont:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM]] forState:UIControlStateNormal];
    welcomeButton.backgroundColor = BLUE_COLOR;
    [welcomeButton setTitleColor:[welcomeButton.titleLabel.textColor colorWithAlphaComponent:0.9] forState:UIControlStateHighlighted];
    welcomeButton.clipsToBounds = NO;
    [welcomeButton setTitleColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [welcomeButton setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    
    float deleteHowmuch1 = 80*MULTIPLYHEIGHT;
    float welcomeBtnX = 29*MULTIPLYHEIGHT;
    float welcomeBtnHeight = 35*MULTIPLYHEIGHT;
    
    welcomeButton.frame = CGRectMake(welcomeBtnX, screen_height-deleteHowmuch1, screen_width - (welcomeBtnX*2), welcomeBtnHeight);
    [self.view addSubview:welcomeButton];
    
    welcomeButton.alpha = 0.0;
    
    
    
    btnPrice = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPrice setTitle:@"CHECK PRICING" forState:UIControlStateNormal];
    [btnPrice setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnPrice.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-1];
    [self.view addSubview:btnPrice];
    [btnPrice setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btnPrice addTarget:self action:@selector(btnPricingClicked) forControlEvents:UIControlEventTouchUpInside];
//    [btnPrice setImage:[UIImage imageNamed:@"check_pricing"] forState:UIControlStateNormal];
//    btnPrice.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    btnPrice.layer.borderColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7].CGColor;
    btnPrice.layer.borderWidth = 1.0;
    
    
    float btnPriceHeight = 30*MULTIPLYHEIGHT;
    float btnPriceY = screen_height-(deleteHowmuch1+btnPriceHeight*1.4);
    
    btnPrice.frame = CGRectMake(welcomeBtnX, btnPriceY, screen_width-(welcomeBtnX*2), btnPriceHeight);
    
    btnPrice.alpha = 0.0;
    
    
    appDel.openWelcomePopup = YES;
    
}


-(void) btnPricingClicked
{
    PriceListViewController_New *pVC = [[PriceListViewController_New alloc] init];
    pVC.delegate = self;
    pVC.isFromWelcome = YES;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pVC];
    nav.navigationBarHidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

-(void) didDismissPricingView
{
    [self welcomeButtonClicked];
}

-(void) rotateRight
{
    if (animating)
    {
        [UIView animateWithDuration:0.05 animations:^{
            
            welcomePingIcon.transform = CGAffineTransformMakeRotation(M_PI/50);
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(rotateLeft) withObject:nil];
            
        }];
    }
    else
    {
        [self showAll];
    }
}

-(void) rotateLeft
{
    if (animating)
    {
        [UIView animateWithDuration:0.05 animations:^{
            
            welcomePingIcon.transform = CGAffineTransformMakeRotation(M_PI/-50);
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(rotateRight) withObject:nil];
            
        }];
    }
    else
    {
        [self showAll];
    }
}


-(void) showAll
{
    welcomePingIcon.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.6 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        lblTitle.alpha = 1.0;
        lblDesc.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    [UIView animateWithDuration:0.6 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        welcomeButton.alpha = 1.0;
        btnPrice.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
}


-(void) stopAnimation
{
    animating = NO;
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [backGroundplayer stop];
}

-(void) welcomeButtonClicked
{
    
    for (id view in appDel.window.subviews)
    {
        [view removeFromSuperview];
    }
    
    appDel.customTabBarController = [[TabBarViewController alloc] init];
    ListViewController *listVC = [[ListViewController alloc] init];
    
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:appDel.customTabBarController
                                                                    leftMenuViewController:nil
                                                                   rightMenuViewController:listVC];
    
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = appDel;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.6;
    sideMenuViewController.contentViewShadowRadius = 12;
    sideMenuViewController.contentViewShadowEnabled = YES;
    
    appDel.window.rootViewController = sideMenuViewController;
    [appDel.window addSubview:sideMenuViewController.view];
    
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
