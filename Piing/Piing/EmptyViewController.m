//
//  EmptyViewController.m
//  Piing
//
//  Created by PIING on 30/01/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "EmptyViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Reachability/Reachability.h>


@interface EmptyViewController ()
{
    AppDelegate *appDel;
    UIImageView *imgBG;
}

@property (nonatomic, strong) MPMoviePlayerController *backGroundplayer;

@end

@implementation EmptyViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [[PiingHandler sharedHandler] appDel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
    
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"splash_video" ofType:@"mp4"];
    NSURL *theurl = [NSURL fileURLWithPath:thePath];
    
    self.backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
    self.backGroundplayer.view.frame = CGRectMake(0, 0, screen_width, screen_height);
    self.backGroundplayer.repeatMode = YES;
    self.backGroundplayer.view.userInteractionEnabled = YES;
    self.backGroundplayer.controlStyle = MPMovieControlStyleNone;
    [self.backGroundplayer prepareToPlay];
    [self.backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
    //self.backGroundplayer.movieSourceType = MPMovieSourceTypeStreaming;
    self.backGroundplayer.backgroundView.backgroundColor = [UIColor blackColor];
    self.backGroundplayer.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backGroundplayer.view];
    [self.backGroundplayer setScalingMode:MPMovieScalingModeAspectFill];
    
    [self.backGroundplayer play];
    
    
    imgBG = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imgBG.contentMode = UIViewContentModeScaleAspectFit;
    imgBG.backgroundColor = [UIColor whiteColor];
    imgBG.image = [UIImage imageNamed:@"splashscreen"];
    [self.view addSubview:imgBG];
    
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
        
        // Allocate a reachability object
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        if (![reach isReachable])
        {
            appDel.isGotResponse = NO;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [self.backGroundplayer stop];
            
            //[appDel showAlertWithMessage:@"The Internet connection appears to be offline." andTitle:@"" andBtnTitle:@"OK"];
            
            imgBG.alpha = 1.0;
            imgBG.backgroundColor = RGBCOLORCODE(242, 241, 244, 1.0);
            
            imgBG.image = [UIImage imageNamed:@"no_internt"];
            
            CGFloat lblY = 320*MULTIPLYHEIGHT;
            
            UILabel *lblNoInternet = [[UILabel alloc]initWithFrame:CGRectMake(0, lblY, screen_width, 50)];
            lblNoInternet.text = @"Seems like you are not connected to the Internet.";
            lblNoInternet.numberOfLines = 0;
            lblNoInternet.textAlignment = NSTextAlignmentCenter;
            lblNoInternet.textColor = [UIColor grayColor];
            lblNoInternet.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
            [self.view addSubview:lblNoInternet];
        }
        else if (appDel.isGotResponse)
        {
            appDel.isGotResponse = NO;
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [self.backGroundplayer stop];
            
            [appDel checkOtherConditions];
        }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.view.backgroundColor = [UIColor blackColor];
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
