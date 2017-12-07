//
//  LoginViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "LoginViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ForgetPasswordViewController.h"
#import "RegistrationViewController.h"


#define USER_NAME_PLACEHOLDER @"EMAIL ID"


@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    MPMoviePlayerController *backGroundplayer;
    NSString *emailString,*passwordString;
    UITextField *tempTf;

    UITableView *logingDetailTableView;
    
    AppDelegate *appDel;
    
    float TABLE_HEIGHT;
    
    float xAxis;
}

@end

@implementation LoginViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    TABLE_HEIGHT = 33*MULTIPLYHEIGHT;
    xAxis = 30*MULTIPLYHEIGHT;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
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
    //blackTransparentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [appDel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
    [self.view addSubview:blackTransparentView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(15.0, 25*MULTIPLYHEIGHT, 30, 30);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(closeBtn.frame), CGRectGetMinY(closeBtn.frame), screen_width - 130, 30)];
    NSString *str = [@"Log in" uppercaseString];
    [appDel spacingForTitle:titleLbl TitleString:str];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-3];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.center = CGPointMake(screen_width/2.0 ,titleLbl.center.y);
    [self.view addSubview:titleLbl];
    
    
    logingDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame)+25*MULTIPLYHEIGHT, screen_width, screen_height)];
    logingDetailTableView.delegate = self;
    logingDetailTableView.dataSource = self;
    logingDetailTableView.separatorColor = [UIColor clearColor];
    logingDetailTableView.backgroundColor = [UIColor clearColor];
    logingDetailTableView.backgroundView = nil;
    logingDetailTableView.showsVerticalScrollIndicator = NO;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, logingDetailTableView.frame.size.width, 250)];
    footerView.backgroundColor = [UIColor clearColor];
    
    float yAxis = 0;
    
    UIButton *forgotPWDButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPWDButton setTitle:@"FORGOT PASSWORD?" forState:UIControlStateNormal];
    [forgotPWDButton setTitleColor:[UIColor colorWithRed:188/255.0	green:186/255.0 blue:187/255.0 alpha:1.0] forState:UIControlStateNormal];
    [forgotPWDButton.titleLabel setFont:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]];
    [forgotPWDButton setBackgroundColor:[UIColor clearColor]];
    forgotPWDButton.frame = CGRectMake(xAxis, yAxis, footerView.frame.size.width-(xAxis*2), 25);
    [forgotPWDButton addTarget:self action:@selector(forgetPwdClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:forgotPWDButton];
    
    yAxis += 25+20*MULTIPLYHEIGHT;
    
    
    UIButton *signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signinButton.frame = CGRectMake(xAxis, yAxis, footerView.frame.size.width-(xAxis*2), TABLE_HEIGHT);
    signinButton.layer.borderWidth = 0.5;
    signinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    signinButton.backgroundColor = [UIColor clearColor];
    [signinButton setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"Log In" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1]] forState:UIControlStateNormal];
    [signinButton addTarget:self action:@selector(signInBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signinButton];
    [signinButton setBackgroundImage:[AppDelegate imageWithColor:[[UIColor colorFromHexString:@"#ededed"]colorWithAlphaComponent:0.2]] forState:UIControlStateHighlighted];
    
    yAxis += TABLE_HEIGHT+17*MULTIPLYHEIGHT;
    
    
    UIImageView *orImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis+20, yAxis, footerView.frame.size.width-(xAxis*2+40), 1)];
    orImageView.backgroundColor = [UIColor colorWithRed:162.0/255.0 green:158.0/255.0 blue:158.0/255.0 alpha:1.0];
    //[footerView addSubview:orImageView];
    
    yAxis += 15*MULTIPLYHEIGHT;
    
    
    UIButton *faceBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    faceBookButton.frame = CGRectMake(xAxis, yAxis, footerView.frame.size.width-(xAxis*2), TABLE_HEIGHT);
    [faceBookButton setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"Connect with Facebook" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2]] forState:UIControlStateNormal];
    faceBookButton.backgroundColor = BLUE_COLOR;
    [faceBookButton addTarget:self action:@selector(faceBookBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    //[footerView addSubview:faceBookButton];
    [faceBookButton setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    
    logingDetailTableView.tableFooterView = footerView;
    [self.view addSubview:logingDetailTableView];
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
}
-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [backGroundplayer stop];
}
-(void) closeBtnClicked
{
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    completion:nil];
}
#pragma mark UIControl Button Actions
-(void) signInBtnClicked
{
    if (Static_screens_Build)
    {
        
    }
    else
    {
        [self.view endEditing:YES];
        
        if ([emailString length] == 0)
        {
            
            UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@""
                                                                                       message:@"Please enter email address"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [errorMessageAlert addAction:defaultAction];
            [self presentViewController:errorMessageAlert animated:YES completion:nil];
            
            return;
            
        }
        if ([passwordString length] == 0)
        {
            
            UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@""
                                                                                       message:@"Please enter password"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [errorMessageAlert addAction:defaultAction];
            [self presentViewController:errorMessageAlert animated:YES completion:nil];
            
            return;
        }
        
        if (![self validateTextFieldWithText:emailString With:VALIDATE_EMAILID])
        {
            
            emailString = @"";
            passwordString = @"";
            
            UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@""
                                                                                       message:@"Please enter a valid email address"
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [errorMessageAlert addAction:defaultAction];
            [self presentViewController:errorMessageAlert animated:YES completion:nil];
            
            [logingDetailTableView reloadData];
            
            return;
        }
//        if ([passwordString length] < 6)
//        {
//            
//            UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@""
//                                                                                       message:@"Password should be at least 6 characters"
//                                                                                preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                                  handler:^(UIAlertAction * action) {}];
//            
//            [errorMessageAlert addAction:defaultAction];
//            [self presentViewController:errorMessageAlert animated:YES completion:nil];
//            
//            return;
//        }
        
//        passwordString = [passwordString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        passwordString = [passwordString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:emailString forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] setObject:passwordString forKey:PASSWORD];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        appDel.loginClicked = YES;
        
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
        
        [appDel callLoginMethod];
        
    }
}

-(void) logincomplete
{
    
    PiingHandler *handler = [PiingHandler sharedHandler];
    [handler.appDel loginCompleted];
    
}
-(void) forgetPwdClicked:(UIButton *)sender
{
    ForgetPasswordViewController *forgetPwdVC = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}
-(void) faceBookBtnClicked
{
    
}
-(void) viewTapped
{
    [self dismissKeyboard];
}
#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"%ldCell",(long)indexPath.section];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(xAxis, 0, tableView.frame.size.width-(xAxis*2), TABLE_HEIGHT)];
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [cell addSubview:bgView];
        
        float imgHeight = 18*MULTIPLYHEIGHT;
        
        UIImageView *cellimageView = [[UIImageView alloc] initWithFrame:CGRectMake(8*MULTIPLYHEIGHT, bgView.frame.size.height/2-(imgHeight/2),imgHeight, imgHeight)];
        cellimageView.tag = 1235;
        cellimageView.contentMode = UIViewContentModeScaleAspectFit;
        [bgView addSubview:cellimageView];
        
        UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(35*MULTIPLYHEIGHT, 0, bgView.frame.size.width-(40*MULTIPLYHEIGHT), TABLE_HEIGHT)];
        textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFeild.tag = 1234;
        textFeild.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        textFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textFeild.autocorrectionType = UITextAutocorrectionTypeNo;
        textFeild.delegate = self;
        textFeild.textColor = [UIColor whiteColor];
        textFeild.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM+1];
        textFeild.returnKeyType = UIReturnKeyGo;
        [bgView addSubview:textFeild];
    }
    
    UITextField *cellTextFeild = (UITextField *)[cell viewWithTag:1234];
    UIImageView *cellimageView = (UIImageView *)[cell viewWithTag:1235];
    
    if (indexPath.section == 0)
    {
        cellimageView.image = [UIImage imageNamed:@"username_icon"];
        [cellTextFeild setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:USER_NAME_PLACEHOLDER attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(200, 200, 200, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        
        cellTextFeild.attributedPlaceholder = str;
        cellTextFeild.text = emailString;
        cellTextFeild.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else
    {
        cellimageView.image = [UIImage imageNamed:@"password_icon"];
        [cellTextFeild setSecureTextEntry:YES];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:PASSWORD attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(200, 200, 200, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        
        cellTextFeild.attributedPlaceholder = str;
        cellTextFeild.text = passwordString;
        cellTextFeild.keyboardType = UIKeyboardTypeDefault;
    }
    
    return cell;
}


#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8*MULTIPLYHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 8*MULTIPLYHEIGHT)];
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft| UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headerView.bounds;
    maskLayer.path = maskPath.CGPath;
    if (section == 0)
        headerView.layer.mask = maskLayer;
    
    headerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return 0.01;
    else
        return 5.0;
    //    return 10.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    float heightValue;
    
    if (section == 0)
        heightValue = 0.01;
    else
        heightValue = 20.0;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, heightValue)];
    
    //    UIBezierPath *maskPath;
    //    maskPath = [UIBezierPath bezierPathWithRoundedRect:footerView.bounds
    //                                     byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
    //                                           cornerRadii:CGSizeMake(5.0, 5.0)];
    //
    //    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //    maskLayer.frame = footerView.bounds;
    //    maskLayer.path = maskPath.CGPath;
    //
    //    if (section)
    //        footerView.layer.mask = maskLayer;
    
    footerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

#pragma mark - TextFeild Delegate methods
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    tempTf = textField;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    [UITableView beginAnimations:nil context:nil];
//    [UITableView setAnimationDuration:0.32];
//    
//    
//    [UITableView commitAnimations];
    
}


-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField.placeholder isEqualToString:USER_NAME_PLACEHOLDER])
    {
        emailString = str;
    }
    else if ([textField.placeholder isEqualToString:PASSWORD])
    {
        if ([str length] > 20)
        {
            return NO;
        }
        
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        
        passwordString = str;
        
//        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
//        
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        
//        if (![string isEqualToString:filtered])
//        {
//            return NO;
//        }
//        else
//        {
//            passwordString = str;
//        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"EMAIL"])
    {
        emailString = textField.text;
    }
    else if ([textField.placeholder isEqualToString:PASSWORD])
    {
        passwordString = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    [self signInBtnClicked];
    
    return YES;
}

-(void) dismissKeyboard {
    [tempTf resignFirstResponder];

    [UITableView beginAnimations:nil context:nil];
    [UITableView setAnimationDuration:0.32];
    
    
    [UITableView commitAnimations];
}

#pragma mark ValidateMethod
-(BOOL) validateTextFieldWithText :(NSString*)text With:(NSString*)validateText  {
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validateText];
    return [test evaluateWithObject:text];
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
