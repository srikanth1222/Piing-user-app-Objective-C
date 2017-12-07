//
//  FAQViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 08/05/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController () <UIWebViewDelegate>
{
    AppDelegate *appDel;
}

@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    webview.delegate = self;
    
    NSString *strurl;
    
    if (self.code == 1)
    {
        strurl = [NSString stringWithFormat:@"http://piing.com.sg/faq"];
    }
    else if (self.code == 2)
    {
        strurl = [NSString stringWithFormat:@"http://piing.com.sg/about"];
    }
    else if (self.code == 3)
    {
        strurl = [NSString stringWithFormat:@"http://piing.com.sg/app.html#/terms-of-service"];
    }
    
    NSURL *url = [NSURL URLWithString:strurl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    [self.view addSubview:webview];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(screen_width-50, yAxis, 40.0, 40.0);
    [closeBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:closeBtn];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDel hideTabBar:appDel.customTabBarController];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    [appDel showAlertWithMessage:[error localizedDescription] andTitle:@"" andBtnTitle:@"OK"];
}

-(void) backToPreviousScreen
{
    [UIView transitionWithView:self.view.superview duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
        [appDel showTabBar:appDel.customTabBarController];
        
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
