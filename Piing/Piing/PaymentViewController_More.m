//
//  PaymentListViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 09/01/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "PaymentViewController_More.h"
#import <CardIO.h>
#import "BraintreeCore.h"
#import "BraintreeCard.h"

#import "WelcomeScreenViewController.h"
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "UIView+Toast.h"



@interface PaymentViewController_More () <UITableViewDataSource, UITableViewDelegate, CardIOPaymentViewControllerDelegate, MFMailComposeViewControllerDelegate>
{
    MPMoviePlayerController *backGroundplayer;
    
    AppDelegate *appDel;
    
    UIButton *nextBtn;
    
    UITableView *tblCards;
    NSMutableArray *arrayCards;
    
    NSString *brainTreeClientToken;
    
    UIButton *btnCashOnDelivery;
    
    NSInteger selectedIndex;
    
    NSString *paymentMode;
    
    UIView *view_Payment;
    
    BOOL selectedAnotherPayment;
    
    UIImageView *starCOD;
}

@property (nonatomic, strong) BTAPIClient *braintree;

@end

@implementation PaymentViewController_More

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
    
    float yAxis = 29*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 40)];
    NSString *string = @"PAYMENT";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    UIImageView *bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, view_Payment.frame.size.height-90, screen_width, 70)];
    bottomImage.contentMode = UIViewContentModeScaleAspectFit;
    bottomImage.image = [UIImage imageNamed:@"bottomcard_icon"];
    [view_Payment addSubview:bottomImage];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    paymentMode = @"Cash";
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, yAxis, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    yAxis = 22*MULTIPLYHEIGHT;
    
    float btnCX = 30*MULTIPLYHEIGHT;
    float btnCHeight = 35*MULTIPLYHEIGHT;
    
    btnCashOnDelivery = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCashOnDelivery.frame = CGRectMake(btnCX, yAxis, screen_width-(btnCX*2), btnCHeight);
    [view_Payment addSubview:btnCashOnDelivery];
    [btnCashOnDelivery addTarget:self action:@selector(setCashonDeliveryAsDefault:) forControlEvents:UIControlEventTouchUpInside];
    btnCashOnDelivery.userInteractionEnabled = YES;
    
    
    float imgCX = 8*MULTIPLYHEIGHT;
    float imgCWidth = 22*MULTIPLYHEIGHT;
    
    UIImageView *imgLeft = [[UIImageView alloc]initWithFrame:CGRectMake(imgCX, 0, imgCWidth, btnCHeight)];
    imgLeft.contentMode = UIViewContentModeScaleAspectFit;
    imgLeft.image = [UIImage imageNamed:@"cash_icon"];
    [btnCashOnDelivery addSubview:imgLeft];
    
    float starX = btnCashOnDelivery.frame.size.width-(imgCWidth+7*MULTIPLYHEIGHT);
    float starWidth = 13*MULTIPLYHEIGHT;
    
    starCOD = [[UIImageView alloc]initWithFrame:CGRectMake(starX, 0, starWidth, btnCHeight)];
    starCOD.contentMode = UIViewContentModeScaleAspectFit;
    starCOD.highlightedImage = [UIImage imageNamed:@"selected_address"];
    starCOD.image = [UIImage imageNamed:@"unselected_address"];
    [btnCashOnDelivery addSubview:starCOD];
    
    
    UILabel *lblCashOnDelivery = [[UILabel alloc]initWithFrame:btnCashOnDelivery.bounds];
    
    NSMutableAttributedString *strAttrCash = [appDel getAttributedStringWithString:@"CASH ON DELIVERY" WithSpacing:1.0];
    [strAttrCash addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(0, strAttrCash.length)];
    
    lblCashOnDelivery.attributedText = strAttrCash;
    
    lblCashOnDelivery.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    lblCashOnDelivery.textAlignment = NSTextAlignmentCenter;
    [btnCashOnDelivery addSubview:lblCashOnDelivery];
    
    yAxis += btnCHeight+15*MULTIPLYHEIGHT;
    
    btnCashOnDelivery.backgroundColor = RGBCOLORCODE(228, 229, 230, 1.0);
    lblCashOnDelivery.textColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    
    
    UIImageView *imgLine = [[UIImageView alloc]init];
    imgLine.frame = CGRectMake(btnCX*1.7, yAxis, screen_width-(btnCX*1.7*2), 1);
    imgLine.backgroundColor = btnCashOnDelivery.backgroundColor;
    [view_Payment addSubview:imgLine];
    
    
    yAxis += 10*MULTIPLYHEIGHT;
    
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
    
    [appDel hideTabBar:appDel.customTabBarController];
    
    [appDel setBottomTabBarColor:TABBAR_COLOR_WHITE BlurEffectStyle:BLUR_EFFECT_STYLE_DARK HideBlurEffect:NO];
}

-(void) setCashonDeliveryAsDefault:(id)sender
{
    
    if ([starCOD isHighlighted])
    {
        return;
    }
    
    selectedAnotherPayment = YES;
    
    paymentMode = @"Cash";
        
    [self setDefaultPaymentMode];
    
    starCOD.highlighted = YES;
    
    [tblCards reloadData];
}

-(void) fetchCards
{
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid", nil];
    
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
                
                starCOD.highlighted = YES;
                
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
        
        float bgX = 30*MULTIPLYHEIGHT;
        float bgHeight = 35*MULTIPLYHEIGHT;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, 5.0, tableView.frame.size.width-(bgX*2), bgHeight)];
        bgView.tag = 24;
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [cell.contentView addSubview:bgView];
        
        float imgCX = 8*MULTIPLYHEIGHT;
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
        
        float starX = bgView.frame.size.width-(imgCWidth+7*MULTIPLYHEIGHT);
        float starWidth = 13*MULTIPLYHEIGHT;
        
        UIImageView *starCard = [[UIImageView alloc]initWithFrame:CGRectMake(starX, 0, starWidth, bgHeight)];
        starCard.tag = 26;
        starCard.contentMode = UIViewContentModeScaleAspectFit;
        starCard.highlightedImage = [UIImage imageNamed:@"selected_address"];
        starCard.image = [UIImage imageNamed:@"unselected_address"];
        [bgView addSubview:starCard];
    }
    
    UILabel *cardLbl = (UILabel *)[cell viewWithTag:25];
    UIView *bgView = (UIView *)[cell viewWithTag:24];
    UIImageView *starCard = (UIImageView *) [cell viewWithTag:26];
    
    UIImageView *imgCard = (UIImageView *)[cell viewWithTag:27];
        
    [imgCard sd_setImageWithURL:[NSURL URLWithString:[[arrayCards objectAtIndex:indexPath.row] objectForKey:@"cardTypeImage"]] placeholderImage:[UIImage imageNamed:@"card_icon"]];
    
    imgCard.contentMode = UIViewContentModeScaleAspectFit;
    
    cardLbl.text = [[arrayCards objectAtIndex:indexPath.row] objectForKey:@"maskedCardNo"];
    
    cardLbl.textColor = [UIColor grayColor];
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    
    if ([[[arrayCards objectAtIndex:indexPath.row] objectForKey:@"default"] boolValue])
    {
        starCOD.highlighted = NO;
        
        starCard.highlighted = YES;
    }
    else
    {
        starCard.highlighted = NO;
    }
    
    return cell;
}

#pragma mark TableView Delegate
-(void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
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
    
    UIImageView *starCard = (UIImageView *) [cell viewWithTag:26];
    
    if ([starCard isHighlighted])
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
    float cellHeight = 42*MULTIPLYHEIGHT;
    return cellHeight;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    float height = 57.6*MULTIPLYHEIGHT;
    
    return height;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    float height = 57.6*MULTIPLYHEIGHT;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *addNewCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addNewCardBtn.backgroundColor = [UIColor clearColor];
    [addNewCardBtn addTarget:self action:@selector(addNewCardBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addNewCardBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    if ([arrayCards count])
    {
        [addNewCardBtn setTitle:@" + ADD ANOTHER CARD" forState:UIControlStateNormal];
    }
    else
    {
        [addNewCardBtn setTitle:@" + ADD CARD" forState:UIControlStateNormal];
    }
    
    addNewCardBtn.frame = footerView.frame;
    addNewCardBtn.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    
    [footerView addSubview:addNewCardBtn];
    
    return footerView;
}


#pragma mark UIAction Methods

-(void) setDefaultPaymentMode
{
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", paymentMode, @"_id", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
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
    
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", nil];
    
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
                                  
                                  NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nonce.nonce, @"paymentMethodNonce", nil];
                                  
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
