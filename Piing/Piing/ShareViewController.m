//
//  ShareViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "ShareViewController.h"


@interface ShareViewController ()
{
    AppDelegate *appDel;
}

@end

@implementation ShareViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //imgBG.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imgBG.image = [UIImage imageNamed:@"free_wash_bg"];
    [self.view addSubview:imgBG];
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 40)];
    NSString *string = @"FREE WASH";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, yAxis, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    yAxis += 40+60*MULTIPLYHEIGHT;
    
    float imgGWidth = 51*MULTIPLYHEIGHT;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(screen_width/2-imgGWidth/2, yAxis, imgGWidth, imgGWidth)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [UIImage imageNamed:@"gift_box.png"];
    [self.view addSubview:imgView];
    
    yAxis += imgGWidth+10*MULTIPLYHEIGHT;
    
    
    float lblSY = 35*MULTIPLYHEIGHT;
    
    UILabel *lblShareJoy = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblSY)];
    lblShareJoy.backgroundColor = [UIColor clearColor];
    lblShareJoy.textAlignment = NSTextAlignmentCenter;
    lblShareJoy.numberOfLines = 0;
    [self.view addSubview:lblShareJoy];
    
    NSString *str1 = @"SHARE THE JOY!";
    NSMutableAttributedString *attrMain = [[NSMutableAttributedString alloc]initWithString:str1];
    [attrMain addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_LIGHT size:appDel.HEADER_LABEL_FONT_SIZE+16], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, str1.length)];
    
    lblShareJoy.attributedText = attrMain;
    
    yAxis += lblSY;
    
    
    float lblFX = 35*MULTIPLYHEIGHT;
    float lblFHeight = 25*MULTIPLYHEIGHT;
    
    UILabel *lblFreeWash = [[UILabel alloc]initWithFrame:CGRectMake(lblFX, yAxis, screen_width-(lblFX*2), lblFHeight)];
    lblFreeWash.textAlignment = NSTextAlignmentCenter;
    lblFreeWash.numberOfLines = 0;
    lblFreeWash.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    lblFreeWash.textColor = [UIColor grayColor];
    
    NSString *strFW = [NSString stringWithFormat:@"Give more, get more. Send friends a free wash to earn a free wash worth $%.2f!", appDel.freewashAmount];
    
    lblFreeWash.text = [strFW uppercaseString];
    [self.view addSubview:lblFreeWash];
    
    yAxis += lblFHeight+40*MULTIPLYHEIGHT;
    
    
    float lblPHeight = 40*MULTIPLYHEIGHT;
    
    lblPromoCode = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblPHeight)];
    lblPromoCode.textAlignment = NSTextAlignmentCenter;
    lblPromoCode.numberOfLines = 0;
    [self.view addSubview:lblPromoCode];
    //lblPromoCode.backgroundColor = [UIColor redColor];
    
    str1 = [@"Share your Promo Code\n" uppercaseString];
    
    attrMain = [[NSMutableAttributedString alloc]initWithString:str1];
    [attrMain addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, str1.length)];
    
    NSString *str2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"referalCode"];
    
    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+8], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, str2.length)];
    
    [attrMain appendAttributedString:attr1];
    
    lblPromoCode.attributedText = attrMain;
    
    yAxis += lblPHeight+30*MULTIPLYHEIGHT;
    
    
    float viewSX = 30*MULTIPLYHEIGHT;
    float viewSHeight = 44*MULTIPLYHEIGHT;
    
    UIView *view_Share = [[UIView alloc]initWithFrame:CGRectMake(viewSX, yAxis, screen_width-(viewSX*2), viewSHeight)];
    [self.view addSubview:view_Share];
    
    NSArray *arrayIcons = [[NSArray alloc]initWithObjects:@"whatsapp_icon.png",@"mail_icon.png",@"text_msg_icon.png", nil];
    
    int Width = view_Share.frame.size.width/[arrayIcons count];
    
    for (int i=0; i<[arrayIcons count]; i++)
    {
        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnShare setImage:[UIImage imageNamed:[arrayIcons objectAtIndex:i]] forState:UIControlStateNormal];
        btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btnShare.frame = CGRectMake(i*Width, 0, Width, 60);
        btnShare.backgroundColor = [UIColor clearColor];
        btnShare.tag = i+1;
        [btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view_Share addSubview:btnShare];
    }
    
    yAxis += viewSHeight+10*MULTIPLYHEIGHT;
    
    
    float btnSHeight = 25*MULTIPLYHEIGHT;
    
    UIButton *btnSocialMedia = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSocialMedia setTitle:@"SHARE ON SOCIAL MEDIA" forState:UIControlStateNormal];
    [btnSocialMedia setTitleColor:APPLE_BLUE_COLOR forState:UIControlStateNormal];
    btnSocialMedia.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
    btnSocialMedia.frame = CGRectMake(0, yAxis, screen_width, btnSHeight);
    [btnSocialMedia addTarget:self action:@selector(socialMediaButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSocialMedia];
    
}

- (void)backToPreviousScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) btnShareClicked:(id)sender
{
    UIButton *btnShare = (UIButton *) sender;
    
    if (btnShare.tag == 1)
    {
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
    }
    else if (btnShare.tag == 2)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            NSString *strFW = [NSString stringWithFormat:@"Hey! I've gifted you a free wash worth $%.2f!", appDel.freewashAmount];
            
            MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
            
            mailCompose.mailComposeDelegate = self;
            [mailCompose setSubject:strFW];
            [mailCompose setMessageBody:appDel.strReferralMessage isHTML:NO];
            
            [self presentViewController:mailCompose animated:YES completion:nil];
        }
    }
    else if (btnShare.tag == 3)
    {
        if(![MFMessageComposeViewController canSendText]) {
            
            [appDel showAlertWithMessage:@"Your device doesn't support SMS!" andTitle:@"" andBtnTitle:@"OK"];
            return;
        }
        
        NSString *message = [NSString stringWithFormat:@"%@", appDel.strReferralMessage];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:message];
        
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appDel hideTabBar:appDel.customTabBarController];
    
    //[appDel setBottomTabBarColor:TABBAR_COLOR_WHITE BlurEffectStyle:BLUR_EFFECT_STYLE_DARK HideBlurEffect:NO];
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


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            [appDel showAlertWithMessage:@"Failed to send SMS!" andTitle:@"" andBtnTitle:@"OK"];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)socialMediaButtonClicked:(id)sender
{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Share" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
            SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
            
            [controller setInitialText:[NSString stringWithFormat:@"%@", lblPromoCode.text]];
            [self presentViewController:controller animated:YES completion:Nil];
        }
        else
        {
            [appDel showAlertWithMessage:@"There is no Facebook account configured. you can add or create a Facebook account in Settings." andTitle:@"" andBtnTitle:@"OK"];
        }
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@", lblPromoCode.text]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            [appDel showAlertWithMessage:@"There is no Twitter account configured. you can add or create a Twitter account in Settings." andTitle:@"" andBtnTitle:@"OK"];
        }
        
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
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
