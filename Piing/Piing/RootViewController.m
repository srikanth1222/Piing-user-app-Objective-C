//
//  RootViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "RootViewController.h"
//#import "FirstPageViewController.h"
#import "LoginViewController.h"
#import "RegistrationViewController.h"
//#import "AddressListViewController.h"
//#import "PaymentOptionViewController.h"

#import <MediaPlayer/MediaPlayer.h>
#import "FAQViewController.h"
#import "PriceListViewController_New.h"



@interface RootViewController () <UIPageViewControllerDelegate>
{
    UIPageViewController *pageVC;
    MPMoviePlayerController *backGroundplayer;
    
    UIView *view_Login;
    UIView *view_Popup;
    UIView *view_Tourist;
    UIView *blackTransparentView;
    AppDelegate *appDel;
    UIImageView *welcomePingIcon;
    
    UIView *view_Share, *view_UnderShare;
    
}

@property (nonatomic, strong) UIPageViewController *pageVC;

@end

@implementation RootViewController
@synthesize pageVC;

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Initializing
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    appDel = [PiingHandler sharedHandler].appDel;
    appDel.window.backgroundColor = [UIColor blackColor];
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:MOBILE_APP_VIDEO ofType:@"mp4"];
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
    
    blackTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:blackTransparentView];
    
    welcomePingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 211, 173)];
    
    welcomePingIcon.center = CGPointMake(screen_width/2.0, screen_height/3.0 + 20);
    
    welcomePingIcon.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6 delay:0.6 options:0 animations:^{
        
        welcomePingIcon.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
    }];
    
    welcomePingIcon.image = [UIImage imageNamed:@"welcome icon"];
    [self.view addSubview:welcomePingIcon];
    
    view_Login = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height, screen_width, screen_height)];
    view_Login.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_Login];
    
    view_Login.frame = CGRectMake(0, 0, screen_width, screen_height);
    view_Login.alpha = 0.0;
    
    [UIView animateWithDuration:0.6 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        view_Login.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    float btnHeight = 32*MULTIPLYHEIGHT;
    
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signUpButton.frame = CGRectMake(btnHeight , screen_height-90-btnHeight-10, screen_width - (btnHeight*2), btnHeight);
    [signUpButton addTarget:self action:@selector(signUpBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    signUpButton.backgroundColor = [UIColor clearColor];
    signUpButton.layer.borderColor = [UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:0.8].CGColor;
    signUpButton.layer.borderWidth = 0.5;
    signUpButton.clipsToBounds = NO;
    signUpButton.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE-2];
//    [signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signUpButton setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"SIGN UP" uppercaseString] andWithColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] andFont:[UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE-2]] forState:UIControlStateNormal];
    [signUpButton setTitleColor:[signUpButton.titleLabel.textColor colorWithAlphaComponent:0.9] forState:UIControlStateHighlighted];
    [signUpButton setTitleColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    signUpButton.backgroundColor = [UIColor clearColor];
    [view_Login addSubview:signUpButton];
    [signUpButton setBackgroundImage:[AppDelegate imageWithColor:[[UIColor colorFromHexString:@"#ededed"]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    loginButton.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE-2];
    [loginButton setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"LOGIN" uppercaseString] andWithColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] andFont:[UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE-2]] forState:UIControlStateNormal];
    loginButton.backgroundColor = BLUE_COLOR;
    [loginButton setTitleColor:[loginButton.titleLabel.textColor colorWithAlphaComponent:0.9] forState:UIControlStateHighlighted];
    loginButton.clipsToBounds = NO;
    [loginButton setTitleColor:[UIColor colorWithRed:240.0/255.0 green:242.0/255.0 blue:241.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    loginButton.frame = CGRectMake(CGRectGetMinX(signUpButton.frame), CGRectGetMaxY(signUpButton.frame)+10, CGRectGetWidth(signUpButton.frame), btnHeight);
    [view_Login addSubview:loginButton];
    [loginButton setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    
    
    UIButton *btnKnowMore = [UIButton buttonWithType:UIButtonTypeCustom];
    [view_Login addSubview:btnKnowMore];
    
    btnKnowMore.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    float btnKW = 150*MULTIPLYHEIGHT;
    float btnKX = screen_width/2-btnKW/2;
    
    btnKnowMore.frame = CGRectMake(btnKX, CGRectGetMaxY(loginButton.frame)+10*MULTIPLYHEIGHT, btnKW, 25*MULTIPLYHEIGHT);
    [btnKnowMore addTarget:self action:@selector(knowMoreClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str1 = [@"Know more" uppercaseString];
    
    NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:str1];
    
    [mainAttr addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)} range:NSMakeRange(0, str1.length)];
    
    [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4], NSForegroundColorAttributeName:[UIColor whiteColor], NSUnderlineStyleAttributeName:@(NSUnderlinePatternSolid |NSUnderlineStyleDouble)} range:NSMakeRange(0, str1.length)];
    
    [btnKnowMore setAttributedTitle:mainAttr forState:UIControlStateNormal];
    
    
    if (appDel.isVerificationCodeEnabled)
    {
        appDel.isVerificationCodeEnabled = NO;
        
        RegistrationViewController *registeVC = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil andWithType:NO];
        registeVC.verificationCodeEnabled = YES;
        
        UINavigationController *navReg = [[UINavigationController alloc]initWithRootViewController:registeVC];
        
        [self.navigationController presentViewController:navReg animated:YES completion:nil];
    }
   
}

-(void) knowMoreClicked
{
    
    blackTransparentView.backgroundColor = [UIColor clearColor];
    
    [appDel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
    
    [self.view insertSubview:blackTransparentView aboveSubview:welcomePingIcon];
    
    //return;
    
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
    
    
    CGFloat yAxis = 0;
    
    float btnaHeight = 35*MULTIPLYHEIGHT;
    
    NSArray *array = @[@"Pricing", @"Faq"];
    
    for (int i = 0; i < [array count]; i++)
    {
        UIImageView *imgLine = [[UIImageView alloc]init];
        imgLine.frame = CGRectMake(0, yAxis, view_details.frame.size.width, 1);
        imgLine.backgroundColor = RGBCOLORCODE(200, 200, 200, 1.0);
        [view_details addSubview:imgLine];
        
        UIButton *btnCall = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCall.tag = i+1;
        
        NSMutableAttributedString *strAttrCal = [appDel getAttributedStringWithString:[[array objectAtIndex:i]uppercaseString] WithSpacing:0.4];
        
        [btnCall setAttributedTitle:strAttrCal forState:UIControlStateNormal];
        
        [btnCall setTitleColor:[[UIColor blackColor]colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
        [btnCall setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btnCall.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
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
        
        view_Share.alpha = 1.0;
        view_Login.alpha = 0.0;
        
        
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void) btnOptionsClicked:(UIButton *) sender
{
    if (sender.tag == 1)
    {
        PriceListViewController_New *pVC = [[PriceListViewController_New alloc] init];
        pVC.isFlipping = YES;
        
        [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [self addChildViewController:pVC];
            [self.view addSubview:pVC.view];
            
        } completion:nil];
    }
    else
    {
        FAQViewController *faq = [[FAQViewController alloc]init];
        faq.code = 1;
        
        [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            
            [self addChildViewController:faq];
            [self.view addSubview:faq.view];
            
        } completion:nil];
    }
}

-(void) btnCloseClicked
{
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect rect = view_UnderShare.frame;
        rect.origin.y = screen_height;
        view_UnderShare.frame = rect;
        
        view_Share.alpha = 0.0;
        view_Login.alpha = 1.0;
        
        
    } completion:^(BOOL finished) {
        
        [view_Share removeFromSuperview];
        view_Share = nil;
        
        blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [appDel removeBlurEffectForView:blackTransparentView];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [backGroundplayer play];
    
    if (!view_Share)
    {
        view_Login.alpha = 1.0;
        view_Popup.alpha = 0.0;
        
        [self.view insertSubview:welcomePingIcon aboveSubview:blackTransparentView];
        blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [appDel removeBlurEffectForView:blackTransparentView];
    }
}

-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [backGroundplayer stop];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    // update the nav bar title showing which index we are displaying
//    [self updateNavBarTitle];
    
}

//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
//    
//    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
//    UIViewController *currentViewController = self.pageVC.viewControllers[0];
//    NSArray *viewControllers = @[currentViewController];
//    [self.pageVC setViewControllers:viewControllers
//                                      direction:UIPageViewControllerNavigationDirectionForward
//                                       animated:YES
//                                     completion:nil];
//    
//    self.pageVC.doubleSided = NO;
//    
//    return UIPageViewControllerSpineLocationMin;
//}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UICOntrol Methods

-(void) closePopupScreen
{
    [self.view endEditing:YES];
    
    [UIView animateKeyframesWithDuration:0.2 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Popup.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [view_Popup removeFromSuperview];
        view_Popup = nil;
        
        view_Login.alpha = 1.0;
        
        [self.view insertSubview:welcomePingIcon aboveSubview:blackTransparentView];
        blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [appDel removeBlurEffectForView:blackTransparentView];
        
    }];
}


-(void) signUpBtnClicked
{
    blackTransparentView.backgroundColor = [UIColor clearColor];
    
    [appDel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
    
    [self.view insertSubview:blackTransparentView aboveSubview:welcomePingIcon];
    
    if (!view_Popup)
    {
        
        view_Popup = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
        view_Popup.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view_Popup];
        
        float popUpHeight = 130*MULTIPLYHEIGHT;
        
        
        float viewTouristWidth = 30*MULTIPLYHEIGHT;
        
        view_Tourist = [[UIView alloc]initWithFrame:CGRectMake(viewTouristWidth, 50, screen_width-(viewTouristWidth*2), popUpHeight)];
        view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
        view_Tourist.layer.cornerRadius = 5.0;
        view_Tourist.layer.masksToBounds = YES;
        view_Popup.alpha = 0.0;
        [view_Popup addSubview:view_Tourist];
        
        float viewWidth = view_Tourist.frame.size.width;
        
        [appDel applyBlurEffectForView:view_Tourist Style:BLUR_EFFECT_STYLE_EXTRA_LIGHT];
        
        float piingiconHeight = 45*MULTIPLYHEIGHT;
        
        UIImageView *imgPiing = [[UIImageView alloc]init];
        imgPiing.image = [UIImage imageNamed:@"Piing_icon_reg"];
        imgPiing.backgroundColor = [UIColor clearColor];
        [view_Popup addSubview:imgPiing];
        imgPiing.contentMode = UIViewContentModeScaleAspectFit;
        imgPiing.frame = CGRectMake(0, 0, piingiconHeight, piingiconHeight);
        imgPiing.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2-(view_Tourist.frame.size.height/2));
        
        float closeHeight = 33*MULTIPLYHEIGHT;
        
        UIButton *closePCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closePCBtn.frame = CGRectMake(view_Tourist.frame.size.width-closeHeight, 0.0, closeHeight, closeHeight);
        closePCBtn.center = CGPointMake(view_Tourist.frame.origin.x, view_Popup.frame.size.height/2-(view_Tourist.frame.size.height/2));
        [closePCBtn setImage:[UIImage imageNamed:@"cancel_popup"] forState:UIControlStateNormal];
        [closePCBtn addTarget:self action:@selector(closePopupScreen) forControlEvents:UIControlEventTouchUpInside];
        [view_Popup addSubview:closePCBtn];
        
        
        float yAxis = 20*MULTIPLYHEIGHT;
        
        UILabel *LblTourist = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, view_Tourist.frame.size.width, 40)];
        LblTourist.text = @"ARE YOU A TOURIST?";
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
        imgLine.backgroundColor = [UIColor lightGrayColor];
        [view_Tourist addSubview:imgLine];
        
        yAxis += 5*MULTIPLYHEIGHT;
        
        UILabel *LblDesc = [[UILabel alloc] initWithFrame:CGRectMake(20, yAxis, viewWidth-40, 40.0)];
//        LblDesc.text = [@"A SMARTER, LAUNDRY FREE LIFE IS AT YOUR FINGERTIPS NOW! SEND FRIEND A FREE SEND WORTH $15."capitalizedString];
        
        LblDesc.text = @"Pick the right option for a personalized laundry experience.";
        
        LblDesc.textAlignment = NSTextAlignmentCenter;
        LblDesc.numberOfLines = 0;
        LblDesc.textColor = [UIColor colorFromHexString:@"#585858"];
        LblDesc.backgroundColor = [UIColor clearColor];
        LblDesc.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [view_Tourist addSubview:LblDesc];
        
        CGSize descSize = [AppDelegate getLabelSizeForRegularText:LblDesc.text WithWidth:viewWidth-40 FontSize:LblDesc.font.pointSize];
        
        CGRect frameDesc = LblDesc.frame;
        frameDesc.size.height = descSize.height;
        LblDesc.frame = frameDesc;
        
        yAxis += frameDesc.size.height+(10*MULTIPLYHEIGHT);
        
        
        CGFloat btnHeight = 30*MULTIPLYHEIGHT;
        
        UIButton *btnYes = [UIButton buttonWithType:UIButtonTypeCustom];
        btnYes.frame = CGRectMake(0, yAxis, view_Tourist.frame.size.width/2-1, btnHeight);
        btnYes.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2];
        [btnYes setTitle:@"YES" forState:UIControlStateNormal];
        [btnYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnYes.backgroundColor = APPLE_BLUE_COLOR;
        [btnYes addTarget:self action:@selector(btnYES_or_No_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        btnYes.tag = 1;
        [view_Tourist addSubview:btnYes];
        [btnYes setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        UIButton *btnNO = [UIButton buttonWithType:UIButtonTypeCustom];
        btnNO.frame = CGRectMake(view_Tourist.frame.size.width/2, yAxis, view_Tourist.frame.size.width/2, btnHeight);
        btnNO.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2];
        [btnNO setTitle:@"NO" forState:UIControlStateNormal];
        [btnNO setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnNO.backgroundColor = APPLE_BLUE_COLOR;
        [btnNO addTarget:self action:@selector(btnYES_or_No_Clicked:) forControlEvents:UIControlEventTouchUpInside];
        btnNO.tag = 2;
        [view_Tourist addSubview:btnNO];
        [btnNO setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        yAxis += btnHeight;
        
        CGRect frameView = view_Tourist.frame;
        frameView.size.height = yAxis;
        view_Tourist.frame = frameView;
        
        view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
        imgPiing.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2-(view_Tourist.frame.size.height/2));
        closePCBtn.center = CGPointMake(view_Tourist.frame.origin.x, view_Popup.frame.size.height/2-(view_Tourist.frame.size.height/2));
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 1.0;
            view_Login.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }
    else
    {
        view_Popup.alpha = 0.0;
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 1.0;
            view_Login.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            
        }];

    }
    
    
    return;
    
    UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@"Register as"
                                                                               message:@"Are you a tourist"
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
    {
                                                              
        
        [[NSUserDefaults standardUserDefaults] setObject:@"T" forKey:IS_TOURIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        RegistrationViewController *registeVC = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil andWithType:YES];
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:registeVC];
        
        [self.navigationController presentViewController:navVC animated:YES completion:^{
            
        }];
        
    }];
    
    
    UIAlertAction* noAlert = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
    {
                                  
        [[NSUserDefaults standardUserDefaults] setObject:@"R" forKey:IS_TOURIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        RegistrationViewController *registeVC = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil andWithType:NO];
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:registeVC];
        
        [self.navigationController presentViewController:navVC animated:YES completion:^{
            
        }];
        
    }];
    
    [errorMessageAlert addAction:defaultAction];
    [errorMessageAlert addAction:noAlert];
    [self presentViewController:errorMessageAlert animated:YES completion:nil];
    
}

-(void) loginButtonClicked
{
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                        [self.navigationController pushViewController:loginVC animated:NO];
                    }
                    completion:nil];
}



-(void) btnYES_or_No_Clicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    if (btn.tag == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"T" forKey:IS_TOURIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        RegistrationViewController *registeVC = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil andWithType:YES];
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:registeVC];
        [self.navigationController presentViewController:navVC animated:YES completion:^{
            
        }];
    }
    else if (btn.tag == 2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"R" forKey:IS_TOURIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        RegistrationViewController *registeVC = [[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil andWithType:NO];
        
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:registeVC];
        [self.navigationController presentViewController:navVC animated:YES completion:^{
            
        }];
    }
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}
@end
