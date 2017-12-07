//
//  RecurringListController.m
//  Piing
//
//  Created by Veedepu Srikanth on 21/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "RecurringListController.h"
#import "RecurringViewController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface RecurringListController ()
{
    UIButton *btnSetRecurring;
    AppDelegate *appDel;
    
    UIView *view_SetRecurring;
    
    MPMoviePlayerController *backGroundplayer;
}

@property (nonatomic, retain) NSArray *userAddresses;

@end

@implementation RecurringListController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    appDel = [PiingHandler sharedHandler].appDel;
    self.userAddresses = [PiingHandler sharedHandler].userAddress;
    
    float yPos = 25*MULTIPLYHEIGHT;
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 40)];
    NSString *string = @"RECURRING WASH";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10.0, yPos, 40.0, 40.0);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
//    float btnEditWidth = 50*MULTIPLYHEIGHT;
//    float btnMinus = 60*MULTIPLYHEIGHT;
//    
//    EditButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    EditButton.frame = CGRectMake(screen_width-btnMinus, yPos, btnEditWidth, 40);
//    [EditButton setTitle:@"EDIT" forState:UIControlStateNormal];
//    [EditButton setTitle:@"DONE" forState:UIControlStateSelected];
//    EditButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    EditButton.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
//    [EditButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [EditButton setTitleColor:BLUE_COLOR forState:UIControlStateSelected];
//    [EditButton addTarget:self action:@selector(editTableViewClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:EditButton];
//    EditButton.hidden = YES;
//    EditButton.alpha = 0.0;
    
    yPos += 40+10*MULTIPLYHEIGHT;
    
    
    float minusTableHeight = 50*MULTIPLYHEIGHT;
    
    tblRecurring = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, screen_height-yPos-minusTableHeight) style:UITableViewStylePlain];
    tblRecurring.dataSource = self;
    tblRecurring.delegate = self;
    tblRecurring.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tblRecurring];
    tblRecurring.hidden = YES;
    tblRecurring.alpha = 0.0;
    
    yPos = 100*MULTIPLYHEIGHT;
    
    view_SetRecurring = [[UIView alloc]initWithFrame:CGRectMake(0, yPos, screen_width, screen_height-yPos)];
    view_SetRecurring.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view_SetRecurring];
    
    float yAxis = 0;
    
    float videoHeight = 60*MULTIPLYHEIGHT;
    
    NSString*thePath=[[NSBundle mainBundle] pathForResource:@"recurring_video" ofType:@"mp4"];
    NSURL*theurl=[NSURL fileURLWithPath:thePath];
    
    backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
    backGroundplayer.view.frame = CGRectMake(0, yAxis, screen_width, videoHeight);
    backGroundplayer.repeatMode = YES;
    backGroundplayer.view.userInteractionEnabled = YES;
    backGroundplayer.controlStyle = MPMovieControlStyleNone;
    [backGroundplayer prepareToPlay];
    [backGroundplayer setShouldAutoplay:YES];
    [view_SetRecurring addSubview:backGroundplayer.view];
    [backGroundplayer play];
    backGroundplayer.backgroundView.backgroundColor = [UIColor whiteColor];
    backGroundplayer.view.backgroundColor = [UIColor clearColor];
    [backGroundplayer setScalingMode:MPMovieScalingModeAspectFit];
    
    
    yAxis += videoHeight+30*MULTIPLYHEIGHT;
    
    //NSString *strRecurring = @"Go laundry-free for life!\nSet a weekly/monthly wash schedule & enjoy clean clothes delivered to you like clockwork.Set it & forget it!Enjoy special privileges! All time slots available.Get 20% on every Recurring order! Pause or resume your schedule anytime";
    
    NSString *strGoLaundry = [@"Go laundry-free for life!" uppercaseString];
    
    UILabel *lblGoLaundry = [[UILabel alloc]init];
    lblGoLaundry.text = strGoLaundry;
    lblGoLaundry.numberOfLines = 0;
    lblGoLaundry.textAlignment = NSTextAlignmentCenter;
    lblGoLaundry.textColor = RGBCOLORCODE(110, 110, 110, 1.0);
    lblGoLaundry.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE];
    [view_SetRecurring addSubview:lblGoLaundry];
    
    CGSize sizeLaundry = [AppDelegate getLabelSizeForRegularText:strGoLaundry WithWidth:screen_width FontSize:lblGoLaundry.font.pointSize];
    
    lblGoLaundry.frame = CGRectMake(screen_width/2-sizeLaundry.width/2, yAxis, sizeLaundry.width, sizeLaundry.height);
    
    yAxis += sizeLaundry.height+5*MULTIPLYHEIGHT;
    
    
    //NSString *strweekly = @"Set a weekly/monthly wash schedule & enjoy clean\nclothes delivered to you like clockwork.\nSet it & forget it!";
    
    NSString *strweekly = @"Set a weekly/monthly wash schedule & enjoy clean\nclothes delivered to you like clockwork.";
    
    UILabel *lblsetWeekly = [[UILabel alloc]init];
    lblsetWeekly.numberOfLines = 0;
    lblsetWeekly.textAlignment = NSTextAlignmentLeft;
    lblsetWeekly.textColor = [UIColor lightGrayColor];
    lblsetWeekly.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    [view_SetRecurring addSubview:lblsetWeekly];
    
    NSMutableAttributedString *mainAttr = [[NSMutableAttributedString alloc]initWithString:strweekly];
    [mainAttr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]} range:NSMakeRange(0, [strweekly length])];
    
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [paragrapStyle setLineSpacing:6.0f];
    [paragrapStyle setMaximumLineHeight:100.0f];
    
    [mainAttr addAttribute:NSParagraphStyleAttributeName value:paragrapStyle range:NSMakeRange(0, mainAttr.length)];
    
    lblsetWeekly.attributedText = mainAttr;
    
    CGSize heightlblweekly = [AppDelegate getAttributedTextHeightForText:mainAttr WithWidth:screen_width];
    
    lblsetWeekly.frame = CGRectMake(0, yAxis, screen_width, heightlblweekly.height);
    
    yAxis += heightlblweekly.height+40*MULTIPLYHEIGHT;
    
    
    float lblX = 40*MULTIPLYHEIGHT;
    float lblWidth = screen_width-lblX;
    
    NSString *strEnjoy = [@"Enjoy special privileges!" uppercaseString];
    
    UILabel *lblEnjoy = [[UILabel alloc]init];
    lblEnjoy.text = strEnjoy;
    lblEnjoy.numberOfLines = 0;
    lblEnjoy.textAlignment = NSTextAlignmentLeft;
    lblEnjoy.textColor = RGBCOLORCODE(110, 110, 110, 1.0);
    lblEnjoy.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-4];
    [view_SetRecurring addSubview:lblEnjoy];
    
    CGFloat heightEnjoy = [AppDelegate getLabelHeightForRegularText:strEnjoy WithWidth:lblWidth FontSize:lblEnjoy.font.pointSize];
    
    lblEnjoy.frame = CGRectMake(lblX, yAxis, lblWidth, heightEnjoy);
    
    yAxis += heightEnjoy;
    
    
    lblX = 40*MULTIPLYHEIGHT+5*MULTIPLYHEIGHT;
    lblWidth = screen_width-lblX;
    
    NSString *strDot = @".";
    
    NSString *strAlltime = @"All time slots available";
    
    UILabel *lblAlltime = [[UILabel alloc]init];
    lblAlltime.numberOfLines = 0;
    lblAlltime.textAlignment = NSTextAlignmentLeft;
    lblAlltime.textColor = [UIColor lightGrayColor];
    lblAlltime.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    [view_SetRecurring addSubview:lblAlltime];
    
    NSString *strAll = [NSString stringWithFormat:@"%@ %@", strDot, strAlltime];
    
    NSMutableAttributedString *attrAlltime = [[NSMutableAttributedString alloc]initWithString:strAll];
    
    [attrAlltime addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE*1.7]} range:NSMakeRange(0, [strDot length])];
    
    [attrAlltime addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]} range:NSMakeRange([strDot length]+1, [strAlltime length])];
    
    lblAlltime.attributedText = attrAlltime;
    
    float lblHeight = 23*MULTIPLYHEIGHT;
    
    lblAlltime.frame = CGRectMake(lblX, yAxis, lblWidth, lblHeight);
    
    yAxis += lblHeight;
    
    
    NSString *strGetoffer = [NSString stringWithFormat:@"Get %@ cashback on every recurring order!", appDel.strRecurringAmount];
    
    UILabel *lblGetoffer = [[UILabel alloc]init];
    lblGetoffer.numberOfLines = 0;
    lblGetoffer.textAlignment = NSTextAlignmentLeft;
    lblGetoffer.textColor = [UIColor lightGrayColor];
    lblGetoffer.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    [view_SetRecurring addSubview:lblGetoffer];
    
    NSString *strGet = [NSString stringWithFormat:@"%@ %@", strDot, strGetoffer];
    
    NSMutableAttributedString *attrGetoffer = [[NSMutableAttributedString alloc]initWithString:strGet];
    
    [attrGetoffer addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE*1.7]} range:NSMakeRange(0, [strDot length])];
    
    [attrGetoffer addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]} range:NSMakeRange([strDot length]+1, [strGetoffer length])];
    
    lblGetoffer.attributedText = attrGetoffer;
    
    lblGetoffer.frame = CGRectMake(lblX, yAxis, lblWidth, lblHeight);
    
    yAxis += lblHeight;
    
    
    NSString *strPause = @"Pause or resume your recurring schedule anytime";
    
    UILabel *lblPause = [[UILabel alloc]init];
    lblPause.numberOfLines = 0;
    lblPause.textAlignment = NSTextAlignmentLeft;
    lblPause.textColor = [UIColor lightGrayColor];
    lblPause.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3];
    [view_SetRecurring addSubview:lblPause];
    
    NSString *strPauseSchedule = [NSString stringWithFormat:@"%@ %@", strDot, strPause];
    
    NSMutableAttributedString *attrPause = [[NSMutableAttributedString alloc]initWithString:strPauseSchedule];
    
    [attrPause addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE*1.7]} range:NSMakeRange(0, [strDot length])];
    
    [attrPause addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-3]} range:NSMakeRange([strDot length]+1, [strPause length])];
    
    lblPause.attributedText = attrPause;
    
    lblPause.frame = CGRectMake(lblX, yAxis, lblWidth, lblHeight);
    
    yAxis += lblHeight;
    
    CGRect rectView_Recurring = view_SetRecurring.frame;
    rectView_Recurring.size.height = yAxis+5*MULTIPLYHEIGHT;
    view_SetRecurring.frame = rectView_Recurring;
    
    yPos += view_SetRecurring.frame.size.height+30*MULTIPLYHEIGHT;
    
    float btnRHeight = 35*MULTIPLYHEIGHT;
    float btnX = 15*MULTIPLYHEIGHT;
    
    btnSetRecurring = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetRecurring.frame = CGRectMake(btnX, yPos, screen_width-(btnX*2), btnRHeight);
    [btnSetRecurring setTitle:@"SET A RECURRING WASH SCHEDULE" forState:UIControlStateNormal];
    btnSetRecurring.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btnSetRecurring.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
    [btnSetRecurring setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnSetRecurring.backgroundColor = BLUE_COLOR;
    [btnSetRecurring setImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
    [btnSetRecurring setBackgroundImage:[AppDelegate imageWithColor:BLUE_COLOR_HIGHLITED] forState:UIControlStateHighlighted];
    btnSetRecurring.layer.cornerRadius = 15.0;
    btnSetRecurring.clipsToBounds = YES;
    
    float rightimageX = 10*MULTIPLYHEIGHT;
    float righttextX = 14*MULTIPLYHEIGHT;
    
    [btnSetRecurring setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, rightimageX)];
    [btnSetRecurring setTitleEdgeInsets:UIEdgeInsetsMake(0, righttextX, 0, 0)];
    
    [btnSetRecurring addTarget:self action:@selector(setRecurringClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSetRecurring];
}

- (void)backToPreviousScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    appDel.sideMenuViewController.panGestureEnabled = NO;
    [appDel hideTabBar:appDel.customTabBarController];
    
    [appDel setBottomTabBarColor:TABBAR_COLOR_GREY BlurEffectStyle:BLUR_EFFECT_STYLE_LIGHT HideBlurEffect:NO];
    
    [self fetchRecurringList];
}

-(void) fetchRecurringList
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/recurring/get/all", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            if(responseObj &&[[responseObj objectForKey:@"em"] count])
                arrayRecurringList = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"em"]];
            
            if ([arrayRecurringList count])
            {
                tblRecurring.hidden = NO;
                EditButton.hidden = NO;
                
//                [btnSetRecurring setTitle:@"SCHEDULE A RECURRING WASH" forState:UIControlStateNormal];
//                btnSetRecurring.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                btnSetRecurring.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
//                [btnSetRecurring setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                btnSetRecurring.backgroundColor = BLUE_COLOR;
//                [btnSetRecurring setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//                [btnSetRecurring setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//                [btnSetRecurring setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    tblRecurring.alpha = 1.0;
                    EditButton.alpha = 1.0;
                    
                    CGRect btnRect = btnSetRecurring.frame;
                    btnRect.origin.y = screen_height-45*MULTIPLYHEIGHT;
                    btnSetRecurring.frame = btnRect;
                    
//                    CGRect rectView = view_SetRecurring.frame;
//                    rectView.origin.y = btnRect.origin.y+btnRect.size.height+20*MULTIPLYHEIGHT;
//                    view_SetRecurring.frame = rectView;
                    
                    view_SetRecurring.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    [backGroundplayer stop];
                    
                }];

             
                
            }
            
            
            [tblRecurring reloadData];
        }
        else {
                
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];

}

-(void) deleteRecurringList:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = [arrayRecurringList objectAtIndex:indexPath.section];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN],@"t", [dict objectForKey:@"rodid"], @"rodid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@deleterecurringorder/services.do?", BASE_URL];
    NSString *str = @"";
    for (NSString *key in [detailsDic allKeys])
    {
        if(str.length > 0)
            str = [str stringByAppendingString:@"&"];
        
        NSString *value = [detailsDic objectForKey:key];
        
        str = [str stringByAppendingFormat:@"%@=%@",key,value];
        
    }
    if(str.length > 0)
        urlStr = [urlStr stringByAppendingString:str];
    
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame){
            
            [arrayRecurringList removeObjectAtIndex:indexPath.section];
            
            [tblRecurring deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            
            if (![arrayRecurringList count])
            {
                EditButton.hidden = YES;
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    view_SetRecurring.alpha = 1.0;
                    
                    float btnY = view_SetRecurring.frame.origin.y+view_SetRecurring.frame.size.height+30*MULTIPLYHEIGHT;
                    
                    [backGroundplayer play];
                    
                    CGRect btnRect = btnSetRecurring.frame;
                    btnRect.origin.y = btnY;
                    btnSetRecurring.frame = btnRect;
                    
//                    CGRect rectView = view_SetRecurring.frame;
//                    rectView.origin.y = btnY+btnRect.size.height+20*MULTIPLYHEIGHT;
//                    view_SetRecurring.frame = rectView;
//                    
//                    
//                    [btnSetRecurring setTitle:@"SET A RECURRING WASH SCHEDULE" forState:UIControlStateNormal];
//                    btnSetRecurring.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                    btnSetRecurring.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
//                    [btnSetRecurring setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                    btnSetRecurring.backgroundColor = BLUE_COLOR;
//                    [btnSetRecurring setImage:[UIImage imageNamed:@"plus_icon.png"] forState:UIControlStateNormal];
//                    
//                    float rightimageX = 58*MULTIPLYHEIGHT;
//                    float righttextX = 22*MULTIPLYHEIGHT;
//                    
//                    [btnSetRecurring setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, rightimageX)];
//                    [btnSetRecurring setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, righttextX)];
                    
                  
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
            [appDel showAlertWithMessage:@"Recurring schedule deleted successfully" andTitle:@"" andBtnTitle:@"OK"];
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
                
    }];
    
}


-(void) setRecurringClicked
{
    
    RecurringViewController *vc = [[RecurringViewController alloc] init];
        
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:vc];
    
    navVC.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
    [self.view addSubview:navVC.view];
    [self addChildViewController:navVC];
    
    [UIView animateWithDuration:0.3 animations:^{
        navVC.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void) editTableViewClicked:(id)sender
{
    if (!EditButton.selected)
    {
        EditButton.selected = YES;
        [tblRecurring setEditing:YES animated:YES];
    }
    else
    {
        EditButton.selected = NO;
        [tblRecurring setEditing:NO animated:YES];
    }
}


#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrayRecurringList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
        
        float topbgX = 11*MULTIPLYHEIGHT;
        float topbgHeight = 36*MULTIPLYHEIGHT;
        float topbgWidth = 177*MULTIPLYHEIGHT;
        
        UIView *topBG = [[UIView alloc]initWithFrame:CGRectMake(topbgX, 0, topbgWidth, topbgHeight)];
        topBG.tag = 1;
        topBG.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        [cell.contentView addSubview:topBG];
        
        
        float bottombgX = topbgHeight+2*MULTIPLYHEIGHT;;
        
        UIView *bottomBG = [[UIView alloc]initWithFrame:CGRectMake(topbgX, bottombgX, topbgWidth, topbgHeight)];
        bottomBG.tag = 2;
        bottomBG.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        [cell.contentView addSubview:bottomBG];
        
        
        float sidebgX = topbgWidth+topbgX+2*MULTIPLYHEIGHT;
        
        UIView *sideBG = [[UIView alloc]initWithFrame:CGRectMake(sidebgX, 0, screen_width-sidebgX-topbgX, bottomBG.frame.origin.y+bottomBG.frame.size.height)];
        sideBG.tag = 3;
        sideBG.backgroundColor = LIGHT_GRAY_BACKGROUND_COLOR;
        [cell.contentView addSubview:sideBG];
        
        
        float pickupIconHeight = 25*MULTIPLYHEIGHT;
        float pickupX = 0;
        
        UIImageView *imgPickupAddr = [[UIImageView alloc]initWithFrame:CGRectMake(pickupX, topbgHeight/2-pickupIconHeight/2, pickupIconHeight, pickupIconHeight)];
        imgPickupAddr.image = [UIImage imageNamed:@"mywashes_pickup"];
        [topBG addSubview:imgPickupAddr];
        
        float lblX = pickupIconHeight+5*MULTIPLYHEIGHT;
        float lblY = 3*MULTIPLYHEIGHT;
        float lblHeight = 15*MULTIPLYHEIGHT;
        
        UILabel *lblPickUpAddr = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblY, topBG.frame.size.width-lblX, lblHeight)];
        lblPickUpAddr.tag = 4;
        lblPickUpAddr.textColor = [UIColor grayColor];
        lblPickUpAddr.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
        [topBG addSubview:lblPickUpAddr];
        
        float lblPY = lblY+lblHeight;
        
        UILabel *lblPickupTime = [[UILabel alloc]initWithFrame:CGRectMake(lblX, lblPY, topBG.frame.size.width-lblX, lblHeight)];
        lblPickupTime.tag = 5;
        lblPickupTime.textColor = [UIColor grayColor];
        lblPickupTime.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [topBG addSubview:lblPickupTime];
        
        
        UIImageView *imgDeliveryAddr = [[UIImageView alloc]initWithFrame:imgPickupAddr.frame];
        imgDeliveryAddr.image = [UIImage imageNamed:@"mywashes_delivery"];
        [bottomBG addSubview:imgDeliveryAddr];
        
        UILabel *lblDeliveryAddr = [[UILabel alloc]initWithFrame:lblPickUpAddr.frame];
        lblDeliveryAddr.tag = 6;
        lblDeliveryAddr.textColor = [UIColor grayColor];
        lblDeliveryAddr.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
        [bottomBG addSubview:lblDeliveryAddr];
        
        UILabel *lblDeliveyTime = [[UILabel alloc]initWithFrame:lblPickupTime.frame];
        lblDeliveyTime.tag = 7;
        lblDeliveyTime.textColor = [UIColor grayColor];
        lblDeliveyTime.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [bottomBG addSubview:lblDeliveyTime];
        
        
        float lblOY = 5*MULTIPLYHEIGHT;
        float lblOHeight = 22*MULTIPLYHEIGHT;
        
        UILabel *lblOrderType = [[UILabel alloc]initWithFrame:CGRectMake(0, lblOY, sideBG.frame.size.width, lblOHeight)];
        lblOrderType.tag = 8;
        lblOrderType.textAlignment = NSTextAlignmentCenter;
        lblOrderType.textColor = [UIColor redColor];
        lblOrderType.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [sideBG addSubview:lblOrderType];
        
        
        float btnOY = lblOY+lblOHeight;
        
        UIButton *btnOrderType = [UIButton buttonWithType:UIButtonTypeCustom];
        btnOrderType.frame = CGRectMake(0, btnOY, sideBG.frame.size.width, lblOHeight);
        btnOrderType.tag = 9;
        btnOrderType.userInteractionEnabled = YES;
        btnOrderType.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [sideBG addSubview:btnOrderType];
        
        
        float lblRY = btnOY+lblOHeight;
        
        UILabel *lblResume = [[UILabel alloc]initWithFrame:CGRectMake(0, lblRY, sideBG.frame.size.width, lblOHeight)];
        lblResume.tag = 10;
        lblResume.textAlignment = NSTextAlignmentCenter;
        lblResume.textColor = [UIColor grayColor];
        lblResume.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [sideBG addSubview:lblResume];
        
    }
    
    NSDictionary *dict = [arrayRecurringList objectAtIndex:indexPath.section];
    
    UIView *topBG = (UIView *) [cell.contentView viewWithTag:1];
    UIView *bottomBG = (UIView *) [cell.contentView viewWithTag:2];
    UIView *sideBG = (UIView *) [cell.contentView viewWithTag:3];
    
    UILabel *lblPickUpAddr = (UILabel *) [topBG viewWithTag:4];
    
    NSArray *sortedArray1 = [[NSMutableArray alloc]initWithArray:self.userAddresses];
    NSPredicate *getDefaultAddPredicate1 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [dict objectForKey:ORDER_PICKUP_ADDRESS_ID]]];
    
    sortedArray1 = [sortedArray1 filteredArrayUsingPredicate:getDefaultAddPredicate1];
    
    NSDictionary *dictPickupAddress = nil;
    
    if ([sortedArray1 count] > 0)
    {
        dictPickupAddress = [sortedArray1 objectAtIndex:0];
    }
    
    lblPickUpAddr.text = [dictPickupAddress objectForKey:@"name"];
    
    UILabel *lblPickupTime = (UILabel *) [topBG viewWithTag:5];
    lblPickupTime.text = [NSString stringWithFormat:@"%@, %@", [dict objectForKey:ORDER_PICKUP_DATE], [dict objectForKey:ORDER_PICKUP_SLOT]];
    
    UILabel *lblDeliveryAddr = (UILabel *) [bottomBG viewWithTag:6];
    
    NSArray *sortedArray2 = [[NSMutableArray alloc]initWithArray:self.userAddresses];
    NSPredicate *getDefaultAddPredicate2 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [dict objectForKey:ORDER_DELIVERY_ADDRESS_ID]]];
    
    sortedArray2 = [sortedArray2 filteredArrayUsingPredicate:getDefaultAddPredicate2];
    
    NSDictionary *dictDeliveryAddress = nil;
    
    if ([sortedArray2 count] > 0)
    {
        dictDeliveryAddress = [sortedArray2 objectAtIndex:0];
    }
    
    lblDeliveryAddr.text = [dictDeliveryAddress objectForKey:@"name"];
    
    UILabel *lblDeliveyTime = (UILabel *) [bottomBG viewWithTag:7];
    lblDeliveyTime.text = [NSString stringWithFormat:@"%@, %@", [dict objectForKey:ORDER_DELIVERY_DATE], [dict objectForKey:ORDER_DELIVERY_SLOT]];
    
    UILabel *lblOrderType = (UILabel *) [sideBG viewWithTag:8];
    
    if ([[dict objectForKey:ORDER_TYPE] isEqualToString:@"R"])
    {
        lblOrderType.text = [@"Regular" uppercaseString];
    }
    else
    {
        lblOrderType.text = [@"Express" uppercaseString];
    }
    
    UILabel *lblResume = (UILabel *) [sideBG viewWithTag:10];
    
    UIButton *btnOrderType = (UIButton *) [sideBG viewWithTag:9];
    
    if ([[dict objectForKey:@"rStatus"] isEqualToString:@"Active"])
    {
        lblResume.text = @"ON";
        [btnOrderType setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
    }
    else
    {
        lblResume.text = @"RESUME";
        [btnOrderType setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
    }
    
    [btnOrderType addTarget:self action:@selector(PlayPauseClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark TableView Delegate

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//       
//        [self deleteRecurringList:indexPath];
//        
//        //EditButton.selected = YES;
//        [self editTableViewClicked:EditButton];
//    }
//}
//
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15*MULTIPLYHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float bgHeight = 74*MULTIPLYHEIGHT;
    return bgHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void) PlayPauseClicked:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tblRecurring];
    NSIndexPath *indexPath = [tblRecurring indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [tblRecurring cellForRowAtIndexPath:indexPath];
    
    UILabel *lblResume = (UILabel *) [cell.contentView viewWithTag:10];
    
    UIButton *btnOrderType = (UIButton *) [cell.contentView viewWithTag:9];
    
    
    NSDictionary *dict = [arrayRecurringList objectAtIndex:indexPath.section];
    
    if ([[dict objectForKey:@"rStatus"] isEqualToString:@"Active"])
    {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Are you sure you want to pause this order?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [dict objectForKey:@"roid"], @"roid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", @"P", @"status", nil];
                                 
                                 NSString *urlStr = [NSString stringWithFormat:@"%@order/recurring/update", BASE_URL];
                                 
                                 [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
                                 
                                 [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                                     
                                     [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                                     
                                     if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                                         
                                         NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                                         [mutableDict setObject:@"Pause" forKey:@"rStatus"];
                                         
                                         [arrayRecurringList replaceObjectAtIndex:indexPath.section withObject:mutableDict];
                                         
                                         [tblRecurring reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                         
                                         lblResume.text = @"RESUME";
                                         [btnOrderType setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
                                         
                                     }
                                     else {
                                         [appDel displayErrorMessagErrorResponse:responseObj];
                                     }
                                     
                                 }];
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else
    {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Are you sure you want to resume this order?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", [dict objectForKey:@"roid"], @"roid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", @"R", @"status", nil];
                                 
                                 NSString *urlStr = [NSString stringWithFormat:@"%@order/recurring/update", BASE_URL];
                                 
                                 [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
                                 
                                 [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                                     
                                     [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
                                     
                                     if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                                         
                                         NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                                         [mutableDict setObject:@"Active" forKey:@"rStatus"];
                                         
                                         [arrayRecurringList replaceObjectAtIndex:indexPath.section withObject:mutableDict];
                                         
                                         [tblRecurring reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                         
                                         lblResume.text = @"ON";
                                         [btnOrderType setImage:[UIImage imageNamed:@"pause_icon.png"] forState:UIControlStateNormal];
                                         
                                     }
                                     else {
                                         [appDel displayErrorMessagErrorResponse:responseObj];
                                     }
                                     
                                 }];
                                 
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


-(void) menuButtonClicked:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
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
