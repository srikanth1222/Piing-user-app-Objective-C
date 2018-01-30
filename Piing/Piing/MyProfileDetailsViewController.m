//
//  MyProfileDetailsViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "MyProfileDetailsViewController.h"
#import "ForgetPasswordViewController.h"
#define TEXT_COLOR_PIINGDETAIL [UIColor colorWithRed:81.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:0.95]

@interface MyProfileDetailsViewController () <UITextFieldDelegate>
{
    AppDelegate *appdel;
    UIButton *editBtn;
    UITextField *fstNametextFeild;
    UITextField *emailtextFeild;
    UITextField *passwordtextFeild;
    UITextField *mobiletextFeild;
    UITextField *referralCodeTF;
    
    UILabel *userNameLbl;
    UIView *view_Popup;
    UIView *view_Tourist;
    
    UITextField *paswordTF,*verfCodeTextField, *confirmPwdTF;

    NSString *strFstName;
    NSString *strEmailID;
    NSString *strPassword;
    NSString *strMobileNum;
    
    UILabel *LblEnterText;
    UIButton *btnSubmit;
    
    NSString *localPiingPin;
    UIScrollView *scrollviewProfile;
    
    BOOL isPopupOpen;
    
    UIButton *btnVerification;
    
    NSDictionary *resDic;
    
    BOOL updateReferralCode;
    
    BOOL referralCodeSuccess;
}

@end

@implementation MyProfileDetailsViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appdel = [PiingHandler sharedHandler].appDel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/checkreferralexists", BASE_URL];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            updateReferralCode = [[responseObj objectForKey:@"updateReferral"] boolValue];
            
            [self showUserProfile];
            
        }
        else
        {
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(void) showUserProfile
{
    
    CGFloat ypos = 22*MULTIPLYHEIGHT;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, ypos, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    float editWidth = 57*MULTIPLYHEIGHT;
    float editX = screen_width-(editWidth+10*MULTIPLYHEIGHT);
    
    editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(editX, ypos, editWidth, 40);
    [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM+1];
    [editBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(EDITBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editBtn];
    editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    ypos += 40+5*MULTIPLYHEIGHT;;
    
    scrollviewProfile = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ypos, screen_width, screen_height-ypos)];
    [self.view addSubview:scrollviewProfile];
    scrollviewProfile.contentSize = CGSizeMake(screen_width, scrollviewProfile.frame.size.height);
    
    float picHeight = 44*MULTIPLYHEIGHT;
    
    ypos = 30*MULTIPLYHEIGHT;
    
    UIImageView *userPic = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width/2-picHeight/2, ypos, picHeight, picHeight)];
    userPic.contentMode = UIViewContentModeCenter;
    userPic.image = [UIImage imageNamed:@"profileUser"];
    [scrollviewProfile addSubview:userPic];
    
    ypos += picHeight;
    
    float lblHeight = 20*MULTIPLYHEIGHT;
    
    userNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, ypos, screen_width, lblHeight)];
    userNameLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM-1];
    userNameLbl.textColor = [UIColor darkGrayColor];
    userNameLbl.textAlignment = NSTextAlignmentCenter;
    userNameLbl.tag = 10;
    userNameLbl.backgroundColor = [UIColor clearColor];
    [scrollviewProfile addSubview:userNameLbl];
    
    ypos += lblHeight+15*MULTIPLYHEIGHT;
    
    
    NSMutableArray *arrayNames = [[NSMutableArray alloc]initWithObjects:@"NAME", @"EMAIL", @"PASSWORD", @"MOBILE", nil];
    NSMutableArray *arrayImages = [[NSMutableArray alloc]initWithObjects:@"Name_icon", @"username_icon", @"password_icon", @"mobile_icon", nil];
    
    
    if (updateReferralCode)
    {
        [arrayNames addObject:@"REFERRAL CODE"];
        [arrayImages addObject:@"referralcode_icon"];
    }
    
    for (int i=0; i<[arrayNames count]; i++)
    {
        float bgX = 15*MULTIPLYHEIGHT;
        float bgHeight = 30*MULTIPLYHEIGHT;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, ypos, screen_width-(bgX*2), bgHeight)];
        bgView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        [scrollviewProfile addSubview:bgView];
        
        float imgX = 7*MULTIPLYHEIGHT;
        float imgHeight = 16*MULTIPLYHEIGHT;
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, bgHeight/2-imgHeight/2, imgHeight, imgHeight)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:[arrayImages objectAtIndex:i]];
        [bgView addSubview:imgView];
        
        
        float lblX = imgX+imgHeight+10*MULTIPLYHEIGHT;
        
        UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(lblX, 0, 120, bgHeight)];
        lblTitle.textColor = [UIColor darkGrayColor];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-2];
        lblTitle.text = [arrayNames objectAtIndex:i];
        [bgView addSubview:lblTitle];
        
        NSString *strText = [arrayNames objectAtIndex:i];
        CGSize size = [AppDelegate getLabelSizeForBoldText:strText WithWidth:screen_width FontSize:lblTitle.font.pointSize];
        CGRect rectLblTitle = lblTitle.frame;
        rectLblTitle.size.width = size.width;
        lblTitle.frame = rectLblTitle;
        
        float tfX = lblX+rectLblTitle.size.width+20*MULTIPLYHEIGHT;
        
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(tfX, 0, bgView.frame.size.width-tfX, bgHeight)];
        tf.delegate = self;
        tf.textColor = [UIColor darkGrayColor];
        tf.backgroundColor = [UIColor clearColor];
        tf.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-1];
        tf.userInteractionEnabled = NO;
        tf.alpha = 0.6;
        [bgView addSubview:tf];
        
        if (i == 0)
        {
            tf.placeholder = @"Name";
            fstNametextFeild = tf;
        }
        if (i == 1)
        {
            tf.placeholder = @"example@example.com";
            emailtextFeild = tf;
        }
        if (i == 2)
        {
            tf.placeholder = @"******";
            tf.secureTextEntry = YES;
            passwordtextFeild = tf;
        }
        if (i == 3)
        {
            tf.placeholder = @"MOBILE NUMBER";
            mobiletextFeild = tf;
        }
        if (i == 4)
        {
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf.placeholder = @"REFERRAL CODE";
            referralCodeTF = tf;
        }
        
        ypos += bgHeight+5*MULTIPLYHEIGHT;
        
    }
    
//    float btnVHeight = 18*MULTIPLYHEIGHT;
//    
//    btnVerification = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnVerification.frame = CGRectMake(0, ypos, screen_width, btnVHeight);
//    //[scrollviewProfile addSubview:btnVerification];
//    [btnVerification addTarget:self action:@selector(resendVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
//    btnVerification.backgroundColor = [UIColor clearColor];
//    
//    ypos += btnVHeight+30*MULTIPLYHEIGHT;
    
    ypos += 35*MULTIPLYHEIGHT;
    
    float bgX = 15*MULTIPLYHEIGHT;
    float logoutHeight = 30*MULTIPLYHEIGHT;
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogout.frame = CGRectMake(bgX, ypos, screen_width - (bgX*2), logoutHeight);
    [btnLogout setTitle:@"LOG OUT" forState:UIControlStateNormal];
    [btnLogout setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnLogout.titleLabel setFont:[UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM]];
    btnLogout.backgroundColor = [UIColor clearColor];
    
    btnLogout.layer.borderWidth = 1.0f;
    btnLogout.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    [btnLogout addTarget:self action:@selector(logoutClicked) forControlEvents:UIControlEventTouchUpInside];
    [scrollviewProfile addSubview:btnLogout];
    
    [self getUserDetails];
}

-(void) getUserDetails
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    NSDictionary *verificationDetailsDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/get", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            resDic = [responseObj objectForKey:@"user"];
            
            userNameLbl.text = [[resDic objectForKey:@"name"] uppercaseString];
            
            fstNametextFeild.text = [resDic objectForKey:@"name"];
            
            emailtextFeild.text = [resDic objectForKey:@"email"];
            passwordtextFeild.text = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
            mobiletextFeild.text = [resDic objectForKey:@"phone"];
            localPiingPin = [resDic objectForKey:@"TransactionPin"];
            
//            if ([[resDic objectForKey:@"newemail"]length])
//            {
//                NSString *str1 = [@"Verification link is sent to your mail. " uppercaseString];
//                
//                NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:str1];
//                [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM-3], NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, str1.length)];
//                
//                NSString *str2 = @"RESEND";
//                
//                NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:str2];
//                [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM-3], NSForegroundColorAttributeName:[UIColor redColor], NSUnderlineStyleAttributeName:@(NSUnderlineStyleDouble)} range:NSMakeRange(0, str2.length)];
//                
//                [mainAttr appendAttributedString:attr1];
//                
//                [btnVerification setAttributedTitle:mainAttr forState:UIControlStateNormal];
//            }
            
        }
    }];
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

-(void) resendVerificationCode:(id)sender
{
    return;
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [resDic objectForKey:@"un"], @"emailid", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@resendemailverification/services.do?", BASE_URL];
    
    NSString *str = @"";
    for (NSString *key in [detailsDic allKeys])
        
    {
        if(str.length > 0)
            str = [str stringByAppendingString:@"&"];
        NSString *value = [detailsDic objectForKey:key];
        
        str = [str stringByAppendingFormat:@"%@=%@",key,value];
        
    }
    if(str.length > 0)
        urlStr = [urlStr stringByAppendingString:str];
    
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"GET" withDetailsDictionary:nil andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame)
        {
            
        }
        else
        {
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


- (void)keyboardFrameWillChange:(NSNotification *)notification
{
    if (!isPopupOpen)
    {
        CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        CGRect newFrame = scrollviewProfile.frame;
        CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
        //CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
        
        newFrame.size.height = keyboardFrameEnd.origin.y-60;
        
        scrollviewProfile.frame = newFrame;
        
        [UIView commitAnimations];
    }
}

-(void) logoutClicked
{
    [appdel userLogout];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appdel hideTabBar:appdel.customTabBarController];
    
    view_Popup.alpha = 0.0;
}

- (void)backToPreviousScreen
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)EDITBtnClicked:(id) sender{
    NSLog(@"Edit clicked ");
    
    
    [self.view endEditing:YES];
    
    UIButton *titleBtn = (UIButton *) sender;
    NSString *titlestr = titleBtn.titleLabel.text;
    
    if([titlestr isEqualToString:@"EDIT"])
    {
        isPopupOpen = YES;
        
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
        else
        {
            view_Popup.alpha = 0.0;
            
            [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
                
                view_Popup.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                
            }];
            
        }
        return;
        //----------------------
        
    }
    else{
        
        strFstName = fstNametextFeild.text;
        strEmailID = emailtextFeild.text;
        strPassword = passwordtextFeild.text;
        strMobileNum = mobiletextFeild.text;
        
        if (strFstName.length == 0 || strFstName == nil) {
            
            [appdel showAlertWithMessage:@"Please enter first name" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        
        if (!([strEmailID length] > 0))
        {
            [appdel showAlertWithMessage:@"Please enter email" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        
        if(strPassword.length < 6)
        {
            [appdel showAlertWithMessage:@"Password should be at least 6 characters" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"y"] == NSOrderedSame)
        {
            
        }
        else
        {
            if(strMobileNum.length == 0 || strMobileNum == nil)
            {
                [appdel showAlertWithMessage:@"Please enter mobile number" andTitle:@"" andBtnTitle:@"OK"];
                
                return;
            }
            
            if ([strMobileNum length] < 8 || [strMobileNum length] > 10 || [strMobileNum length] == 9)
            {
                [appdel showAlertWithMessage:@"Number should be 8 or 10 digits" andTitle:@"" andBtnTitle:@"OK"];
                
                return;
            }
        }
        if (![self validateTextFieldWithText:emailtextFeild.text With:VALIDATE_EMAILID])
        {
            [appdel showAlertWithMessage:@"Please enter a valid email address" andTitle:@"" andBtnTitle:@"OK"];
            
            return;
        }
        
        [self updateUserProfile];
    }
}

-(void)updateUserProfile
{
    if ([referralCodeTF.text length])
    {
        NSDictionary *dictRef = [NSMutableDictionary dictionaryWithObjectsAndKeys:referralCodeTF.text, @"referCode", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user/check/refercode", BASE_URL];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dictRef andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
            {
                NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", referralCodeTF.text, @"referCode", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
                
                NSString *urlStr = [NSString stringWithFormat:@"%@user/savereferral", BASE_URL];
                
                [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:params andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                    
                    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
                    
                    if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                        
                        [self showReferraSuccessMessage:[responseObj objectForKey:@"msg"]];
                    }
                    else
                    {
                        [appdel displayErrorMessagErrorResponse:responseObj];
                    }
                }];
            }
            else {
                [appdel displayErrorMessagErrorResponse:responseObj];
            }
        }];
    }
    else
    {
        [self updateAgain];
    }
}

-(void) updateAgain
{
    NSString *psw = [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    NSDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", strFstName, @"name", strEmailID, @"email", psw, @"password", strMobileNum, @"phone", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/update", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:params andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            if ([[responseObj objectForKey:@"verificationneeded"] boolValue])
            {
                [self MobileUpdateVarificationPopup];
            }
            else
            {
                [appdel showAlertWithMessage:@"Your profile has been updated successfully." andTitle:@"" andBtnTitle:@"OK"];
                
                [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
                
                fstNametextFeild.alpha = 0.6;
                emailtextFeild.alpha = 0.6;
                passwordtextFeild.alpha = 0.6;
                mobiletextFeild.alpha = 0.6;
                referralCodeTF.alpha = 0.6;
                
                fstNametextFeild.userInteractionEnabled = NO;
                emailtextFeild.userInteractionEnabled = NO;
                passwordtextFeild.userInteractionEnabled = NO;
                mobiletextFeild.userInteractionEnabled = NO;
                referralCodeTF.userInteractionEnabled = NO;
            }
        }
        else
        {
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void)MobileUpdateVarificationPopup{
    
    isPopupOpen = YES;
    
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
        LblTourist.text = @"VERIFY MOBILE";
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
        
        //yAxis += 10*MULTIPLYHEIGHT;
        
        
        float lblX = 20*MULTIPLYHEIGHT;
        float lblHeight = 30*MULTIPLYHEIGHT;
        
        UILabel *LblDesc = [[UILabel alloc] initWithFrame:CGRectMake(lblX, yAxis, viewWidth-(lblX*2), lblHeight)];
        LblDesc.text = @"A verification code has been sent to your mobile.";
        LblDesc.textAlignment = NSTextAlignmentCenter;
        LblDesc.numberOfLines = 0;
        LblDesc.textColor = [UIColor darkGrayColor];
        LblDesc.backgroundColor = [UIColor clearColor];
        LblDesc.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-4];
        [view_Top addSubview:LblDesc];
        
        yAxis += lblHeight+5*MULTIPLYHEIGHT;
        
        
        float tfHeight = 26*MULTIPLYHEIGHT;
        
        verfCodeTextField= [[UITextField alloc] initWithFrame:CGRectMake(lblX, yAxis, viewWidth-(lblX*2), tfHeight)];
        verfCodeTextField.borderStyle = UITextBorderStyleNone;
        verfCodeTextField.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-2];
        verfCodeTextField.placeholder = @"CODE";
        verfCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        verfCodeTextField.returnKeyType = UIReturnKeyDone;
        verfCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        verfCodeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        verfCodeTextField.delegate = self;
        [view_Top addSubview:verfCodeTextField];
        verfCodeTextField.layer.borderWidth = 0.6;
        verfCodeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        verfCodeTextField.leftView = paddingView;
        verfCodeTextField.leftViewMode = UITextFieldViewModeAlways;
        [verfCodeTextField becomeFirstResponder];
        
        yAxis += tfHeight+10*MULTIPLYHEIGHT;
        
        
        UIButton *confirmBut = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmBut.frame = CGRectMake(lblX, yAxis, viewWidth-(lblX*2), tfHeight);
        confirmBut.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-2];
        [confirmBut setTitle:@"CONFIRM" forState:UIControlStateNormal];
        [confirmBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBut.backgroundColor = APPLE_BLUE_COLOR;
        [confirmBut addTarget:self action:@selector(CONFIRM_or_RESENDVERIFICATION:) forControlEvents:UIControlEventTouchUpInside];
        confirmBut.tag = 1;
        [view_Top addSubview:confirmBut];
        [confirmBut setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        yAxis += tfHeight+5*MULTIPLYHEIGHT;
        
        
        UIButton *resendVerfBut = [UIButton buttonWithType:UIButtonTypeCustom];
        resendVerfBut.frame = CGRectMake(lblX, yAxis, viewWidth-(lblX*2), tfHeight);
        resendVerfBut.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-3];
        [resendVerfBut setTitle:@"RESEND VERIFICATION CODE" forState:UIControlStateNormal];
        [resendVerfBut setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateNormal];
        resendVerfBut.backgroundColor = [UIColor clearColor];
        [resendVerfBut addTarget:self action:@selector(CONFIRM_or_RESENDVERIFICATION:) forControlEvents:UIControlEventTouchUpInside];
        resendVerfBut.tag = 2;
        [view_Top addSubview:resendVerfBut];
        resendVerfBut.layer.borderWidth = 0.6;
        resendVerfBut.layer.borderColor = APPLE_BLUE_COLOR.CGColor;
        [resendVerfBut setBackgroundImage:[AppDelegate imageWithColor:[[UIColor colorFromHexString:@"#ededed"]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
        
        
        yAxis += tfHeight+20*MULTIPLYHEIGHT;
        
        CGRect frameView = view_Tourist.frame;
        frameView.size.height = yAxis;
        view_Tourist.frame = frameView;
        
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else
    {
        view_Popup.alpha = 0.0;
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            
        }];
        
    }
    return;
    //--------------------
    
}

-(void) showPasswordPopup
{
    isPopupOpen = YES;
    
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
        LblTourist.text = @"CHANGE PASSWORD";
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
        
//        float letHeight = 18*MULTIPLYHEIGHT;
        float lblX = 20*MULTIPLYHEIGHT;
//
//        LblEnterText = [[UILabel alloc] initWithFrame:CGRectMake(lblX, yAxis, view_Top.frame.size.width-(lblX*2), letHeight)];
//        LblEnterText.text = @"ENTER YOUR PASSWORD";
//        LblEnterText.textAlignment = NSTextAlignmentLeft;
//        LblEnterText.numberOfLines = 0;
//        LblEnterText.textColor = [UIColor grayColor];
//        LblEnterText.backgroundColor = [UIColor clearColor];
//        LblEnterText.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-4];
//        [view_Top addSubview:LblEnterText];
//        
//        yAxis += letHeight;
//        
        
        float tfHeight = 26*MULTIPLYHEIGHT;
        
        paswordTF = [[UITextField alloc] initWithFrame:CGRectMake(lblX, yAxis, viewWidth-(lblX*2), tfHeight)];
        paswordTF.borderStyle = UITextBorderStyleNone;
        paswordTF.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-2];
        paswordTF.placeholder = @"New password";
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
        
        yAxis += tfHeight+5*MULTIPLYHEIGHT;
        
        confirmPwdTF = [[UITextField alloc] initWithFrame:CGRectMake(lblX, yAxis, viewWidth-(lblX*2), tfHeight)];
        confirmPwdTF.borderStyle = UITextBorderStyleNone;
        confirmPwdTF.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-2];
        confirmPwdTF.placeholder = @"Confirm Password";
        confirmPwdTF.autocorrectionType = UITextAutocorrectionTypeNo;
        confirmPwdTF.returnKeyType = UIReturnKeyDone;
        confirmPwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        confirmPwdTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        confirmPwdTF.delegate = self;
        confirmPwdTF.secureTextEntry = YES;
        [view_Top addSubview:confirmPwdTF];
        confirmPwdTF.layer.borderWidth = 0.6;
        confirmPwdTF.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        confirmPwdTF.leftView = paddingView1;
        confirmPwdTF.leftViewMode = UITextFieldViewModeAlways;
        //[confirmPwdTF becomeFirstResponder];
        
        yAxis += tfHeight+15*MULTIPLYHEIGHT;
        
        CGFloat btnHeight = 30*MULTIPLYHEIGHT;
        
        UIButton *btnYes = [UIButton buttonWithType:UIButtonTypeCustom];
        btnYes.frame = CGRectMake(0, yAxis, viewWidth/2-1, btnHeight);
        btnYes.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM];
        [btnYes setTitle:@"CANCEL" forState:UIControlStateNormal];
        [btnYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnYes.backgroundColor = APPLE_BLUE_COLOR;
        [btnYes addTarget:self action:@selector(changePasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnYes.tag = 2;
        [view_Top addSubview:btnYes];
        [btnYes setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
        
        btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        btnSubmit.frame = CGRectMake(viewWidth/2, yAxis, viewWidth/2, btnHeight);
        btnSubmit.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM];
        [btnSubmit setTitle:@"SUBMIT" forState:UIControlStateNormal];
        btnSubmit.backgroundColor = APPLE_BLUE_COLOR;
        [btnSubmit addTarget:self action:@selector(changePasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    else
    {
        view_Popup.alpha = 0.0;
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Popup.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
}

-(void) changePasswordClicked:(UIButton *) btn
{
    if (btn.tag == 2)
    {
        [self closePopupScreen];
    }
    else
    {
        if ([paswordTF.text isEqualToString:confirmPwdTF.text])
        {
            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", paswordTF.text, @"newPassword", passwordtextFeild.text, @"oldPassword", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@user/changepassword", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
                
                if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                    
                    [self closePopupScreen];
                    
                    passwordtextFeild.text = paswordTF.text;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:passwordtextFeild.text forKey:PASSWORD];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [appdel showAlertWithMessage:@"Your password has been updated successfully." andTitle:@"" andBtnTitle:@"OK"];
                    
                }
                else {
                    [appdel displayErrorMessagErrorResponse:responseObj];
                }
            }];
        }
        else
        {
            [appdel showAlertWithMessage:@"New password and confirm password should be same." andTitle:@"" andBtnTitle:@"OK"];
        }
    }
}

-(void) closePopupScreen
{
    [self.view endEditing:YES];
    
    [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        view_Popup.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [view_Tourist removeFromSuperview];
        view_Tourist = nil;
        
        [view_Popup removeFromSuperview];
        view_Popup = nil;
        
        isPopupOpen = NO;
        
        if (referralCodeSuccess)
        {
            referralCodeSuccess = NO;
            
            [self updateAgain];
        }
        
    }];
}


-(void)CONFIRM_or_RESENDVERIFICATION:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == 1) {
        
        NSString *verificationCodeStr = verfCodeTextField.text;
        
        if (verificationCodeStr.length == 0)
        {
            [appdel showAlertWithMessage:@"Please enter verification code" andTitle:@"" andBtnTitle:@"OK"];
        }
        else
        {
            NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", verificationCodeStr, @"verificationCode", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@user/verifyprofileupdate", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
                
                if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                    
                    [self closePopupScreen];
                    
                    [appdel showAlertWithMessage:@"Your profile has been updated successfully." andTitle:@"" andBtnTitle:@"OK"];
                    
                    [editBtn setTitle:@"EDIT" forState:UIControlStateNormal];
                    
                    fstNametextFeild.alpha = 0.6;
                    emailtextFeild.alpha = 0.6;
                    passwordtextFeild.alpha = 0.6;
                    mobiletextFeild.alpha = 0.6;
                    referralCodeTF.alpha = 0.6;
                    
                    fstNametextFeild.userInteractionEnabled = NO;
                    emailtextFeild.userInteractionEnabled = NO;
                    passwordtextFeild.userInteractionEnabled = NO;
                    mobiletextFeild.userInteractionEnabled = NO;
                    referralCodeTF.userInteractionEnabled = NO;
                }
                else {
                    [appdel displayErrorMessagErrorResponse:responseObj];
                }            
            }];
        }
    }
    else if (btn.tag == 2)
    {
        NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", mobiletextFeild.text, @"mno", nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user/resendverificationcode", BASE_URL];
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
            
            if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                
                [appdel showAlertWithMessage:@"A new verification code has been sent" andTitle:@"" andBtnTitle:@"OK"];
            }
            else {
                
                verfCodeTextField.text = @"";
                
                [appdel displayErrorMessagErrorResponse:responseObj];
            }            
        }];
    }
}

-(void)ForgotButton_or_YES_or_No_Clicked:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    
    [paswordTF resignFirstResponder];
    
    if (btn.tag == 1) {
        ForgetPasswordViewController *forgetPwdVC = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
        [self.navigationController pushViewController:forgetPwdVC animated:YES];
    }
    else if (btn.tag == 2){
        
        NSLog(@"Cancel");
        
        [self closePopupScreen];
    }
    else if (btn.tag == 3){
        NSLog(@"Submit");
        
        NSString *strForgot = paswordTF.text;
        
        if (strForgot.length == 0) {
            [appdel showAlertWithMessage:@"Please enter Password" andTitle:@"" andBtnTitle:@"OK"];
        }
        else{
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",strForgot,@"password",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", nil];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@user/authprofileupdate", BASE_URL];
            
            [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
            
            [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:params andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                
                [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
                
                if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                    NSLog(@"Sucess Edit verification");
                    
                    [editBtn setTitle: @"UPDATE" forState: UIControlStateNormal];
                    
                    fstNametextFeild.alpha = 1.0;
                    emailtextFeild.alpha = 1.0;
                    passwordtextFeild.alpha = 1.0;
                    mobiletextFeild.alpha = 1.0;
                    referralCodeTF.alpha = 1.0;
                    
                    fstNametextFeild.userInteractionEnabled = YES;
                    emailtextFeild.userInteractionEnabled = YES;
                    passwordtextFeild.userInteractionEnabled = YES;
                    mobiletextFeild.userInteractionEnabled = YES;
                    referralCodeTF.userInteractionEnabled = YES;
                    
                    [self closePopupScreen];
                }
                else
                {
                    NSLog(@"Failure verification");
                    
                    LblEnterText.text = @"EROR VERIFYING PASSWORD";
                    LblEnterText.textColor = [[UIColor redColor]colorWithAlphaComponent:0.7];
                    
                    btnSubmit.userInteractionEnabled = NO;
                    [btnSubmit setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
                    
                    paswordTF.layer.borderColor = [[UIColor redColor]colorWithAlphaComponent:0.7].CGColor;
                }
            }];
        }
    }
}


#pragma mark ValidateMethod
-(BOOL) validateTextFieldWithText :(NSString*)text With:(NSString*)validateText  {
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validateText];
    return [test evaluateWithObject:text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:passwordtextFeild])
    {
        [self.view endEditing:YES];
        
        [self showPasswordPopup];
        
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:paswordTF] || [textField isEqual:verfCodeTextField] || [textField isEqual:confirmPwdTF])
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:paswordTF] || [textField isEqual:verfCodeTextField] || [textField isEqual:confirmPwdTF])
    {
        [UIView animateKeyframesWithDuration:0.3 delay:0.0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            view_Tourist.center = CGPointMake(view_Popup.frame.size.width/2, view_Popup.frame.size.height/2);
            
        } completion:^(BOOL finished) {
            
        }];
    }
 
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([textField.placeholder isEqualToString:@"MOBILE NUMBER"])
    {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([str length] > 10)
        {
            [appdel showAlertWithMessage:@"Number should be 8 or 10 digits" andTitle:@"" andBtnTitle:@"OK"];
            
            return NO;
        }
        
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
    }
    else if ([textField.placeholder isEqualToString:@"******"])
    {
        NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([str length] > 20)
        {
            return NO;
        }
        
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        
        //passwordtextFeild.text = str;
    }
    else if ([textField.placeholder isEqualToString:@"Enter Password"])
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
    }
    else if ([textField.placeholder isEqualToString:@"CODE"])
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


-(void) showReferraSuccessMessage:(NSString *) message
{
    referralCodeSuccess = YES;
    
    view_Popup = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //view_Popup.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
    [self.view addSubview:view_Popup];
    view_Popup.alpha = 0.0;
    [appdel applyBlurEffectForView:view_Popup Style:BLUR_EFFECT_STYLE_DARK];
    
    
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
    [appdel applyBlurEffectForView:view_Top Style:BLUR_EFFECT_STYLE_EXTRA_LIGHT];
    
    
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
    LblTourist.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.HEADER_LABEL_FONT_SIZE-2];
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
    //LblDiscount.text = [NSString stringWithFormat:@"You have won a free wash worth $%.2f", appdel.freewashAmount];
    LblDiscount.text = message;
    
    //LblDiscount.text = @"You have won free wash worth of $15.";
    
    LblDiscount.numberOfLines = 0;
    LblDiscount.textAlignment = NSTextAlignmentCenter;
    LblDiscount.textColor = [UIColor darkGrayColor];
    LblDiscount.backgroundColor = [UIColor clearColor];
    LblDiscount.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM-2];
    [view_Tourist addSubview:LblDiscount];
    
    CGSize size = [AppDelegate getLabelSizeForRegularText:message WithWidth:LblDiscount.frame.size.width FontSize:LblDiscount.font.pointSize];
    
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
