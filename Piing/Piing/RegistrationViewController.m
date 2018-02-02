//
//  RegistrationViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "RegistrationViewController.h"
#import "AddressListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RegistrationFeilds.h"
#import "AddAddressViewController.h"
#import "FAQViewController.h"


@interface RegistrationViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    MPMoviePlayerController *backGroundplayer;
    RegistrationFeilds *registerFeilds;
    
    UITableView *registrationTableView;
    UIButton *nextBtn;
    
    UITextField *tempTf;
    UIView *validateUserView;
    UITextField *verificationTextFeild;
    
    BOOL isAllFeildsCorrect;
    
    UIButton *closeBtn;
    
    AppDelegate *appDel;
    BOOL animating;
    
    UIView *view_Popup;
    UIView *view_Tourist;
    
    NSDictionary *dictRegisterResponse;
    
    UIButton *btnTerms;
    
    UILabel *lblPhn;
    
    UIButton *resendBlueBtn;
    UIImageView *imgBlue;
}

@end

@implementation RegistrationViewController
@synthesize isForTouristBool;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andWithType:(BOOL) isForTourist{
    
    self = [super init];
    if (self) {
        
        self.isForTouristBool = isForTouristBool;
    }
    return self;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;

    //Initialization
    registerFeilds = [[RegistrationFeilds alloc] init];
    isAllFeildsCorrect = NO;

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
    
    
    UIView *blackTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:blackTransparentView];
    
    [appDel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, 0, 5.0)];
    statusBarView.backgroundColor = BLUE_COLOR;
    [self.view addSubview:statusBarView];
    
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        statusBarView.frame = CGRectMake(-1, -1, screen_width/3 + 2, 5.0);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(5.0, yAxis, 35, 40);
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn setImage:[UIImage imageNamed:@"cancel_white"] forState:UIControlStateNormal];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, screen_width, 40)];
    titleLbl.attributedText = [[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"Account" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM]];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLbl];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(screen_width-50, yAxis, 40.0, 40);
    UIImage *image = [[UIImage imageNamed:@"next_arrow_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [nextBtn setImage:image forState:UIControlStateNormal];
    //[nextBtn setImage:[UIImage imageNamed:@"next_arrow_white"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn setShowsTouchWhenHighlighted:YES];
    nextBtn.layer.cornerRadius = nextBtn.frame.size.width/2;
    nextBtn.enabled = NO;
    //nextBtn.tintColor = BLUE_COLOR;
    nextBtn.tintColor = [UIColor whiteColor];
    nextBtn.hidden = YES;
    
    yAxis += 40+15*MULTIPLYHEIGHT;
    
    registrationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yAxis, screen_width, screen_height-yAxis)];
    registrationTableView.scrollEnabled = NO;
    registrationTableView.delegate = self;
    registrationTableView.dataSource = self;
    registrationTableView.layer.cornerRadius = 6.0;
    registrationTableView.separatorColor = [UIColor clearColor];
    registrationTableView.backgroundColor = [UIColor clearColor];
    registrationTableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    [self.view addSubview:registrationTableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, registrationTableView.frame.size.width, 60*MULTIPLYHEIGHT)];
    footerView.backgroundColor = [UIColor clearColor];
    registrationTableView.tableFooterView = footerView;
    
    float bgX = 17*MULTIPLYHEIGHT;
    
    btnTerms = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTerms.frame = CGRectMake(bgX, 0, bgX*2, footerView.frame.size.height);
    [btnTerms setImage:[UIImage imageNamed:@"terms_nonselected"] forState:UIControlStateNormal];
    [btnTerms setImage:[UIImage imageNamed:@"terms_selected"] forState:UIControlStateSelected];
    [footerView addSubview:btnTerms];
    btnTerms.selected = YES;
    [btnTerms addTarget:self action:@selector(btnTermsImageSelected) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnTermsText = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTermsText.frame = CGRectMake(bgX*2+16*MULTIPLYHEIGHT, 0, registrationTableView.frame.size.width-((bgX*2+5*MULTIPLYHEIGHT)*2), footerView.frame.size.height);
    [footerView addSubview:btnTermsText];
    btnTermsText.titleLabel.numberOfLines = 0;
    [btnTermsText addTarget:self action:@selector(btnTermsTextSelected) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *str1 = @"By registering, you are accepting to Piing!’s ";
    
    NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:str1];
    [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1], NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, str1.length)];
    
    NSString *str2 = @"Terms & Conditions";
    
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1], NSForegroundColorAttributeName:BLUE_COLOR, NSUnderlineStyleAttributeName:@(NSUnderlineStyleDouble)} range:NSMakeRange(0, str2.length)];
    
    [mainAttr appendAttributedString:attr1];
    
    [btnTermsText setAttributedTitle:mainAttr forState:UIControlStateNormal];
    
    
    
//    UILabel *notesLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,  footerView.frame.size.width, 30)];
//    notesLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
//    notesLbl.textAlignment = NSTextAlignmentCenter;
//    notesLbl.backgroundColor = [UIColor clearColor];
//    notesLbl.numberOfLines = 2;
//    notesLbl.textColor = [UIColor whiteColor];
//    notesLbl.text = @"We use your contact info to notify about your order status";
//    [footerView addSubview:notesLbl];
//    
    
    /// VERIFICATION VIEW
    
    
    float valiY = 80*MULTIPLYHEIGHT;
    
    validateUserView = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height, screen_width, screen_height-valiY)];
    validateUserView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:validateUserView];
    
    [self.view bringSubviewToFront:closeBtn];
    
    float yPos = 0;
    float lblHeight = 30*MULTIPLYHEIGHT;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, validateUserView.frame.size.width, lblHeight)];
    titleLabel.numberOfLines = 3;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //titleLabel.text = @"A verification code has been sent to your mobile. Key it in to complete the registration.";
    
    NSString *strVe = @"Please enter verification code that was\nsent to the number below";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strVe];
    
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [strVe length])];
    titleLabel.attributedText = attributedString;
    
    [validateUserView addSubview:titleLabel];
    
    yPos += lblHeight;
    
    
    lblPhn = [[UILabel alloc] initWithFrame:CGRectMake(0, yPos, validateUserView.frame.size.width, lblHeight)];
    lblPhn.numberOfLines = 3;
    lblPhn.backgroundColor = [UIColor clearColor];
    lblPhn.textColor = [UIColor whiteColor];
    lblPhn.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE];
    lblPhn.textAlignment = NSTextAlignmentCenter;
    [validateUserView addSubview:lblPhn];
    
    yPos += lblHeight+20*MULTIPLYHEIGHT;
    
    
    float txtFX = 80*MULTIPLYHEIGHT;
    float tfHeight = 20*MULTIPLYHEIGHT;
    
    verificationTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(txtFX, yPos, screen_width-txtFX*2, tfHeight)];
    verificationTextFeild.backgroundColor = [UIColor clearColor];
    verificationTextFeild.delegate = self;
    verificationTextFeild.autocorrectionType = UITextAutocorrectionTypeNo;
    verificationTextFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    verificationTextFeild.textAlignment = NSTextAlignmentCenter;
    verificationTextFeild.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    verificationTextFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //verificationTextFeild.keyboardType = UIKeyboardTypeNumberPad;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Enter verification code" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
//    verificationTextFeild.attributedPlaceholder = str;
    verificationTextFeild.textColor = [UIColor whiteColor];
    verificationTextFeild.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
    [validateUserView addSubview:verificationTextFeild];
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = CGRectMake(0, verificationTextFeild.frame.size.height-1, verificationTextFeild.frame.size.width, 0.4f);
    layer.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8].CGColor;
    [verificationTextFeild.layer addSublayer:layer];
    
    yPos += tfHeight+30*MULTIPLYHEIGHT;
    
    
//    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmBtn.frame = CGRectMake(0, yPos, validateUserView.frame.size.width, bgHeight);
//    confirmBtn.backgroundColor = BLUE_COLOR;
//    [confirmBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"Confirm" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM]] forState:UIControlStateNormal];
//    [confirmBtn addTarget:self action:@selector(verifyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [validateUserView addSubview:confirmBtn];
//    [confirmBtn setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
//    
//    yPos += bgHeight+5*MULTIPLYHEIGHT;
    
    
    float lMX = 20*MULTIPLYHEIGHT;
    
    UILabel *lblMsg = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, lMX)];
    lblMsg.text = @"Didn't get SMS?";
    lblMsg.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.7];
    lblMsg.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    lblMsg.textAlignment = NSTextAlignmentCenter;
    [validateUserView addSubview:lblMsg];
    
    yPos += lMX+5*MULTIPLYHEIGHT;
    
    float reX = 30*MULTIPLYHEIGHT;
    float bgHeight = 30*MULTIPLYHEIGHT;
    
    UIButton *resendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resendBtn.frame = CGRectMake(reX, yPos, screen_width-(reX*2), bgHeight);
    resendBtn.backgroundColor = [UIColor clearColor];
    resendBtn.layer.borderWidth = 0.5;
    resendBtn.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0].CGColor;
    //[resendBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"Resend verification code" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]] forState:UIControlStateNormal];
    [resendBtn addTarget:self action:@selector(resendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [validateUserView addSubview:resendBtn];
    [resendBtn setBackgroundImage:[AppDelegate imageWithColor:[[UIColor colorFromHexString:@"#ededed"]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
    resendBtn.enabled = NO;
    
    imgBlue = [[UIImageView alloc]init];
    imgBlue.frame = CGRectMake(reX, yPos, 0, bgHeight);
    imgBlue.backgroundColor = BLUE_COLOR;
    [validateUserView addSubview:imgBlue];
    
    resendBlueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resendBlueBtn.frame = CGRectMake(reX, yPos, screen_width-(reX*2), bgHeight);
    [resendBlueBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"Resend verification code" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]] forState:UIControlStateNormal];
    [resendBlueBtn addTarget:self action:@selector(resendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [validateUserView addSubview:resendBlueBtn];
    resendBlueBtn.enabled = NO;
    
    if (self.verificationCodeEnabled)
    {
        [self performSelector:@selector(resendBlue) withObject:nil afterDelay:1];
        
        if ([appDel.strPhoneNumber length])
        {
            NSString *strVe = appDel.strPhoneNumber;
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strVe];
            
            float spacing = 2.0f;
            [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [strVe length])];
            lblPhn.attributedText = attributedString;
        }
        
//        nextBtn.enabled = YES;
//        nextBtn.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.2];
//        nextBtn.hidden = NO;
        
        validateUserView.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
           
            CGRect rect = validateUserView.frame;
            rect.origin.y = 80*MULTIPLYHEIGHT;
            validateUserView.frame = rect;
            
        } completion:^(BOOL finished) {
            
            [verificationTextFeild becomeFirstResponder];
            
        }];
        
        registrationTableView.hidden = YES;
    }
    else
    {
        validateUserView.hidden = YES;
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
}

-(void) resendBlue
{
    [UIView animateWithDuration:10.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect frame = imgBlue.frame;
        frame.size.width = screen_width-frame.origin.x*2;
        imgBlue.frame = frame;
        
    } completion:^(BOOL finished) {
        
        resendBlueBtn.enabled = YES;
        
    }];
}

-(void) btnTermsImageSelected
{
    if (btnTerms.selected)
    {
        btnTerms.selected = NO;
    }
    else
    {
        btnTerms.selected = YES;
    }
}

-(void) btnTermsTextSelected
{
    FAQViewController *faq = [[FAQViewController alloc]init];
    faq.code = 3;
    
    [UIView transitionWithView:self.view duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
        [self addChildViewController:faq];
        [self.view addSubview:faq.view];
        
    } completion:nil];
}



-(void) glowBlue
{
    if (animating)
    {
        [UIView animateWithDuration:0.4 animations:^{
            
            nextBtn.tintColor = BLUE_COLOR;
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(glowWhite) withObject:nil];
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            
            nextBtn.tintColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void) glowWhite
{
    if (animating)
    {
        [UIView animateWithDuration:0.4 animations:^{
            
            nextBtn.tintColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
            
            [self performSelector:@selector(glowBlue) withObject:nil];
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            
            nextBtn.tintColor = [UIColor whiteColor];
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void) stopAnimation
{
    animating = NO;
}

#pragma mark UIControl Actions
-(void) viewTapped
{
    [self dismissKeyboard];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [backGroundplayer play];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [backGroundplayer play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotif:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [backGroundplayer stop];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark UIControl Statements
-(void) faceBookBtnClicked
{
}
-(void) closeBtnClicked
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_ID];
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CurrentStateOfApp"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USERNAME];
    //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_TOKEN];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void) resendBtnClicked:(UIButton *) sender
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/resendverificationcode", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [appDel showAlertWithMessage:@"A new verification code has been sent" andTitle:@"" andBtnTitle:@"OK"];
        }
        else
        {
            verificationTextFeild.text = @"";
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void)receivedResendActivationCode:(id)response
{
    
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    if ([[response objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame)
    {
        
        [appDel showAlertWithMessage:@"A new verification code has been sent" andTitle:@"Suceess..!" andBtnTitle:@"OK"];
        
    }
    else
    {
        [appDel displayErrorMessagErrorResponse:response];
    }
}
#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    
    if (indexPath.row == 3)
    {
        //CellIdentifier = @"Not Only Text Feild";
        
        CellIdentifier = @"Only Text Feild";
    }
    else
    {
        CellIdentifier = @"Only Text Feild";
    }
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        if ([CellIdentifier isEqualToString:@"Only Text Feild"])
        {
            float bgX = 20*MULTIPLYHEIGHT;
            float bgHeight = 30*MULTIPLYHEIGHT;
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, 5.0, tableView.frame.size.width-(bgX*2), bgHeight)];
            bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
            [cell addSubview:bgView];
            
            
            float imgHeight = 20*MULTIPLYHEIGHT;
            float imgWidth = 16*MULTIPLYHEIGHT;
            float imgX = 8*MULTIPLYHEIGHT;
            
            UIImageView *cellimageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, bgHeight/2-imgHeight/2, imgWidth, imgHeight)];
            cellimageView.tag = 1236;
            cellimageView.contentMode = UIViewContentModeScaleAspectFit;
            [bgView addSubview:cellimageView];
            
            
            float txtX = 33*MULTIPLYHEIGHT;
            float minusWidth = txtX+5*MULTIPLYHEIGHT;
            float txtHeight = 35*MULTIPLYHEIGHT;
            
            UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(txtX, 0, bgView.frame.size.width-minusWidth,  txtHeight)];
            textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFeild.tag = 1234;
            textFeild.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
            textFeild.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textFeild.autocorrectionType = UITextAutocorrectionTypeNo;
            textFeild.delegate = self;
            textFeild.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM+1];
            textFeild.textColor = [UIColor whiteColor];
            //textFeild.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            textFeild.backgroundColor = [UIColor clearColor];
            [bgView addSubview:textFeild];
            
            //textFeild.frame = CGRectMake(45.0, 0, bgView.frame.size.width-50,  46);
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"R"] == NSOrderedSame)
            {
                if (indexPath.row == 3)
                {
                    UILabel *lblMN = [[UILabel alloc]init];
                    lblMN.frame = CGRectMake(imgX+imgWidth+5*MULTIPLYHEIGHT, 0, 30*MULTIPLYHEIGHT, bgHeight);
                    lblMN.text = @"+65";
                    lblMN.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM];
                    lblMN.textColor = [UIColor whiteColor];
                    [bgView addSubview:lblMN];
                    
                    float otherX = 54*MULTIPLYHEIGHT;
                    float otherWidth = otherX+5*MULTIPLYHEIGHT;
                    
                    textFeild.frame = CGRectMake(otherX, 0, bgView.frame.size.width-otherWidth, txtHeight);
                }
                else
                {
                    textFeild.frame = CGRectMake(txtX, 0, bgView.frame.size.width-minusWidth, txtHeight);
                }
            }
            
        }
        else
        {
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 5.0, tableView.frame.size.width/2-15, 40.0)];
            bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
            [cell addSubview:bgView];
            
            UIImageView *cellimageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 0,22, 40)];
            cellimageView.tag = 1236;
            cellimageView.contentMode = UIViewContentModeScaleAspectFit;
            [bgView addSubview:cellimageView];
            
            UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(45.0, 0, bgView.frame.size.width-50, 40)];
            textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFeild.tag = 1234;
            textFeild.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            textFeild.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
            textFeild.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textFeild.autocorrectionType = UITextAutocorrectionTypeNo;
            textFeild.delegate = self;
            textFeild.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM+1];
            textFeild.textColor = [UIColor whiteColor];
            textFeild.returnKeyType = UIReturnKeyDefault;
            textFeild.backgroundColor = [UIColor clearColor];
            [bgView addSubview:textFeild];
            
            UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bgView.frame)+5, 5.0, tableView.frame.size.width/2-10, 40.0)];
            bgView2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
            [cell addSubview:bgView2];
            
            UIImageView *cellimageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 0,22, 40)];
            cellimageView1.tag = 1237;
            cellimageView1.contentMode = UIViewContentModeScaleAspectFit;
            [bgView2 addSubview:cellimageView1];
            
            UITextField *textFeild2 = [[UITextField alloc] initWithFrame:CGRectMake(45, 0.0, bgView2.frame.size.width-50, 40)];
            textFeild2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFeild2.tag = 1235;
            textFeild2.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            textFeild2.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
            textFeild2.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            textFeild2.autocorrectionType = UITextAutocorrectionTypeNo;
            textFeild2.delegate = self;
            textFeild2.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM];
            textFeild2.textColor = [UIColor whiteColor];
            textFeild2.returnKeyType = UIReturnKeyDefault;
            textFeild2.backgroundColor = [UIColor clearColor];
            [bgView2 addSubview:textFeild2];
        }
        
    }
    
    UITextField *cellTextFeild = (UITextField *)[cell viewWithTag:1234];
    UIView *lineView = (UIView *)[cell viewWithTag:3333];
    UIImageView *cellimageView = (UIImageView *)[cell viewWithTag:1236];
    UIImageView *cellimageView1 = (UIImageView *)[cell viewWithTag:1237];
    
    if(indexPath.row == 1)
    {
        cellimageView.image = [UIImage imageNamed:@"username_icon"];
        
        cellTextFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        [cellTextFeild setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
        
        cellTextFeild.attributedPlaceholder = str;
        cellTextFeild.text = registerFeilds.emailAddress;
        cellTextFeild.keyboardType = UIKeyboardTypeEmailAddress;
        
        if ([self validateTextFieldWithText:registerFeilds.emailAddress With:VALIDATE_EMAILID])
            lineView.backgroundColor = [UIColor blueColor];
        else
            lineView.backgroundColor = [UIColor grayColor];
        
    }
    else if(indexPath.row == 2)
    {
        cellimageView.image = [UIImage imageNamed:@"password_icon"];
        
        [cellTextFeild setSecureTextEntry:YES];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
        
        cellTextFeild.attributedPlaceholder = str;
        cellTextFeild.text = registerFeilds.password;
        cellTextFeild.keyboardType = UIKeyboardTypeDefault;
        
        if ([registerFeilds.password length] > 6)
            lineView.backgroundColor = [UIColor blueColor];
        else
            lineView.backgroundColor = [UIColor grayColor];
    }
    else if((indexPath.row == 0))
    {
        UITextField *cellTextFeild1 = (UITextField *)[cell viewWithTag:1234];
        UITextField *cellTextFeild2 = (UITextField *)[cell viewWithTag:1235];
        
        cellimageView.image = [UIImage imageNamed:@"Name_icon"];
        
        [cellTextFeild1 setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"NAME" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
        cellTextFeild1.attributedPlaceholder = str;
        cellTextFeild1.text = registerFeilds.firstName;
        cellTextFeild1.keyboardType = UIKeyboardTypeDefault;
        
        
        cellimageView1.image = [UIImage imageNamed:@"Name_icon"];
        
        [cellTextFeild2 setSecureTextEntry:NO];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"LAST NAME" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
        
        cellTextFeild2.attributedPlaceholder = str2;
        cellTextFeild2.text = registerFeilds.lastName;
        cellTextFeild2.keyboardType = UIKeyboardTypeDefault;
        
        UIView *lineView1 = (UIView *)[cell viewWithTag:3333];
        UIView *lineView2 = (UIView *)[cell viewWithTag:3334];
        
        if ([registerFeilds.firstName length] > 2)
            lineView1.backgroundColor = [UIColor blueColor];
        else
            lineView1.backgroundColor = [UIColor grayColor];
        
        
        if ([registerFeilds.lastName length] > 2)
            lineView2.backgroundColor = [UIColor blueColor];
        else
            lineView2.backgroundColor = [UIColor grayColor];
        
    }
    else if(indexPath.row == 3)
    {
        cellimageView.image = [UIImage imageNamed:@"mobile_icon"];
        
        [cellTextFeild setSecureTextEntry:NO];
        
        NSAttributedString *str;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"T"] == NSOrderedSame)
        {
            str = [[NSAttributedString alloc] initWithString:@"MOBILE or LAND-LINE NUMBER" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
        }
        else
        {
            str = [[NSAttributedString alloc] initWithString:@"MOBILE NUMBER" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
        }
        
        cellTextFeild.attributedPlaceholder = str;
        cellTextFeild.text = registerFeilds.cellPhone;
        cellTextFeild.keyboardType = UIKeyboardTypePhonePad;
        
        if ([registerFeilds.cellPhone length] < 10)
            lineView.backgroundColor = [UIColor grayColor];
        else
            lineView.backgroundColor = [UIColor blueColor];
        
    }
    else if(indexPath.row == 4)
    {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"T"] == NSOrderedSame)
        {
            cellimageView.image = [UIImage imageNamed:@"extension_number"];
            
            [cellTextFeild setSecureTextEntry:NO];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"ROOM / EXTENSION NUMBER" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
            cellTextFeild.attributedPlaceholder = str;
            cellTextFeild.text = registerFeilds.extn_Number;
            cellTextFeild.keyboardType = UIKeyboardTypePhonePad;
            
            if ([registerFeilds.cellPhone length] < 10)
                lineView.backgroundColor = [UIColor grayColor];
            else
                lineView.backgroundColor = [UIColor blueColor];
        }
        else
        {
            cellimageView.image = [UIImage imageNamed:@"referralcode_icon"];
            
            [cellTextFeild setSecureTextEntry:NO];
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"REFERRAL CODE" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-3] }];
            cellTextFeild.attributedPlaceholder = str;
            cellTextFeild.text = registerFeilds.referalCode;
            cellTextFeild.keyboardType = UIKeyboardTypeDefault;
            cellTextFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
            
            if ([registerFeilds.cellPhone length] < 10)
                lineView.backgroundColor = [UIColor grayColor];
            else
                lineView.backgroundColor = [UIColor blueColor];
        }
        
    }
    
//    if (isAllFeildsCorrect)
//        nextBtn.enabled = YES;
//    else
//        nextBtn.enabled = YES;
    
    return cell;
}
#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float bgHeight = 35*MULTIPLYHEIGHT;
    return bgHeight;
}
//-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12.50)];
//    
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds
//                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
//                                           cornerRadii:CGSizeMake(5.0, 5.0)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = footerView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    footerView.layer.mask = maskLayer;
//    
//    //    footerView.layer.cornerRadius = 5.0;
//    footerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    footerView.backgroundColor = [UIColor clearColor];
//    
//    return footerView;
//    
//    return nil;
//}
//-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 12.50)];
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds
//                                     byRoundingCorners:(UIRectCornerTopLeft| UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(5.0, 5.0)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = headerView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    headerView.layer.mask = maskLayer;
//    
//    //    headerView.layer.cornerRadius = 5.0;
//    headerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
//    headerView.backgroundColor = [UIColor clearColor];
//    
//    return headerView;
//    
//    return nil;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 12.5;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 12.5;
//}
#pragma mark - TextFeild Delegate methods
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    tempTf = textField;
    return YES;
}

-(void) keyboardWillChangeFrameNotif:(NSNotification *)notif
{
    
    NSTimeInterval obj = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    UIViewAnimationCurve curve = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue];
    
    CGRect keyboardEndFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    keyboardEndFrame = [self.view convertRect:keyboardEndFrame fromView:nil];
    
    [UIView beginAnimations:nil context:NULL];
    
    [UIView setAnimationDuration:obj];
    
    [UIView setAnimationCurve:curve];
    
    CGFloat yAxis = CGRectGetMaxY(self.view.bounds) - keyboardEndFrame.origin.y;
    
    registrationTableView.frame = CGRectMake(registrationTableView.frame.origin.x, registrationTableView.frame.origin.y, registrationTableView.frame.size.width, screen_height-( registrationTableView.frame.origin.y+yAxis));
    registrationTableView.scrollEnabled = YES;
    //registrationTableView.scrollEnabled = NO;
    
    [UIView commitAnimations];
    
}

-(void) textFieldDidChange:(NSNotification *)notif
{
    if (verificationTextFeild.text.length == 6)
    {
        [verificationTextFeild resignFirstResponder];
        
        [self verifyBtnClicked:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == verificationTextFeild)
    {
        
        
        return YES;
    }
    
    if (textField != verificationTextFeild)
    {
        // If there is text in the text field
        if (textField.text.length + (string.length - range.length) > 0)
        {
            float txtHeight = 30*MULTIPLYHEIGHT;
            
            CGRect frame = textField.frame;
            frame.size.height = txtHeight;
            textField.frame = frame;
        }
        else
        {
            float txtHeight = 35*MULTIPLYHEIGHT;
            
            CGRect frame = textField.frame;
            frame.size.height = txtHeight;
            textField.frame = frame;
        }
    }
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField.placeholder isEqualToString:@"EMAIL"])
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        
        registerFeilds.emailAddress = str;
    }
    else if ([textField.placeholder isEqualToString:@"PASSWORD"])
    {
        if ([str length] > 20)
        {
            return NO;
        }
        
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        
        registerFeilds.password = str;
    }
    else if ([textField.placeholder isEqualToString:@"NAME"])
    {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        //str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([str length] > 20)
        {
            return NO;
        }
        
        registerFeilds.firstName = str;
    }
    else if ([textField.placeholder isEqualToString:@"LAST NAME"])
    {
        if ([str length] > 20)
        {
            return NO;
        }
        
        registerFeilds.lastName = str;
    }
    else if ([textField.placeholder isEqualToString:@"MOBILE NUMBER"] || [textField.placeholder isEqualToString:@"MOBILE or LAND-LINE NUMBER"])
    {
        if ([str length] > 10)
        {
            [appDel showAlertWithMessage:@"Number should be 8 or 10 digits" andTitle:@"" andBtnTitle:@"OK"];
            
            return NO;
        }
        
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        
        registerFeilds.cellPhone = str;
    }
    else if ([textField.placeholder isEqualToString:@"REFERRAL CODE"])
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        
        registerFeilds.referalCode = str;
    }
    else if([textField.placeholder isEqualToString:@"ROOM / EXTENSION NUMBER"])
    {
        if ([str length] > 20)
        {
            return NO;
        }
        
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        
        registerFeilds.extn_Number = str;
    }
    else if([textField.placeholder isEqualToString:@"ENTER CODE HERE"])
    {
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"T"] == NSOrderedSame)
    {
        if ([registerFeilds.emailAddress length] && [registerFeilds.password length] && [registerFeilds.firstName length])
        {
            nextBtn.enabled = YES;
            nextBtn.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.2];
            nextBtn.hidden = NO;
        }
        else
        {
            nextBtn.enabled = NO;
            nextBtn.backgroundColor = [UIColor clearColor];
            nextBtn.hidden = YES;
            
            animating = NO;
        }
    }
    else
    {
        if ([registerFeilds.emailAddress length] && [registerFeilds.password length] && [registerFeilds.firstName length] && [registerFeilds.cellPhone length])
        {
            nextBtn.enabled = YES;
            nextBtn.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.2];
            nextBtn.hidden = NO;
        }
        else
        {
            nextBtn.enabled = NO;
            nextBtn.backgroundColor = [UIColor clearColor];
            nextBtn.hidden = YES;
            
            animating = NO;
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == verificationTextFeild)
    {
        return;
    }
    if ([textField.placeholder isEqualToString:@"EMAIL"])
    {
        registerFeilds.emailAddress = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"PASSWORD"])
    {
        registerFeilds.password = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"NAME"])
    {
        registerFeilds.firstName = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"LAST NAME"])
    {
        registerFeilds.lastName = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"MOBILE NUMBER"] || [textField.placeholder isEqualToString:@"MOBILE or LAND-LINE NUMBER"])
    {
        if ([textField.text length] > 10)
        {
            return;
        }
        
        registerFeilds.cellPhone = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"REFERRAL CODE"])
    {
        registerFeilds.referalCode = textField.text;
    }
    else if([textField.placeholder isEqualToString:@"ENTER CODE HERE"])
    {
        
    }
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"T"] == NSOrderedSame)
    {
        if ([registerFeilds.emailAddress length] && [registerFeilds.password length] && [registerFeilds.firstName length])
        {
            nextBtn.enabled = YES;
            nextBtn.hidden = NO;
            nextBtn.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.2];
        }
        else
        {
            nextBtn.enabled = NO;
            nextBtn.hidden = YES;
            nextBtn.backgroundColor = [UIColor clearColor];
            
            animating = NO;
        }
    }
    else
    {
        if ([registerFeilds.emailAddress length] && [registerFeilds.password length] && [registerFeilds.firstName length] && [registerFeilds.cellPhone length])
        {
            nextBtn.enabled = YES;
            nextBtn.hidden = NO;
            nextBtn.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.2];
        }
        else
        {
            nextBtn.enabled = NO;
            nextBtn.hidden = YES;
            nextBtn.backgroundColor = [UIColor clearColor];
            
            animating = NO;
        }
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    [registrationTableView reloadData];
    
    return YES;
}

#pragma mark ValidateMethod
-(BOOL) validateTextFieldWithText :(NSString*)text With:(NSString*)validateText  {
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validateText];
    return [test evaluateWithObject:text];
}

-(void) dismissKeyboard
{
    [tempTf resignFirstResponder];
    [registrationTableView reloadData];
}


-(void) nextBtnClicked
{
    [self.view endEditing:YES];
    
    DLog(@"%@,%@,%@,%@,%@", registerFeilds.emailAddress, registerFeilds.password, registerFeilds.firstName, registerFeilds.lastName, registerFeilds.cellPhone);
    
    if (Static_screens_Build)
    {
        //Following lines is for testing
        
        if (validateUserView.hidden == NO)
        {
            closeBtn.hidden = YES;
            
            [self verifyBtnClicked:nil];
            
            return;
        }
        
        registrationTableView.hidden = YES;
        validateUserView.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = validateUserView.frame;
            rect.origin.y = 80*MULTIPLYHEIGHT;
            validateUserView.frame = rect;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        
        if (!btnTerms.selected)
        {
            
            [appDel showAlertWithMessage:@"Please agree to the terms & conditions" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        
        if (validateUserView.hidden == NO)
        {
            
            [self verifyBtnClicked:nil];
            
            return;
        }
        if (![self validateTextFieldWithText:registerFeilds.emailAddress With:VALIDATE_EMAILID])
        {
            
            [appDel showAlertWithMessage:@"Please enter a valid email address" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        if ([registerFeilds.password length] < 6)
        {
            
            [appDel showAlertWithMessage:@"Password should be at least 6 characters" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        if ([registerFeilds.firstName length] == 0)
        {
            
            [appDel showAlertWithMessage:@"Name shold not be empty" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        if ([registerFeilds.firstName length] <= 1)
        {
            
            [appDel showAlertWithMessage:@"Name should be atleast 2 characters" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
//        if ([registerFeilds.lastName length] == 0)
//        {
//            
//            [appDel showAlertWithMessage:@"Last name shold not be empty" andTitle:@"" andBtnTitle:@"OK"];
//            
//            return;
//        }
//        if ([registerFeilds.lastName length] <= 1)
//        {
//            
//            [appDel showAlertWithMessage:@"Last name should be atleast 2 characters" andTitle:@"" andBtnTitle:@"OK"];
//            
//            return;
//        }
        
        
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"T"] == NSOrderedSame)
        {
            if ([registerFeilds.cellPhone length])
            {
                if ([registerFeilds.cellPhone length] < 8 || [registerFeilds.cellPhone length] > 10 || [registerFeilds.cellPhone length] == 9)
                {
                    [appDel showAlertWithMessage:@"Number should be 8 or 10 digits" andTitle:@"" andBtnTitle:@"OK"];
                    
                    return;
                }
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *myNumber = [f numberFromString:registerFeilds.cellPhone];;
                
                if (!myNumber)
                {
                    [appDel showAlertWithMessage:@"Please enter a valid cellphone" andTitle:@"" andBtnTitle:@"OK"];
                    
                    return;
                }
            }
        }
        else
        {
            if ([registerFeilds.cellPhone length] == 0)
            {
                [appDel showAlertWithMessage:@"Please enter number" andTitle:@"" andBtnTitle:@"OK"];
                
                return;
            }
            
            if ([registerFeilds.cellPhone length] < 8 || [registerFeilds.cellPhone length] > 10 || [registerFeilds.cellPhone length] == 9)
            {
                [appDel showAlertWithMessage:@"Number should be 8 or 10 digits" andTitle:@"" andBtnTitle:@"OK"];
                
                return;
            }
            
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *myNumber = [f numberFromString:registerFeilds.cellPhone];;
            
            if (!myNumber)
            {
                [appDel showAlertWithMessage:@"Please enter a valid cellphone" andTitle:@"" andBtnTitle:@"OK"];
                
                return;
            }
        }
        
        if ([registerFeilds.referalCode length])
        {
            NSDictionary *dictRef = [NSMutableDictionary dictionaryWithObjectsAndKeys:registerFeilds.referalCode, @"referCode", nil];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@user/check/refercode", BASE_URL];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dictRef andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                {
                    [self registerServiceCalled];
                }
                else {
                    [appDel displayErrorMessagErrorResponse:responseObj];
                }
                
            }];
        }
        else
        {
            [self registerServiceCalled];
        }
    }
}

-(void) registerServiceCalled
{
    NSDictionary *dictReg = [NSMutableDictionary dictionaryWithObjectsAndKeys:registerFeilds.emailAddress, @"email", registerFeilds.password, @"password", registerFeilds.firstName,@"name", registerFeilds.cellPhone, @"phone", @"IOS", @"source", registerFeilds.referalCode, @"referCode", registerFeilds.extn_Number, @"roomExtensionNo", [[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST], @"userType", @"000000", @"zipcode", @"IOS", @"device", nil];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/register", BASE_URL];
    
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dictReg andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            
            dictRegisterResponse = [NSDictionary dictionaryWithDictionary:[responseObj objectForKey:@"r"]];
            
            [[NSUserDefaults standardUserDefaults] setObject:[responseObj objectForKey:@"uid"] forKey:USER_ID];
            
            [[NSUserDefaults standardUserDefaults] setObject:[responseObj objectForKey:@"t"] forKey:USER_TOKEN];
            
            [[NSUserDefaults standardUserDefaults] setObject:[[responseObj objectForKey:@"r"] objectForKey:@"refCode"] forKey:@"referalCode"];
            
            [[NSUserDefaults standardUserDefaults] setObject:registerFeilds.emailAddress forKey:USERNAME];
            [[NSUserDefaults standardUserDefaults] setObject:registerFeilds.password forKey:PASSWORD];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:REGISTER_DEVICETOKEN object:appDel];
            
            registrationTableView.hidden = YES;
            
            appDel.strReferralMessage = [[responseObj objectForKey:@"r"] objectForKey:@"refMessage"];
            
            appDel.freewashAmount = [[[responseObj objectForKey:@"r"] objectForKey:@"freeWashDiscount"]floatValue];
            
            if ([[[responseObj objectForKey:@"r"] objectForKey:@"recDiscountType"] isEqualToString:@"P"])
            {
                appDel.strRecurringAmount = [NSString stringWithFormat:@"%d%%", [[[responseObj objectForKey:@"r"] objectForKey:@"recDiscount"] intValue]];
            }
            else
            {
                appDel.strRecurringAmount = [NSString stringWithFormat:@"$%.2f", [[[responseObj objectForKey:@"r"] objectForKey:@"recDiscount"] floatValue]];
            }
            
            appDel.strShoeClean = [[responseObj objectForKey:@"r"] objectForKey:@"shoeCleaning"];
            appDel.strShoePolish = [[responseObj objectForKey:@"r"] objectForKey:@"shoePolishing"];
            appDel.strBagClean = [[responseObj objectForKey:@"r"] objectForKey:@"bagCleaning"];
            appDel.strCurtainClean = [[responseObj objectForKey:@"r"] objectForKey:@"curtainCleaning"];
            
            appDel.strShoeStartPrice = [[responseObj objectForKey:@"r"] objectForKey:@"shoeStartingPrice"];
            appDel.strBagStartPrice = [[responseObj objectForKey:@"r"] objectForKey:@"bagStartPrice"];
            
            if ([registerFeilds.referalCode length])
            {
                [self showReferraSuccessMessage];
            }
            else
            {
                [self checkConditions];
            }
        }
        else {
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}

-(void) checkConditions
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"T"] == NSOrderedSame)
    {
        AddressListViewController *addressView =[[AddressListViewController alloc] initWithNibName:@"AddressListViewController" bundle:nil];
        appDel.isFirstTimeAddressAdding = YES;
        
        [self.navigationController pushViewController:addressView animated:YES];
    }
    else
    {
        nextBtn.hidden = YES;
        
        [self performSelector:@selector(resendBlue) withObject:nil afterDelay:1];
        
        NSString *strVe = [NSString stringWithFormat:@"+65 %@", registerFeilds.cellPhone];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strVe];
        
        float spacing = 2.0f;
        [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [strVe length])];
        lblPhn.attributedText = attributedString;
        
        validateUserView.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect rect = validateUserView.frame;
            rect.origin.y = 80*MULTIPLYHEIGHT;
            validateUserView.frame = rect;
            
        } completion:^(BOOL finished) {
            
        }];
    }
}


-(void) verifyBtnClicked:(UIButton *) sender
{
    
    if (Static_screens_Build)
    {
        AddressListViewController *addressView =[[AddressListViewController alloc] initWithNibName:@"AddressListViewController" bundle:nil];
        [self.navigationController pushViewController:addressView animated:YES];
    }
    else
    {
        if (!([verificationTextFeild.text length] > 0))
        {
            [appDel showAlertWithMessage:@"Please enter the verification code" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", verificationTextFeild.text, @"verificationCode", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
        NSString *urlStr = [NSString stringWithFormat:@"%@user/verify", BASE_URL];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dict andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
            
            if ([[responseObj objectForKey:@"s"] intValue] == 1)
            {
                AddressListViewController *addressView =[[AddressListViewController alloc] initWithNibName:@"AddressListViewController" bundle:nil andWithType:NO];
                appDel.isFirstTimeAddressAdding = YES;
                [self.navigationController pushViewController:addressView animated:YES];
            }
            else
            {
                verificationTextFeild.text = @"";
                
                [appDel displayErrorMessagErrorResponse:responseObj];
            }
        }];
    }
}

-(void) showReferraSuccessMessage
{
    
    view_Popup = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //view_Popup.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:view_Popup];
    view_Popup.alpha = 0.0;
    [appDel applyBlurEffectForView:view_Popup Style:BLUR_EFFECT_STYLE_DARK];
    
    
    float vtX = 12*MULTIPLYHEIGHT;
    
    view_Tourist = [[UIView alloc]initWithFrame:CGRectMake(vtX, 0, screen_width-(vtX*2), 190)];
    view_Tourist.backgroundColor = [UIColor clearColor];
    view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
    [view_Popup addSubview:view_Tourist];
    
    
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
    closePCBtn.frame = CGRectMake(viewWidth-closeHeight, 0.0, closeHeight, closeHeight);
    closePCBtn.center = CGPointMake(vtX, vtX);
    [closePCBtn setImage:[UIImage imageNamed:@"cancel_popup"] forState:UIControlStateNormal];
    [closePCBtn addTarget:self action:@selector(closePopupScreen) forControlEvents:UIControlEventTouchUpInside];
    [view_Tourist addSubview:closePCBtn];
    
    [self performSelector:@selector(closePopupScreen) withObject:nil afterDelay:4];
    
    
    float yAxis = piingiconHeight/2+(10*MULTIPLYHEIGHT);
    
    UILabel *LblTourist = [[UILabel alloc] initWithFrame:CGRectMake(0, yAxis, view_Tourist.frame.size.width, 40)];
    LblTourist.text = @"CONGRATULATIONS!";
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
    
    float imgX = 36*MULTIPLYHEIGHT;
    
    float imgWidth = 40*MULTIPLYHEIGHT;
    
    UIImageView *imgPic = [[UIImageView alloc]initWithFrame:CGRectMake(view_Tourist.frame.size.width/2-(imgWidth/2), yAxis, imgWidth, imgWidth)];
    imgPic.backgroundColor = [UIColor clearColor];
    imgPic.contentMode = UIViewContentModeScaleAspectFit;
    imgPic.image = [UIImage imageNamed:@"gift_box"];
    [view_Tourist addSubview:imgPic];
    
    
    yAxis += imgWidth;
    
    float lblDiscountHeight = 20*MULTIPLYHEIGHT;
    
    UILabel *LblDiscount = [[UILabel alloc] initWithFrame:CGRectMake(imgX, yAxis, view_Tourist.frame.size.width-(imgX*2), lblDiscountHeight)];
    //LblDiscount.text = [NSString stringWithFormat:@"You have won a free wash worth $%.2f", appDel.freewashAmount];
    LblDiscount.text = [dictRegisterResponse objectForKey:@"referralCodeMsg"];
    LblDiscount.numberOfLines = 0;
    LblDiscount.textAlignment = NSTextAlignmentCenter;
    LblDiscount.textColor = [UIColor darkGrayColor];
    LblDiscount.backgroundColor = [UIColor clearColor];
    LblDiscount.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
    [view_Tourist addSubview:LblDiscount];
    
    CGSize size = [AppDelegate getLabelSizeForRegularText:LblDiscount.text WithWidth:LblDiscount.frame.size.width FontSize:LblDiscount.font.pointSize];
    
    CGRect rect = LblDiscount.frame;
    rect.size.height = size.height;
    LblDiscount.frame = rect;
    
    yAxis += size.height + 30*MULTIPLYHEIGHT;
    
    CGRect frameView = view_Tourist.frame;
    frameView.size.height = yAxis;
    view_Tourist.frame = frameView;
    
    
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Popup.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        
    }];
}


-(void) closePopupScreen
{
    
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Popup.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [view_Popup removeFromSuperview];
        view_Popup = nil;
        
        
        [self checkConditions];
    }];
}

@end
