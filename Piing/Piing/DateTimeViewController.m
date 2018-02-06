//
//  DateTimeViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 16/09/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "DateTimeViewController.h"
#import "AppDelegate.h"

#define TABLE_TIME_HEIGHT 45*MULTIPLYHEIGHT

@interface DateTimeViewController () <UITableViewDelegate, UITableViewDataSource>
{
    AppDelegate *appDel;
    
    UITableView *tblDates;
    UITableView *tblTimes;
    
    CGFloat yAxis;
    
    NSInteger selectedTimeslotIndex;
    
    BOOL isFirstTime;
    
    CGFloat TABLE_DATE_HEIGHT;
}

@end

@implementation DateTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedTimeslotIndex = -1;
    
    self.view.backgroundColor = RGBCOLORCODE(239, 240, 241, 1.0);
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    if (self.isFromRecurring)
    {
        TABLE_DATE_HEIGHT  = 37*MULTIPLYHEIGHT+10*MULTIPLYHEIGHT;
    }
    else
    {
        TABLE_DATE_HEIGHT  = 37*MULTIPLYHEIGHT;
    }
    
    yAxis = 60*MULTIPLYHEIGHT;
    
    UIView *view_Top = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, yAxis)];
    view_Top.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_Top];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(10.0, view_Top.frame.size.height-45, 40, 40);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeDateTimeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [view_Top addSubview:closeBtn];
    
    UIButton *forwardeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardeBtn.frame = CGRectMake(screen_width - 50.0, view_Top.frame.size.height-45, 40, 40);
    [forwardeBtn setImage:[UIImage imageNamed:@"forward_arrow_grey"] forState:UIControlStateNormal];
    [forwardeBtn addTarget:self action:@selector(selectDateTimeScreen:) forControlEvents:UIControlEventTouchUpInside];
    [view_Top addSubview:forwardeBtn];
    
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(0, yAxis, screen_width, 1);
    topLayer.backgroundColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
    [view_Top.layer addSublayer:topLayer];
    
    yAxis += 1;
    
    CGFloat tblDWidth = 122*MULTIPLYHEIGHT;
    
    tblDates = [[UITableView alloc]initWithFrame:CGRectMake(0, yAxis, tblDWidth, screen_height-yAxis)];
    tblDates.delegate = self;
    tblDates.dataSource = self;
    tblDates.separatorColor = [UIColor clearColor];
    tblDates.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblDates.backgroundColor = RGBCOLORCODE(239, 240, 241, 1.0);
    [self.view addSubview:tblDates];
    tblDates.contentInset = UIEdgeInsetsZero;
    
    
    float customHeight = 0.0;
    
    for (int i = 0; i<[self.arrayDates count]; i++)
    {
        float height = TABLE_DATE_HEIGHT+7*MULTIPLYHEIGHT;
        customHeight += height;
    }
    
    float minusHeight = 15*MULTIPLYHEIGHT+yAxis;
    
    float height = MIN(customHeight, ((screen_height+yAxis) - (minusHeight*2)));
    tblDates.frame = CGRectMake(0.0, minusHeight, tblDWidth, height);
    tblDates.center = CGPointMake(tblDWidth/2, (screen_height+yAxis)/2);
    
    
    UIView *view_Right = [[UIView alloc]initWithFrame:CGRectMake(tblDWidth, yAxis, screen_width-tblDWidth, screen_height-yAxis)];
    view_Right.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_Right];
    
    tblTimes = [[UITableView alloc]initWithFrame:CGRectMake(tblDWidth, yAxis, screen_width-tblDWidth, screen_height-yAxis)];
    tblTimes.backgroundColor = [UIColor whiteColor];
    tblTimes.delegate = self;
    tblTimes.dataSource = self;
    tblTimes.separatorColor = [UIColor clearColor];
    tblTimes.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblTimes];
    tblTimes.contentInset = UIEdgeInsetsMake(-5*MULTIPLYHEIGHT, 0, 0, 0);
    
    isFirstTime = YES;
    
    if (![self.selectedDate length])
    {
        self.selectedDate = [[self.arrayDates objectAtIndex:0] objectForKey:@"actValue"];
        
        if (self.isFromRecurring)
        {
            
        }
        else if (self.isFromDelivery)
        {
            self.strColocated = [[self.arrayDates objectAtIndex:0] objectForKey:@"colocateddelivery"];
        }
        else
        {
            self.strColocated = [[self.arrayDates objectAtIndex:0] objectForKey:@"colocatedpickup"];
        }
    }
    else
    {
        
    }
    
    [self fetchTimeSlots];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.selectedDate length])
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [tblDates selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        for (int i=0; i<[self.arrayDates count]; i++)
        {
            NSDictionary *dict = [self.arrayDates objectAtIndex:i];
            
            if ([self.selectedDate isEqualToString:[dict objectForKey:@"actValue"]])
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:i];
                [tblDates selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                
                break;
            }
        }
    }
}

-(void) selectDateTimeScreen:(id)sender
{
    if ([self.strSelectedTimeSlot length])
    {
        if ([self.delegate respondsToSelector:@selector(didSelectDateAndTime:)])
        {
            NSArray *array = [NSArray arrayWithObjects:self.selectedDate, self.strSelectedTimeSlot, self.strColocated, nil];
            [self.delegate didSelectDateAndTime:array];
            
            [self closeDateTimeScreen:nil];
        }
    }
    else
    {
        [appDel showAlertWithMessage:@"Please select your preferred time slot" andTitle:@"" andBtnTitle:@"OK"];
    }
}

-(void) closeDateTimeScreen:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == tblDates)
    {
        return [self.arrayDates count];
    }
    else if (tableView == tblTimes)
    {
        return [self.arrayTimes count];
    }
    else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblDates)
    {
        return TABLE_DATE_HEIGHT;
    }
    else if (tableView == tblTimes)
    {
        return TABLE_TIME_HEIGHT;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tblDates)
    {
        return 7*MULTIPLYHEIGHT;
    }
    else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tblDates)
    {
        UIView *selectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 7*MULTIPLYHEIGHT)];
        selectionView.backgroundColor = [UIColor clearColor];
        
        return selectionView;
    }
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblDates)
    {
        static NSString *strCellId = @"DateId";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellId];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:strCellId];
            
            
            UILabel *lblTitle = [[UILabel alloc]init];
            lblTitle.tag = 1;
            lblTitle.numberOfLines = 0;
            [cell.contentView addSubview:lblTitle];
            
            UIImageView *imgDis = [[UIImageView alloc]init];
            imgDis.tag = 3;
            [cell.contentView addSubview:imgDis];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *lblTitle = (UILabel *) [cell.contentView viewWithTag:1];
        UIImageView *imgDis = (UIImageView *) [cell.contentView viewWithTag:3];
        
        CGFloat lblX = 16*MULTIPLYHEIGHT;
        CGFloat lblWidth;
        
        UIView *selectionView = [UIView new];
        selectionView.backgroundColor = RGBCOLORCODE(219, 227, 231, 1.0);
        [cell setSelectedBackgroundView:selectionView];
        
        NSDictionary *dict = [self.arrayDates objectAtIndex:indexPath.section];
        
        lblTitle.textColor = RGBCOLORCODE(100, 100, 100, 1);
        lblTitle.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM+2];
        
        if (self.isFromRecurring)
        {
            NSString *str1 = [dict objectForKey:@"title"];
            NSString *str2 = [NSString stringWithFormat:@"\n%@", [dict objectForKey:@"actValue"]];
            
            NSMutableAttributedString *attrMain = [[NSMutableAttributedString alloc]initWithString:str1];
            [attrMain addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE+1], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, str1.length)];
            
            NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc]initWithString:str2];
            [attr1 addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2], NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, str2.length)];
            
            [attrMain appendAttributedString:attr1];
            
            CGSize titleSize = [AppDelegate getAttributedTextHeightForText:attrMain WithWidth:tblDates.frame.size.width];
            lblTitle.frame = CGRectMake(lblX, 0, titleSize.width, TABLE_DATE_HEIGHT);
            
            lblTitle.attributedText = attrMain;
            
            lblWidth = titleSize.width;
        }
        else
        {
            NSString *str1 = [dict objectForKey:@"title"];
            CGSize titleSize = [AppDelegate getLabelSizeForSemiBoldText:str1 WithWidth:tblDates.frame.size.width FontSize:lblTitle.font.pointSize];
            
            lblTitle.frame = CGRectMake(lblX, 0, titleSize.width, TABLE_DATE_HEIGHT);
            
            lblTitle.text = [dict objectForKey:@"title"]; //actValue
            
            lblWidth = titleSize.width;
        }
        
        CGFloat imgX = lblX+lblWidth+10*MULTIPLYHEIGHT;
        
        imgDis.frame = CGRectMake(imgX, 0, 15*MULTIPLYHEIGHT, TABLE_DATE_HEIGHT);
        imgDis.contentMode = UIViewContentModeScaleAspectFit;
        
        if ([[dict objectForKey:@"discountValue"] length])
        {
            imgDis.image = [UIImage imageNamed:@"off_icon"];
        }
        else
        {
            imgDis.image = [UIImage imageNamed:@""];
        }
        
        //imgDis.image = [UIImage imageNamed:@"off_icon"];
        
        return cell;
    }
    else
    {
        static NSString *strCellId = @"TimeId";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCellId];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:strCellId];
            
            
            UILabel *lblTitle = [[UILabel alloc]init];
            lblTitle.tag = 1;
            [cell.contentView addSubview:lblTitle];
            
            UIButton *btnOffer = [UIButton buttonWithType:UIButtonTypeCustom];
            btnOffer.tag = 2;
            btnOffer.userInteractionEnabled = NO;
            btnOffer.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+3];
            [cell.contentView addSubview:btnOffer];
            
            UIImageView *imgSelected = [[UIImageView alloc]init];
            imgSelected.tag = 3;
            imgSelected.contentMode = UIViewContentModeScaleAspectFit;
            [cell.contentView addSubview:imgSelected];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setSelectedBackgroundView:nil];
        
        UILabel *lblTitle = (UILabel *) [cell.contentView viewWithTag:1];
        //lblTitle.backgroundColor = [UIColor redColor];
        
        UIButton *btnOffer = (UIButton *) [cell.contentView viewWithTag:2];
        
        UIImageView *imgSelected = (UIImageView *) [cell.contentView viewWithTag:3];
        imgSelected.highlightedImage = [UIImage imageNamed:@"slected_timeslot"];
        
        CGFloat lblX = 20*MULTIPLYHEIGHT;
        CGFloat xAxis;
        
        lblTitle.textColor = [UIColor lightGrayColor];
        lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
        
        NSDictionary *dict = [self.arrayTimes objectAtIndex:indexPath.section];
        
        if (self.isFromRecurring)
        {
            NSString *slot = [dict objectForKey:@"slot"];
            
            slot = [[slot stringByReplacingOccurrencesOfString:@" PM" withString:@""] stringByAppendingString:@" PM"];
            slot = [slot stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
            
            lblTitle.text = slot;
            
            CGSize titleSize = [AppDelegate getLabelSizeForMediumText:slot WithWidth:tblDates.frame.size.width FontSize:lblTitle.font.pointSize];
            
            lblTitle.frame = CGRectMake(lblX, 0, titleSize.width, TABLE_TIME_HEIGHT);
            
            xAxis = lblX+titleSize.width+3*MULTIPLYHEIGHT;
        }
        else
        {
            NSString *slot = [dict objectForKey:@"slot"];
            
            slot = [[slot stringByReplacingOccurrencesOfString:@" PM" withString:@""] stringByAppendingString:@" PM"];
            slot = [slot stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
            
            lblTitle.text = slot;
            
            CGSize titleSize = [AppDelegate getLabelSizeForSemiBoldText:slot WithWidth:tblDates.frame.size.width FontSize:lblTitle.font.pointSize];
            
            lblTitle.frame = CGRectMake(lblX, 0, titleSize.width, TABLE_TIME_HEIGHT);
            
            xAxis = lblX+titleSize.width+3*MULTIPLYHEIGHT;
            
            if ([[dict objectForKey:@"dis"] length] > 1)
            {
                btnOffer.hidden = NO;
                
                UIImage *img = [UIImage imageNamed:@"discount_bg"];
                //CGSize sizeOfImg = img.size;
                
                [btnOffer setBackgroundImage:img forState:UIControlStateNormal];
                
                NSString *strDis = [NSString stringWithFormat:@"%@", [dict objectForKey:@"dis"]];
                
                [btnOffer setTitle:strDis forState:UIControlStateNormal];
                
                CGFloat width = 55*MULTIPLYHEIGHT;
                CGFloat height = 25*MULTIPLYHEIGHT;
                
                btnOffer.frame = CGRectMake(xAxis, TABLE_TIME_HEIGHT/2 - height/2, width, height);
                
                btnOffer.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM+1];
                
                [btnOffer setTitleColor:RGBCOLORCODE(71, 185, 120, 1.0) forState:UIControlStateNormal];
                btnOffer.titleEdgeInsets = UIEdgeInsetsMake(0, 20*MULTIPLYHEIGHT, 0, 0);
                xAxis += btnOffer.frame.size.width;
            }
            else if ([[dict objectForKey:@"se"] length] > 1)
            {
                btnOffer.hidden = NO;
                
                UIImage *img = [UIImage imageNamed:@"surgeprice_bg"];
                //CGSize sizeOfImg = img.size;
                
                [btnOffer setBackgroundImage:img forState:UIControlStateNormal];
                
                NSString *strSurge = [NSString stringWithFormat:@"+ %@", [dict objectForKey:@"se"]];
                
                [btnOffer setTitle:strSurge forState:UIControlStateNormal];
                
                CGFloat width = 55*MULTIPLYHEIGHT;
                CGFloat height = 25*MULTIPLYHEIGHT;
                
                btnOffer.frame = CGRectMake(xAxis, TABLE_TIME_HEIGHT/2 - height/2, width, height);
                
                btnOffer.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
                
                [btnOffer setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
                btnOffer.titleEdgeInsets = UIEdgeInsetsMake(0, 13*MULTIPLYHEIGHT, 0, 0);
                xAxis += btnOffer.frame.size.width;
            }
            else
            {
                btnOffer.hidden = YES;
                xAxis += 6*MULTIPLYHEIGHT;
            }
        }
        
        if (selectedTimeslotIndex == indexPath.section)
        {
            imgSelected.highlighted = YES;
            
            self.strSelectedTimeSlot = [dict objectForKey:@"slot"];
        }
        else
        {
            imgSelected.highlighted = NO;
        }
        
        imgSelected.frame = CGRectMake(xAxis, 0, 14*MULTIPLYHEIGHT, TABLE_TIME_HEIGHT);
        
        return cell;
    }
   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblDates)
    {
        NSDictionary *dict = [self.arrayDates objectAtIndex:indexPath.section];
        
        selectedTimeslotIndex = -1;
        self.strSelectedTimeSlot = @"";
        
        self.selectedDate = [[self.arrayDates objectAtIndex:indexPath.section] objectForKey:@"actValue"];
        
        if (self.isFromRecurring)
        {
            
        }
        else if (self.isFromDelivery)
        {
            self.strColocated = [dict objectForKey:@"colocateddelivery"];
        }
        else
        {
            self.strColocated = [dict objectForKey:@"colocatedpickup"];
        }
        
        [self fetchTimeSlots];
    }
    else
    {
        selectedTimeslotIndex = indexPath.section;
        
        [tblTimes reloadData];
    }
}



-(void)fetchTimeSlots
{
    
//    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
//    [dtFormatter setDateFormat:@"dd MMM, EEE"];
//    
//    NSDate *date = [dtFormatter dateFromString:self.selectedDate];
//    
//    NSDateFormatter *toDtFormatter = [[NSDateFormatter alloc] init];
//    [toDtFormatter setDateFormat:@"dd-MM-yyyy"];
//    
//    NSString *strDate = [toDtFormatter stringFromDate:date];
    
    self.arrayTimes = [self.dictDatesAndTimes objectForKey:self.selectedDate];
    
    for (int i = 0; i<[self.arrayTimes count]; i++)
    {
        if (self.isFromRecurring)
        {
            NSDictionary *dict = [self.arrayTimes objectAtIndex:i];
            
            if ([self.strSelectedTimeSlot isEqualToString:[dict objectForKey:@"slot"]])
            {
                selectedTimeslotIndex = i;
                
                break;
            }
        }
        else
        {
            NSDictionary *dict = [self.arrayTimes objectAtIndex:i];
            
            if ([self.strSelectedTimeSlot isEqualToString:[dict objectForKey:@"slot"]])
            {
                selectedTimeslotIndex = i;
                
                break;
            }
        }
    }
    
    
    float customHeight = 0.0;
    
    for (int i = 0; i<[self.arrayTimes count]; i++)
    {
        float height = TABLE_TIME_HEIGHT;
        customHeight += height;
    }
    
    float minusHeight = 25*MULTIPLYHEIGHT;
    
    float height = MIN(customHeight, ((screen_height-yAxis) - (minusHeight*2)));
    
    [UIView animateWithDuration:0.2 animations:^{
    
        tblTimes.frame = CGRectMake(0.0, minusHeight, tblTimes.frame.size.width, height);
        tblTimes.center = CGPointMake(tblDates.frame.size.width+tblTimes.frame.size.width/2, (screen_height+yAxis)/2);
        
    } completion:^(BOOL finished) {
        
    }];
    
    [tblTimes reloadData];
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
