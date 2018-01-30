//
//  MyBookingViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "MyBookingViewController.h"
#import "CustomSegmentControl.h"
#import "OrdersTableViewCell.h"
#import "BookViewController.h"
#import "FAQViewController.h"
#import <StoreKit/SKStoreReviewController.h>


@interface MyBookingViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate, MyBookingViewControllerDelegate>
{
    UITableView *orderTableView;
    
    CGRect originalCellSize;
    AppDelegate *appDel;
    UILabel *titleLbl;
    
    BOOL isFirstTime;
    
    UIImageView *bgImageView;
    
    UIRefreshControl *refreshControl;
    
    BOOL isRefreshing;
    
    BookViewController *bookGlobal;
    
    int selectedSegment;
}

@property (nonatomic, retain) NSMutableArray *arrayOrders;
@property (nonatomic, assign) CGAffineTransform transf;

@property (nonatomic, strong) id previewingContext;

@end

@implementation MyBookingViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [refreshControl.superview sendSubviewToBack:refreshControl];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [PiingHandler sharedHandler].appDel;
    appDel.window.backgroundColor = [UIColor whiteColor];
    
    isFirstTime = YES;
    
    if ([self isForceTouchAvailable])
    {
        self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //bgImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    bgImageView.image = [UIImage imageNamed:@"mywashes_singapore"];
    bgImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgImageView];
    bgImageView.hidden = NO;
    
    UIView *viewImageBG = [[UIView alloc]initWithFrame:bgImageView.frame];
    viewImageBG.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:viewImageBG];
    
//    UIButton *btnCurrent = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnCurrent.frame = CGRectMake(30, 20, 50, 30);
//    [self.view addSubview:btnCurrent];
//    btnCurrent.backgroundColor = [UIColor redColor];
//    
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:btnCurrent.bounds
//                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
//                                           cornerRadii:CGSizeMake(5.0, 5.0)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame =btnCurrent.bounds;
//    maskLayer.path = maskPath.CGPath;
//    btnCurrent.layer.mask = maskLayer;
//    btnCurrent.clipsToBounds = YES;
//    btnCurrent.layer.masksToBounds = YES;
//
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(30, 20, 50, 30);
//    [self.view addSubview:btn];
//    btn.backgroundColor = [UIColor redColor];
//    
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds
//                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
//                                           cornerRadii:CGSizeMake(5.0, 5.0)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame =btn.bounds;
//    maskLayer.path = maskPath.CGPath;
//    btn.layer.mask = maskLayer;
//    btn.clipsToBounds = YES;
//    btn.layer.masksToBounds = YES;
    
    
//    CALayer *TopBorder = [CALayer layer];
//    TopBorder.frame = CGRectMake(0.0f, 0.0f, btn.frame.size.width, 3.0f);
//    TopBorder.backgroundColor = [UIColor greenColor].CGColor;
//    [btn.layer addSublayer:TopBorder];
//    
//    CALayer *rightBorder = [CALayer layer];
//    rightBorder.frame = CGRectMake(btn.frame.size.width-2, 0.0f, 2, btn.frame.size.height);
//    rightBorder.backgroundColor = [UIColor greenColor].CGColor;
//    [btn.layer addSublayer:rightBorder];
//    
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, btn.frame.size.height-2, btn.frame.size.width, 2.0f);
//    bottomBorder.backgroundColor = [UIColor greenColor].CGColor;
//    [btn.layer addSublayer:bottomBorder];
    
    
    float segmentWidth = 150*MULTIPLYHEIGHT;
    
    UIView *viewSeg = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2-(segmentWidth/2), 33*MULTIPLYHEIGHT, segmentWidth, 30.0)];
    viewSeg.layer.cornerRadius = 15.0;
    viewSeg.layer.masksToBounds = YES;
    [self.view addSubview:viewSeg];
    
    NSArray *arr = @[@"CURRENT",@"PREVIOUS"];
    
    for (int i = 0; i < [arr count]; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
        btn.tag = i+1;
        
        if (i == 0)
        {
            btn.backgroundColor = BLUE_COLOR;
        }
        else
        {
            btn.backgroundColor = RGBCOLORCODE(50, 50, 50, 0.9);
        }
        
        btn.frame = CGRectMake(i*segmentWidth/2, 0, segmentWidth/2, viewSeg.frame.size.height);
        [btn addTarget:self action:@selector(currentAndPreviousSeelcted:) forControlEvents:UIControlEventTouchUpInside];
        [viewSeg addSubview:btn];
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(1.25, 1.25);
    self.transf = transform;
    
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(viewSeg.frame)+10, screen_width, screen_height - CGRectGetMaxY(viewSeg.frame)-10) style:UITableViewStylePlain];
    orderTableView.backgroundColor = [UIColor clearColor];
    orderTableView.dataSource = self;
    orderTableView.delegate = self;
    orderTableView.separatorColor = [UIColor clearColor];
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTableView.showsVerticalScrollIndicator = NO;
    orderTableView.showsHorizontalScrollIndicator = NO;
    orderTableView.contentInset = UIEdgeInsetsMake(20*MULTIPLYHEIGHT, 0, 50, 0);
    [self.view addSubview:orderTableView];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [orderTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [refreshControl endRefreshing];
    
    [self getCurrentOrders];
}

-(void) currentAndPreviousSeelcted:(UIButton *) sender
{
    UIView *viewSeg = (UIView *) sender.superview;
    
    for (UIButton *btn in viewSeg.subviews)
    {
        btn.backgroundColor = RGBCOLORCODE(50, 50, 50, 0.9);
    }
    
    sender.backgroundColor = BLUE_COLOR;
    
    if (sender.tag == 1)
    {
        selectedSegment = 0;
        [self getCurrentOrders];
    }
    else
    {
        selectedSegment = 1;
        [self getPastOrders];
    }
}


-(void) refreshTable
{
    refreshControl.hidden = NO;
    
    orderTableView.userInteractionEnabled = NO;
    isRefreshing = YES;
    
    if (selectedSegment == 0)
    {
        [self getCurrentOrders];
    }
    else
    {
        [self getPastOrders];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appDel setBottomTabBarColor:TABBAR_COLOR_GREY BlurEffectStyle:BLUR_EFFECT_STYLE_LIGHT HideBlurEffect:NO];
    [appDel setBottomTabBarColorForTab:2];
    
    [appDel showTabBar:appDel.customTabBarController];
    
    orderTableView.hidden = NO;
    titleLbl.hidden = NO;
    
    if (!isFirstTime)
    {
        if (appDel.directlyGotoOrderDetails)
        {
            selectedSegment = 0;
            
            [self getCurrentOrders];
        }
        else
        {
            if (selectedSegment == 0)
            {
                [self getCurrentOrders];
            }
            else
            {
                [self getPastOrders];
            }
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


-(void) segmentChange:(CustomSegmentControl *) sender
{
    [orderTableView setContentOffset:CGPointMake(0, -27)];
    //orderTableView.contentInset = UIEdgeInsetsMake(20*MULTIPLYHEIGHT, 0, 50, 0);
    
    if(sender.selectedIndex == 0) {
        
//        if (!isFirstTime)
//        {
//            [self getCurrentOrders];
//        }
        
        [self getCurrentOrders];
    }
    else {
        [self getPastOrders];
    }
    
}

- (void)getPastOrders
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", @"complete", @"status", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/get/all", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        orderTableView.userInteractionEnabled = YES;
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            if([[responseObj objectForKey:@"em"]count]){
                
                self.arrayOrders = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"em"]];
                
                bgImageView.image = [UIImage imageNamed:@"mywashes_singapore"];
            }
            else
            {
                [self.arrayOrders removeAllObjects];
                
                bgImageView.image = [UIImage imageNamed:@"noorders_BG"];
            }
            
            [orderTableView reloadData];
            
            refreshControl.hidden = YES;
            
            if (isRefreshing)
            {
                isRefreshing = NO;
                [refreshControl endRefreshing];
            }
            
            //[self callBackgroundImageService];
            
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
    
}


- (void)getCurrentOrders {
    
    if (!appDel.directlyGotoOrderDetails)
    {
        [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    }
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", @"New", @"status", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/get/all", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        orderTableView.userInteractionEnabled = YES;
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        isFirstTime = NO;
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            if([[responseObj objectForKey:@"em"] count]){
                
                self.arrayOrders = [NSMutableArray arrayWithArray:[responseObj objectForKey:@"em"]];
                
                if (appDel.directlyGotoOrderDetails)
                {
                    appDel.directlyGotoOrderDetails = NO;
                    [self gotoOrderDetails:0];
                }
                
                else if (appDel.openTrackingAuto || appDel.openOrderDetailAuto || appDel.openBillAuto)
                {
                    appDel.openTrackingAuto = NO;
                    appDel.openOrderDetailAuto = NO;
                    //appDel.openBillAuto = NO;
                    
                    [self gotoOrderDetails:0];
                }
                else
                {
//                    if ([self.arrayOrders count] >= 1)
//                    {
//                        if (@available(iOS 10.3, *))
//                        {
//                            [SKStoreReviewController requestReview];
//                        }
//                    }
                }
                
                bgImageView.image = [UIImage imageNamed:@"mywashes_singapore"];
                
            }
            else
            {
                [self.arrayOrders removeAllObjects];
                
                bgImageView.image = [UIImage imageNamed:@"noorders_BG"];
            }
            
            //[self callBackgroundImageService];
            
            [orderTableView reloadData];
            
            refreshControl.hidden = YES;
            
            if (isRefreshing)
            {
                isRefreshing = NO;
                [refreshControl endRefreshing];
            }
        }
        else {
            
            appDel.directlyGotoOrderDetails = NO;
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
    
}

-(void) callBackgroundImageService
{
    NSString *strCode;
    
    if (![self.arrayOrders count])
    {
        strCode = @"NO";
    }
    else
    {
        strCode = @"MO";
    }
    
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN],@"t", strCode, @"order", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@getorderstatusimages/services.do?", BASE_URL];
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
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"GET" withDetailsDictionary:nil andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] caseInsensitiveCompare:@"y"] == NSOrderedSame){
            
            if(responseObj &&[[responseObj objectForKey:@"r"] count]){
                
                if ([[responseObj objectForKey:@"r"]count])
                {
                    bgImageView.hidden = NO;
                    
                    NSString *strUrl = [[[responseObj objectForKey:@"r"]objectAtIndex:0]objectForKey:@"imgpath"];
                    
                    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    if ([appDel.dictImagesSaved objectForKey:strUrl])
                    {
                        orderTableView.backgroundColor = [UIColor clearColor];
                        
                        bgImageView.image = [appDel.dictImagesSaved objectForKey:strUrl];
                        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
                        bgImageView.clipsToBounds = YES;
                    }
                    else
                    {
                        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                            
                            if (!connectionError && data)
                            {
                                orderTableView.backgroundColor = [UIColor clearColor];
                                
                                bgImageView.image = [UIImage imageWithData:data];
                                bgImageView.contentMode = UIViewContentModeScaleAspectFill;
                                bgImageView.clipsToBounds = YES;
                                
                                [appDel.dictImagesSaved setObject:bgImageView.image forKey:strUrl];
                            }
                            
                        }];
                    }
                }
            }
        }
        else {
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void) gotoOrderDetails:(NSInteger) row
{
    __block BookViewController *bookVC = [[BookViewController alloc] init];
    bookVC.bookNowCobID = [[self.arrayOrders objectAtIndex:row] objectForKey:@"oid"];
    bookVC.isFromOrdersList = YES;
    [self.navigationController pushViewController:bookVC animated:YES];
}



#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block BookViewController *bookVC = nil;
    if (Static_screens_Build)
    {
        bookVC = [[BookViewController alloc] init];
        bookVC.bookNowCobID = @"480";
    }
    else
    {
        [self gotoOrderDetails:indexPath.section];
    }
}


-(void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersTableViewCell *cell = (OrdersTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    originalCellSize = cell.frame;
    
    //Using animation so the frame change transform will be smooth.
    
    [UIView animateWithDuration:0.1f animations:^{
        
        cell.transform = CGAffineTransformMakeScale(0.9, 0.9);
        //        cell.frame = CGRectMake(cell.frame.origin.x +20, cell.frame.origin.y, cell.frame.size.width-40, cell.frame.size.height);
    }];
    
}
-(void) tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrdersTableViewCell *cell = (OrdersTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    
    [UIView animateWithDuration:0.1f animations:^{
        cell.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        //        cell.frame = CGRectMake(0, originalCellSize.origin.y, self.view.bounds.size.width, 180) ;
    }];
    
    originalCellSize = CGRectMake(0, 0, 0, 0);
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float onWidth = 122.4*MULTIPLYHEIGHT; //170
    
    return onWidth;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float onWidth = 122.4*MULTIPLYHEIGHT; //170
    
    return onWidth;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10.0)];
    emptyView.backgroundColor = [UIColor clearColor];
    
    return emptyView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (Static_screens_Build)
    {
        return 10;
    }
    
    return [self.arrayOrders count];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"OrderCell";
    
    OrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[OrdersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier andWithDelegate:self];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    if (Static_screens_Build)
    {
        [cell setDetails:nil andCellType:1];
    }
    else
    {
        [cell setDetails:[self.arrayOrders objectAtIndex:indexPath.section] andCellType:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isDragging] || (tableView.contentOffset.y == 0.0))
    {
        cell.transform = self.transf;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            cell.transform = CGAffineTransformIdentity;
        }];
    }
    
//    cell.transform = self.transf;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        cell.transform = CGAffineTransformIdentity;
//    }];
}

- (BOOL)isForceTouchAvailable
{
    BOOL isForceTouchAvailable = NO;
    
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)])
    {
        isForceTouchAvailable = self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable;
    }
    
    return isForceTouchAvailable;
}

- (UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    // check if we're not already displaying a preview controller (BookViewController is my preview controller)
    if ([self.presentedViewController isKindOfClass:[BookViewController class]])
    {
        return nil;
    }
    
    CGPoint cellPostion = [orderTableView convertPoint:location fromView:self.view];
    NSIndexPath *path = [orderTableView indexPathForRowAtPoint:cellPostion];
    
    if (path)
    {
        OrdersTableViewCell *tableCell = [orderTableView cellForRowAtIndexPath:path];
        
        BookViewController *bookVC = [[BookViewController alloc] init];
        bookVC.delegate = self;
        bookVC.bookNowCobID = [[self.arrayOrders objectAtIndex:path.section] objectForKey:@"oid"];
        bookVC.isFromOrdersList = YES;
        
        previewingContext.sourceRect = [self.view convertRect:tableCell.frame fromView:orderTableView];
        
        bookGlobal = bookVC;
        
        return bookVC;
    }
    
    return nil;
}

- (void)previewingContext:(id )previewingContext commitViewController: (UIViewController *)viewControllerToCommit
{
    // if you want to present the selected view controller as it self us this:
    // [self presentViewController:viewControllerToCommit animated:YES completion:nil];
    
    // to render it with a navigation controller (more common) you should use this:
    [self.navigationController showViewController:viewControllerToCommit sender:nil];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    
    if ([self isForceTouchAvailable])
    {
        if (!self.previewingContext)
        {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.view];
        }
    }
    else
    {
        if (self.previewingContext)
        {
            [self unregisterForPreviewingWithContext:self.previewingContext];
            self.previewingContext = nil;
        }
    }
}

-(void) callParentControll:(NSString *) methodType
{
    [bookGlobal callPreviewAction:methodType];
    
    [self.navigationController showViewController:bookGlobal sender:nil];
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
