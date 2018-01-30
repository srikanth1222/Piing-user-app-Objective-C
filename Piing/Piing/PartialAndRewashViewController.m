//
//  PartialAndRewashViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 27/04/17.
//  Copyright © 2017 shashank. All rights reserved.
//

#import "PartialAndRewashViewController.h"

@interface PartialAndRewashViewController () <UITableViewDelegate, UITableViewDataSource>
{
    AppDelegate *appDel;
    
    UITableView *tblViewBill;
    
    UILabel *lblOrderNumber;
    
    UILabel *lblFinalAmount;
    
    NSMutableDictionary *dictMain;
    NSMutableDictionary *dictViewBill;
    NSMutableDictionary *dictPartialOrder;
    
    NSMutableArray *arrayWashType;
    NSMutableArray *arrayWashTypeImages;
    
    UILabel *lblTitle;
    
    NSDictionary *dictAll;
    
    UIButton *btnDiscount;
    
    NSMutableArray *arrayViewBill;
    NSMutableArray *arrayMainData;
    
    NSMutableArray *arrayCustomizedData;
    
}

@end

@implementation PartialAndRewashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    dictMain = [[NSMutableDictionary alloc]init];
    dictViewBill = [[NSMutableDictionary alloc]init];
    dictPartialOrder = [[NSMutableDictionary alloc]init];
    arrayWashType = [[NSMutableArray alloc]init];
    arrayWashTypeImages = [[NSMutableArray alloc]init];
    
    arrayViewBill = [[NSMutableArray alloc]init];
    arrayMainData = [[NSMutableArray alloc]init];
    arrayCustomizedData = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float yPos = 25*MULTIPLYHEIGHT;
    
    lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 40)];
    NSString *string = @"UNDELIVERED/REWASH GARMENTS";
    [appDel spacingForTitle:lblTitle TitleString:string Spacing:1.0];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
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
    
    tblViewBill = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, screen_height-yPos) style:UITableViewStylePlain];
    tblViewBill.dataSource = self;
    tblViewBill.delegate = self;
    tblViewBill.backgroundColor = [UIColor clearColor];
    tblViewBill.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblViewBill];
    
    [self fetchViewBillData];
}


-(void) fetchViewBillData
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@bags/getbyorderid", BASE_URL];
    
    NSMutableDictionary *registrationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.strUserId, @"uid", self.strCobID, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:registrationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            [arrayViewBill removeAllObjects];
            [arrayViewBill addObjectsFromArray:[responseObj objectForKey:@"em"]];
            
            [self getCustomizedData];
            
            [tblViewBill reloadData];
        }
        else {
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}

-(void) getCustomizedData
{
    for (int i = 0; i < [arrayViewBill count]; i++)
    {
        NSDictionary *dictBag = [arrayViewBill objectAtIndex:i];
        
        if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:@"WF"] || [[dictBag objectForKey:@"serviceTypesId"] isEqualToString:@"CA"])
        {
            
        }
        else
        {
            NSArray *arrayData = [dictBag objectForKey:@"Bag"];
            
            for (int p = 0; p < [arrayData count]; p++)
            {
                NSArray *arrayItems = [[arrayData objectAtIndex:p] objectForKey:@"itemsDetailsFull"];
                
                NSMutableDictionary *dictItemsFull = [[NSMutableDictionary alloc]init];
                
                NSMutableDictionary *dictItemType = [[NSMutableDictionary alloc]init];
                
                for (int j = 0; j < [arrayItems count]; j++)
                {
                    NSDictionary *dictItem = [arrayItems objectAtIndex:j];
                    
                    if ([[dictItem objectForKey:@"status"] caseInsensitiveCompare:@"DE"] != NSOrderedSame)
                    {
                        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:dictItem];
                        
                        NSString *strItemCode = [dictItem objectForKey:@"itemType"];
                        
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
                }
                
                if ([dictItemType count])
                {
                    [dictItemsFull setObject:dictItemType forKey:@"itemsDetailsFull"];
                    
                    [dictItemsFull setObject:[[arrayData objectAtIndex:p] objectForKey:@"BagNo"] forKey:@"BagNo"];
                    [dictItemsFull setObject:[[arrayData objectAtIndex:p] objectForKey:@"Total"] forKey:@"Total"];
                    [dictItemsFull setObject:[[arrayData objectAtIndex:p] objectForKey:@"_id"] forKey:@"_id"];
                    
                    NSMutableArray *arrayBag = [[NSMutableArray alloc]initWithObjects:dictItemsFull, nil];
                    
                    NSMutableDictionary *dictBagPar = [[NSMutableDictionary alloc]initWithObjectsAndKeys:arrayBag, @"Bag", nil];
                    [dictBagPar setObject:[dictBag objectForKey:@"serviceTypesId"] forKey:@"serviceTypesId"];
                    [dictBagPar setObject:[dictBag objectForKey:@"_id"] forKey:@"_id"];
                    
                    if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_DC])
                    {
                        [dictBagPar setObject:@"Dry Cleaning" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_DCG])
                    {
                        [dictBagPar setObject:@"Green Dry Cleaning" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_WI])
                    {
                        [dictBagPar setObject:@"Wash & Iron" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_IR])
                    {
                        [dictBagPar setObject:@"Ironing" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_LE])
                    {
                        [dictBagPar setObject:@"Leather Cleaning" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_CC_DC])
                    {
                        [dictBagPar setObject:@"Curtains without installation - Dry Cleaning" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_CC_W_DC])
                    {
                        [dictBagPar setObject:@"Curtains with installation - Dry Cleaning" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_CC_WI])
                    {
                        [dictBagPar setObject:@"Curtains without installation - Wash & Iron" forKey:@"serviceTypeName"];
                    }
                    else if ([[dictBag objectForKey:@"serviceTypesId"] isEqualToString:SERVICETYPE_CC_W_WI])
                    {
                        [dictBagPar setObject:@"Curtains with installation - Wash & Iron" forKey:@"serviceTypeName"];
                    }
                    
                    [arrayMainData addObject:dictBagPar];
                }
            }
        }
    }
}


#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayMainData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"Cell"];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 5, screen_width, 100)];
    viewBG.tag = 1;
    viewBG.backgroundColor = [UIColor clearColor];
    //viewBG.backgroundColor = [UIColor yellowColor];
    [cell.contentView addSubview:viewBG];
    
    
    float yAxis = 10*MULTIPLYHEIGHT;
    
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
    
    UILabel *lblWashType = [[UILabel alloc]initWithFrame:CGRectMake(lblWX, yAxis+5*MULTIPLYHEIGHT, lblWWidth, lblWHeight)];
    lblWashType.tag = 3;
    lblWashType.textColor = [UIColor grayColor];
    lblWashType.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
    [viewBG addSubview:lblWashType];
    
    CALayer *bottomLayerView = [[CALayer alloc]init];
    bottomLayerView.name = @"viewBG";
    CGFloat layerX = 40*MULTIPLYHEIGHT;
    bottomLayerView.frame = CGRectMake(layerX, viewBG.frame.size.height-1, viewBG.frame.size.width-(layerX*2), 1);
    bottomLayerView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    [viewBG.layer addSublayer:bottomLayerView];
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dictDetail = [arrayMainData objectAtIndex:indexPath.row];
    
    NSArray *arrayDetail = [dictDetail objectForKey:@"Bag"];
    
    NSString *strWashType = [dictDetail objectForKey:@"serviceTypesId"];
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
    
    if ([strWashType caseInsensitiveCompare:@"DC"] == NSOrderedSame || [strWashType caseInsensitiveCompare:@"DCG"] == NSOrderedSame)
    {
        imgWashType.image = [UIImage imageNamed:@"dryclean_price"];
    }
    else if ([strWashType caseInsensitiveCompare:@"WI"] == NSOrderedSame)
    {
        imgWashType.image = [UIImage imageNamed:@"wash_iron_price"];
    }
    else if ([strWashType caseInsensitiveCompare:@"IR"] == NSOrderedSame)
    {
        imgWashType.image = [UIImage imageNamed:@"ironing_price"];
    }
    else if ([strWashType caseInsensitiveCompare:@"LE"] == NSOrderedSame)
    {
        imgWashType.image = [UIImage imageNamed:@"leather_price"];
    }
    else if ([strWashType containsString:@"CC"])
    {
        imgWashType.image = [UIImage imageNamed:@"curtains_price"];
    }
    
    float imgWHeight = 30*MULTIPLYHEIGHT;
    
    yAxis += imgWHeight+5*MULTIPLYHEIGHT;
    
    for (int i = 0; i < [arrayDetail count]; i++)
    {
        NSDictionary *dict1 = [arrayDetail objectAtIndex:i];
        
        NSDictionary *dict2 = [dict1 objectForKey:@"itemsDetailsFull"];
        
        NSArray *arrayGar = [dict2 allValues];
        
        for (int j = 0; j < [arrayGar count]; j++)
        {
            NSArray *arrayGar1 = [arrayGar objectAtIndex:j];
            
            for (int k = 0; k < [arrayGar1 count]; k++)
            {
                NSDictionary *dictGar = [arrayGar1 objectAtIndex:k];
                
                float xWidth = 20*MULTIPLYHEIGHT;
                
                float localYHeight = 0;
                
                UIView *view_Normal = [[UIView alloc]initWithFrame:CGRectMake(xWidth, yAxis, screen_width-50*MULTIPLYHEIGHT, 50*MULTIPLYHEIGHT)];
                view_Normal.backgroundColor = [UIColor clearColor];
                [cell.contentView addSubview:view_Normal];
                
                UILabel *lblItemName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view_Normal.frame.size.width, 20*MULTIPLYHEIGHT)];
                
                if ([dictGar objectForKey:@"itemName"])
                {
                    lblItemName.text = [[dictGar objectForKey:@"itemName"] uppercaseString];
                }
                else
                {
                    lblItemName.text = [[dictGar objectForKey:@"itemCode"] uppercaseString];
                }
                
                lblItemName.textColor = [UIColor darkGrayColor];
                lblItemName.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-1];
                [view_Normal addSubview:lblItemName];
                
                localYHeight += lblItemName.frame.size.height;
                
                CGFloat viewColorHeight = 13*MULTIPLYHEIGHT;
                
                UIImageView *imgColor = [[UIImageView alloc]initWithFrame:CGRectMake(0, localYHeight, viewColorHeight, viewColorHeight)];
                
                if ([[dictGar objectForKey:@"colorCode"] length] > 1)
                {
                    imgColor.backgroundColor = [UIColor colorFromHexString:[dictGar objectForKey:@"colorCode"]];
                }
                else
                {
                    imgColor.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
                }
                
                imgColor.layer.cornerRadius = imgColor.frame.size.width/2;
                [view_Normal addSubview:imgColor];
                
                float lblBX = viewColorHeight+3*MULTIPLYHEIGHT;
                
                UILabel *lblBrandName = [[UILabel alloc]initWithFrame:CGRectMake(lblBX, localYHeight, view_Normal.frame.size.width-lblBX, viewColorHeight)];
                lblBrandName.textColor = [UIColor grayColor];
                
                if ([[dictGar objectForKey:@"brand"] length] && [[dictGar objectForKey:@"brand"] caseInsensitiveCompare:@"na"] != NSOrderedSame)
                {
                    lblBrandName.text = [dictGar objectForKey:@"brand"];
                }
                else
                {
                    lblBrandName.text = @"N/A";
                }
                
                lblBrandName.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
                [view_Normal addSubview:lblBrandName];
                
                yAxis += 50*MULTIPLYHEIGHT;
            }
        }
    }
    
    float viewbgY = 0*MULTIPLYHEIGHT;
    
    yAxis += 5*MULTIPLYHEIGHT;
    
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
    
    return cell;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dictDetail = [arrayMainData objectAtIndex:indexPath.row];
    
    NSArray *arrayDetail = [dictDetail objectForKey:@"Bag"];
    
    float yAxis = 10*MULTIPLYHEIGHT;
    
    float imgWHeight = 30*MULTIPLYHEIGHT;
    
    yAxis += imgWHeight+5*MULTIPLYHEIGHT;
    
    for (int i = 0; i < [arrayDetail count]; i++)
    {
        NSDictionary *dict1 = [arrayDetail objectAtIndex:i];
        
        NSDictionary *dict2 = [dict1 objectForKey:@"itemsDetailsFull"];
        
        NSArray *arrayGar = [dict2 allValues];
        
        for (int j = 0; j < [arrayGar count]; j++)
        {
            NSArray *arrayGar1 = [arrayGar objectAtIndex:j];
            
            for (int k = 0; k < [arrayGar1 count]; k++)
            {
                //NSDictionary *dictGar = [arrayGar1 objectAtIndex:k];
                
                yAxis += 50*MULTIPLYHEIGHT;
            }
        }
    }
    
    yAxis += 5*MULTIPLYHEIGHT;
    
    return yAxis;
}

- (void)closeScheduleScreen:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
