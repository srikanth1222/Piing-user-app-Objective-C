//
//  ViewBillController.m
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "ViewBillController.h"
#import "ViewBillDetailsController.h"
#import "ViewBillDiscountDetailsController.h"
#import "NSNull+JSON.h"



@interface ViewBillController ()
{
    AppDelegate *appDel;
    
    UITableView *tblViewBill;
    
    UILabel *lblOrderNumber;
    
    UILabel *lblFinalAmount;
    
    NSMutableArray *arrayWashType;
    NSMutableArray *arrayWashTypeImages;
    
    UILabel *lblAmountText;
    
    UILabel *lblWalletText, *lblWalletAmount;
    
    UILabel *lblDiscountText, *lblDiscountAmount;
    UILabel *lblGSTAmountText, *lblGSTAmountValue;
    
    UISegmentedControl *segmentPartialOrder;
    UILabel *lblTitle;
    
    NSDictionary *dictAll;
    
    UIButton *btnDiscount;
    
    NSMutableArray *arrayViewBill;
    NSMutableArray *arrayMainData;
    
    NSMutableArray *arrayCustomizedData;
    
}

@end


@implementation ViewBillController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    arrayWashType = [[NSMutableArray alloc]init];
    arrayWashTypeImages = [[NSMutableArray alloc]init];
    
    arrayViewBill = [[NSMutableArray alloc]init];
    arrayMainData = [[NSMutableArray alloc]init];
    arrayCustomizedData = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float yPos = 25*MULTIPLYHEIGHT;
    
    lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 40)];
    NSString *string = @"VIEW BILL";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-2];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(screen_width-45, yPos, 40.0, 40.0);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:closeBtn];
    
    yPos += 40+10*MULTIPLYHEIGHT;
    
    
    float lblOHeight = 28*MULTIPLYHEIGHT;
    
    lblOrderNumber = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, lblOHeight)];
    lblOrderNumber.textAlignment = NSTextAlignmentCenter;
    lblOrderNumber.text = [NSString stringWithFormat:@"ORDER ID # %@", self.strCobID];
    lblOrderNumber.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
    lblOrderNumber.textColor = APP_FONT_COLOR_GREY;
    lblOrderNumber.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblOrderNumber];
    
    CALayer *bottomLayerLbl = [[CALayer alloc]init];
    bottomLayerLbl.frame = CGRectMake(0, lblOrderNumber.frame.size.height-1, screen_width, 1);
    bottomLayerLbl.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    [lblOrderNumber.layer addSublayer:bottomLayerLbl];
    
    
    yPos += lblOHeight;
    
    NSArray *arrayItems = @[@"VIEW BILL", @"PARTIAL ORDER"];
    segmentPartialOrder = [[UISegmentedControl alloc]initWithItems:arrayItems];
    [self.view addSubview:segmentPartialOrder];
    segmentPartialOrder.hidden = YES;
    
    float segmentWidth = 170*MULTIPLYHEIGHT;
    
    segmentPartialOrder.frame = CGRectMake((screen_width/2)-(segmentWidth/2), 30*MULTIPLYHEIGHT, segmentWidth, 30.0);
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateSelected];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateNormal];
    
    [segmentPartialOrder addTarget:self action:@selector(segmentPartialOrderChange:) forControlEvents:UIControlEventValueChanged];
    segmentPartialOrder.tintColor = BLUE_COLOR;
    segmentPartialOrder.selectedSegmentIndex = 0;
    
    
    float height = 42*MULTIPLYHEIGHT;
    
    UIView *view_Total = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height-height, screen_width, height)];
    view_Total.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.9];
    [self.view addSubview:view_Total];
    
    lblFinalAmount = [[UILabel alloc]initWithFrame:CGRectMake(20*MULTIPLYHEIGHT, 0, screen_width-(20*MULTIPLYHEIGHT*2), height)];
    lblFinalAmount.textAlignment = NSTextAlignmentLeft;
    lblFinalAmount.text = @"FINAL  AMOUNT";
    lblFinalAmount.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM];
    lblFinalAmount.textColor = [UIColor whiteColor];
    lblFinalAmount.backgroundColor = [UIColor clearColor];
    [view_Total addSubview:lblFinalAmount];
    
    
    float typeX = 115*MULTIPLYHEIGHT;
    float typeWidth = 30*MULTIPLYHEIGHT;
    float typeHeight = 12*MULTIPLYHEIGHT;
    
    UILabel *lblPaymentType = [[UILabel alloc]initWithFrame:CGRectMake(typeX, height/2-((12*MULTIPLYHEIGHT)/2), typeWidth, typeHeight)];
    
    if ([self.strPaymentType caseInsensitiveCompare:@"Cash"] == NSOrderedSame)
    {
        lblPaymentType.text = @"CASH";
    }
    else
    {
        lblPaymentType.text = @"CARD";
    }
    
    lblPaymentType.font = [UIFont fontWithName:APPFONT_ITALIC size:appDel.FONT_SIZE_CUSTOM-6];
    lblPaymentType.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9];
    lblPaymentType.textAlignment = NSTextAlignmentCenter;
    lblPaymentType.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.9].CGColor;
    lblPaymentType.layer.borderWidth = 1.0f;
    [view_Total addSubview:lblPaymentType];
    lblPaymentType.layer.cornerRadius = 4.0;
    
    
    lblAmountText = [[UILabel alloc]initWithFrame:CGRectMake(20*MULTIPLYHEIGHT, 0, screen_width-(20*MULTIPLYHEIGHT*2), height)];
    lblAmountText.textAlignment = NSTextAlignmentRight;
    lblAmountText.text = @"$0.00";
    lblAmountText.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE];
    lblAmountText.textColor = [UIColor whiteColor];
    lblAmountText.backgroundColor = [UIColor clearColor];
    [view_Total addSubview:lblAmountText];
    
    
    float discountHeight = 57*MULTIPLYHEIGHT;
    UIView *view_Discount = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height-discountHeight-height, screen_width, discountHeight)];
    view_Discount.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_Discount];
    
    CALayer *layerDiscount = [[CALayer alloc]init];
    layerDiscount.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    layerDiscount.frame = CGRectMake(0, 0, screen_width, 2);
    [view_Discount.layer addSublayer:layerDiscount];
    
    
    float lblX = 20*MULTIPLYHEIGHT;
    
    float lblY = 5*MULTIPLYHEIGHT;
    float lblHeight = 16*MULTIPLYHEIGHT;
    
    lblWalletText = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, screen_width-(lblX*2), lblHeight)];
    lblWalletText.textAlignment = NSTextAlignmentLeft;
    lblWalletText.text = @"PIING! CREDITS";
    lblWalletText.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    lblWalletText.textColor = [UIColor lightGrayColor];
    lblWalletText.backgroundColor = [UIColor clearColor];
    [view_Discount addSubview:lblWalletText];
    
    lblWalletAmount = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, screen_width-(lblX*2.2), lblHeight)];
    lblWalletAmount.textAlignment = NSTextAlignmentRight;
    lblWalletAmount.text = @"$0.00";
    lblWalletAmount.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
    lblWalletAmount.textColor = [UIColor lightGrayColor];
    lblWalletAmount.backgroundColor = [UIColor clearColor];
    [view_Discount addSubview:lblWalletAmount];
    
    lblY = lblY+lblHeight;
    
    lblDiscountText = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, screen_width-(lblX*2), lblHeight)];
    lblDiscountText.textAlignment = NSTextAlignmentLeft;
    lblDiscountText.text = @"DISCOUNT";
    lblDiscountText.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    lblDiscountText.textColor = [UIColor lightGrayColor];
    lblDiscountText.backgroundColor = [UIColor clearColor];
    [view_Discount addSubview:lblDiscountText];
    
    lblDiscountAmount = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, screen_width-(lblX*2.2), lblHeight)];
    lblDiscountAmount.textAlignment = NSTextAlignmentRight;
    lblDiscountAmount.text = @"$0.00";
    lblDiscountAmount.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
    lblDiscountAmount.textColor = [UIColor lightGrayColor];
    lblDiscountAmount.backgroundColor = [UIColor clearColor];
    [view_Discount addSubview:lblDiscountAmount];
    
    lblY = lblY+lblHeight;
    
    lblGSTAmountText = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, screen_width-(lblX*2), lblHeight)];
    lblGSTAmountText.textAlignment = NSTextAlignmentLeft;
    lblGSTAmountText.text = @"GST";
    lblGSTAmountText.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    lblGSTAmountText.textColor = [UIColor lightGrayColor];
    lblGSTAmountText.backgroundColor = [UIColor clearColor];
    [view_Discount addSubview:lblGSTAmountText];
    
    lblGSTAmountValue = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, screen_width-(lblX*2.2), lblHeight)];
    lblGSTAmountValue.textAlignment = NSTextAlignmentRight;
    lblGSTAmountValue.text = @"$0.00";
    lblGSTAmountValue.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
    lblGSTAmountValue.textColor = [UIColor lightGrayColor];
    lblGSTAmountValue.backgroundColor = [UIColor clearColor];
    [view_Discount addSubview:lblGSTAmountValue];
    
    
    btnDiscount = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDiscount.frame = view_Discount.bounds;
    [btnDiscount setImage:[UIImage imageNamed:@"right_arrow"] forState:UIControlStateNormal];
    //btnDiscount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btnDiscount.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(screen_width-20*MULTIPLYHEIGHT));
    [btnDiscount addTarget:self action:@selector(btnDiscountClicked) forControlEvents:UIControlEventTouchUpInside];
    [view_Discount addSubview:btnDiscount];
    
    
    tblViewBill = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, view_Discount.frame.origin.y-yPos) style:UITableViewStylePlain];
    tblViewBill.dataSource = self;
    tblViewBill.delegate = self;
    tblViewBill.backgroundColor = [UIColor clearColor];
    tblViewBill.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblViewBill];
    
    [self fetchViewBillData];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDel hideTabBar:appDel.customTabBarController];
}


-(void) btnDiscountClicked
{
    if ([[dictAll objectForKey:@"discountBreakdown"] count])
    {
        ViewBillDiscountDetailsController *objDiscount = [[ViewBillDiscountDetailsController alloc]init];
        objDiscount.arrayDiscount = [dictAll objectForKey:@"discountBreakdown"];
        [self.navigationController pushViewController:objDiscount animated:YES];
    }
}


-(void) fetchViewBillData
{
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.strUserId, @"uid", self.strCobID, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    NSString *urlStr = @"";
    
    if (self.isPartialBill)
    {
        urlStr = [NSString stringWithFormat:@"%@order/get/billpartial", BASE_URL];
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"%@order/get/bill", BASE_URL];
    }
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            NSDictionary *dictNow;
            
            if ([[responseObj objectForKey:@"em"] isKindOfClass:[NSArray class]])
            {
                dictNow = [[responseObj objectForKey:@"em"] objectAtIndex:0];
                
                [arrayViewBill removeAllObjects];
                [arrayViewBill addObjectsFromArray:[[[responseObj objectForKey:@"em"] objectAtIndex:0] objectForKey:@"r"]];;
                
                [arrayMainData removeAllObjects];
                [arrayMainData addObjectsFromArray:[[[responseObj objectForKey:@"em"] objectAtIndex:0] objectForKey:@"r"]];
            }
            else
            {
                dictNow = [responseObj objectForKey:@"em"];
                
                [arrayViewBill removeAllObjects];
                [arrayViewBill addObjectsFromArray:[[responseObj objectForKey:@"em"] objectForKey:@"r"]];;
                
                [arrayMainData removeAllObjects];
                [arrayMainData addObjectsFromArray:[[responseObj objectForKey:@"em"] objectForKey:@"r"]];
            }
            
            [self getCustomizedData];
            
            if ([dictNow objectForKey:@"totalSum"])
            {
                dictAll = [dictNow objectForKey:@"totalSum"];
                
                if (![[dictAll objectForKey:@"discountBreakdown"] count])
                {
                    btnDiscount.hidden = YES;
                }
                
                if ([[dictAll objectForKey:@"totalAmount"] floatValue] == 0.0)
                {
                    lblAmountText.text = [NSString stringWithFormat:@"$%.2f", [[dictAll objectForKey:@"amountPaid"] floatValue]];
                }
                else
                {
                    lblAmountText.text = [NSString stringWithFormat:@"$%.2f", [[dictAll objectForKey:@"totalAmount"] floatValue]];
                }
                
                float discountVal = [[dictAll objectForKey:@"promoAmount"] floatValue] + [[dictAll objectForKey:@"freeWashAmount"] floatValue];
                
                lblDiscountAmount.text = [NSString stringWithFormat:@"-$%.2f", discountVal];
                
                lblWalletAmount.text = [NSString stringWithFormat:@"-$%.2f", [[dictAll objectForKey:@"walletAmount"] floatValue]];
                lblGSTAmountValue.text = [NSString stringWithFormat:@"+$%.2f", [[dictAll objectForKey:@"gstAmount"] floatValue]];
            }
            else
            {
                btnDiscount.hidden = YES;
                
                lblAmountText.text = [NSString stringWithFormat:@"$%.2f", [[dictNow objectForKey:@"billAmount"] floatValue]];
            }
            
            [tblViewBill reloadData];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(void) getCustomizedData
{
    for (int i = 0; i < [arrayMainData count]; i++)
    {
        NSDictionary *dictBag = [arrayMainData objectAtIndex:i];
        
        if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_WF])
        {
            NSArray *arrayItems = [dictBag objectForKey:@"STItems"];
            
            if ([arrayItems count])
            {
                NSMutableDictionary *dictItemType = [[NSMutableDictionary alloc]init];
                [dictItemType setObject:[[arrayItems objectAtIndex:0] objectForKey:@"weight"] forKey:@"weight"];
                [dictItemType setObject:[[arrayItems objectAtIndex:0] objectForKey:@"totalPrice"] forKey:@"totalPrice"];
                
                NSMutableArray *arrayBag = [[NSMutableArray alloc]initWithObjects:dictItemType, nil];
                
                NSMutableDictionary *dictBagPar = [[NSMutableDictionary alloc]initWithObjectsAndKeys:arrayBag, @"STItems", nil];
                [dictBagPar setObject:[dictBag objectForKey:@"serviceType"] forKey:@"serviceType"];
                
                [dictBagPar setObject:@"Load Wash" forKey:@"serviceTypeName"];
                
                [arrayCustomizedData addObject:dictBagPar];
            }
        }
        else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_CA])
        {
            NSArray *arrayItems = [dictBag objectForKey:@"STItems"];
            
            if ([arrayItems count])
            {
                NSMutableDictionary *dictItemType = [[NSMutableDictionary alloc]init];
                [dictItemType setObject:[[arrayItems objectAtIndex:0] objectForKey:@"weight"] forKey:@"weight"];
                [dictItemType setObject:[[arrayItems objectAtIndex:0] objectForKey:@"totalPrice"] forKey:@"totalPrice"];
                
                NSMutableArray *arrayBag = [[NSMutableArray alloc]initWithObjects:dictItemType, nil];
                
                NSMutableDictionary *dictBagPar = [[NSMutableDictionary alloc]initWithObjectsAndKeys:arrayBag, @"STItems", nil];
                [dictBagPar setObject:[dictBag objectForKey:@"serviceType"] forKey:@"serviceType"];
                
                [dictBagPar setObject:@"Carpet Cleaning" forKey:@"serviceTypeName"];
                
                [arrayCustomizedData addObject:dictBagPar];
            }
        }
        else
        {
            NSArray *arrayItems = [dictBag objectForKey:@"STItems"];
            
            NSMutableDictionary *dictItemType = [[NSMutableDictionary alloc]init];
            
            for (int j = 0; j < [arrayItems count]; j++)
            {
                NSDictionary *dictItem = [arrayItems objectAtIndex:j];
                
                NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:dictItem];
                
                NSString *strItemCode = [dictItem objectForKey:@"itemCode"];
                
                if (![dictItemType objectForKey:strItemCode])
                {
                    NSMutableArray *arrayItemCode = [[NSMutableArray alloc]initWithObjects:dict1, nil];
                    
                    [dictItemType setObject:arrayItemCode forKey:strItemCode];
                }
                else
                {
                    NSMutableArray *arrayItemCode = [dictItemType objectForKey:strItemCode];
                    
                    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:dictItem];
                    
                    [arrayItemCode addObject:dict1];
                }
            }
            
            NSMutableArray *arrayBag = [[NSMutableArray alloc]initWithObjects:dictItemType, nil];
            
            NSMutableDictionary *dictBagPar = [[NSMutableDictionary alloc]initWithObjectsAndKeys:arrayBag, @"STItems", nil];
            [dictBagPar setObject:[dictBag objectForKey:@"serviceType"] forKey:@"serviceType"];
            
            if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_DC])
            {
                [dictBagPar setObject:@"Dry Cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_DCG])
            {
                [dictBagPar setObject:@"Green Dry Cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_WI])
            {
                [dictBagPar setObject:@"Wash & Iron" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_IR])
            {
                [dictBagPar setObject:@"Ironing" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_HL_DC])
            {
                [dictBagPar setObject:@"Home linen - Dry Cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_HL_DCG])
            {
                [dictBagPar setObject:@"Home linen - Green Dry Cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_HL_WI])
            {
                [dictBagPar setObject:@"Home linen - Wash & Iron" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_LE])
            {
                [dictBagPar setObject:@"Leather Cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_CC_DC])
            {
                [dictBagPar setObject:@"Curtains without installation - Dry Cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_CC_W_DC])
            {
                [dictBagPar setObject:@"Curtains with installation - Dry Cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_CC_WI])
            {
                [dictBagPar setObject:@"Curtains without installation - Wash & Iron" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_CC_W_WI])
            {
                [dictBagPar setObject:@"Curtains with installation - Wash & Iron" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_BAG])
            {
                [dictBagPar setObject:@"Bag" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_SHOE_CLEAN])
            {
                [dictBagPar setObject:@"Shoe cleaning" forKey:@"serviceTypeName"];
            }
            else if ([[dictBag objectForKey:@"serviceType"] isEqualToString:SERVICETYPE_SHOE_POLISH])
            {
                [dictBagPar setObject:@"Shoe polishing" forKey:@"serviceTypeName"];
            }
            
            [arrayCustomizedData addObject:dictBagPar];
        }
    }
}


-(void) segmentPartialOrderChange:(UISegmentedControl *)segmentControl
{
    [tblViewBill reloadData];
}


#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayCustomizedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"Cell"];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 5, screen_width, 100)];
        viewBG.tag = 1;
        viewBG.backgroundColor = [UIColor clearColor];
        //viewBG.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:viewBG];
        
        
        float yAxis = 20*MULTIPLYHEIGHT;
        
        float imgWX = 11*MULTIPLYHEIGHT;
        float imgWWidth = 29*MULTIPLYHEIGHT;
        
        UIImageView *imgWashType = [[UIImageView alloc]initWithFrame:CGRectMake(imgWX, yAxis, imgWWidth, imgWWidth)];
        imgWashType.tag = 2;
        imgWashType.contentMode = UIViewContentModeScaleAspectFit;
        [viewBG addSubview:imgWashType];
        
        
        float lblWX = imgWX+imgWWidth+11*MULTIPLYHEIGHT;
        float minusWidth = 85*MULTIPLYHEIGHT;
        float lblWWidth = lblWX+minusWidth;
        float lblWHeight = 15*MULTIPLYHEIGHT;
        
        UILabel *lblWashType = [[UILabel alloc]initWithFrame:CGRectMake(lblWX, yAxis, lblWWidth+5*MULTIPLYHEIGHT, lblWHeight)];
        lblWashType.tag = 3;
        lblWashType.numberOfLines = 0;
        lblWashType.textColor = [UIColor grayColor];
        lblWashType.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
        [viewBG addSubview:lblWashType];
        
        float lblPWidth = 70*MULTIPLYHEIGHT;
        float lblPHeight = 15*MULTIPLYHEIGHT;
        float lblPX = 90*MULTIPLYHEIGHT;
        
        UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(screen_width-lblPX, yAxis, lblPWidth, lblPHeight)];
        lblPrice.tag = 5;
        lblPrice.textAlignment = NSTextAlignmentRight;
        lblPrice.textColor = [UIColor darkGrayColor];
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+2];
        [viewBG addSubview:lblPrice];
        
        yAxis += lblWHeight+15*MULTIPLYHEIGHT;
        
        
        UILabel *lblDetail = [[UILabel alloc]initWithFrame:CGRectMake(lblWX, yAxis, lblWWidth, lblWHeight)];
        lblDetail.tag = 4;
        lblDetail.numberOfLines = 0;
        lblDetail.textColor = [UIColor grayColor];
        lblDetail.backgroundColor = [UIColor clearColor];
        lblDetail.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
        [viewBG addSubview:lblDetail];
        
        yAxis += lblWHeight+15*MULTIPLYHEIGHT;
        
        UILabel *lblAddOns = [[UILabel alloc]initWithFrame:CGRectMake(lblWX, yAxis, lblWWidth, lblWHeight)];
        lblAddOns.tag = 7;
        lblAddOns.numberOfLines = 0;
        lblAddOns.textColor = [UIColor grayColor];
        lblAddOns.backgroundColor = [UIColor clearColor];
        lblAddOns.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1];
        [viewBG addSubview:lblAddOns];
        
        
        UIImageView *imgArrow = [[UIImageView alloc]init];
        imgArrow.tag = 6;
        imgArrow.contentMode = UIViewContentModeScaleAspectFit;
        imgArrow.image = [UIImage imageNamed:@"right_arrow"];
        [viewBG addSubview:imgArrow];
        
        CALayer *bottomLayerView = [[CALayer alloc]init];
        bottomLayerView.name = @"viewBG";
        CGFloat layerX = 40*MULTIPLYHEIGHT;
        bottomLayerView.frame = CGRectMake(layerX, viewBG.frame.size.height-1, viewBG.frame.size.width-(layerX*2), 1);
        bottomLayerView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
        [viewBG.layer addSublayer:bottomLayerView];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    float yAxis = 0;
    
    UIView *viewBG = (UIView *) [cell.contentView viewWithTag:1];
    UIImageView *imgWashType = (UIImageView *) [cell.contentView viewWithTag:2];
    
    UILabel *lblWashType = (UILabel *) [cell.contentView viewWithTag:3];
    
    UILabel *lblDetail = (UILabel *) [cell.contentView viewWithTag:4];
    
    UILabel *lblPrice = (UILabel *) [cell.contentView viewWithTag:5];
    
    UIImageView *imgArrow = (UIImageView *) [cell.contentView viewWithTag:6];
    
    UILabel *lblAddOns = (UILabel *) [cell.contentView viewWithTag:7];
    lblAddOns.text = @"";
    
    NSDictionary *dictDetail = [arrayCustomizedData objectAtIndex:indexPath.row];
    
    NSArray *arrayDetail = [dictDetail objectForKey:@"STItems"];
    
    NSString *strWashType = [dictDetail objectForKey:@"serviceType"];
    NSString *strServiceName = [dictDetail objectForKey:@"serviceTypeName"];
    
    NSString *strTi = @"";
    
    if ([strServiceName length])
    {
        strTi = [strServiceName uppercaseString];
    }
    else
    {
        strTi = [strWashType uppercaseString];
    }
    
    lblWashType.text = strTi;
    
    CGFloat lblWH = [AppDelegate getLabelHeightForMediumText:strTi WithWidth:lblWashType.frame.size.width FontSize:lblWashType.font.pointSize];
    
    CGRect frame = lblWashType.frame;
    frame.size.height = lblWH;
    lblWashType.frame = frame;
    
    if ([strWashType caseInsensitiveCompare:SERVICETYPE_WF] == NSOrderedSame)
    {
        if ([arrayDetail count])
        {
            NSDictionary *dictDetail = [arrayDetail objectAtIndex:0];
            
            lblDetail.text = [NSString stringWithFormat:@"Number of kgs - %.2f", [[dictDetail objectForKey:@"weight"] floatValue]];
            lblPrice.text = [NSString stringWithFormat:@"$%.2f", [[dictDetail objectForKey:@"totalPrice"] floatValue]];
        }
        
        yAxis = lblWashType.frame.origin.y+lblWashType.frame.size.height;
        
        yAxis += 30*MULTIPLYHEIGHT;
        
        imgWashType.image = [UIImage imageNamed:@"loadwash_price"];
        
        imgArrow.hidden = YES;
    }
    else if ([strWashType caseInsensitiveCompare:SERVICETYPE_CA] == NSOrderedSame)
    {
        if ([arrayDetail count])
        {
            NSDictionary *dictDetail = [arrayDetail objectAtIndex:0];
            
            lblDetail.text = [NSString stringWithFormat:@"Number of sqfts - %.2f", [[dictDetail objectForKey:@"weight"] floatValue]];
            lblPrice.text = [NSString stringWithFormat:@"$%.2f", [[dictDetail objectForKey:@"totalPrice"] floatValue]];
        }
        
        yAxis = lblWashType.frame.origin.y+lblWashType.frame.size.height;
        
        yAxis += 30*MULTIPLYHEIGHT;
        
        imgWashType.image = [UIImage imageNamed:@"carpet_price"];
        
        imgArrow.hidden = YES;
    }
    else
    {
        if ([strWashType caseInsensitiveCompare:SERVICETYPE_DC] == NSOrderedSame || [strWashType caseInsensitiveCompare:SERVICETYPE_HL_DC] == NSOrderedSame)
        {
            imgWashType.image = [UIImage imageNamed:@"dryclean_price"];
        }
        else if ([strWashType caseInsensitiveCompare:SERVICETYPE_HL_DCG] == NSOrderedSame || [strWashType caseInsensitiveCompare:SERVICETYPE_DCG] == NSOrderedSame)
        {
            imgWashType.image = [UIImage imageNamed:@"dcg_price"];
        }
        else if ([strWashType caseInsensitiveCompare:SERVICETYPE_WI] == NSOrderedSame || [strWashType caseInsensitiveCompare:SERVICETYPE_HL_WI] == NSOrderedSame)
        {
            imgWashType.image = [UIImage imageNamed:@"wash_iron_price"];
        }
        else if ([strWashType caseInsensitiveCompare:SERVICETYPE_IR] == NSOrderedSame)
        {
            imgWashType.image = [UIImage imageNamed:@"ironing_price"];
        }
        else if ([strWashType caseInsensitiveCompare:SERVICETYPE_LE] == NSOrderedSame)
        {
            imgWashType.image = [UIImage imageNamed:@"leather_price"];
        }
        else if ([strWashType containsString:SERVICETYPE_CC])
        {
            imgWashType.image = [UIImage imageNamed:@"curtains_price"];
        }
        else if ([strWashType containsString:SERVICETYPE_BAG])
        {
            imgWashType.image = [UIImage imageNamed:@"bag_price"];
        }
        else if ([strWashType containsString:SERVICETYPE_SHOE])
        {
            imgWashType.image = [UIImage imageNamed:@"shoe_price"];
        }
        
        NSString *strType = @"";
        float Price = 0;
        
        BOOL isColorCodeFound = NO;
        
        NSMutableDictionary *dictExtraReq = [[NSMutableDictionary alloc]init];
        
        for (NSDictionary *dict1 in arrayDetail)
        {
            NSArray *arrayItemCode = [dict1 allKeys];
            
            for (NSString *strCode in arrayItemCode)
            {
                NSArray *arrayItems = [dict1 objectForKey:strCode];
                
                NSDictionary *dict2 = [arrayItems objectAtIndex:0];
                
                if ([dict2 objectForKey:@"itemName"])
                {
                    NSString *strI = [[[dict2 objectForKey:@"itemName"] componentsSeparatedByString:@"^^"] objectAtIndex:0];
                    
                    if ([[dict2 objectForKey:@"weight"] floatValue] == 0.0)
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %ld\n", strI, [arrayItems count]];
                    }
                    else
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %.2f kgs\n", strI, [[dict2 objectForKey:@"weight"] floatValue]];
                    }
                }
                else
                {
                    if ([[dict2 objectForKey:@"weight"] floatValue] == 0.0)
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %ld\n", [dict2 objectForKey:@"itemCode"], [arrayItems count]];
                    }
                    else
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %.2f kgs\n", [dict2 objectForKey:@"itemCode"], [[dict2 objectForKey:@"weight"] floatValue]];
                    }
                }
                
                for (NSDictionary *dict3 in arrayItems)
                {
                    NSDictionary *dictExR = [dict3 objectForKey:@"extraRequirment"];
                    
                    NSMutableArray *arrayKey = [[NSMutableArray alloc]init];
                    NSMutableArray *arrayKeyCost = [[NSMutableArray alloc]init];
                    
                    if ([[dictExR objectForKey:@"shirts"] containsString:@"Fold"])
                    {
                        [arrayKey addObject:@"Folded Shirts"];
                        [arrayKeyCost addObject: @"shirtsFoldCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"trousersHanger"] containsString:@"Clip Hanger"])
                    {
                        [arrayKey addObject:@"Clip-hanged Trousers"];
                        [arrayKeyCost addObject: @"trousersClipHangerCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"interiorCleaning"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Interior Cleaning"];
                        [arrayKeyCost addObject: @"interiorCleaningCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"antiBacterialCleaning"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Anti-Bacterial Cleaning"];
                        [arrayKeyCost addObject: @"antiBacterialCleaningCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"hydrophobicCoating"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Hydrophobic Coating"];
                        [arrayKeyCost addObject: @"hydrophobicCoatingCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"bagsSilkBandeau"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Bags Silk Bandeau"];
                        [arrayKeyCost addObject: @"bagsSilkBandeauCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"stainRemoval"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Stain Removal"];
                        [arrayKeyCost addObject: @"stainRemovalCost"];
                    }
                    
                    for (int p = 0; p < [arrayKey count]; p++)
                    {
                        NSString *strKey = [arrayKey objectAtIndex:p];
                        
                        if ([dictExtraReq objectForKey:strKey])
                        {
                            NSInteger count = [[dictExtraReq objectForKey:strKey] integerValue];
                            
                            count ++;
                            
                            [dictExtraReq setObject:[NSString stringWithFormat:@"%ld", count] forKey:strKey];
                        }
                        else
                        {
                            [dictExtraReq setObject:@"1" forKey:strKey];
                        }
                    }
                }
                
                for (NSDictionary *dict3 in arrayItems)
                {
                    Price += [[dict3 objectForKey:@"totalPrice"] floatValue];
                    
                    if ([[dict3 objectForKey:@"brand"] length])
                    {
                        isColorCodeFound = YES;
                    }
                }
            }
        }
        
        if (isColorCodeFound && ![strWashType containsString:@"CC_"])
        {
            imgArrow.hidden = NO;
        }
        else
        {
            imgArrow.hidden = YES;
        }
        
        strType = [strType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:strType];
        
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.alignment = NSTextAlignmentLeft;
        [paragrapStyle setLineSpacing:4.0f];
        [paragrapStyle setMaximumLineHeight:100.0f];
        
        [attr addAttributes:@{NSParagraphStyleAttributeName:paragrapStyle, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:lblDetail.font.pointSize]} range:NSMakeRange(0, attr.length)];
        
        CGSize frameSize = [AppDelegate getAttributedTextHeightForText:attr WithWidth:lblDetail.frame.size.width];
        
        if (frameSize.height <= 20)
        {
            frameSize.height = 20;
        }
        
        lblDetail.attributedText = attr;
        
        CGRect frame = lblDetail.frame;
        frame.size.height = frameSize.height;
        lblDetail.frame = frame;
        
        lblPrice.text = [NSString stringWithFormat:@"$%.2f", Price];
        
        yAxis = lblDetail.frame.origin.y+lblDetail.frame.size.height;
        
        lblAddOns.text = @"";
        
        if ([dictExtraReq count])
        {
            yAxis += 10*MULTIPLYHEIGHT;
            
            NSString *strText = @"Add-ons";
            
            NSString *strAddOn = @"";
            
            for (NSString *key in dictExtraReq)
            {
                strAddOn = [strAddOn stringByAppendingFormat:@"%@ - %@\n", key, [dictExtraReq objectForKey:key]];
            }
            
            NSString *strFull = [NSString stringWithFormat:@"%@\n%@", strText, strAddOn];
            
            NSMutableAttributedString *attrAddOn = [[NSMutableAttributedString alloc]initWithString:strFull];
            
            [attrAddOn setAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-1], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, strText.length)];
            
            [attrAddOn setAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(strText.length+1, strAddOn.length)];
            
            NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
            paragrapStyle.alignment = NSTextAlignmentLeft;
            [paragrapStyle setLineSpacing:4.0f];
            [paragrapStyle setMaximumLineHeight:100.0f];
            
            [attrAddOn addAttributes:@{NSParagraphStyleAttributeName:paragrapStyle} range:NSMakeRange(0, attrAddOn.length)];
            
            CGSize sizeAtt = [AppDelegate getAttributedTextHeightForText:attrAddOn WithWidth:lblAddOns.frame.size.width];
            
            lblAddOns.attributedText = attrAddOn;
            
            CGRect rect = lblAddOns.frame;
            rect.origin.y = yAxis;
            rect.size.height = sizeAtt.height;
            lblAddOns.frame = rect;
            
            yAxis = lblAddOns.frame.origin.y+lblAddOns.frame.size.height;
        }
    }
    
    float viewbgY = 0*MULTIPLYHEIGHT;
    
    yAxis += 20*MULTIPLYHEIGHT;
    
    viewBG.frame = CGRectMake(0, viewbgY, screen_width, yAxis);
    
    for (CALayer *layer in [viewBG.layer sublayers])
    {
        if ([[layer name] isEqualToString:@"viewBG"])
        {
            CGRect rectL = layer.frame;
            rectL.origin.y = viewBG.frame.size.height-1;
            layer.frame = rectL;
        }
    }
    
    //    CGRect rect = imgWashType.frame;
    //    rect.origin.y = (yAxis/2)-(imgWashType.frame.size.height/2);
    //    imgWashType.frame = rect;
    
    
    float imgAWidth = 8*MULTIPLYHEIGHT;
    float minusArrowY = 15*MULTIPLYHEIGHT;
    imgArrow.frame = CGRectMake(screen_width-minusArrowY, (yAxis/2)-(imgAWidth/2), imgAWidth, imgAWidth);
    
    CGRect rectPrice = lblPrice.frame;
    rectPrice.origin.y = yAxis/2-lblPrice.frame.size.height/2;
    lblPrice.frame = rectPrice;
    
    return cell;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dictDetail = [arrayCustomizedData objectAtIndex:indexPath.row];
    
    NSArray *arrayDetail = [dictDetail objectForKey:@"STItems"];
    
    NSString *strWashType = [dictDetail objectForKey:@"serviceType"];
    
    float yAxis = 20*MULTIPLYHEIGHT;
    
    float imgWX = 11*MULTIPLYHEIGHT;
    float imgWWidth = 29*MULTIPLYHEIGHT;
    
    float lblWX = imgWX+imgWWidth+11*MULTIPLYHEIGHT;
    float minusWidth = 85*MULTIPLYHEIGHT;
    float lblWWidth = lblWX+minusWidth;
    float lblWHeight = 15*MULTIPLYHEIGHT;
    
    yAxis += lblWHeight+15*MULTIPLYHEIGHT;
    
    if ([strWashType caseInsensitiveCompare:SERVICETYPE_WF] == NSOrderedSame  || [strWashType isEqualToString:SERVICETYPE_CA])
    {
        yAxis += lblWHeight;
        
        yAxis += 20*MULTIPLYHEIGHT;
    }
    else
    {
        NSString *strType = @"";
        
        NSMutableDictionary *dictExtraReq = [[NSMutableDictionary alloc]init];
        
        for (NSDictionary *dict1 in arrayDetail)
        {
            NSArray *arrayItemCode = [dict1 allKeys];
            
            for (NSString *strCode in arrayItemCode)
            {
                NSArray *arrayItems = [dict1 objectForKey:strCode];
                
                NSDictionary *dict2 = [arrayItems objectAtIndex:0];
                
                if ([dict2 objectForKey:@"itemName"])
                {
                    NSString *strI = [[[dict2 objectForKey:@"itemName"] componentsSeparatedByString:@"^^"] objectAtIndex:0];
                    
                    if ([[dict2 objectForKey:@"weight"] floatValue] == 0.0)
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %ld\n", strI, [arrayItems count]];
                    }
                    else
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %.2f kgs\n", strI, [[dict2 objectForKey:@"weight"] floatValue]];
                    }
                }
                else
                {
                    if ([[dict2 objectForKey:@"weight"] floatValue] == 0.0)
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %ld\n", [dict2 objectForKey:@"itemCode"], [arrayItems count]];
                    }
                    else
                    {
                        strType = [strType stringByAppendingFormat:@"%@ - %.2f kgs\n", [dict2 objectForKey:@"itemCode"], [[dict2 objectForKey:@"weight"] floatValue]];
                    }
                }
                
                for (NSDictionary *dict3 in arrayItems)
                {
                    NSDictionary *dictExR = [dict3 objectForKey:@"extraRequirment"];
                    
                    NSMutableArray *arrayKey = [[NSMutableArray alloc]init];
                    NSMutableArray *arrayKeyCost = [[NSMutableArray alloc]init];
                    
                    if ([[dictExR objectForKey:@"shirts"] containsString:@"Fold"])
                    {
                        [arrayKey addObject:@"Folded Shirts"];
                        [arrayKeyCost addObject: @"shirtsFoldCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"trousersHanger"] containsString:@"Clip Hanger"])
                    {
                        [arrayKey addObject:@"Clip-hanged Trousers"];
                        [arrayKeyCost addObject: @"trousersClipHangerCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"interiorCleaning"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Interior Cleaning"];
                        [arrayKeyCost addObject: @"interiorCleaningCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"antiBacterialCleaning"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Anti-Bacterial Cleaning"];
                        [arrayKeyCost addObject: @"antiBacterialCleaningCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"hydrophobicCoating"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Hydrophobic Coating"];
                        [arrayKeyCost addObject: @"hydrophobicCoatingCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"bagsSilkBandeau"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Bags Silk Bandeau"];
                        [arrayKeyCost addObject: @"bagsSilkBandeauCost"];
                    }
                    
                    if ([[dictExR objectForKey:@"stainRemoval"] intValue] == 1)
                    {
                        [arrayKey addObject:@"Stain Removal"];
                        [arrayKeyCost addObject: @"stainRemovalCost"];
                    }
                    
                    for (int p = 0; p < [arrayKey count]; p++)
                    {
                        NSString *strKey = [arrayKey objectAtIndex:p];
                        
                        if ([dictExtraReq objectForKey:strKey])
                        {
                            NSInteger count = [[dictExtraReq objectForKey:strKey] integerValue];
                            
                            count ++;
                            
                            [dictExtraReq setObject:[NSString stringWithFormat:@"%ld", count] forKey:strKey];
                        }
                        else
                        {
                            [dictExtraReq setObject:@"1" forKey:strKey];
                        }
                    }
                }
            }
        }
        
        strType = [strType stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:strType];
        
        NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapStyle.alignment = NSTextAlignmentLeft;
        [paragrapStyle setLineSpacing:4.0f];
        [paragrapStyle setMaximumLineHeight:100.0f];
        
        [attr addAttributes:@{NSParagraphStyleAttributeName:paragrapStyle, NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]} range:NSMakeRange(0, attr.length)];
        
        CGSize frameSize = [AppDelegate getAttributedTextHeightForText:attr WithWidth:lblWWidth];
        
        if (frameSize.height <= 20)
        {
            frameSize.height = 20;
        }
        
        yAxis += frameSize.height+20*MULTIPLYHEIGHT;
        
        if ([dictExtraReq count])
        {
            NSString *strText = @"Add-ons";
            
            NSString *strAddOn = @"";
            
            for (NSString *key in dictExtraReq)
            {
                strAddOn = [strAddOn stringByAppendingFormat:@"%@ - %@\n", key, [dictExtraReq objectForKey:key]];
            }
            
            NSString *strFull = [NSString stringWithFormat:@"%@\n%@", strText, strAddOn];
            
            NSMutableAttributedString *attrAddOn = [[NSMutableAttributedString alloc]initWithString:strFull];
            
            [attrAddOn setAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-1], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, strText.length)];
            
            [attrAddOn setAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(strText.length+1, strAddOn.length)];
            
            CGSize sizeAtt = [AppDelegate getAttributedTextHeightForText:attrAddOn WithWidth:lblWWidth];
            
            yAxis += sizeAtt.height + 10*MULTIPLYHEIGHT;
        }
    }
    
    return yAxis;
}

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
    NSDictionary *dictDetail = [arrayCustomizedData objectAtIndex:indexPath.row];
    
    NSArray *arrayDetail = [dictDetail objectForKey:@"STItems"];
    
    NSString *strWashType = [dictDetail objectForKey:@"serviceType"];
    
    if ([strWashType caseInsensitiveCompare:SERVICETYPE_WF] == NSOrderedSame  || [strWashType isEqualToString:SERVICETYPE_CA] || [strWashType containsString:@"CC_"])
    {
        return;
    }
    
    BOOL isColorCodeFound = NO;
    
    for (NSDictionary *dict1 in arrayDetail)
    {
        NSArray *arrayItemCode = [dict1 allKeys];
        
        NSArray *arrayItems = [dict1 objectForKey:[arrayItemCode objectAtIndex:0]];
        
        for (NSDictionary *dict3 in arrayItems)
        {
            if ([[dict3 objectForKey:@"brand"] length])
            {
                isColorCodeFound = YES;
                break;
            }
        }
    }
    
    for (int i = 0; i < [arrayCustomizedData count]; i++)
    {
        NSDictionary *dict = [arrayCustomizedData objectAtIndex:i];
        
        if ([[dict objectForKey:@"serviceType"] isEqualToString:strWashType])
        {
            if (isColorCodeFound)
            {
                ViewBillDetailsController *vbdvc = [[ViewBillDetailsController alloc]init];
                vbdvc.dictViewBill = [[NSMutableDictionary alloc]initWithDictionary:[[dict objectForKey:@"STItems"] objectAtIndex:0]];
                vbdvc.strWashType = strWashType;
                [self.navigationController pushViewController:vbdvc animated:YES];
            }
            else
            {
                [appDel showAlertWithMessage:@"Details of garments are not available yet. Please check back later." andTitle:@"" andBtnTitle:@"OK"];
            }
            
            return;
        }
    }
}


- (void)closeScheduleScreen:(UIButton *)sender
{
    
    [UIView transitionWithView:self.navigationController.view.superview duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
        [self.navigationController removeFromParentViewController];
        [self.navigationController.view removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
        
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
