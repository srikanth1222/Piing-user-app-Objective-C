//
//  PickupFeedbackViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 24/04/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "DeliveryFeedbackViewController.h"
#import "HCSStarRatingView.h"
#import "FXBlurView.h"
#import "UIView+Toast.h"



@interface DeliveryFeedbackViewController () <UITextViewDelegate, UIScrollViewDelegate>
{
    UIImageView *imgView;
    UIScrollView *scrollFeedback;
    UIScrollView *scrollPaging;
    
    AppDelegate *appDel;
    
    UILabel *lblfb;
    UIButton *confirmBtn;
    
    UIImageView *profilePicView;
    UILabel *lblPiingoName;
    UITextView *txtView;
    
    HCSStarRatingView *starRatingView, *starRatingServiceView;
    
    NSString *strCobId;
    
    UIPageControl *pageControlBottom;
}


@end

@implementation DeliveryFeedbackViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnView:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"pickupfeedback_bg"];
    imgView.frame = self.view.bounds;
    [self.view addSubview:imgView];
    [appDel applyCustomBlurEffetForView:self.view WithBlurRadius:20];
    
    scrollFeedback = [[UIScrollView alloc]init];
    scrollFeedback.frame = CGRectMake(0, 20, screen_width, screen_height-20);
    [self.view addSubview:scrollFeedback];
    scrollFeedback.contentSize = CGSizeMake(scrollFeedback.frame.size.width, scrollFeedback.frame.size.height);
    
    [self continueShowDeliveryScreen];
    
    [self callClientOrderDetails];
    
    FXBlurView *blur = [self.view viewWithTag:98765];
    blur.alpha = 0.0;
    scrollFeedback.alpha = 0.0;
    
    [UIView animateWithDuration:0.3 delay:1 options:0 animations:^{
        
        blur.alpha = 1.0;
        scrollFeedback.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect newFrame = scrollFeedback.frame;
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    //CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.size.height = keyboardFrameEnd.origin.y-20;
    
    scrollFeedback.contentOffset = CGPointMake(scrollFeedback.frame.size.width, newFrame.size.height);
    scrollFeedback.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void) didChangeValue:(HCSStarRatingView *)rating
{
    if (starRatingView.value > 0 && starRatingServiceView.value > 0)
    {
//        confirmBtn.alpha = 1.0;
//        confirmBtn.userInteractionEnabled = YES;
    }
    else
    {
//        confirmBtn.alpha = 0.3;
//        confirmBtn.userInteractionEnabled = NO;
    }
    
    //NSLog(@"%f", starRatingView.value);
    
    if (starRatingView.value > 0)
    {
        [self performSelector:@selector(gotoPiingoRating) withObject:nil afterDelay:0.7];
    }
}

-(void) didChangeValueService:(HCSStarRatingView *)rating
{
    if (starRatingView.value > 0 && starRatingServiceView.value > 0)
    {
//        confirmBtn.alpha = 1.0;
//        confirmBtn.userInteractionEnabled = YES;
    }
    else
    {
//        confirmBtn.alpha = 0.3;
//        confirmBtn.userInteractionEnabled = NO;
    }
}

-(void) gotoPiingoRating
{
    [scrollPaging setContentOffset:CGPointMake(screen_width, 0) animated:YES];
}

-(void) callClientOrderDetails
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    strCobId = [self.loginDetails objectForKey:@"feedBackOid"];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", strCobId, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/get/byid", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            if(responseObj &&[[responseObj objectForKey:@"em"] count]){
                
                NSDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[[responseObj objectForKey:@"em"] objectAtIndex:0]];
                
                NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [dict objectForKey:@"dpid"], @"pid", nil];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@piingo/get", BASE_URL];
                
                [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                    
                    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                    
                    if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                            NSDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[responseObj objectForKey:@"em"]];
                            
                            NSString *strImage = [dict objectForKey:@"image"];
                            
                            [profilePicView sd_setImageWithURL:[NSURL URLWithString:strImage]
                                              placeholderImage:[UIImage imageNamed:@"piingo_cap"]];
                            
                            profilePicView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
                            profilePicView.layer.borderWidth = 1.0;
                            profilePicView.layer.cornerRadius = CGRectGetWidth(profilePicView.bounds)/2;
                            profilePicView.clipsToBounds = YES;
                            
                            profilePicView.contentMode = UIViewContentModeScaleAspectFill;
                            
                            lblPiingoName.text = [[dict objectForKey:@"name"] uppercaseString];
                        }];
                    }
                    else {
                        
                        //[appDel displayErrorMessagErrorResponse:responseObj];
                    }
                    
                }];
            }
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
    
}

-(void) continueShowDeliveryScreen
{
    
    float yAxis = 15*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 25*MULTIPLYHEIGHT)];
    NSString *string = @"DELIVERY";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = [UIColor whiteColor];
    [scrollFeedback addSubview:lblTitle];
    
    yAxis += 25*MULTIPLYHEIGHT+10*MULTIPLYHEIGHT;;
    
    scrollPaging = [[UIScrollView alloc]init];
    scrollPaging.pagingEnabled = YES;
    scrollPaging.delegate = self;
    scrollPaging.backgroundColor = [UIColor clearColor];
    [scrollFeedback addSubview:scrollPaging];
    [scrollPaging setContentSize:CGSizeMake(2*screen_width, 0)];
    scrollPaging.showsHorizontalScrollIndicator = NO;
    scrollPaging.showsVerticalScrollIndicator = NO;
    scrollPaging.bounces = NO;
    
    
    
    // PAGE 1
    
    float YPos = 15*MULTIPLYHEIGHT;
    
    float imgHeight = 75*MULTIPLYHEIGHT;
    
    profilePicView = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-(imgHeight/2), YPos, imgHeight, imgHeight)];
    profilePicView.backgroundColor = [UIColor clearColor];
    profilePicView.image = [UIImage imageNamed:@"piingo_cap"];
    [scrollPaging addSubview:profilePicView];
    
    YPos += imgHeight+10*MULTIPLYHEIGHT;
    
    
    lblPiingoName = [[UILabel alloc] init];
    lblPiingoName.frame = CGRectMake(0, YPos, screen_width, 25*MULTIPLYHEIGHT);
    lblPiingoName.textAlignment = NSTextAlignmentCenter;
    lblPiingoName.textColor = [UIColor whiteColor];
    lblPiingoName.numberOfLines = 0;
    lblPiingoName.backgroundColor = [UIColor clearColor];
    lblPiingoName.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.FONT_SIZE_CUSTOM];
    [scrollPaging addSubview:lblPiingoName];
    lblPiingoName.text = @"";
    
    YPos += 25*MULTIPLYHEIGHT+30*MULTIPLYHEIGHT;
    
    
    NSString *strDesc = [@"Hope we helped you chill a little!" uppercaseString];
    
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.frame = CGRectMake(0, YPos, screen_width, 20);
    lblDesc.textAlignment = NSTextAlignmentCenter;
    lblDesc.textColor = [UIColor whiteColor];
    lblDesc.numberOfLines = 0;
    lblDesc.backgroundColor = [UIColor clearColor];
    lblDesc.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.FONT_SIZE_CUSTOM-3];
    [scrollPaging addSubview:lblDesc];
    
    lblDesc.text = strDesc;
    
    CGFloat lbldescHeight = [AppDelegate getLabelHeightForRegularText:strDesc WithWidth:screen_width FontSize:lblDesc.font.pointSize];
    
    CGRect lblDescRect = lblDesc.frame;
    lblDescRect.size.height = lbldescHeight;
    lblDesc.frame = lblDescRect;
    
    YPos += lbldescHeight+7*MULTIPLYHEIGHT;
    
    
    
    NSString *strRatePiingo = [@"please rate your piingo" uppercaseString];
    
    UILabel *lblRatePiingo = [[UILabel alloc] init];
    lblRatePiingo.frame = CGRectMake(0, YPos, screen_width, 20);
    lblRatePiingo.textAlignment = NSTextAlignmentCenter;
    lblRatePiingo.textColor = [UIColor whiteColor];
    lblRatePiingo.numberOfLines = 0;
    lblRatePiingo.backgroundColor = [UIColor clearColor];
    lblRatePiingo.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.HEADER_LABEL_FONT_SIZE];
    [scrollPaging addSubview:lblRatePiingo];
    
    lblRatePiingo.text = strRatePiingo;
    
    CGFloat lblRateHeight = [AppDelegate getLabelHeightForRegularText:strRatePiingo WithWidth:screen_width FontSize:lblRatePiingo.font.pointSize];
    
    CGRect lblRateRect = lblRatePiingo.frame;
    lblRateRect.size.height = lblRateHeight;
    lblRatePiingo.frame = lblRateRect;
    
    YPos += lblRateHeight+15*MULTIPLYHEIGHT;
    
    
    float viewstarX = 30*MULTIPLYHEIGHT;
    float viewstarHeight = 40*MULTIPLYHEIGHT;
    
    UIView *view_Star = [[UIView alloc]initWithFrame:CGRectMake(viewstarX, YPos, screen_width-(viewstarX*2), viewstarHeight)];
    [scrollPaging addSubview:view_Star];
    
    
    starRatingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, view_Star.frame.size.width, viewstarHeight)];
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = 0;
    starRatingView.spacing = 25*MULTIPLYHEIGHT;
    starRatingView.emptyStarImage = [UIImage imageNamed:@"star_un_selected"];
    starRatingView.filledStarImage = [UIImage imageNamed:@"star_selected"];
    //starRatingView.tintColor = [UIColor redColor];
    [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [view_Star addSubview:starRatingView];
    
    //YPos += viewstarHeight+5*MULTIPLYHEIGHT;
    
    
    // PAGE 2 ///////////////////////
    
    YPos = 20*MULTIPLYHEIGHT;
    
    UIView *viewService = [[UIView alloc]init];
    viewService.frame = CGRectMake(screen_width, 0, screen_width, 10);
    [scrollPaging addSubview:viewService];
    
    CGFloat viewServiceWidth = viewService.frame.size.width;
    
    float imgLogoHeight = 75*MULTIPLYHEIGHT;
    float imgLogoWidth = 100*MULTIPLYHEIGHT;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(viewServiceWidth/2-(imgLogoWidth/2), YPos, imgLogoWidth, imgLogoHeight)];
    logo.backgroundColor = [UIColor clearColor];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image = [UIImage imageNamed:@"piing_logo_icon"];
    [viewService addSubview:logo];
    
    YPos += imgHeight+60*MULTIPLYHEIGHT;
    
    
    NSString *strDesc2 = [@"Had fun in your free time?" uppercaseString];
    
    UILabel *lblDesc2 = [[UILabel alloc] init];
    lblDesc2.frame = CGRectMake(0, YPos, screen_width, 20);
    lblDesc2.textAlignment = NSTextAlignmentCenter;
    lblDesc2.textColor = [UIColor whiteColor];
    lblDesc2.numberOfLines = 0;
    lblDesc2.backgroundColor = [UIColor clearColor];
    lblDesc2.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.FONT_SIZE_CUSTOM-1];
    [viewService addSubview:lblDesc2];
    
    lblDesc2.text = strDesc2;
    
    CGFloat lbldesc2Height = [AppDelegate getLabelHeightForRegularText:strDesc2 WithWidth:screen_width FontSize:lblDesc2.font.pointSize];
    
    CGRect lblDesc2Rect = lblDesc2.frame;
    lblDesc2Rect.size.height = lbldesc2Height;
    lblDesc2.frame = lblDesc2Rect;
    
    YPos += lbldesc2Height+7*MULTIPLYHEIGHT;
    
    
    
    NSString *strRateService = [@"Please rate your Piing experience" uppercaseString];
    
    UILabel *lblRateService = [[UILabel alloc] init];
    lblRateService.frame = CGRectMake(0, YPos, screen_width, 20);
    lblRateService.textAlignment = NSTextAlignmentCenter;
    lblRateService.textColor = [UIColor whiteColor];
    lblRateService.numberOfLines = 0;
    lblRateService.backgroundColor = [UIColor clearColor];
    lblRateService.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.FONT_SIZE_CUSTOM+1];
    [viewService addSubview:lblRateService];
    
    lblRateService.text = strRateService;
    
    CGFloat lblRateSericeHeight = [AppDelegate getLabelHeightForRegularText:strRateService WithWidth:screen_width FontSize:lblRateService.font.pointSize];
    
    CGRect lblRateServiceRect = lblRateService.frame;
    lblRateServiceRect.size.height = lblRateSericeHeight;
    lblRateService.frame = lblRateServiceRect;
    
    YPos += lblRateSericeHeight+15*MULTIPLYHEIGHT;
    
    
    UIView *view_Star2 = [[UIView alloc]initWithFrame:CGRectMake(viewstarX, YPos, screen_width-(viewstarX*2), viewstarHeight)];
    [viewService addSubview:view_Star2];
    
    starRatingServiceView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(0, 0, view_Star2.frame.size.width, viewstarHeight)];
    starRatingServiceView.backgroundColor = [UIColor clearColor];
    starRatingServiceView.maximumValue = 5;
    starRatingServiceView.minimumValue = 0;
    starRatingServiceView.value = 0;
    starRatingServiceView.spacing = 25*MULTIPLYHEIGHT;
    starRatingServiceView.emptyStarImage = [UIImage imageNamed:@"star_un_selected"];
    starRatingServiceView.filledStarImage = [UIImage imageNamed:@"star_selected"];
    [starRatingServiceView addTarget:self action:@selector(didChangeValueService:) forControlEvents:UIControlEventValueChanged];
    [view_Star2 addSubview:starRatingServiceView];
    
    YPos += viewstarHeight+5*MULTIPLYHEIGHT;
    
    
    CGRect frameScrollPaging = scrollPaging.frame;
    frameScrollPaging.origin.y = yAxis;
    frameScrollPaging.origin.x = 0;
    frameScrollPaging.size.width = screen_width;
    frameScrollPaging.size.height = YPos;
    scrollPaging.frame = frameScrollPaging;
    
    viewService.frame = CGRectMake(screen_width, 0, screen_width, YPos);
    
    yAxis += YPos;
    
    
    pageControlBottom = [[UIPageControl alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 37)];
    pageControlBottom.autoresizingMask = UIViewAutoresizingNone;
    pageControlBottom.backgroundColor = [UIColor clearColor];
    pageControlBottom.numberOfPages = 2;
    pageControlBottom.pageIndicatorTintColor = [BLUE_COLOR colorWithAlphaComponent:0.3];
    pageControlBottom.currentPageIndicatorTintColor = BLUE_COLOR;
    //[pageControlBottom addTarget:self action:@selector(pagecontrolClicked:) forControlEvents:UIControlEventValueChanged];
    [scrollFeedback addSubview:pageControlBottom];
    //pageControlBottom.userInteractionEnabled = NO;
    
    yAxis += 37+10*MULTIPLYHEIGHT;
    
    
    float viewtxtHeight = 60*MULTIPLYHEIGHT;
    
    UIView *view_TextView = [[UIView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, viewtxtHeight)];
    view_TextView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
    [scrollFeedback addSubview:view_TextView];
    
    txtView = [[UITextView alloc]init];
    txtView.delegate = self;
    txtView.frame = CGRectMake(10*MULTIPLYHEIGHT, 5*MULTIPLYHEIGHT, view_TextView.frame.size.width-((10*MULTIPLYHEIGHT)*2), view_TextView.frame.size.height-(5*MULTIPLYHEIGHT)*1.5);
    txtView.textColor = [UIColor whiteColor];
    txtView.backgroundColor = [UIColor clearColor];
    txtView.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
    [view_TextView addSubview:txtView];
    
    
    NSString *strfbTxt = [@"How can we improve your delivery experience?" uppercaseString];
    
    lblfb = [[UILabel alloc] init];
    lblfb.frame = CGRectMake(0, 0, screen_width, 20);
    lblfb.textAlignment = NSTextAlignmentCenter;
    lblfb.textColor = [UIColor lightGrayColor];
    lblfb.numberOfLines = 0;
    lblfb.backgroundColor = [UIColor clearColor];
    lblfb.font = [UIFont fontWithName:APPFONT_LIGHT_ITALIC size:appDel.FONT_SIZE_CUSTOM-3];
    [view_TextView addSubview:lblfb];
    
    lblfb.text = strfbTxt;
    
    CGFloat lblfbHeight = [AppDelegate getLabelHeightForRegularText:strfbTxt WithWidth:screen_width FontSize:lblfb.font.pointSize];
    
    CGRect lblfbRect = lblfb.frame;
    lblfbRect.size.height = lblfbHeight;
    lblfbRect.origin.y = view_TextView.frame.size.height/2-(lblfbHeight/2);
    lblfb.frame = lblfbRect;
    
    yAxis += viewtxtHeight+20*MULTIPLYHEIGHT;
    
    
    CGFloat btnHeight = 27*MULTIPLYHEIGHT;
    
    CGFloat btnconfirmX = 40*MULTIPLYHEIGHT;
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(btnconfirmX, yAxis, screen_width - (btnconfirmX*2), btnHeight);
    confirmBtn.backgroundColor = RGBCOLORCODE(15, 43, 68, 1.0);
    confirmBtn.titleLabel.font = [UIFont fontWithName:APPFONT_LIGHT size:appDel.FONT_SIZE_CUSTOM+1];
    [confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmDeliveyFeedback:) forControlEvents:UIControlEventTouchUpInside];
    [scrollFeedback addSubview:confirmBtn];
    [confirmBtn setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
//    confirmBtn.alpha = 0.3;
//    confirmBtn.userInteractionEnabled = NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
    
    NSInteger page = lround(fractionalPage);
    
    pageControlBottom.currentPage = page;
    
}

-(void) confirmDeliveyFeedback:(id)sender
{
    if (starRatingView.value > 0 && starRatingServiceView.value > 0)
    {
        [self.view endEditing:YES];
        
        NSString *strRating = [NSString stringWithFormat:@"%d", (int) starRatingView.value];
        NSString *strRating2 = [NSString stringWithFormat:@"%d", (int) starRatingServiceView.value];
        
        NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strCobId, @"oid", strRating, @"rating", strRating2, @"oRating", txtView.text, @"note", @"D", @"feedBackType", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@order/feedback", BASE_URL];
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
            
            if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                
                //[appDel showAlertWithMessage:@"Thanks for delivery feedback" andTitle:@"" andBtnTitle:@"OK"];
                self.view.userInteractionEnabled = NO;
                
                [appDel.window makeToast:@"Thanks for delivery feedback"];
                
                [appDel performSelector:@selector(checkConditionsAfterFeedback) withObject:nil afterDelay:2];                
            }
            else {
                
                [appDel displayErrorMessagErrorResponse:responseObj];
            }
        }];
    }
    else
    {
        [appDel showAlertWithMessage:@"Please give us your ratings and feedback." andTitle:@"" andBtnTitle:@"OK"];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    lblfb.hidden = YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        lblfb.hidden = NO;
    }
}


-(void) tapOnView:(UITapGestureRecognizer *) tap
{
    [self.view endEditing:YES];
    [scrollFeedback setContentOffset:CGPointZero animated:YES];
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
