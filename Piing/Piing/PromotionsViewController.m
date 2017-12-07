//
//  PromotionsViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 07/01/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "PromotionsViewController.h"


@interface PromotionsViewController () <UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *appDel;
    
    NSMutableArray *arrayPromotions;
    
    UITableView *tblPromotions;
    
    NSMutableArray *arrayCopyText;
    
    NSMutableDictionary *dictImages;
}
@end

@implementation PromotionsViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    arrayPromotions = [[NSMutableArray alloc]init];
    arrayCopyText = [[NSMutableArray alloc]init];
    
    dictImages = [[NSMutableDictionary alloc]init];
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, 40)];
    NSString *string = @"PROMOTIONS";
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
    
    yAxis += 40+10*MULTIPLYHEIGHT;
    
    tblPromotions = [[UITableView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, screen_height-yAxis) style:UITableViewStylePlain];
    tblPromotions.dataSource = self;
    tblPromotions.delegate = self;
    tblPromotions.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:tblPromotions];
    tblPromotions.contentInset = UIEdgeInsetsMake(0, 0, 35*MULTIPLYHEIGHT, 0);
    tblPromotions.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self fetchPromotions];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDel setBottomTabBarColor:TABBAR_COLOR_GREY BlurEffectStyle:BLUR_EFFECT_STYLE_EXTRA_LIGHT HideBlurEffect:NO];
    [appDel hideTabBar:appDel.customTabBarController];
}


-(void) fetchPromotions
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@promo/getall", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            if(responseObj &&[[responseObj objectForKey:@"promos"] count])
            {
                arrayPromotions = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"promos"]];
            }
            
            [tblPromotions reloadData];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


-(void) backToPreviousScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayPromotions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"Cell"];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.tag = 1;
        [cell.contentView addSubview:imgView];
        
        UILabel *lblPromoDesc = [[UILabel alloc]init];
        lblPromoDesc.tag = 2;
        lblPromoDesc.numberOfLines = 0;
        lblPromoDesc.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [cell.contentView addSubview:lblPromoDesc];
        
        UILabel *lblCouponCodeText = [[UILabel alloc]init];
        lblCouponCodeText.tag = 3;
        lblCouponCodeText.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
        [cell.contentView addSubview:lblCouponCodeText];
        
        UILabel *lblOfferValid = [[UILabel alloc]init];
        lblOfferValid.tag = 4;
        lblOfferValid.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
        [cell.contentView addSubview:lblOfferValid];
        
        UIButton *btnCopyCode = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCopyCode.tag = 5;
        [cell.contentView addSubview:btnCopyCode];
        
        UILabel *lblAmount = [[UILabel alloc]init];
        lblAmount.tag = 6;
        lblAmount.textAlignment = NSTextAlignmentCenter;
        lblAmount.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
        [cell.contentView addSubview:lblAmount];
    }
    
    UIImageView *imgView = (UIImageView *) [cell.contentView viewWithTag:1];
    //imgView.delegate = self;
    
    UILabel *lblPromoDesc = (UILabel *) [cell.contentView viewWithTag:2];
    UILabel *lblCouponCodeText = (UILabel *) [cell.contentView viewWithTag:3];
    UILabel *lblOfferValid = (UILabel *) [cell.contentView viewWithTag:4];
    UIButton *btnCopyCode = (UIButton *) [cell.contentView viewWithTag:5];
    UILabel *lblAmount = (UILabel *) [cell.contentView viewWithTag:6];
    
    NSDictionary *dictPromotions = [arrayPromotions objectAtIndex:indexPath.row];
    
    float rowHeight = 8*MULTIPLYHEIGHT;
    
    float imgX = 11*MULTIPLYHEIGHT;
    float imgHeight = 108*MULTIPLYHEIGHT;
    
    imgView.frame = CGRectMake(imgX, rowHeight, screen_width-(imgX*2), imgHeight);
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[dictPromotions objectForKey:@"image"]]
                 placeholderImage:[UIImage imageNamed:@"promotions_loading"]];
    
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    imgView.clipsToBounds = YES;
    
    rowHeight += imgHeight+8*MULTIPLYHEIGHT;
    
    if ([[dictPromotions objectForKey:@"Type"] caseInsensitiveCompare:@"ByPercentage"] == NSOrderedSame)
    {
        lblAmount.text = [NSString stringWithFormat:@"%@%%", [dictPromotions objectForKey:@"value"]];
    }
    else
    {
        lblAmount.text = [NSString stringWithFormat:@"$%@", [dictPromotions objectForKey:@"value"]];
    }
    
    lblAmount.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    lblAmount.textColor = BLUE_COLOR;
    
    float lblAHeight = 30*MULTIPLYHEIGHT;
    float minusX = 50*MULTIPLYHEIGHT;
    float minusY = 36*MULTIPLYHEIGHT;
    
    lblAmount.frame = CGRectMake(screen_width-minusX, (imgView.frame.origin.y+imgView.frame.size.height)-minusY, lblAHeight, lblAHeight);
    lblAmount.layer.cornerRadius = lblAmount.frame.size.width/2;
    lblAmount.layer.masksToBounds = YES;
    
    CGFloat customHeight;
    CGFloat maxWidth = screen_width-(imgX*2);
    
    if ([dictPromotions objectForKey:@"longDesc"])
    {
        customHeight = [AppDelegate getLabelHeightForSemiBoldText:[dictPromotions objectForKey:@"longDesc"] WithWidth:maxWidth FontSize:appDel.FONT_SIZE_CUSTOM-2];
        
        lblPromoDesc.text = [dictPromotions objectForKey:@"longDesc"];
        lblPromoDesc.frame = CGRectMake(imgX, rowHeight, maxWidth, customHeight);
        lblPromoDesc.textColor = [UIColor grayColor];
        
        rowHeight += customHeight+5*MULTIPLYHEIGHT;
    }
    
    
    lblCouponCodeText.textColor = [UIColor blackColor];
    NSString *strPromoCode = @"Coupon code:";
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", strPromoCode, [dictPromotions objectForKey:@"couponId"]]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [strPromoCode length])];
    
    lblCouponCodeText.attributedText = attrStr;
    
    float lblCHeight = 13*MULTIPLYHEIGHT;
    lblCouponCodeText.frame = CGRectMake(imgX, rowHeight, maxWidth, lblCHeight);
    
    float btnMinusX = 72*MULTIPLYHEIGHT;
    float btnHeight = 22*MULTIPLYHEIGHT;
    float btnWidth = 65*MULTIPLYHEIGHT;
    
    btnCopyCode.frame = CGRectMake(screen_width-btnMinusX, rowHeight, btnWidth, btnHeight);
    
    if ([arrayCopyText containsObject:indexPath])
    {
        [btnCopyCode setImage:[UIImage imageNamed:@"couponcopy_selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnCopyCode setImage:[UIImage imageNamed:@"couponcopy.png"] forState:UIControlStateNormal];
    }
    
    [btnCopyCode addTarget:self action:@selector(copyCouponcode:) forControlEvents:UIControlEventTouchUpInside];
    btnCopyCode.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    rowHeight += lblCHeight+5*MULTIPLYHEIGHT;
    
    lblOfferValid.textColor = [UIColor lightGrayColor];
    
    NSArray *arrEndDate = [[dictPromotions objectForKey:@"eDate"] componentsSeparatedByString:@"T"];
    
    NSString *strEndDate = [arrEndDate objectAtIndex:0];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [df dateFromString:strEndDate];
    [df setDateFormat:@"dd MMMM yyyy"];
    strEndDate = [df stringFromDate:date];
    
    NSString *strValidtill = @"Offer valid till:";
    
    attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", strValidtill, strEndDate]];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:NSMakeRange(0, [strValidtill length])];
    
    lblOfferValid.attributedText = attrStr;
    lblOfferValid.frame = CGRectMake(imgX, rowHeight, maxWidth, lblCHeight);
    
    rowHeight += lblCHeight+5*MULTIPLYHEIGHT;
    
    return cell;
}


#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictPromotions = [arrayPromotions objectAtIndex:indexPath.row];
    
    float rowHeight = 8*MULTIPLYHEIGHT;
    
    float imgHeight = 108*MULTIPLYHEIGHT;
    float imgX = 11*MULTIPLYHEIGHT;
    
    rowHeight += imgHeight;
    
    CGFloat customHeight;
    CGFloat maxWidth = screen_width-(imgX*2);
    
    if ([dictPromotions objectForKey:@"longDesc"])
    {
        customHeight = [AppDelegate getLabelHeightForSemiBoldText:[dictPromotions objectForKey:@"longDesc"] WithWidth:maxWidth FontSize:appDel.FONT_SIZE_CUSTOM-2];
        rowHeight += customHeight+5*MULTIPLYHEIGHT;
    }
    
    float lblCHeight = 13*MULTIPLYHEIGHT;
    
    rowHeight += lblCHeight+5*MULTIPLYHEIGHT;
    
    rowHeight += lblCHeight+5*MULTIPLYHEIGHT;
    
    rowHeight += 8*MULTIPLYHEIGHT;
    
    return rowHeight;
}


-(void) copyCouponcode:(id)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tblPromotions];
    NSIndexPath *selectedIndexPath = [tblPromotions indexPathForRowAtPoint:position];
    
    [arrayCopyText removeAllObjects];
    [arrayCopyText addObject:selectedIndexPath];
    
    NSDictionary *dictPromotions = [arrayPromotions objectAtIndex:selectedIndexPath.row];
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:[dictPromotions objectForKey:@"couponId"]];
    
    [tblPromotions reloadData];
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
