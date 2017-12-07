//
//  PaymentListViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 09/01/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "PaymentListViewController.h"
#import <CardIO.h>
#import "BraintreeCore.h"
#import "BraintreeCard.h"
#import "WelcomeScreenViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "UIView+Toast.h"



@interface PaymentListViewController () <UITableViewDataSource, UITableViewDelegate, CardIOPaymentViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    MPMoviePlayerController *backGroundplayer;
    
    AppDelegate *appDel;
    
    UIButton *nextBtn;
    
    UITableView *tblCards;
    NSMutableArray *arrayCards;
    
    NSString *brainTreeClientToken;
    
    UIButton *btnCashOnDelivery;
    UIView *dotViewCashOnDelivery;
    
    NSInteger selectedIndex;
    
    NSString *paymentMode;
    UISegmentedControl *segmentPayment;
    
    UIView *view_Payment;
    
    BOOL selectedAnotherPayment;
}

@property (nonatomic, strong) BTAPIClient *braintree;

@end

@implementation PaymentListViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    arrayCards = [[NSMutableArray alloc]init];
    
    float viewPY = 57*MULTIPLYHEIGHT;
    
    view_Payment = [[UIView alloc]initWithFrame:CGRectMake(0, viewPY, screen_width, screen_height-viewPY)];
    view_Payment.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_Payment];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    paymentMode = @"Cash";
    
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
    //blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [appDel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
    [self.view addSubview:blackTransparentView];
    
    
    float yAxis = 29*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 40)];
    NSString *string = @"PAYMENT";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    lblTitle.textColor = [UIColor whiteColor];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(screen_width - 50, yAxis, 40.0, 40);
    [nextBtn setImage:[UIImage imageNamed:@"next_arrow_white"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, 0, 5.0)];
    statusBarView.backgroundColor = BLUE_COLOR;
    [self.view addSubview:statusBarView];
    
    [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        
        statusBarView.frame = CGRectMake(-1, -1, screen_width, 5.0);
        
    } completion:^(BOOL finished) {
        
    }];
    
    [self.view bringSubviewToFront:view_Payment];
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, yAxis, 40.0, 40.0);
    
    [backBtn setImage:[UIImage imageNamed:@"LeftARROW.png"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    yAxis = 22*MULTIPLYHEIGHT;
    
    float btnCX = 22*MULTIPLYHEIGHT;
    float btnCHeight = 30*MULTIPLYHEIGHT;
    
    btnCashOnDelivery = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCashOnDelivery.frame = CGRectMake(btnCX, yAxis, screen_width-(btnCX*2), btnCHeight);
    btnCashOnDelivery.layer.borderColor = BLUE_COLOR.CGColor;
    btnCashOnDelivery.layer.borderWidth = 0.0;
    [view_Payment addSubview:btnCashOnDelivery];
    [btnCashOnDelivery addTarget:self action:@selector(setCashonDeliveryAsDefault:) forControlEvents:UIControlEventTouchUpInside];
    btnCashOnDelivery.userInteractionEnabled = YES;
    
    
    float imgCX = 7*MULTIPLYHEIGHT;
    float imgCWidth = 22*MULTIPLYHEIGHT;
    
    UIImageView *imgLeft = [[UIImageView alloc]initWithFrame:CGRectMake(imgCX, 0, imgCWidth, btnCHeight)];
    imgLeft.contentMode = UIViewContentModeScaleAspectFit;
    imgLeft.image = [UIImage imageNamed:@"cash_icon"];
    [btnCashOnDelivery addSubview:imgLeft];
    
    UILabel *lblCashOnDelivery = [[UILabel alloc]initWithFrame:btnCashOnDelivery.bounds];
    lblCashOnDelivery.text  = @"CASH ON DELIVERY";
    lblCashOnDelivery.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
    lblCashOnDelivery.textAlignment = NSTextAlignmentCenter;
    [btnCashOnDelivery addSubview:lblCashOnDelivery];
    
    
    dotViewCashOnDelivery = [[UIView alloc] initWithFrame:CGRectMake(btnCashOnDelivery.frame.origin.x-imgCX, (yAxis+btnCashOnDelivery.frame.size.height)-(btnCashOnDelivery.frame.size.height/2), 3.0, 3.0)];
    dotViewCashOnDelivery.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [view_Payment addSubview:dotViewCashOnDelivery];
    
    yAxis += btnCHeight+15*MULTIPLYHEIGHT;
    
    
    UIImageView *imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(btnCHeight, yAxis, view_Payment.frame.size.width-(btnCHeight*2), 1.5f)];
    [view_Payment addSubview:imgLine];
    
    btnCashOnDelivery.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    lblCashOnDelivery.textColor = [UIColor whiteColor];
    imgLine.backgroundColor = [UIColor whiteColor];
    
    yAxis += 13*MULTIPLYHEIGHT;
    
    tblCards = [[UITableView alloc] initWithFrame:CGRectMake(0, yAxis, screen_width, view_Payment.frame.size.height-yAxis)];
    tblCards.delegate = self;
    tblCards.dataSource = self;
    tblCards.separatorColor = [UIColor clearColor];
    tblCards.backgroundColor = [UIColor clearColor];
    tblCards.backgroundView = nil;
    tblCards.separatorColor = [UIColor clearColor];
    tblCards.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblCards.contentInset = UIEdgeInsetsMake(0, 0, 70*MULTIPLYHEIGHT, 0);
    [view_Payment addSubview:tblCards];
    
    [self fetchCards];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appDel setBottomTabBarColor:TABBAR_COLOR_WHITE BlurEffectStyle:BLUR_EFFECT_STYLE_DARK HideBlurEffect:NO];
}

-(void) setCashonDeliveryAsDefault:(id)sender
{
    
    if ([dotViewCashOnDelivery.backgroundColor isEqual:BLUE_COLOR])
    {
        return;
    }
    
    selectedAnotherPayment = YES;
    
    paymentMode = @"Cash";
    
    [self setDefaultPaymentMode];
    
    btnCashOnDelivery.layer.borderWidth = 1.0f;
    
    //dotViewCashOnDelivery.layer.borderWidth = 1.0;
    dotViewCashOnDelivery.backgroundColor = BLUE_COLOR;
    
    [tblCards reloadData];
}

-(void) fetchCards
{
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@payment/getallpaymentmethods", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            [arrayCards removeAllObjects];
            
            NSDictionary *dict = [responseObj objectForKey:@"paymentMethod"];
            
            NSMutableArray *arrayLocalCards = [[NSMutableArray alloc]init];
            
            NSDictionary *dictCash;
            
            if ([[[dict objectForKey:@"cash"] objectForKey:@"default"]intValue] == 1)
            {
                paymentMode = @"Cash";
                
                if (selectedAnotherPayment)
                {
                    selectedAnotherPayment = NO;
                    
                    [appDel.window makeToast:@"COD selected as default payment mode" duration:1.5f position:CSToastPositionCenter];
                }
                
                btnCashOnDelivery.layer.borderWidth = 1.0f;
                dotViewCashOnDelivery.backgroundColor = BLUE_COLOR;
                
                dictCash = [NSDictionary dictionaryWithObjectsAndKeys:@"CASH ON DELIVERY", @"maskedCardNo", @"Cash", @"_id", @"1", @"default", nil];
            }
            else
            {
                dictCash = [NSDictionary dictionaryWithObjectsAndKeys:@"CASH ON DELIVERY", @"maskedCardNo", @"Cash", @"_id", @"0", @"default", nil];
            }
            
            [arrayLocalCards addObject:dictCash];
            
            if ([[[dict objectForKey:@"card"] objectForKey:@"cardList"] count])
            {
                NSArray *arra = [[dict objectForKey:@"card"] objectForKey:@"cardList"];
                
                for (int i = 0; i < [arra count]; i++)
                {
                    NSDictionary *dictCardlist = [arra objectAtIndex:i];
                    
                    if ([[dictCardlist objectForKey:@"default"] intValue] == 1)
                    {
                        paymentMode = [dictCardlist objectForKey:@"_id"];
                        
                        if (selectedAnotherPayment)
                        {
                            selectedAnotherPayment = NO;
                            
                            NSString *strMsg = [NSString stringWithFormat:@"%@ selected as default payment mode", [dictCardlist objectForKey:@"maskedCardNo"]];
                            
                            [appDel.window makeToast:strMsg duration:1.5f position:CSToastPositionCenter];
                        }
                        
                        break;
                    }
                }
                
                [arrayCards addObjectsFromArray:[[dict objectForKey:@"card"] objectForKey:@"cardList"]];
                
                [arrayLocalCards addObjectsFromArray:arrayCards];
            }
            
            [PiingHandler sharedHandler].userSavedCards = arrayLocalCards;
            
            [tblCards reloadData];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}



#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayCards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"%ldPaymentCell",(long)indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        float bgX = 22*MULTIPLYHEIGHT;
        float bgHeight = 30*MULTIPLYHEIGHT;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, 5.0, tableView.frame.size.width-(bgX*2), bgHeight)];
        bgView.tag = 24;
        bgView.layer.borderColor = BLUE_COLOR.CGColor;
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [cell.contentView addSubview:bgView];
        
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(bgView.frame.origin.x-7*MULTIPLYHEIGHT, 5+bgHeight/2-(3/2), 3.0, 3.0)];
        dotView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        dotView.tag = 23;
        [cell.contentView addSubview:dotView];
        
        float imgCX = 7*MULTIPLYHEIGHT;
        float imgCWidth = 22*MULTIPLYHEIGHT;
        
        UIImageView *imgCard = [[UIImageView alloc]initWithFrame:CGRectMake(imgCX, 0, imgCWidth, bgHeight)];
        imgCard.tag = 27;
        [bgView addSubview:imgCard];
        
        UILabel *cardnameLbl = [[UILabel alloc] initWithFrame:bgView.bounds];
        cardnameLbl.tag = 25;
        cardnameLbl.textAlignment = NSTextAlignmentCenter;
        cardnameLbl.backgroundColor = [UIColor clearColor];
        cardnameLbl.font = [UIFont fontWithName:APPFONT_SemiBold_Italic size:appDel.FONT_SIZE_CUSTOM-1];
        cardnameLbl.textColor = [UIColor whiteColor];
        [bgView addSubview:cardnameLbl];
        
        //        EGOImageView *defaultImage = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        //        defaultImage.tag = 26;
        //        defaultImage.image = [UIImage imageNamed:@"uncheck"];
        //        [bgView addSubview:defaultImage];
    }
    
    UILabel *cardLbl = (UILabel *)[cell viewWithTag:25];
    UIView *dotView = (UIView *)[cell viewWithTag:23];
    UIView *bgView = (UIView *)[cell viewWithTag:24];
    
    UIImageView *imgCard = (UIImageView *)[cell viewWithTag:27];
    
    [imgCard sd_setImageWithURL:[NSURL URLWithString:[[arrayCards objectAtIndex:indexPath.row] objectForKey:@"cardTypeImage"]]
               placeholderImage:[UIImage imageNamed:@"card_icon"]];
    
    imgCard.contentMode = UIViewContentModeScaleAspectFit;
    
    cardLbl.text = [[arrayCards objectAtIndex:indexPath.row] objectForKey:@"maskedCardNo"];
    
    cardLbl.textColor = [UIColor whiteColor];
    bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    dotView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    bgView.layer.borderWidth = 0;
    
    if ([[[arrayCards objectAtIndex:indexPath.row] objectForKey:@"default"] boolValue])
    {
        dotView.backgroundColor = BLUE_COLOR;
        bgView.layer.borderWidth = 1.0;
        
        btnCashOnDelivery.layer.borderWidth = 0.0f;
        
        dotViewCashOnDelivery.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    else
    {
        bgView.layer.borderWidth = 0;
        
        dotView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    
    return cell;
}

#pragma mark TableView Delegate
-(void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //Using animation so the frame change transform will be smooth.
    
    [UIView animateWithDuration:0.1f animations:^{
        
        cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }];
    
}
-(void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    [UIView animateWithDuration:0.1f animations:^{
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    }];
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *dotView = (UIView *)[cell viewWithTag:23];
    
    if ([dotView.backgroundColor isEqual:BLUE_COLOR])
    {
        
    }
    else
    {
        selectedAnotherPayment = YES;
        
        selectedIndex = indexPath.row;
        
        NSDictionary *dict = [arrayCards objectAtIndex:indexPath.row];
        
        paymentMode = [dict objectForKey:@"_id"];
        
        [self setDefaultPaymentMode];
        
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 36*MULTIPLYHEIGHT;
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == tblCards)
    {
        float height = 57.6*MULTIPLYHEIGHT;
        
        return height;
    }
    else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == tblCards)
    {
        float height = 57.6*MULTIPLYHEIGHT;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
        footerView.backgroundColor = [UIColor clearColor];
        
        UIButton *addNewCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addNewCardBtn.backgroundColor = [UIColor clearColor];
        [addNewCardBtn addTarget:self action:@selector(addNewCardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [addNewCardBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        
        if ([arrayCards count])
        {
            [addNewCardBtn setTitle:@" + ADD ANOTHER CARD" forState:UIControlStateNormal];
        }
        else
        {
            [addNewCardBtn setTitle:@" + ADD CARD" forState:UIControlStateNormal];
        }
        
        addNewCardBtn.frame = footerView.frame;
        addNewCardBtn.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
        
        [footerView addSubview:addNewCardBtn];
        
        return footerView;
    }
    else
    {
        return nil;
    }
    
}


#pragma mark UIAction Methods


-(void) setDefaultPaymentMode
{
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", paymentMode, @"_id", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@payment/setdefaultpaymentmethod", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            [self fetchCards];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];

}

-(void) addNewCardBtnClicked
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@payment/gettoken", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            brainTreeClientToken = [responseObj objectForKey:@"token"];
            
            self.braintree = [[BTAPIClient alloc]initWithAuthorization:brainTreeClientToken];
            
            BTCardClient *cardClient = [[BTCardClient alloc] initWithAPIClient:self.braintree];
            
            BTCard *card = [[BTCard alloc] initWithNumber:info.cardNumber
                                          expirationMonth:[NSString stringWithFormat:@"%lu",(unsigned long)info.expiryMonth]
                                           expirationYear:[NSString stringWithFormat:@"%lu",(unsigned long)info.expiryYear]
                                                      cvv:info.cvv];
            
            [cardClient tokenizeCard:card
                          completion:^(BTCardNonce *nonce, NSError *error) {
                              // Communicate the nonce to your server, or handle error
                              
                              if (!error)
                              {
                                  DLog(@"Nounce %@",nonce.nonce);
                                  
                                  NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nonce.nonce, @"paymentMethodNonce", nil];
                                  
                                  NSString *urlStr = [NSString stringWithFormat:@"%@payment/save", BASE_URL];
                                  
                                  [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                                      
                                      if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                                      {
                                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                              
                                              [self dismissViewControllerAnimated:YES completion:nil];
                                              
                                          }];
                                          
                                          [self fetchCards];
                                      }
                                      else {
                                          
                                          [appDel displayErrorMessagErrorResponse:responseObj];
                                      }
                                  }];
                              }
                              else
                              {
                                  
                                  [appDel showAlertWithMessage:[error localizedDescription] andTitle:@"" andBtnTitle:@"OK"];
                                  
                                  [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                              }
                              
                          }];
            
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void) closeBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIAction Methods
-(void) nextBtnClicked
{
    [UIView transitionWithView:self.navigationController.view
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                        WelcomeScreenViewController *welcomeVC = [[WelcomeScreenViewController alloc] initWithNibName:@"WelcomeScreenViewController" bundle:nil];
                        [self.navigationController pushViewController:welcomeVC animated:NO];
                        
                    }
     
                    completion:nil];
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
