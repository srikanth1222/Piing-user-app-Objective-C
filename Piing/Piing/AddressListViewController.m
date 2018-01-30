//
//  AddressListViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "AddressListViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AddAddressViewController.h"
#import "PaymentListViewController.h"
#import "AddressFeild.h"



@interface AddressListViewController () <UITableViewDataSource, UITableViewDelegate>
{
    MPMoviePlayerController *backGroundplayer;
    
    UITableView *listOfAddressTableView;
    NSMutableArray *addressArray;
    UIButton *nextBtn;
    BOOL isFirstTime;
    
    AddressFeild *addressFeild;
    AppDelegate *appdel;
    
    BOOL isFromReg;
    
    NSIndexPath *selectedIndexPath;
    
}

@property (nonatomic, readwrite) BOOL isFromProfile;

@end

@implementation AddressListViewController
@synthesize isFromProfile;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andWithType:(BOOL) isFromPro
{
    self = [super init];
    if (self) {
        
        self.isFromProfile = isFromPro;
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
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    appdel = [PiingHandler sharedHandler].appDel;
    
    addressFeild = [[AddressFeild alloc] init];
    addressArray = [[NSMutableArray alloc]init];
    
    if (!isFromProfile)
    {
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
    }
    
    
    UIView *blackTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //blackTransparentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [appdel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
    [self.view addSubview:blackTransparentView];
    
    CGFloat yAxis = 20*MULTIPLYHEIGHT;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5.0, yAxis, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"LeftARROW.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(backBtn.frame), screen_width, 40)];
    NSString *string = @"ADDRESS";
    [appdel spacingForTitle:titleLbl TitleString:string];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.HEADER_LABEL_FONT_SIZE-3];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLbl];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(screen_width - 50, yAxis, 40.0, 40);
    [nextBtn setImage:[UIImage imageNamed:@"next_arrow_white"] forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    nextBtn.userInteractionEnabled = NO;
    nextBtn.alpha = 0.6;
    
    
    if (isFromProfile)
    {
        nextBtn.hidden = YES;
    }
    else
    {
        backBtn.hidden = YES;
        isFromReg = YES;
        
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, 0, 5.0)];
        statusBarView.backgroundColor = BLUE_COLOR;
        [self.view addSubview:statusBarView];
        
        [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
            
            statusBarView.frame = CGRectMake(-1, -1, (screen_width/3 ) * 2, 5.0);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    yAxis += 40+10*MULTIPLYHEIGHT;
    
    
    CGFloat tblX = 10*MULTIPLYHEIGHT;
    
    listOfAddressTableView = [[UITableView alloc] initWithFrame:CGRectMake(tblX, yAxis, screen_width-(tblX*2), screen_height-yAxis)];
    listOfAddressTableView.delegate = self;
    listOfAddressTableView.dataSource = self;
    listOfAddressTableView.separatorColor = [UIColor clearColor];
    listOfAddressTableView.backgroundColor = [UIColor clearColor];
    listOfAddressTableView.backgroundView = nil;
    listOfAddressTableView.separatorColor = [UIColor clearColor];
    listOfAddressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listOfAddressTableView.contentInset = UIEdgeInsetsMake(0, 0, 60*MULTIPLYHEIGHT, 0);
    [self.view addSubview:listOfAddressTableView];
    
}


-(void) closeBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appdel setBottomTabBarColor:TABBAR_COLOR_WHITE BlurEffectStyle:BLUR_EFFECT_STYLE_DARK HideBlurEffect:NO];
    
    [self getAddressFromServer];
    
    if (backGroundplayer)
    {
        [backGroundplayer play];
    }
}

-(void) getAddressFromServer
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/get", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
        
        [listOfAddressTableView setContentOffset:CGPointZero];
        
        if ([[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [addressArray removeAllObjects];
            
            [addressArray addObjectsFromArray:[responseObj objectForKey:@"addresses"]];
            
            [PiingHandler sharedHandler].userAddress = addressArray;
            
            if ([addressArray count])
            {
                nextBtn.userInteractionEnabled = YES;
                nextBtn.alpha = 1.0;
            }
            
            [listOfAddressTableView reloadData];
        }
        else if ([[responseObj objectForKey:@"s"] intValue] == 2)
        {
            [self addAddressBtnClicked];
            isFirstTime = YES;
        }
        else
        {
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (backGroundplayer)
    {
        [backGroundplayer stop];
    }
    
}


#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [addressArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"%ldCell",(long)indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView = nil;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        
        CGFloat dotX = 2*MULTIPLYHEIGHT;
        CGFloat dotY = 10*MULTIPLYHEIGHT;
        
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(dotX, dotY, 3.0, 3.0)];
        dotView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        dotView.tag = 23;
        dotView.layer.borderWidth = 1.0;
        dotView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
        dotView.clipsToBounds = YES;
        [cell addSubview:dotView];
        
        
        CGFloat bgX = 10*MULTIPLYHEIGHT;
        CGFloat bgHeight = 70*MULTIPLYHEIGHT;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, 5.0, tableView.frame.size.width-(bgX*2), bgHeight)];
        bgView.tag = 24;
        bgView.layer.borderColor = BLUE_COLOR.CGColor;
        bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        [cell addSubview:bgView];
        
        CGFloat lblX = 10*MULTIPLYHEIGHT;
        CGFloat lblY = 5*MULTIPLYHEIGHT;
        
        CGFloat addrHeight = 13*MULTIPLYHEIGHT;
        
        UILabel *addressnameLbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, bgView.frame.size.width-(lblX*2), addrHeight)];
        addressnameLbl.tag = 10;
        addressnameLbl.backgroundColor = [UIColor clearColor];
        addressnameLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-1];
        addressnameLbl.textColor = [UIColor whiteColor];
        [bgView addSubview:addressnameLbl];
        
        
        UIImageView *defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addressnameLbl.frame), CGRectGetMinY(addressnameLbl.frame), 19, 19)];
        defaultImage.tag = 11;
        defaultImage.image = [UIImage imageNamed:@"uncheck"];
        [bgView addSubview:defaultImage];
        
        
        UILabel *addressInfoLbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, 13*MULTIPLYHEIGHT+5*MULTIPLYHEIGHT, bgView.frame.size.width-(lblX*2), 50*MULTIPLYHEIGHT)];
        addressInfoLbl.tag = 12;
        addressInfoLbl.backgroundColor = [UIColor clearColor];
        addressInfoLbl.numberOfLines = 4;
        addressInfoLbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appdel.FONT_SIZE_CUSTOM-1];
        addressInfoLbl.textColor = [UIColor whiteColor];
        [bgView addSubview:addressInfoLbl];
        
        
        UIButton *btnEditAddress = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnEditAddress setImage:[UIImage imageNamed:@"edit_icon"] forState:UIControlStateNormal];
        btnEditAddress.tag = 13;
        [bgView addSubview:btnEditAddress];
    }
    
    UILabel *addressnameLbl = (UILabel *)[cell viewWithTag:10];
    UILabel *addressInfoLbl = (UILabel *)[cell viewWithTag:12];
    UIView *dotView = (UIView *)[cell viewWithTag:23];
    UIView *bgView = (UIView *)[cell viewWithTag:24];
    
    UIButton *btnEditAddress = (UIButton *)[cell viewWithTag:13];
    
    NSDictionary *dict = [addressArray objectAtIndex:indexPath.row];
    
    addressnameLbl.text = [[dict objectForKey:@"name"] uppercaseString];
    
    NSMutableString *strAddr = [[NSMutableString alloc]initWithString:@""];
    
    if ([[dict objectForKey:@"line1"] length] > 1)
    {
        [strAddr appendString:[NSString stringWithFormat:@"%@, ", [dict objectForKey:@"line1"]]];
    }
    
    NSString *strFno;
    
    if ([[dict objectForKey:@"floorNo"] isKindOfClass:[NSString class]])
    {
        strFno = [dict objectForKey:@"floorNo"];
    }
    else
    {
        strFno = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"floorNo"] intValue]];
    }
    
    if ([strFno length])
    {
        if ([strFno length] == 1)
        {
            [strAddr appendString:[NSString stringWithFormat:@"#0%@", strFno]];
        }
        else
        {
            [strAddr appendString:[NSString stringWithFormat:@"#%@", [dict objectForKey:@"floorNo"]]];
        }
    }
    
    NSString *strUno;
    
    if ([[dict objectForKey:@"unitNo"] isKindOfClass:[NSString class]])
    {
        strUno = [dict objectForKey:@"unitNo"];
    }
    else
    {
        strUno = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"unitNo"] intValue]];
    }
    
    if ([strUno length])
    {
        [strAddr appendString:[NSString stringWithFormat:@"-%@, ", strUno]];
    }
    
    if ([[dict objectForKey:@"line2"] length])
    {
        [strAddr appendString:[NSString stringWithFormat:@"%@, ", [dict objectForKey:@"line2"]]];
    }
    if ([[dict objectForKey:@"zipcode"] length])
    {
        [strAddr appendString:[NSString stringWithFormat:@"%@", [dict objectForKey:@"zipcode"]]];
    }
    
    addressInfoLbl.text = strAddr;
    
    if ([[dict objectForKey:@"default"] intValue] == 1)
    {
        dotView.backgroundColor = BLUE_COLOR;
        bgView.layer.borderWidth = 1.0;
    }
    else
    {
        dotView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        bgView.layer.borderWidth = 0;
    }
    
    btnEditAddress.frame = CGRectMake(bgView.frame.size.width-35, bgView.frame.origin.y, 30, 30);
    [btnEditAddress addTarget:self action:@selector(btnEditAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *dotView = (UIView *)[cell viewWithTag:23];
    
    if ([dotView.backgroundColor isEqual:BLUE_COLOR])
    {
        
    }
    else
    {
        //defaultImage.image = [UIImage imageNamed:@"check"];
        
//        for (NSMutableDictionary *dict in addressArray)
//        {
//            [dict setObject:[NSNumber numberWithInt:0] forKey:@"default"];
//        }
        
//        [addressArray setValue:@"12" forKey:@"line2"];
//        
//        [[addressArray objectAtIndex:indexPath.row] setValue:[NSNumber numberWithInt:1] forKey:@"default"];
        
        NSDictionary *dict = [addressArray objectAtIndex:indexPath.row];
        
        selectedIndexPath = indexPath;
        
        [self setDefaultAddress:dict];
        
        //[tableView reloadData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat bgHeight = 85*MULTIPLYHEIGHT;
    return bgHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10.0)];
    footerView.backgroundColor = [UIColor clearColor];
    
    UIButton *addAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addAddressBtn.backgroundColor = [UIColor clearColor];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [addAddressBtn setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
    [addAddressBtn setTitle:@" + ADD ADDRESS" forState:UIControlStateNormal];
    addAddressBtn.frame = CGRectMake(0, 0, CGRectGetWidth(listOfAddressTableView.frame), 30);
    addAddressBtn.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appdel.FONT_SIZE_CUSTOM-1];
    
    [footerView addSubview:addAddressBtn];
    
    return footerView;
}

#pragma mark UIControl Methods

-(void) btnEditAddressClicked:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:listOfAddressTableView];
    NSIndexPath *indexPath = [listOfAddressTableView indexPathForRowAtPoint:buttonPosition];
    
    NSDictionary *dict = [addressArray objectAtIndex:indexPath.row];
    
    addressFeild.zipCode = [dict objectForKey:@"zipcode"];
    addressFeild.addressName = [dict objectForKey:@"name"];
    addressFeild.addressID = [dict objectForKey:@"_id"];
    addressFeild.addressLine1 = [dict objectForKey:@"line1"];
    addressFeild.addressLine2 = [dict objectForKey:@"line2"];
    
    if ([[dict objectForKey:@"floorNo"] isKindOfClass:[NSNumber class]])
    {
        addressFeild.fno = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"floorNo"]intValue]];
    }
    else
    {
        addressFeild.fno = [dict objectForKey:@"floorNo"];
    }
    
    if ([[dict objectForKey:@"unitNo"] isKindOfClass:[NSNumber class]])
    {
        addressFeild.uno = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"unitNo"]intValue]];
    }
    else
    {
        addressFeild.uno = [dict objectForKey:@"unitNo"];
    }
    
    addressFeild.isAddressDefault = [dict objectForKey:@"default"];
    //addressFeild.zoneID = [dict objectForKey:@"zid"];
    addressFeild.notes = [dict objectForKey:@"landMark"];
    addressFeild.lat = [dict objectForKey:@"lat"];
    addressFeild.lng = [dict objectForKey:@"lon"];
    
    AddAddressViewController *addAddVC = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
    addAddVC.addressFeild = addressFeild;
    addAddVC.isEditingAddress = YES;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addAddVC];
    
    [self presentViewController:navVC animated:YES completion:nil];
}


-(void) setDefaultAddress:(NSDictionary *)dict
{
    addressFeild.zipCode = [dict objectForKey:@"zipcode"];
    addressFeild.addressName = [dict objectForKey:@"name"];
    addressFeild.addressID = [dict objectForKey:@"_id"];
    addressFeild.addressLine1 = [dict objectForKey:@"line1"];
    addressFeild.addressLine2 = [dict objectForKey:@"line2"];
    
    if ([[dict objectForKey:@"floorNo"] isKindOfClass:[NSNumber class]])
    {
        addressFeild.fno = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"floorNo"]intValue]];
    }
    else
    {
        addressFeild.fno = [dict objectForKey:@"floorNo"];
    }
    
    if ([[dict objectForKey:@"unitNo"] isKindOfClass:[NSNumber class]])
    {
        addressFeild.uno = [NSString stringWithFormat:@"%d", [[dict objectForKey:@"unitNo"]intValue]];
    }
    else
    {
        addressFeild.uno = [dict objectForKey:@"unitNo"];
    }
    
    addressFeild.lat = [dict objectForKey:@"lat"];
    addressFeild.lng = [dict objectForKey:@"lon"];
    
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid", addressFeild.addressName, @"name", addressFeild.addressLine1, @"line1", addressFeild.addressLine2, @"line2", addressFeild.city, @"city", addressFeild.state, @"state", addressFeild.country, @"country",addressFeild.notes, @"landMark", addressFeild.zipCode, @"zipcode", @"1", @"default",addressFeild.fno, @"floorNo", addressFeild.uno, @"unitNo", addressFeild.addressID, @"_id", addressFeild.lat, @"lat", addressFeild.lng, @"lon", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/save", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dict andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            [self getAddressFromServer];
            
            [listOfAddressTableView moveRowAtIndexPath:selectedIndexPath toIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        else {
            
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(void) addAddressBtnClicked
{
    AddAddressViewController *addAddVC = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
    addAddVC.isFromReg = isFromReg;
    
    [self presentViewController:addAddVC animated:YES completion:nil];
}

-(void) nextBtnClicked:(UIBarButtonItem *) sender
{    
    PaymentListViewController *paymentVC = [[PaymentListViewController alloc] init];
    [self.navigationController pushViewController:paymentVC animated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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
