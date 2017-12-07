//
//  AddressListViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "AddressListViewController_Map.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AddAddressViewController.h"
#import "PaymentListViewController.h"
#import "AddressFeild.h"
#import "GoogleMapView2.h"
#import "UIView+Toast.h"



@interface AddressListViewController_Map () <UIScrollViewDelegate, AddAddressViewControllerDelegate>
{
    
    NSMutableArray *addressArray;
    
    AddressFeild *addressFeild;
    AppDelegate *appdel;
    
    GoogleMapView2 *addressMapView;
    
    UIScrollView *scrollViewAddresses;
    
    UIPageControl *pageControlForAddress;
    
    UIButton *btnAddAddress;
    
    NSInteger previousPage;
    
    UIButton *btnEditAddress, *btnSetDefault;
    
    BOOL addressSelectedAsDefault;
}

@property (nonatomic, readwrite) BOOL isFromProfile;

@end


@implementation AddressListViewController_Map

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    appdel = [PiingHandler sharedHandler].appDel;
    
    addressFeild = [[AddressFeild alloc] init];
    addressArray = [[NSMutableArray alloc]init];
    
    float backY = 20*MULTIPLYHEIGHT;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, backY, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    btnAddAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddAddress.backgroundColor = [UIColor clearColor];
    [btnAddAddress addTarget:self action:@selector(addAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btnAddAddress setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    btnAddAddress.frame = CGRectMake(screen_width-55*MULTIPLYHEIGHT, backY, 55*MULTIPLYHEIGHT, 40);
//    [btnAddAddress setTitle:@"ADD" forState:UIControlStateNormal];
//    btnAddAddress.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-1];
    
    btnAddAddress.frame = CGRectMake(screen_width-40*MULTIPLYHEIGHT, backY, 40*MULTIPLYHEIGHT, 40);
    [btnAddAddress setTitle:@"+" forState:UIControlStateNormal];
    btnAddAddress.titleLabel.font = [UIFont fontWithName:APPFONT_LIGHT size:appdel.HEADER_LABEL_FONT_SIZE*1.7];
    
    [self.view addSubview:btnAddAddress];
    
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, backY, screen_width, 40)];
    NSString *string = @"ADDRESSES";
    [appdel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    CGFloat mapY = 65*MULTIPLYHEIGHT;
    
    addressMapView = [[GoogleMapView2 alloc] initWithFrame:CGRectMake(0, mapY, screen_width, (screen_height/1.5)-mapY)];
    addressMapView.delegate = self;
    [self.view addSubview:addressMapView];
    
    pageControlForAddress = [[UIPageControl alloc]initWithFrame:CGRectMake(0, addressMapView.frame.origin.y+addressMapView.frame.size.height, screen_width, 37)];
    pageControlForAddress.autoresizingMask = UIViewAutoresizingNone;
    pageControlForAddress.backgroundColor = [UIColor clearColor];
    pageControlForAddress.pageIndicatorTintColor = [UIColor grayColor];
    pageControlForAddress.currentPageIndicatorTintColor = [UIColor colorWithRed:68/255.0 green:192/255.0 blue:233/255.0 alpha:1.0];
    [pageControlForAddress addTarget:self action:@selector(pagecontrolClicked:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControlForAddress];
    pageControlForAddress.transform = CGAffineTransformMakeScale(0.6, 0.6);
    
    
    scrollViewAddresses = [[UIScrollView alloc]initWithFrame:CGRectMake(0, pageControlForAddress.frame.origin.y+pageControlForAddress.frame.size.height, screen_width, screen_height-(pageControlForAddress.frame.origin.y+pageControlForAddress.frame.size.height)-50*MULTIPLYHEIGHT)];
    scrollViewAddresses.delegate = self;
    scrollViewAddresses.pagingEnabled = YES;
    [self.view addSubview:scrollViewAddresses];
    scrollViewAddresses.showsHorizontalScrollIndicator = NO;
    
    
    float btnY = 48*MULTIPLYHEIGHT;
    
    btnSetDefault = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSetDefault setTitle:@"SET AS DEFAULT" forState:UIControlStateNormal];
    [btnSetDefault setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnSetDefault.frame = CGRectMake(btnY, screen_height-50*MULTIPLYHEIGHT, 100*MULTIPLYHEIGHT, 35*MULTIPLYHEIGHT);
    btnSetDefault.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appdel.FONT_SIZE_CUSTOM-3];
    [btnSetDefault addTarget:self action:@selector(setaddressDefault:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSetDefault];
    btnSetDefault.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btnY += 90*MULTIPLYHEIGHT;
    
    UIImageView *imgLine = [[UIImageView alloc]init];
    imgLine.backgroundColor = RGBCOLORCODE(200, 200, 200, 1.0);
    imgLine.frame = CGRectMake(btnY, screen_height-48*MULTIPLYHEIGHT, 1, 30*MULTIPLYHEIGHT);
    [self.view addSubview:imgLine];
    
    btnY += 5*MULTIPLYHEIGHT;
    
    btnEditAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEditAddress setTitle:@"EDIT ADDRESS" forState:UIControlStateNormal];
    [btnEditAddress setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnEditAddress.frame = CGRectMake(btnY, screen_height-50*MULTIPLYHEIGHT, 100*MULTIPLYHEIGHT, 35*MULTIPLYHEIGHT);
    btnEditAddress.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appdel.FONT_SIZE_CUSTOM-3];
    [btnEditAddress addTarget:self action:@selector(btnEditAddressClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEditAddress];
    
    [self getAddressFromServer];
    
}


-(void) closeBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appdel hideTabBar:appdel.customTabBarController];
    
    [appdel setBottomTabBarColor:TABBAR_COLOR_GREY BlurEffectStyle:BLUR_EFFECT_STYLE_LIGHT HideBlurEffect:NO];
}

-(void) getAddressFromServer
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/get", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appdel withObject:nil];
        
        if ([[responseObj objectForKey:@"s"] intValue] == 1)
        {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [addressArray removeAllObjects];
                
                [addressArray addObjectsFromArray:[responseObj objectForKey:@"addresses"]];
                
                for (NSDictionary *dic in addressArray)
                {
                    if ([[dic objectForKey:@"default"] intValue] == 1)
                    {
                        [addressArray removeObject:dic];
                        
                        [addressArray insertObject:dic atIndex:0];
                        
                        break;
                    }
                }
                
                [PiingHandler sharedHandler].userAddress = addressArray;
                
                [addressMapView clearAllMarkers];
                
                [self loadLatandLongofAddresses];
                
                if (addressSelectedAsDefault)
                {
                    addressSelectedAsDefault = NO;
                    [appdel.window makeToast:@"Address is selected as default"];
                }
                
            }];
            
        }
        else
        {
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void) loadLatandLongofAddresses
{
    
    for (int i=0; i<[addressArray count]; i++)
    {
        
        NSDictionary *dict = [addressArray objectAtIndex:i];
        
        UIView *viewAddress = (UIView *) [scrollViewAddresses viewWithTag:10+i];
        
        if ([[dict objectForKey:@"default"] intValue] == 1)
        {
            [addressMapView addMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"lat"], @"lat", [dict objectForKey:@"lon"], @"lon", @"address_map_selected", @"markImage", nil] withIndex:1];
        }
        else
        {
            [addressMapView addMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"lat"], @"lat", [dict objectForKey:@"lon"], @"lon", @"address_pointer_normal", @"markImage", nil] withIndex:1];
        }
        
        if (!viewAddress)
        {
            viewAddress = [[UIView alloc]init];
            viewAddress.tag = 10+i;
            [scrollViewAddresses addSubview:viewAddress];
        }
        
        viewAddress.frame = CGRectMake(i*screen_width+7*MULTIPLYHEIGHT, 0, screen_width-7*MULTIPLYHEIGHT, scrollViewAddresses.frame.size.height);
        
        float yPos = 10*MULTIPLYHEIGHT;
        
        float lblX = 41*MULTIPLYHEIGHT;
        
        UILabel *lblName = (UILabel *) [viewAddress viewWithTag:201];
        
        if (!lblName)
        {
            lblName = [[UILabel alloc]init];
            lblName.tag = 201;
            [viewAddress addSubview:lblName];
        }
        
        lblName.frame = CGRectMake(lblX, yPos, viewAddress.frame.size.width-lblX*2, 25*MULTIPLYHEIGHT);
        lblName.font = [UIFont fontWithName:APPFONT_BOLD size:appdel.HEADER_LABEL_FONT_SIZE];
        lblName.textColor = [UIColor darkGrayColor];
        lblName.text = [[dict objectForKey:@"name"] uppercaseString];
        
        yPos += 25*MULTIPLYHEIGHT;
        
        UILabel *addressnameLbl = (UILabel *)[viewAddress viewWithTag:202];
        
        if (!addressnameLbl)
        {
            addressnameLbl = [[UILabel alloc] init];
            addressnameLbl.tag = 202;
            [viewAddress addSubview:addressnameLbl];
        }
        
        addressnameLbl.numberOfLines = 0;
        addressnameLbl.frame = CGRectMake(lblX, yPos, viewAddress.frame.size.width-(lblX+8*MULTIPLYHEIGHT), 20);
        addressnameLbl.backgroundColor = [UIColor clearColor];
        addressnameLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appdel.FONT_SIZE_CUSTOM-1];
        addressnameLbl.textColor = [UIColor lightGrayColor];
        
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
        
        strAddr = [[strAddr uppercaseString] mutableCopy];
        
        addressnameLbl.text = strAddr;
        
        CGFloat addheight = [AppDelegate getLabelHeightForMediumText:strAddr WithWidth:addressnameLbl.frame.size.width FontSize:addressnameLbl.font.pointSize];
        
        CGRect addrect = addressnameLbl.frame;
        addrect.size.height = addheight;
        addressnameLbl.frame = addrect;
        
        UIButton *btnDefault = (UIButton *)[viewAddress viewWithTag:203];
        
        if (!btnDefault)
        {
            btnDefault = [UIButton buttonWithType:UIButtonTypeCustom];
            btnDefault.frame = CGRectMake(10*MULTIPLYHEIGHT, 13*MULTIPLYHEIGHT, 18*MULTIPLYHEIGHT, 18*MULTIPLYHEIGHT);
            btnDefault.tag = 203;
            [viewAddress addSubview:btnDefault];
        }
        
        if ([[dict objectForKey:@"default"] intValue] == 1)
        {
            [btnDefault setImage:[UIImage imageNamed:@"selected_address"] forState:UIControlStateNormal];
        }
        else
        {
            [btnDefault setImage:[UIImage imageNamed:@"unselected_address"] forState:UIControlStateNormal];
        }
        
        [btnDefault addTarget:self action:@selector(setaddressDefault:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [addressMapView focusMapToShowAllMarkers];
    
    NSDictionary *dict = [addressArray objectAtIndex:0];
    
    pageControlForAddress.numberOfPages = [addressArray count];
    pageControlForAddress.currentPage = 0;
    [scrollViewAddresses setContentSize:CGSizeMake([addressArray count] * screen_width, 0)];
    
    [scrollViewAddresses setContentOffset:CGPointMake(0, 0)];
    
    [addressMapView replaceMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"lat"],@"lat",[dict objectForKey:@"lon"],@"lon",@"address_map_selected",@"markImage",@"no",@"clearAll", nil] PositionAtIndex:pageControlForAddress.currentPage];
    
    [addressMapView focusMapToShowAllMarkers];
    
    [btnSetDefault setTitleColor:RGBCOLORCODE(200, 200, 200, 1.0) forState:UIControlStateNormal];
    btnSetDefault.enabled = NO;
}


-(void) btnEditAddressClicked:(id)sender
{
    NSDictionary *dict = [addressArray objectAtIndex:pageControlForAddress.currentPage];
    
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
    addressFeild.notes = [dict objectForKey:@"landMark"];
    
    AddAddressViewController *addAddVC = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
    addAddVC.addressFeild = addressFeild;
    addAddVC.isEditingAddress = YES;
    addAddVC.delegate = self;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addAddVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

-(void) setaddressDefault:(UIButton *) sender
{
    addressSelectedAsDefault = YES;
    
    [self setDefaultAddress:[addressArray objectAtIndex:pageControlForAddress.currentPage]];
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
    
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid", addressFeild.addressName, @"name", addressFeild.addressLine1, @"line1", addressFeild.addressLine2, @"line2", addressFeild.city, @"city", addressFeild.state, @"state", addressFeild.country, @"country",addressFeild.notes, @"landMark", addressFeild.zipCode, @"zipcode", @"1", @"default",addressFeild.fno, @"floorNo", addressFeild.uno, @"unitNo", addressFeild.addressID, @"_id", addressFeild.lat, @"lat", addressFeild.lng, @"lon", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/save", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appdel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dict andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            [self getAddressFromServer];
        }
        else {
            
            [appdel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void)googlemapViewTappedOnMarker:(CustomGMSMarker *)marker
{
    NSInteger page = [addressMapView.allMarkersArray indexOfObject:marker];
    
    NSDictionary *dict1 = [addressArray objectAtIndex:pageControlForAddress.currentPage];
    
    [addressMapView replaceMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict1 objectForKey:@"lat"], @"lat", [dict1 objectForKey:@"lon"], @"lon", @"address_pointer_normal", @"markImage", nil] PositionAtIndex:pageControlForAddress.currentPage];
    
    pageControlForAddress.currentPage = page;
    previousPage = page;
    
    NSDictionary *dict = [addressArray objectAtIndex:page];
    
    [addressMapView replaceMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"lat"],@"lat",[dict objectForKey:@"lon"],@"lon",@"address_map_selected",@"markImage",@"no",@"clearAll", nil] PositionAtIndex:page];
    
    [addressMapView focusMapToShowAllMarkers];
    
    pageControlForAddress.currentPage = page;
    [scrollViewAddresses setContentOffset:CGPointMake(screen_width*page, 0) animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollViewAddresses.frame.size.width;
    float fractionalPage = scrollViewAddresses.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    if (pageControlForAddress.currentPage == page)
    {
        
    }
    else
    {
        NSDictionary *dict1 = [addressArray objectAtIndex:pageControlForAddress.currentPage];
        
        [addressMapView replaceMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict1 objectForKey:@"lat"],@"lat",[dict1 objectForKey:@"lon"],@"lon",@"address_pointer_normal",@"markImage",@"no",@"clearAll", nil] PositionAtIndex:pageControlForAddress.currentPage];
        
        pageControlForAddress.currentPage = page;
        previousPage = page;
        
        NSDictionary *dict = [addressArray objectAtIndex:page];
        
        [addressMapView replaceMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"lat"],@"lat",[dict objectForKey:@"lon"],@"lon",@"address_map_selected",@"markImage",@"no",@"clearAll", nil] PositionAtIndex:page];
        
        [addressMapView focusMapToShowAllMarkers];

    }
    
    if (page == 0)
    {
        btnSetDefault.enabled = NO;
        [btnSetDefault setTitleColor:RGBCOLORCODE(200, 200, 200, 1.0) forState:UIControlStateNormal];
    }
    else
    {
        btnSetDefault.enabled = YES;
        [btnSetDefault setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

-(void) pagecontrolClicked:(id)sender
{
    NSInteger page = pageControlForAddress.currentPage;
    if (page < 0)
        return;
    if (page >= [addressArray count])
        return;
    
    NSDictionary *dict1 = [addressArray objectAtIndex:previousPage];
    
    [addressMapView replaceMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict1 objectForKey:@"lat"],@"lat",[dict1 objectForKey:@"lon"],@"lon",@"address_pointer_normal",@"markImage",@"no",@"clearAll", nil] PositionAtIndex:previousPage];
    
    previousPage = page;
    
    NSDictionary *dict = [addressArray objectAtIndex:page];
    
    [addressMapView replaceMarker:[[NSDictionary alloc] initWithObjectsAndKeys:[dict objectForKey:@"lat"],@"lat",[dict objectForKey:@"lon"],@"lon",@"address_map_selected",@"markImage",@"no",@"clearAll", nil] PositionAtIndex:page];
    
    [addressMapView focusMapToShowAllMarkers];
    
    [scrollViewAddresses setContentOffset:CGPointMake(screen_width*page, 0) animated:YES];
}

-(void) didAddNewAddress
{
    [self getAddressFromServer];
}

#pragma mark UIControl Methods



-(void) addAddressBtnClicked
{
    AddAddressViewController *addAddVC = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
    addAddVC.delegate = self;
    
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


@end
