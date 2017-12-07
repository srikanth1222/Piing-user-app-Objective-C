//
//  CircularBtnView.m
//  Ping
//
//  Created by SHASHANK on 27/02/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "CircularBtnView.h"
#import "PulsingHaloLayer.h"

#define kMaxRadius 200
#define kMaxDuration 10


@interface CircularBtnView ()
{
    UIButton *timerBtn;
    UIImageView *timerImageView;
    
    AppDelegate *appDel;
}

@property (nonatomic, strong) PulsingHaloLayer *halo;

@end
@implementation CircularBtnView
@synthesize countdownLabel;
@synthesize paentDel;

BOOL animating;

-(id) initWithFrame:(CGRect)frame andDelegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1.7]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        appDel = [PiingHandler sharedHandler].appDel;
        
        animating = NO;
        
        self.paentDel = delegate;
        
        float tlHeight = 32*MULTIPLYHEIGHT;
        
        timerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tlHeight, tlHeight)];
        timerImageView.image = [UIImage imageNamed:@"timer"];
        timerImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        float cdLblHeight = 22*MULTIPLYHEIGHT;
        
        countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(4*MULTIPLYHEIGHT, 7*MULTIPLYHEIGHT, cdLblHeight, cdLblHeight)];
        //countdownLabel.center = CGPointMake(19, 27.0);
        countdownLabel.backgroundColor = [UIColor clearColor];
        countdownLabel.text = @"15";
        countdownLabel.textAlignment = NSTextAlignmentCenter;
        countdownLabel.textColor = APPLE_BLUE_COLOR;
        countdownLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM];
        [timerImageView addSubview:countdownLabel];
        
        [self addSubview:timerImageView];
        
        float tbHeight = 115*MULTIPLYHEIGHT;
        
        timerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timerBtn.frame = CGRectMake(tlHeight/2, 10, tbHeight, tbHeight);
        timerBtn.backgroundColor = [UIColor clearColor];
        timerBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [timerBtn setImage:[UIImage imageNamed:@"logo_icon.png"] forState:UIControlStateNormal];
        [timerBtn addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:timerBtn];
        
        [self addPulseLayer];
        
        float aiHeight = 127*MULTIPLYHEIGHT;
        
        anchorimageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(timerBtn.frame), timerBtn.frame.origin.y, aiHeight, aiHeight)];
        anchorimageView.frame = CGRectMake(11*MULTIPLYHEIGHT, 2, aiHeight, aiHeight);
        anchorimageView.image = [UIImage imageNamed:@"Anchon_spl_img"];
        anchorimageView.backgroundColor = [UIColor clearColor];
        [self addSubview:anchorimageView];
    }
    
    return self;
}


-(void) addPulseLayer
{
    // basic setup
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    layer.position = timerBtn.center;
    self.halo = layer;
    [self.layer insertSublayer:self.halo below:timerBtn.layer];
    
    UIColor *color = [UIColor colorWithRed:19.0/255.0 green:132.0/255.0 blue:254.0/255.0 alpha:1.0];
    
    [self.halo setBackgroundColor:color.CGColor];
    
    self.halo.haloLayerNumber = 5;
    self.halo.radius = 1.0 * kMaxRadius;
    self.halo.animationDuration = 0.5 * kMaxDuration;
    
    [self.halo start];
}


- (void) spinWithOptions: (UIViewAnimationOptions) options {
    // this spin completes 360 degrees every 2 seconds
    [UIView animateWithDuration: 15.0f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         
                         anchorimageView.transform = CGAffineTransformMakeRotation( M_PI );
                         
                         //                         DLog(@"1 - %f 2- %f",animatedImageView.frame.origin.y,animatedImageView2.frame.origin.y);
                         
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             
                             if (animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void) startSpin {
    if (!animating) {
        animating = YES;
        [self spinWithOptions: UIViewAnimationOptionCurveEaseIn];
    }
}

- (void) stopSpin {
    // set the flag to stop spinning after one last 90 degree increment
    animating = NO;
}

-(void) btnPressed
{
    if (animating)
    {
        [self stopRotate2];
    }
    
    if ([timerImageView isHidden])
    {
        //[self showOnlyWaves];
        
        appDel.openScheduleLater = YES;
        [paentDel performSelector:@selector(loadAPIForBookNowStatus) withObject:nil afterDelay:0];
    }
    else
    {
        [UIView animateWithDuration:1
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
//                             CGAffineTransform trans = timerBtn.imageView.transform;
//                             CGAffineTransformTranslate(trans, 40, 40);
//                             CGAffineTransformScale(trans, 1.4, 1.4);
//                             timerBtn.imageView.transform = trans;
                             
                             //timerBtn.imageView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                             
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done");
                             
                             //timerBtn.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             
                             [paentDel performSelector:@selector(confirmBookOrderNow) withObject:nil];

                         }];
        
    }
}

-(void)setHidden:(BOOL)hidden {
    
}

-(void) showOnlyWaves
{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.halo.hidden = NO;
        
        BOOL found = NO;
        
        for (CALayer *layer in self.layer.sublayers)
        {
            if ([layer isKindOfClass:[PulsingHaloLayer class]])
            {
                found = YES;
            }
        }
        
        if (!found)
        {
            self.halo = nil;
            [self addPulseLayer];
        }
        
        timerBtn.hidden = YES;
        anchorimageView.hidden = YES;
        timerImageView.hidden = YES;
        
    }];
    
}
-(void) offWaves
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.halo.hidden = YES;
        timerBtn.hidden = NO;
        anchorimageView.hidden = NO;
        timerImageView.hidden = YES;
        
    }];
}

-(void) hideAllData
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        self.halo.hidden = YES;
        timerBtn.hidden = YES;
        anchorimageView.hidden = YES;
        timerImageView.hidden = YES;
        
    }];
}


-(void) rotate2
{
    if (!animating) {
        animating = YES;
    }
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 1 * 1.0 ];
    rotationAnimation.duration = 15.0;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    [anchorimageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void) stopRotate2
{
    animating = NO;
    
    [anchorimageView.layer removeAnimationForKey:@"rotationAnimation"];
    
    CGRect frame = anchorimageView.frame;
    frame.origin.x = 11*MULTIPLYHEIGHT;
    frame.origin.y = 2;
    anchorimageView.frame = frame;
}

-(void) rotate
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, timerBtn.center.x, timerBtn.frame.origin.y);
    CGPathAddQuadCurveToPoint(path, NULL,timerBtn.center.x, timerBtn.center.y,timerBtn.center.x, timerBtn.frame.origin.y);
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.path = path;
    [pathAnimation setCalculationMode:kCAAnimationCubic];
    [pathAnimation setFillMode:kCAFillModeForwards];
    pathAnimation.duration = 15;
    
    [anchorimageView.layer addAnimation:pathAnimation forKey:nil];
}
-(void) setDetails:(int) value
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (value == 1)
        {
            timerImageView.hidden = NO;
            [timerBtn setImage:[UIImage imageNamed:@"logo_icon.png"] forState:UIControlStateNormal];
        }
        else if (value ==2)
        {
            timerImageView.hidden = YES;
            [timerBtn setImage:[UIImage imageNamed:@"refresh_icon.png"] forState:UIControlStateNormal];
        }
        
    }];

}


@end
