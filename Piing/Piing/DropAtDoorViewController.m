//
//  DropAtDoorViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 23/04/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "DropAtDoorViewController.h"
#import <FirebaseAnalytics/FIRAnalytics.h>


@interface DropAtDoorViewController () <UITextFieldDelegate, UITextViewDelegate>
{
    AppDelegate *appDel;
    
    NSMutableArray *arrayChars;
    NSString *strTextView;
    UIScrollView *scrollDrop;
    
    UITextField *activeTextField;
    
    UITextField *tfPin;
    UITextView *txtView;
}

@end

#define TEXT_COLOR [UIColor colorWithRed:128/255.0 green:127/255.0 blue:126/255.0 alpha:1.0]

@implementation DropAtDoorViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    appDel = [[PiingHandler sharedHandler] appDel];
    
    arrayChars = [[NSMutableArray alloc]init];
    
    CGFloat yAxis = 10*MULTIPLYHEIGHT;
    
    scrollDrop = [[UIScrollView alloc]init];
    scrollDrop.backgroundColor = [UIColor whiteColor];
    scrollDrop.frame = CGRectMake(0, 20, screen_width, screen_height-20);
    [self.view addSubview:scrollDrop];
    scrollDrop.contentSize = CGSizeMake(scrollDrop.frame.size.width, scrollDrop.frame.size.height);
    
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(screen_width-50, yAxis, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [scrollDrop addSubview:closeBtn];
    
    yAxis += 40+20*MULTIPLYHEIGHT;
    
    
    CGFloat lbl1X = 30*MULTIPLYHEIGHT;
    
    CGFloat lbl1Width = screen_width - (lbl1X*2);
    
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.frame = CGRectMake(lbl1X, yAxis, lbl1Width, 30);
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.textColor = TEXT_COLOR;
    lbl1.numberOfLines = 0;
    lbl1.backgroundColor = [UIColor clearColor];
    lbl1.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    [scrollDrop addSubview:lbl1];
    
    
    NSString *str1 = [@"your freshly-washed laundry will wait for you at your doorstep" uppercaseString];
    lbl1.text = str1;
    
    CGFloat lbl1Height = [AppDelegate getLabelHeightForRegularText:str1 WithWidth:lbl1Width FontSize:lbl1.font.pointSize];
    
    CGRect lbl1Rect = lbl1.frame;
    lbl1Rect.size.height = lbl1Height;
    lbl1.frame = lbl1Rect;
    
    yAxis += lbl1Height+25*MULTIPLYHEIGHT;
    
    
    CGFloat imgHeight = 100*MULTIPLYHEIGHT;
    
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(0, yAxis, screen_width, imgHeight);
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.backgroundColor = RGBCOLORCODE(229, 238, 243, 1.0);
    imgView.image = [UIImage imageNamed:@"dropatdoor_screen"];
    [scrollDrop addSubview:imgView];
    
    yAxis += imgHeight+10*MULTIPLYHEIGHT;
    
    
    CGFloat lbl2X = 20*MULTIPLYHEIGHT;
    
    CGFloat lbl2Width = screen_width - (lbl2X*2);
    
    UILabel *lbl2 = [[UILabel alloc] init];
    lbl2.frame = CGRectMake(lbl2X, yAxis, lbl2Width, 30);
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.textColor = RGBCOLORCODE(180, 180, 180, 1.0);
    lbl2.numberOfLines = 0;
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
    [scrollDrop addSubview:lbl2];
    
    
    NSString *str2 = @"Please note, in the unfortunate event of loss or damage to your unattended laundry, Piing! will not be held responsible.";
    lbl2.text = str2;
    
    CGFloat lbl2Height = [AppDelegate getLabelHeightForRegularText:str2 WithWidth:lbl2Width FontSize:appDel.FONT_SIZE_CUSTOM-2];
    
    CGRect lbl2Rect = lbl2.frame;
    lbl2Rect.size.height = lbl2Height;
    lbl2.frame = lbl2Rect;
    
    yAxis += lbl2Height+25*MULTIPLYHEIGHT;
    
    
//    
//    CGFloat lblPinX = 30*MULTIPLYHEIGHT;
//    
//    CGFloat lblPinWidth = screen_width - (lblPinX*2);
//    
//    UILabel *lblPin = [[UILabel alloc] init];
//    lblPin.frame = CGRectMake(lblPinX, yAxis, lblPinWidth, 30);
//    lblPin.textAlignment = NSTextAlignmentCenter;
//    lblPin.textColor = TEXT_COLOR;
//    lblPin.numberOfLines = 0;
//    lblPin.backgroundColor = [UIColor clearColor];
//    lblPin.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
//    [scrollDrop addSubview:lblPin];
//    
//    NSString *strPin = [@"please enter your piing! pin to confirm" uppercaseString];
//    lblPin.text = strPin;
//    
//    CGFloat lblPinHeight = [AppDelegate getLabelHeightForRegularText:strPin WithWidth:lblPinWidth FontSize:lblPin.font.pointSize];
//    
//    CGRect lblPinRect = lblPin.frame;
//    lblPinRect.size.height = lblPinHeight;
//    lblPin.frame = lblPinRect;
//    
//    yAxis += lblPinHeight+10*MULTIPLYHEIGHT;
//    
//    
//   
//    CGFloat viewPinHeight = 40*MULTIPLYHEIGHT;
//    
//    UIView *viewPin = [[UIView alloc]init];
//    viewPin.backgroundColor = RGBCOLORCODE(244, 245, 246, 1.0);
//    [scrollDrop addSubview:viewPin];
//    
//    
//    int tfX = 16*MULTIPLYHEIGHT;
//    
//    tfPin = [[UITextField alloc]init];
//    tfPin.delegate = self;
//    tfPin.frame = CGRectMake(tfX, 0, 20*MULTIPLYHEIGHT*5+(10*4), viewPinHeight-5*MULTIPLYHEIGHT);
//    tfPin.textColor = TEXT_COLOR;
//    tfPin.textAlignment = NSTextAlignmentLeft;
//    tfPin.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM+3];
//    [viewPin addSubview:tfPin];
//    [tfPin setTintColor:[UIColor clearColor]];
//    tfPin.keyboardType = UIKeyboardTypeNumberPad;
//    tfPin.backgroundColor = [UIColor clearColor];
//    
//    CGFloat blX = 10*MULTIPLYHEIGHT;
//    
//    for (int i=0; i<4; i++)
//    {
//        CALayer *bottomLayer = [[CALayer alloc]init];
//        bottomLayer.frame = CGRectMake(blX, tfPin.frame.size.height-1, 20*MULTIPLYHEIGHT, 1.0f);
//        bottomLayer.backgroundColor = RGBCOLORCODE(190, 190, 190, 1.0).CGColor;
//        [viewPin.layer addSublayer:bottomLayer];
//        
//        blX += 20*MULTIPLYHEIGHT+10;
//    }
//    
//    tfX = blX+5*MULTIPLYHEIGHT;
//    
//    //float viewPinWidth = (20*MULTIPLYHEIGHT)*4+(10*MULTIPLYHEIGHT+20*MULTIPLYHEIGHT);
//    
//    viewPin.frame = CGRectMake(screen_width/2-(tfX/2), yAxis, tfX, viewPinHeight);
//    
//    yAxis += viewPinHeight+10*MULTIPLYHEIGHT;
    
    
    txtView = [[UITextView alloc]init];
    txtView.delegate = self;
    
    strTextView = @"ANY DELIVERY INSTRUCTIONS? (E.G. LEAVE AT GAURD HOUSE)";
    
    txtView.text = strTextView;
    txtView.textColor = RGBCOLORCODE(200, 200, 200, 1.0);
    txtView.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-6];
    txtView.layer.cornerRadius = 5.0;
    txtView.layer.borderColor = RGBCOLORCODE(230, 230, 230, 1.0).CGColor;
    txtView.layer.borderWidth = 1.0;
    [scrollDrop addSubview:txtView];
    
    CGFloat txtX = 30*MULTIPLYHEIGHT;
    CGFloat txtHeight = 40*MULTIPLYHEIGHT;
    
    txtView.frame = CGRectMake(txtX, yAxis, screen_width-(txtX*2), txtHeight);
    
    yAxis += txtHeight+20*MULTIPLYHEIGHT;
    
    CGFloat btnHeight = 32*MULTIPLYHEIGHT;
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(txtX, yAxis, screen_width - (txtX*2), btnHeight);
    confirmBtn.backgroundColor = APPLE_BLUE_COLOR;
    confirmBtn.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2];
    [confirmBtn setTitle:@"CONFIRM" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmDropAtDoor:) forControlEvents:UIControlEventTouchUpInside];
    [scrollDrop addSubview:confirmBtn];
    [confirmBtn setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    confirmBtn.layer.cornerRadius = 15.0;
    confirmBtn.clipsToBounds = YES;
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
    
    CGRect newFrame = scrollDrop.frame;
    CGRect keyboardFrameEnd = [self.view convertRect:keyboardEndFrame toView:nil];
    //CGRect keyboardFrameBegin = [self.view convertRect:keyboardBeginFrame toView:nil];
    
    newFrame.size.height = keyboardFrameEnd.origin.y-20;
    
    scrollDrop.contentOffset = CGPointMake(scrollDrop.frame.size.width, newFrame.size.height);
    scrollDrop.frame = newFrame;
    
    [UIView commitAnimations];
}

-(void) confirmDropAtDoor:(id)sender
{
    [FIRAnalytics logEventWithName:@"confirm_drop_at_door_button" parameters:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", txtView.text, @"deliverAtDoorNote", [self.orderEditDetails objectForKey:@"oid"], @"oid", @"1", @"deliverAtDoor", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/deliveratdoor", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [self closeScreen:nil];
            
            if ([self.delegate respondsToSelector:@selector(didFinishDropAtDoor)])
            {
                [self.delegate didFinishDropAtDoor];
            }
        }
        
        else {
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


-(void) textFieldDidChange:(NSNotification *)notif
{
    if (tfPin.text.length == 4)
    {
        [tfPin resignFirstResponder];
    }
    else
    {
        [appDel spacingForTextField:tfPin TitleString:tfPin.text WithSpace:20*MULTIPLYHEIGHT];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if ((textField.text.length == 4) && (string.length > 0))
//    {
//        return NO;
//    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"fegd");
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"fegd");
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:strTextView])
    {
        textView.text = @"";
        textView.textColor = TEXT_COLOR;
        textView.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        textView.text = strTextView;
        textView.textColor = RGBCOLORCODE(200, 200, 200, 1.0);
        textView.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-6];
    }
}

-(void) closeScreen:(id)sender
{
    
    [UIView transitionWithView:self.view.superview duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
    }];

}


-(void) tapOnView:(UITapGestureRecognizer *) tap
{
    [self.view endEditing:YES];
    [scrollDrop setContentOffset:CGPointZero animated:YES];
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
