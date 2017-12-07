//
//  ViewBillDetailsController.m
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "ViewBillDetailsController.h"
#import "NSNull+JSON.h"


@interface ViewBillDetailsController ()
{
    AppDelegate *appDel;
}

@end

@implementation ViewBillDetailsController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float yPos = 25*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 40)];
    NSString *string = @"VIEW BILL";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(10, yPos, 40.0, 40.0);
    [closeBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:closeBtn];
    
    yPos += 40+10*MULTIPLYHEIGHT;
    
    
    tblViewBill = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, screen_height-yPos) style:UITableViewStylePlain];
    tblViewBill.dataSource = self;
    tblViewBill.delegate = self;
    tblViewBill.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblViewBill];
    
    CALayer *bottomLayerLbl = [[CALayer alloc]init];
    bottomLayerLbl.frame = CGRectMake(0, yPos, screen_width, 1);
    bottomLayerLbl.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    [self.view.layer addSublayer:bottomLayerLbl];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDel hideTabBar:appDel.customTabBarController];
}

-(void) closeScheduleScreen:(id)sender
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
    return [self.dictViewBill count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"Cell"];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *viewBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 100)];
    viewBG.tag = 1;
    //viewBG.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.4];
    //viewBG.backgroundColor = [UIColor redColor];
    [cell.contentView addSubview:viewBG];
    
    CGFloat lblX = 10*MULTIPLYHEIGHT;
    CGFloat lblHeight = 20*MULTIPLYHEIGHT;
    CGFloat lblIY = 15*MULTIPLYHEIGHT;
    
    CGFloat lblPX = 90*MULTIPLYHEIGHT;
    
    UILabel *lblItemType = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblIY, screen_width-lblPX, lblHeight)];
    lblItemType.textColor = [UIColor grayColor];
    lblItemType.numberOfLines = 0;
    lblItemType.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    [viewBG addSubview:lblItemType];
    
    CGFloat lblPWidth = 70*MULTIPLYHEIGHT;
    CGFloat lblPHeight = 20*MULTIPLYHEIGHT;
    
    UILabel *lblTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(screen_width-lblPX, lblIY, lblPWidth, lblPHeight)];
    lblTotalPrice.textColor = [UIColor darkGrayColor];
    lblTotalPrice.textAlignment = NSTextAlignmentRight;
    lblTotalPrice.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+3];
    [viewBG addSubview:lblTotalPrice];
    
    NSMutableArray *arrTable = [self.dictViewBill objectForKey:[[self.dictViewBill allKeys] objectAtIndex:indexPath.row]];
    
    CGFloat totalPrice = 0;
    
    CGFloat yAxis = 0;
    
    for (int i=0; i<[arrTable count]; i++)
    {
        NSDictionary *dictDetail = [arrTable objectAtIndex:i];
        
        if (i == 0)
        {
            NSArray *arraI = [[dictDetail objectForKey:@"itemName"] componentsSeparatedByString:@"^^"];
            
            NSString *strI = @"";
            
            if ([arraI count] > 1)
            {
                strI = [[[[dictDetail objectForKey:@"itemName"] componentsSeparatedByString:@"^^"] objectAtIndex:0] uppercaseString];
            }
            else
            {
                strI = [[dictDetail objectForKey:@"itemName"] uppercaseString];
            }
            
            NSString *strItemName = @"";
            
            if ([self.strWashType containsString:SERVICETYPE_SHOE])
            {
                if ([arrTable count] == 1)
                {
                    strItemName = [NSString stringWithFormat:@"%@ - %ld pair", strI, [arrTable count]];
                }
                else
                {
                    strItemName = [NSString stringWithFormat:@"%@ - %ld pairs", strI, [arrTable count]];
                }
            }
            else
            {
                strItemName = [NSString stringWithFormat:@"%@ - %ld", strI, [arrTable count]];
            }
            
            lblItemType.text = strItemName;
            
            CGFloat lblH = [AppDelegate getLabelHeightForMediumText:strItemName WithWidth:lblItemType.frame.size.width FontSize:lblItemType.font.pointSize];
            
            CGRect rect = lblItemType.frame;
            rect.size.height = lblH;
            lblItemType.frame = rect;
            
            yAxis = lblItemType.frame.origin.y + lblItemType.frame.size.height+10*MULTIPLYHEIGHT;
        }
        
        totalPrice += [[dictDetail objectForKey:@"itemPrice"] floatValue];
        
        NSArray *arraI = [[dictDetail objectForKey:@"itemName"] componentsSeparatedByString:@"^^"];
        
        NSString *strI = @"";
        
        if ([arraI count] > 1)
        {
            strI = [NSString stringWithFormat:@"%@ @ $%.2f", [[[dictDetail objectForKey:@"itemName"] componentsSeparatedByString:@"^^"] objectAtIndex:1], [[dictDetail objectForKey:@"itemPrice"] floatValue]];
        }
        else
        {
            strI = [NSString stringWithFormat:@"%@ @ $%.2f", [dictDetail objectForKey:@"itemName"], [[dictDetail objectForKey:@"itemPrice"] floatValue]];
        }
        
        UILabel *lblCategory = [[UILabel alloc]initWithFrame:CGRectMake(lblX, yAxis, screen_width-lblX-20*MULTIPLYHEIGHT, lblHeight)];
        lblCategory.numberOfLines = 0;
        lblCategory.text = strI;
        lblCategory.textColor = [UIColor grayColor];
        lblCategory.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [viewBG addSubview:lblCategory];
        
        yAxis += lblHeight;
        
        CGFloat viewColorHeight = 13*MULTIPLYHEIGHT;
        
        UIImageView *imgColor = [[UIImageView alloc]initWithFrame:CGRectMake(lblX, yAxis, viewColorHeight, viewColorHeight)];
        
        if ([[dictDetail objectForKey:@"colorCode"] length] > 1)
        {
            imgColor.backgroundColor = [UIColor colorFromHexString:[dictDetail objectForKey:@"colorCode"]];
        }
        else
        {
            imgColor.backgroundColor = [UIColor colorFromHexString:@"#ffffff"];
        }
        
        imgColor.layer.cornerRadius = imgColor.frame.size.width/2;
        [viewBG addSubview:imgColor];
        
        CGFloat lblBX = lblX+viewColorHeight+3*MULTIPLYHEIGHT;
        CGFloat lblBW = screen_width-(lblBX+20*MULTIPLYHEIGHT);
        
        UILabel *lblBrandName = [[UILabel alloc]initWithFrame:CGRectMake(lblBX, yAxis, lblBW, viewColorHeight)];
        lblBrandName.textColor = [UIColor grayColor];
        
        if ([[dictDetail objectForKey:@"brand"] length])
        {
            lblBrandName.text = [dictDetail objectForKey:@"brand"];
        }
        else
        {
            lblBrandName.text = @"N/A";
        }
        
        lblBrandName.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
        [viewBG addSubview:lblBrandName];
        
        yAxis += viewColorHeight+10*MULTIPLYHEIGHT;
        
        NSMutableDictionary *dictExtraReq = [[NSMutableDictionary alloc]init];
        
        NSDictionary *dictExR = [dictDetail objectForKey:@"extraRequirment"];
        
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
            NSString *strCostKey = [arrayKeyCost objectAtIndex:p];
            
            [dictExtraReq setObject:[NSString stringWithFormat:@"%.2f", [[dictExR objectForKey:strCostKey] floatValue]] forKey:strKey];
        }
        
        if ([dictExtraReq count])
        {
            UILabel *lblAddOns = [[UILabel alloc]initWithFrame:CGRectMake(lblX, yAxis, 100, 10)];
            lblAddOns.numberOfLines = 0;
            lblAddOns.textColor = [UIColor grayColor];
            lblAddOns.backgroundColor = [UIColor clearColor];
            lblAddOns.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1];
            [viewBG addSubview:lblAddOns];
            
            NSString *strText = @"Add-ons";
            
            NSString *strAddOn = @"";
            
            for (NSString *key in dictExtraReq)
            {
                NSString *strPrice = [dictExtraReq objectForKey:key];
                
                totalPrice += [strPrice floatValue];
                
                if ([self.strWashType containsString:SERVICETYPE_SHOE])
                {
                    strAddOn = [strAddOn stringByAppendingFormat:@"%@ @ $%@ per pair\n", key, strPrice];
                }
                else
                {
                    strAddOn = [strAddOn stringByAppendingFormat:@"%@ @ $%@\n", key, strPrice];
                }
            }
            
            if ([strAddOn hasSuffix:@"\n"])
            {
                strAddOn = [strAddOn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
            
            CGFloat lblAW = screen_width-30*MULTIPLYHEIGHT;
            
            CGSize sizeAtt = [AppDelegate getAttributedTextHeightForText:attrAddOn WithWidth:lblAW];
            
            lblAddOns.attributedText = attrAddOn;
            
            CGRect rect = lblAddOns.frame;
            rect.origin.y = yAxis;
            rect.origin.x += 14*MULTIPLYHEIGHT;
            rect.size.width = lblAW;
            rect.size.height = sizeAtt.height;
            lblAddOns.frame = rect;
            
            yAxis += sizeAtt.height+10*MULTIPLYHEIGHT;
        }
    }
    
    yAxis += 5*MULTIPLYHEIGHT;
    
    lblTotalPrice.text = [NSString stringWithFormat:@"$%.2f", totalPrice];
    
    viewBG.frame = CGRectMake(0, 0, screen_width, yAxis);
    
    CALayer *bottomLayerView = [[CALayer alloc]init];
    bottomLayerView.name = @"viewBG";
    CGFloat layerX = 40*MULTIPLYHEIGHT;
    bottomLayerView.frame = CGRectMake(layerX, viewBG.frame.size.height-1, viewBG.frame.size.width-(layerX*2), 1);
    bottomLayerView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    [viewBG.layer addSublayer:bottomLayerView];
    
    return cell;
}

#pragma mark TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arrTable = [self.dictViewBill objectForKey:[[self.dictViewBill allKeys] objectAtIndex:indexPath.row]];
    
    float yAxis = 15*MULTIPLYHEIGHT;
    
    for (int i=0; i<[arrTable count]; i++)
    {
        NSDictionary *dictDetail = [arrTable objectAtIndex:i];
        
        if (i == 0)
        {
            CGFloat lblPX = 90*MULTIPLYHEIGHT;
            
            NSArray *arraI = [[dictDetail objectForKey:@"itemName"] componentsSeparatedByString:@"^^"];
            
            NSString *strI = @"";
            
            if ([arraI count] > 1)
            {
                strI = [[[[dictDetail objectForKey:@"itemName"] componentsSeparatedByString:@"^^"] objectAtIndex:0] uppercaseString];
            }
            else
            {
                strI = [[dictDetail objectForKey:@"itemName"] uppercaseString];
            }
            
            NSString *strItemName = @"";
            
            if ([self.strWashType containsString:SERVICETYPE_SHOE])
            {
                if ([arrTable count] == 1)
                {
                    strItemName = [NSString stringWithFormat:@"%@ - %ld pair", strI, [arrTable count]];
                }
                else
                {
                    strItemName = [NSString stringWithFormat:@"%@ - %ld pairs", strI, [arrTable count]];
                }
            }
            else
            {
                strItemName = [NSString stringWithFormat:@"%@ - %ld", strI, [arrTable count]];
            }
            
            CGFloat lblH = [AppDelegate getLabelHeightForMediumText:strItemName WithWidth:screen_width-lblPX FontSize:appDel.FONT_SIZE_CUSTOM-2];
            
            yAxis += lblH + 10*MULTIPLYHEIGHT;
        }
        
        yAxis += 20*MULTIPLYHEIGHT;
        
        CGFloat viewColorHeight = 13*MULTIPLYHEIGHT;
        
        yAxis += viewColorHeight+10*MULTIPLYHEIGHT;
        
        NSMutableDictionary *dictExtraReq = [[NSMutableDictionary alloc]init];
        
        NSDictionary *dictExR = [dictDetail objectForKey:@"extraRequirment"];
        
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
            NSString *strCostKey = [arrayKeyCost objectAtIndex:p];
            
            [dictExtraReq setObject:[NSString stringWithFormat:@"%.2f", [[dictExR objectForKey:strCostKey] floatValue]] forKey:strKey];
        }
        
        if ([dictExtraReq count])
        {
            NSString *strText = @"Add-ons";
            
            NSString *strAddOn = @"";
            
            for (NSString *key in dictExtraReq)
            {
                NSString *strPrice = [dictExtraReq objectForKey:key];
                
                strAddOn = [strAddOn stringByAppendingFormat:@"%@ @ $%@\n", key, strPrice];
            }
            
            if ([strAddOn hasSuffix:@"\n"])
            {
                strAddOn = [strAddOn stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
            
            CGFloat lblAW = screen_width-30*MULTIPLYHEIGHT;
            
            CGSize sizeAtt = [AppDelegate getAttributedTextHeightForText:attrAddOn WithWidth:lblAW];
            
            yAxis += sizeAtt.height+10*MULTIPLYHEIGHT;
        }
    }
    
    yAxis += 5*MULTIPLYHEIGHT;
    
    return yAxis;
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
