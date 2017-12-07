//
//  IntraScreenViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 08/04/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "IntraScreenViewController.h"
#import "RootViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface IntraScreenViewController () <UIScrollViewDelegate>
{
    UIPageControl *pageControlBottom;
    UIScrollView *scrollIntra;
    
    UIImageView *imgShirt;
    UIImageView *imgWashingMachine;
    UIImageView *imgVan;
    UIImageView *imgDelivery;
    
    NSInteger page;
    float fractionalPage;
    float fractionalPageGlobal;
    
    NSTimer *timer;
    
    BOOL washingMachineAnimated;
    
    CGFloat scaleShirt;
    CGFloat scaleVan;
    
    AppDelegate *appDel;
    
    UIButton *BtnGetStarted;
    
    UIImageView *imgBG;
    UIImageView *imgLogo;
    
    UIView *view_Splash;
}

@property (nonatomic, strong) MPMoviePlayerController *backGroundplayer;

@end

@implementation IntraScreenViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    appDel = [[PiingHandler sharedHandler] appDel];
    
    view_Splash = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view_Splash];
    
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"splash_video" ofType:@"mp4"];
    NSURL *theurl = [NSURL fileURLWithPath:thePath];
    
    self.backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
    self.backGroundplayer.view.frame = CGRectMake(0, 0, screen_width, view_Splash.frame.size.height);
    self.backGroundplayer.repeatMode = YES;
    self.backGroundplayer.view.userInteractionEnabled = YES;
    self.backGroundplayer.controlStyle = MPMovieControlStyleNone;
    [self.backGroundplayer prepareToPlay];
    [self.backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
    //self.backGroundplayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.backGroundplayer.backgroundView.backgroundColor = [UIColor blackColor];
    self.backGroundplayer.view.backgroundColor = [UIColor blackColor];
    [view_Splash addSubview:self.backGroundplayer.view];
    [self.backGroundplayer setScalingMode:MPMovieScalingModeAspectFill];
    
    [self.backGroundplayer play];
    
    
    imgBG = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgBG.image = [UIImage imageNamed:@"splashscreen"];
    [view_Splash addSubview:imgBG];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        imgBG.alpha = 0.0;
//        
//    } completion:^(BOOL finished) {
//        
//    }];
    
    
//    float imgY = 70*MULTIPLYHEIGHT;
//    
//    float imgHeight = 80*MULTIPLYHEIGHT;
//    
//    imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, imgY, screen_width, imgHeight)];
//    imgLogo.contentMode = UIViewContentModeScaleAspectFit;
//    imgLogo.image = [UIImage imageNamed:@"splash_piing_logo"];
//    [view_Splash addSubview:imgLogo];
//    
//    imgLogo.alpha = 1.0;
//    
//    [UIView animateWithDuration:0.6 delay:0.0 options:0 animations:^{
//        
//        imgLogo.alpha = 1.0;
//        
//    } completion:^(BOOL finished) {
//        
//        [self performSelector:@selector(intraScreens) withObject:nil afterDelay:2.0];
//        
//    }];
    
    [self performSelector:@selector(intraScreens) withObject:nil afterDelay:4.0];
    
}

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    if (self.backGroundplayer.playbackState == MPMoviePlaybackStatePlaying)
    { //playing
        
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            
            imgBG.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
        }];

    }
    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateStopped)
    { //stopped
        
    }
    if (self.backGroundplayer.playbackState == MPMoviePlaybackStatePaused)
    { //paused
        
    }
    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateInterrupted)
    { //interrupted
        
    }
    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateSeekingForward)
    { //seeking forward
        
    }
    if (self.backGroundplayer.playbackState == MPMoviePlaybackStateSeekingBackward)
    { //seeking backward
        
    }
    
}

-(void) intraScreens
{
    
    scrollIntra = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    scrollIntra.delegate = self;
    scrollIntra.pagingEnabled = YES;
    [self.view addSubview:scrollIntra];
    scrollIntra.showsHorizontalScrollIndicator = NO;
    scrollIntra.showsVerticalScrollIndicator = NO;
    scrollIntra.bounces = NO;
    scrollIntra.alpha = 0.0;
    
    [UIView animateWithDuration:0.01 delay:0.5 options:0 animations:^{
        
//        scrollIntra.frame = CGRectMake(0, 0, screen_width, screen_height);
//        view_Splash.frame = CGRectMake(-screen_width, 0, screen_width, screen_height);
        
        view_Splash.alpha = 0.0;
        scrollIntra.alpha = 1.0;
        
    } completion:^(BOOL finished) {
       
        [view_Splash removeFromSuperview];
        view_Splash = nil;
        
    }];
    
    
    
    scaleVan = 1.0;
    
    NSArray *arrayImages = [NSArray arrayWithObjects:@"first_screen", @"second_screen", @"third_screen", @"fourth_screen", @"fifth_screen", nil];
    
    NSArray *arrayText = [NSArray arrayWithObjects:@"Request an on-demand\npick-up or schedule one for later", @"Track your order\nreal-time right until delivery", @"At your service,\n6 days a week, from 1 PM to 11 PM", @"Enjoy next-day deliveries,\nanywhere you want", @"Pay with cash or electronically,\nusing our secure payment gateway", nil];
    
    float xAxis = 0;
    
    float imgX = 30*MULTIPLYHEIGHT;
    
    for (int i=0; i<[arrayImages count]; i++)
    {
        
        CGFloat imgHeight = 320*MULTIPLYHEIGHT;
        CGFloat imgY = 14.4*MULTIPLYHEIGHT;
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(xAxis+imgX, imgY, scrollIntra.frame.size.width-(imgX*2), imgHeight)];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.image = [UIImage imageNamed:[arrayImages objectAtIndex:i]];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollIntra addSubview:imgView];
        
        UILabel *lblText = [[UILabel alloc]init];
        lblText.text = [arrayText objectAtIndex:i];
        lblText.frame = CGRectMake(xAxis+imgX, imgView.frame.origin.y+imgView.frame.size.height, scrollIntra.frame.size.width-(imgX*2), 30*MULTIPLYHEIGHT);
        lblText.numberOfLines = 0;
        lblText.textAlignment = NSTextAlignmentCenter;
        lblText.textColor = RGBCOLORCODE(120, 120, 120, 1.0);
        lblText.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+1];
        [scrollIntra addSubview:lblText];
        
        
        xAxis += scrollIntra.frame.size.width;
    }
    
    [scrollIntra setContentSize:CGSizeMake(xAxis, scrollIntra.frame.size.height)];
    
    float minusPageY = 60*MULTIPLYHEIGHT;
    
    pageControlBottom = [[UIPageControl alloc]initWithFrame:CGRectMake(0, scrollIntra.frame.size.height-minusPageY, screen_width, 37)];
    pageControlBottom.autoresizingMask = UIViewAutoresizingNone;
    pageControlBottom.backgroundColor = [UIColor clearColor];
    pageControlBottom.numberOfPages = [arrayImages count];
    pageControlBottom.pageIndicatorTintColor = [BLUE_COLOR colorWithAlphaComponent:0.3];
    pageControlBottom.currentPageIndicatorTintColor = BLUE_COLOR;
    //[pageControlBottom addTarget:self action:@selector(pagecontrolClicked:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControlBottom];
    pageControlBottom.userInteractionEnabled = NO;
    
    
    CGFloat imgShirtX = 100*MULTIPLYHEIGHT;
    CGFloat imgShirtHeight = 21.6*MULTIPLYHEIGHT;
    CGFloat imgShirtMinusY = 36*MULTIPLYHEIGHT;
    
    imgShirt = [[UIImageView alloc]init];
    imgShirt.frame = CGRectMake(screen_width-imgShirtX, screen_height/2-imgShirtMinusY, imgShirtHeight, imgShirtHeight);
    imgShirt.image = [UIImage imageNamed:@"shirt_hang"];
    imgShirt.contentMode = UIViewContentModeScaleAspectFit;
    [scrollIntra addSubview:imgShirt];
    
    CGFloat imgWX = 72*MULTIPLYHEIGHT;
    CGFloat imgWY = 180*MULTIPLYHEIGHT;
    
    imgWashingMachine = [[UIImageView alloc]init];
    imgWashingMachine.frame = CGRectMake(screen_width+(screen_width/2-imgWX/2), imgWY, imgWX, imgWX);
    imgWashingMachine.image = [UIImage imageNamed:@"washing_machin"];
    imgWashingMachine.contentMode = UIViewContentModeScaleAspectFit;
    [scrollIntra addSubview:imgWashingMachine];
    
    
    CGFloat imgVX = 46*MULTIPLYHEIGHT;
    CGFloat imgVY = 219*MULTIPLYHEIGHT;
    CGFloat imgVWidth = 87*MULTIPLYHEIGHT;
    CGFloat imgVHeight = 36*MULTIPLYHEIGHT;
    
    imgVan = [[UIImageView alloc]init];
    imgVan.frame = CGRectMake((screen_width*2)+imgVX, imgVY, imgVWidth, imgVHeight);
    imgVan.image = [UIImage imageNamed:@"van"];
    imgVan.contentMode = UIViewContentModeScaleAspectFit;
    [scrollIntra addSubview:imgVan];
    
    
    CGFloat imgDX = 21.6*MULTIPLYHEIGHT;
    CGFloat imgDY = 158.3*MULTIPLYHEIGHT;
    CGFloat imgDWidth = 36*MULTIPLYHEIGHT;
    CGFloat imgDHeight = 58*MULTIPLYHEIGHT;
    
    imgDelivery = [[UIImageView alloc]init];
    imgDelivery.frame = CGRectMake((screen_width*4)-(screen_width/2)+imgDX, imgDY, imgDWidth, imgDHeight);
    
    CGFloat imgDTrans = 0.2;
    imgDelivery.transform = CGAffineTransformMakeScale(imgDTrans, imgDTrans);
    imgDelivery.image = [UIImage imageNamed:@"deliveybag"];
    imgDelivery.contentMode = UIViewContentModeScaleAspectFit;
    [scrollIntra addSubview:imgDelivery];
    imgDelivery.alpha = 0.0;
    
    
    
    scaleShirt = 1.0f;
    fractionalPageGlobal = 0.0;
    
    float btnHeight = 30*MULTIPLYHEIGHT;
    
    BtnGetStarted = [UIButton buttonWithType:UIButtonTypeCustom];
    BtnGetStarted.frame = CGRectMake(0, screen_height, screen_width, btnHeight);
    BtnGetStarted.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.8];
    BtnGetStarted.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2];
    //[BtnGetStarted setTitle:@"GET STARTED" forState:UIControlStateNormal];
    [BtnGetStarted setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"GET STARTED" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2]] forState:UIControlStateNormal];
    [BtnGetStarted addTarget:self action:@selector(GetStarted:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:BtnGetStarted];
    [BtnGetStarted setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    
    BtnGetStarted.alpha = 0.0;
}

-(void) GetStarted:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"INTRA_SHOWN"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    for (id view in appDel.window.subviews)
    {
        [view removeFromSuperview];
    }
    
    RootViewController *homeViewController = [[RootViewController alloc] init];
    UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    appDel.window.rootViewController = rootNavController;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    if (page == 1)
//    {
//        CGFloat pageWidth = scrollIntra.frame.size.width;
//        float fractionalPage = scrollIntra.contentOffset.x / pageWidth;
//        
//        [self performSelector:@selector(rotateRight) withObject:nil];
//    }
//    else
//    {
//        //imgWashingMachine.transform = CGAffineTransformMake
//    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
//    CGPoint scrollVelocity = [[scrollIntra panGestureRecognizer] velocityInView:self.view];
//    NSLog(@"velocity : %f", scrollVelocity.x);
    
    BtnGetStarted.alpha = 0.0;
    
    CGFloat pageWidth = scrollIntra.frame.size.width;
    fractionalPage = scrollIntra.contentOffset.x / pageWidth;
    
    page = lround(fractionalPage);
    
    pageControlBottom.currentPage = page;
    
    if (fractionalPage < 1.0)
    {
        float someX = scrollView.contentOffset.x;
        
        if (fractionalPage > 0.8)
        {
            [UIView animateWithDuration:0.15 delay:0.0 options:0 animations:^{
                
                imgShirt.alpha = 0.3;
                
            } completion:^(BOOL finished) {
                
                
            }];
        }
        else
        {
            imgShirt.alpha = 1.0;
        }
        
        CGFloat imgShirtX = 89*MULTIPLYHEIGHT;
        CGFloat imgShirtY = 25.2*MULTIPLYHEIGHT;
        
        imgShirt.center = CGPointMake((screen_width-imgShirtX)+(someX*0.83), (screen_height/2-imgShirtY));
    }
    else if (fractionalPage >= 1 && fractionalPage < 2.0)
    {
        if (fractionalPage == 1.0)
        {
            washingMachineAnimated = YES;
            
            if (timer)
            {
                [timer invalidate];
                timer = nil;
            }
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(timerMethod) userInfo:nil repeats:NO];
            [self performSelector:@selector(rotateRight) withObject:nil];
        }
        else if (fractionalPage < 2.0)
        {
            
            if (fractionalPage > 1.9)
            {
                [UIView animateWithDuration:0.15 delay:0.0 options:0 animations:^{
                    
                    imgShirt.alpha = 0.3;
                    
                } completion:^(BOOL finished) {
                    
                    
                }];
            }
            else
            {
                imgShirt.alpha = 1.0;
            }
            
            float someX = scrollView.contentOffset.x-screen_width;
            
            float someY = (scrollIntra.contentOffset.x-screen_width)*0.1;
            
            CGFloat imgShirtY = 25.2*MULTIPLYHEIGHT;
            
            imgShirt.center = CGPointMake((screen_width*2-(screen_width/2))+(someX*0.7), (screen_height/2-imgShirtY)+(someY*0.7));
        }
    }
    
    else if (fractionalPage >= 2.0 && fractionalPage <= 3.0)
    {
        if (fractionalPage == 2.0)
        {
            imgShirt.alpha = 0.0;
            
            scaleVan = 1.0;
            fractionalPageGlobal = 0.0;
            
            imgVan.transform = CGAffineTransformMakeScale(1, 1);
            float some = ((scrollIntra.contentOffset.x/2)-screen_width)*1.8;
            
            CGFloat imgVX = 90*MULTIPLYHEIGHT;
            CGFloat imgVY = 237.45*MULTIPLYHEIGHT;
            
            imgVan.center = CGPointMake((screen_width*2)+imgVX+some, imgVY);
            
        }
        else if (scrollIntra.contentOffset.x <= screen_width*2+115*MULTIPLYHEIGHT)
        {
            
            [UIView animateWithDuration:0.15 delay:0.0 options:0 animations:^{
                
                imgVan.transform = CGAffineTransformMakeScale(1, 1);
                
            } completion:^(BOOL finished) {
                
            }];
            
            float some = ((scrollIntra.contentOffset.x/2)-screen_width)*1.8;
            
            CGFloat imgVX = 90*MULTIPLYHEIGHT;
            CGFloat imgVY = 237.45*MULTIPLYHEIGHT;
            
            imgVan.center = CGPointMake((screen_width*2)+imgVX+some, imgVY);
        }
        else if (fractionalPage == 3.0)
        {
            CGFloat imgDX = 43.2*MULTIPLYHEIGHT;
            CGFloat imgDY = 187.2*MULTIPLYHEIGHT;
            
            imgDelivery.center = CGPointMake((screen_width*4)-(screen_width/2)+imgDX, imgDY);
            
            CGFloat imgDTrans = 0.2;
            
            imgDelivery.transform = CGAffineTransformMakeScale(imgDTrans, imgDTrans);
            imgDelivery.alpha = 0.0;
            
            pageControlBottom.alpha = 1.0;
            
        }
        else if (fractionalPage > fractionalPageGlobal)
        {
            float some = ((scrollIntra.contentOffset.x-115*MULTIPLYHEIGHT)-(screen_width*2))*0.0037;
            
            //NSLog(@"%.2f", some);
            
            scaleVan = 1.0-some;
            
            [self performSelector:@selector(increaseDecreaseVanSize) withObject:nil];
        }
        else
        {
            float some = ((scrollIntra.contentOffset.x-115*MULTIPLYHEIGHT)-(screen_width*2))*0.0037;
            
            //NSLog(@"%.2f", some);
            
            scaleVan = 1.0-some;
            
            [self performSelector:@selector(increaseDecreaseVanSize) withObject:nil];
        }
        
        fractionalPageGlobal = fractionalPage;
    }
    else if (fractionalPage > 3.0 && fractionalPage < 4.0)
    {
        imgDelivery.alpha = 1.0;
        
        float someX = (scrollIntra.contentOffset.x)-(screen_width*3);
        
        float someY = (scrollIntra.contentOffset.x)-(screen_width*3);
        
        CGFloat imgDX = 43.2*MULTIPLYHEIGHT;
        CGFloat imgDY = 187.2*MULTIPLYHEIGHT;
        
        CGFloat imgDTrans = 0.2;
        
        CGFloat imgDScale = imgDTrans+(someY*0.0021);
        
        //NSLog(@"scale : %f", imgDScale);
        
        imgDelivery.center = CGPointMake(((screen_width*4)-(screen_width/2)+imgDX)+(someX*0.89), imgDY+(someY*0.067));
        imgDelivery.transform = CGAffineTransformMakeScale(imgDScale, imgDScale);
        
        float minusAlpha = someX*0.0032;
        
        pageControlBottom.alpha = 1.0-minusAlpha;
        
        CGRect btnRect = BtnGetStarted.frame;
        btnRect.origin.y = screen_height-someX*0.11;
        BtnGetStarted.frame = btnRect;
        BtnGetStarted.alpha = minusAlpha;
    }
    else if (fractionalPage == 4.0)
    {
        BtnGetStarted.alpha = 1.0;
        
        CGFloat imgDX = 15*MULTIPLYHEIGHT;
        CGFloat imgDY = 205*MULTIPLYHEIGHT;
        
        imgDelivery.center = CGPointMake((screen_width*4)+(screen_width/2)+imgDX, imgDY);
        imgDelivery.alpha = 1.0;
        
        [UIView animateWithDuration:0.1 animations:^{
            
            imgDelivery.transform = CGAffineTransformMakeScale(1, 1);
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
}

-(void) timerMethod
{
    if (washingMachineAnimated)
    {
        washingMachineAnimated = NO;
        imgWashingMachine.transform = CGAffineTransformIdentity;
    }
    else
    {
        washingMachineAnimated = YES;
    }
    
    [self performSelector:@selector(rotateRight) withObject:nil];

}

-(void) rotateRight
{
    if (fractionalPage == 1.0 && washingMachineAnimated)
    {
        [UIView animateWithDuration:0.05 animations:^{
            
            imgWashingMachine.transform = CGAffineTransformMakeRotation(M_PI/80);
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(rotateLeft) withObject:nil];
            
        }];
    }
    else
    {
        imgWashingMachine.transform = CGAffineTransformIdentity;
    }
}

-(void) rotateLeft
{
    if (fractionalPage == 1.0 && washingMachineAnimated)
    {
        [UIView animateWithDuration:0.05 animations:^{
            
            imgWashingMachine.transform = CGAffineTransformMakeRotation(M_PI/-80);
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(rotateRight) withObject:nil];
            
        }];
    }
    else
    {
        imgWashingMachine.transform = CGAffineTransformIdentity;
    }
}

-(void) increaseDecreaseVanSize
{
    [UIView animateWithDuration:0.1 animations:^{
        
        imgVan.transform = CGAffineTransformMakeScale(scaleVan, scaleVan);
        
    } completion:^(BOOL finished) {
        
    }];
    
    float someX = ((scrollIntra.contentOffset.x-120*MULTIPLYHEIGHT)-(screen_width*2));
    
    float someY = ((scrollIntra.contentOffset.x-120*MULTIPLYHEIGHT)-(screen_width*2));
    
    CGFloat imgVX = 80*MULTIPLYHEIGHT;
    CGFloat imgVY = 236*MULTIPLYHEIGHT;
    
    imgVan.center = CGPointMake((scrollIntra.contentOffset.x+imgVX)+(someX*0.66), imgVY-(someY*0.30));
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
