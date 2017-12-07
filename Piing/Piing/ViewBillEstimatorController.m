//
//  ViewBillController.m
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "ViewBillEstimatorController.h"
#import "ViewBillDetailsController.h"
#import "NSNull+JSON.h"


@interface ViewBillEstimatorController ()
{
    AppDelegate *appDel;
    
    UITableView *tblViewBill;
    
    NSMutableArray *arrayWashType;
    NSMutableArray *arrayWashTypeImages;
}

@end

@implementation ViewBillEstimatorController

@synthesize dictMain;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    float yPos = 25*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 40)];
    NSString *string = @"COST ESTIMATOR";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(screen_width-45, yPos, 40.0, 40.0);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeScheduleScreen:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:closeBtn];
    
    yPos += 40+15*MULTIPLYHEIGHT;
    
    float height = 42*MULTIPLYHEIGHT;
    
    tblViewBill = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, screen_height-yPos-height) style:UITableViewStylePlain];
    tblViewBill.dataSource = self;
    tblViewBill.delegate = self;
    tblViewBill.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblViewBill];
    
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(0, tblViewBill.frame.origin.y, screen_width, 1);
    topLayer.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    [self.view.layer addSublayer:topLayer];
    
    UIView *view_Total = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height-height, screen_width, height)];
    view_Total.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.9];
    [self.view addSubview:view_Total];
    
    UILabel *lblFinalAmount = [[UILabel alloc]initWithFrame:CGRectMake(20*MULTIPLYHEIGHT, 0, screen_width-(20*MULTIPLYHEIGHT*2), height)];
    lblFinalAmount.textAlignment = NSTextAlignmentLeft;
    lblFinalAmount.text = @"FINAL  AMOUNT";
    lblFinalAmount.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM];
    lblFinalAmount.textColor = [UIColor whiteColor];
    lblFinalAmount.backgroundColor = [UIColor clearColor];
    [view_Total addSubview:lblFinalAmount];
    
    
    UILabel *lblAmountText = [[UILabel alloc]initWithFrame:CGRectMake(20*MULTIPLYHEIGHT, 0, screen_width-(20*MULTIPLYHEIGHT*2), height)];
    lblAmountText.textAlignment = NSTextAlignmentRight;
    lblAmountText.text = self.strTotalPrice;
    lblAmountText.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE];
    lblAmountText.textColor = [UIColor whiteColor];
    lblAmountText.backgroundColor = [UIColor clearColor];
    [view_Total addSubview:lblAmountText];
    
    [self arrangeOrderData];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDel hideTabBar:appDel.customTabBarController];
}

-(void) arrangeOrderData
{
    NSArray *array = [dictMain allKeys];
    
    [arrayWashType removeAllObjects];
    [arrayWashTypeImages removeAllObjects];
    
    if ([array containsObject:[@"Load Wash" uppercaseString]])
    {
        [arrayWashType addObject:[@"Load Wash" uppercaseString]];
        [arrayWashTypeImages addObject:@"loadwash_price"];
    }
    if ([array containsObject:[@"Wash & Iron" uppercaseString]])
    {
        [arrayWashType addObject:[@"Wash & Iron" uppercaseString]];
        [arrayWashTypeImages addObject:@"wash_iron_price"];
    }
    if ([array containsObject:[@"Dry Cleaning" uppercaseString]])
    {
        [arrayWashType addObject:[@"Dry Cleaning" uppercaseString]];
        [arrayWashTypeImages addObject:@"dryclean_price"];
    }
    if ([array containsObject:[@"Green Dry Cleaning" uppercaseString]])
    {
        [arrayWashType addObject:[@"Green Dry Cleaning" uppercaseString]];
        [arrayWashTypeImages addObject:@"dryclean_price"];
    }
    if ([array containsObject:[@"Ironing" uppercaseString]])
    {
        [arrayWashType addObject:[@"Ironing" uppercaseString]];
        [arrayWashTypeImages addObject:@"ironing_price"];
    }
    if ([array containsObject:[@"Leather Cleaning" uppercaseString]])
    {
        [arrayWashType addObject:[@"Leather Cleaning" uppercaseString]];
        [arrayWashTypeImages addObject:@"leather_price"];
    }
    if ([array containsObject:[@"Carpet Cleaning" uppercaseString]])
    {
        [arrayWashType addObject:[@"Carpet Cleaning" uppercaseString]];
        [arrayWashTypeImages addObject:@"carpet_price"];
    }
    if ([array containsObject:[@"Curtains" uppercaseString]])
    {
        [arrayWashType addObject:[@"Curtains" uppercaseString]];
        [arrayWashTypeImages addObject:@"curtains_price"];
    }
    if ([array containsObject:[@"Bags" uppercaseString]])
    {
        [arrayWashType addObject:[@"Bags" uppercaseString]];
        [arrayWashTypeImages addObject:@"ironing_price"];
    }
    if ([array containsObject:[@"Shoes" uppercaseString]])
    {
        [arrayWashType addObject:[@"Shoes" uppercaseString]];
        [arrayWashTypeImages addObject:@"ironing_price"];
    }
}


#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayWashType count];
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
        
        UILabel *lblWashType = [[UILabel alloc]initWithFrame:CGRectMake(lblWX, yAxis, lblWWidth, lblWHeight)];
        lblWashType.tag = 3;
        lblWashType.textColor = [UIColor grayColor];
        lblWashType.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
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
    
    NSString *strWashType = [arrayWashType objectAtIndex:indexPath.row];
    
    id idType = [dictMain objectForKey:strWashType];
    
    NSArray *arrayDetail;
    NSDictionary *dictDetail;
    
    if ([idType isKindOfClass:[NSArray class]])
    {
        arrayDetail = [dictMain objectForKey:strWashType];
        dictDetail = [arrayDetail objectAtIndex:0];
    }
    else
    {
        dictDetail = [dictMain objectForKey:strWashType];
    }
    
    lblWashType.text = [strWashType uppercaseString];
    imgWashType.image = [UIImage imageNamed:[arrayWashTypeImages objectAtIndex:indexPath.row]];
    
    if ([[dictDetail objectForKey:@"jd"] caseInsensitiveCompare:@"WF"] == NSOrderedSame || [[dictDetail objectForKey:@"jd"] caseInsensitiveCompare:@"CA"] == NSOrderedSame)
    {
        if ([[dictDetail objectForKey:@"jd"] caseInsensitiveCompare:@"WF"] == NSOrderedSame)
        {
            lblDetail.text = [NSString stringWithFormat:@"Number of KGs - %.2f", [[dictDetail objectForKey:@"weight"] floatValue]];
        }
        else if ([[dictDetail objectForKey:@"jd"] caseInsensitiveCompare:@"CA"] == NSOrderedSame)
        {
            lblDetail.text = [NSString stringWithFormat:@"Number of SQFTs - %.2f", [[dictDetail objectForKey:@"weight"] floatValue]];
        }
        
        float price = [[dictDetail objectForKey:@"ip"] floatValue];
        
        lblPrice.text = [NSString stringWithFormat:@"$%.2f", price];
        
        yAxis = lblWashType.frame.origin.y+lblWashType.frame.size.height;
        
        yAxis += 30*MULTIPLYHEIGHT;
    }
    else
    {
        NSString *strType = @"";
        float Price = 0;
        
        for (NSDictionary *dict1 in arrayDetail)
        {
            strType = [strType stringByAppendingFormat:@"%@ - %@   ", [dict1 objectForKey:@"n"], [dict1 objectForKey:@"quantity"]];
            Price += [[dict1 objectForKey:@"ip"] floatValue]*[[dict1 objectForKey:@"quantity"]floatValue];
        }
        
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
    
    CGRect rectPrice = lblPrice.frame;
    rectPrice.origin.y = yAxis/2-lblPrice.frame.size.height/2;
    lblPrice.frame = rectPrice;
    
    return cell;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *strWashType = [arrayWashType objectAtIndex:indexPath.row];
    
    id idType = [dictMain objectForKey:strWashType];
    
    NSArray *arrayDetail;
    NSDictionary *dictDetail;
    
    if ([idType isKindOfClass:[NSArray class]])
    {
        arrayDetail = [dictMain objectForKey:strWashType];
        dictDetail = [arrayDetail objectAtIndex:0];
    }
    else
    {
        dictDetail = [dictMain objectForKey:strWashType];
    }
    
    float yAxis = 20*MULTIPLYHEIGHT;
    
    float imgWX = 11*MULTIPLYHEIGHT;
    float imgWWidth = 29*MULTIPLYHEIGHT;
    
    float lblWX = imgWX+imgWWidth+11*MULTIPLYHEIGHT;
    float minusWidth = 85*MULTIPLYHEIGHT;
    float lblWWidth = lblWX+minusWidth;
    float lblWHeight = 15*MULTIPLYHEIGHT;
    
    yAxis += lblWHeight+15*MULTIPLYHEIGHT;
    
    if ([[dictDetail objectForKey:@"jd"] caseInsensitiveCompare:@"WF"] == NSOrderedSame || [[dictDetail objectForKey:@"jd"] caseInsensitiveCompare:@"CA"] == NSOrderedSame)
    {
        yAxis += lblWHeight;
        
        yAxis += 20*MULTIPLYHEIGHT;
    }
    else
    {
        NSString *strType = @"";
        float Price = 0;
        
        for (NSDictionary *dict1 in arrayDetail)
        {
            strType = [strType stringByAppendingFormat:@"%@ - %@   ", [dict1 objectForKey:@"n"], [dict1 objectForKey:@"quantity"]];
            Price += [[dict1 objectForKey:@"ip"] floatValue];
        }
        
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
