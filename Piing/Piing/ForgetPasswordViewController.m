//
//  ForgetPasswordViewController.m
//  Piing
//
//  Created by SHASHANK on 04/10/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()
{
    UITextField *emailTxtFeild;
    AppDelegate *appDel;
}

@end

@implementation ForgetPasswordViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(10.0, yAxis, 30, 30);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_white"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(closeBtn.frame), CGRectGetMinY(closeBtn.frame), screen_width - 130, 30)];
    NSString *str = [@"Forgot password" uppercaseString];
    [appDel spacingForTitle:titleLbl TitleString:str];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-3];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.center = CGPointMake(screen_width/2.0 ,titleLbl.center.y);
    [self.view addSubview:titleLbl];
    
    yAxis += 30+30*MULTIPLYHEIGHT;
    
    
    float lblX = 15*MULTIPLYHEIGHT;
    float lblHeight = 30*MULTIPLYHEIGHT;
    
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, yAxis, screen_width-(lblX*2), lblHeight)];
    headingLabel.text = @"Please enter the registered email address to receive your password";
    headingLabel.backgroundColor = [UIColor clearColor];
    headingLabel.numberOfLines = 0;
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    headingLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
    [self.view addSubview:headingLabel];
    
    yAxis += lblHeight+15*MULTIPLYHEIGHT;
    
    float bgX = 20*MULTIPLYHEIGHT;
    
    UIView *emailBG = [[UIView alloc] initWithFrame:CGRectMake(bgX, yAxis, screen_width-(bgX*2), lblHeight)];
    emailBG.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.95];
    [self.view addSubview:emailBG];
    
    
    float tfX = 10*MULTIPLYHEIGHT;
    
    emailTxtFeild = [[UITextField alloc] initWithFrame:CGRectMake(tfX, 0, emailBG.frame.size.width-(tfX*2), lblHeight)];
    emailTxtFeild.textAlignment = NSTextAlignmentLeft;
    emailTxtFeild.backgroundColor = [UIColor clearColor];
    emailTxtFeild.placeholder = @"Email";
    emailTxtFeild.keyboardType = UIKeyboardTypeEmailAddress;
    emailTxtFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailTxtFeild.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTxtFeild.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
    [emailBG addSubview:emailTxtFeild];
    
    yAxis += lblHeight+10*MULTIPLYHEIGHT;
    
    
    UIButton *submitPwdbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitPwdbtn.frame = CGRectMake(bgX, yAxis, CGRectGetWidth(emailBG.frame), lblHeight);
    [submitPwdbtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:1] forState:UIControlStateNormal];
    [submitPwdbtn addTarget:self action:@selector(submitButtonCLicked) forControlEvents:UIControlEventTouchUpInside];
    submitPwdbtn.backgroundColor = BLUE_COLOR;
    [submitPwdbtn setTitle:@"RESET" forState:UIControlStateNormal];
    submitPwdbtn.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
    [self.view addSubview:submitPwdbtn];
    [submitPwdbtn setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
}
#pragma mark UIcontrol methods
-(void) closeBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) viewTapped
{
    [self dismissKeyboard];
}
-(void) dismissKeyboard {
    [emailTxtFeild resignFirstResponder];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void) submitButtonCLicked
{
    [self dismissKeyboard];
    
    if (!([emailTxtFeild.text length] > 0))
    {
        UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@""
                                                                                   message:@"Please enter email"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errorMessageAlert addAction:defaultAction];
        [self presentViewController:errorMessageAlert animated:YES completion:nil];
        return;
    }
    if (![self validateTextFieldWithText:emailTxtFeild.text With:VALIDATE_EMAILID])
    {
        
        UIAlertController* errorMessageAlert = [UIAlertController alertControllerWithTitle:@""
                                                                                   message:@"Please enter a valid email address"
                                                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [errorMessageAlert addAction:defaultAction];
        [self presentViewController:errorMessageAlert animated:YES completion:nil];
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:emailTxtFeild.text, @"email", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/forgotpassword", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            emailTxtFeild.text = @"";
            
            [appDel showAlertWithMessage:@"Password is sent to your registered mail address" andTitle:@"" andBtnTitle:@"OK"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            emailTxtFeild.text = @"";
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


#pragma mark ValidateMethod
-(BOOL) validateTextFieldWithText :(NSString*)text With:(NSString*)validateText  {
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validateText];
    return [test evaluateWithObject:text];
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
