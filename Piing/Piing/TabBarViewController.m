//
//  TabBarViewController.m
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomePageViewController.h"
#import "MyBookingViewController.h"
#import "MoreViewController.h"
#import "BookViewController.h"
#import "ILTranslucentView.h"
#import "PriceListViewController_New.h"
#import "MyWalletViewController.h"



@interface TabBarViewController ()
{
    HomePageViewController *homePageVC;
    MyBookingViewController *myBookingVC;
    MoreViewController *moreViewCon;
    PriceListViewController_New *priceViewCon;
    MyWalletViewController *mywalletViewCon;
    
    UINavigationController *homePageNVC;
    UINavigationController *myBookingNVC;
    UINavigationController *navMore;
    UINavigationController *priceNav;
    UINavigationController *mywalletNav;
}

@end

@implementation TabBarViewController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    homePageVC = [[HomePageViewController alloc] init];
    homePageVC.title = @"BOOK";
    homePageNVC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    homePageNVC.navigationBarHidden = YES;
    homePageNVC.view.frame = self.view.bounds;
    
    
    myBookingVC = [[MyBookingViewController alloc] init];
    myBookingVC.title = @"MY WASHES";
    myBookingNVC = [[UINavigationController alloc] initWithRootViewController:myBookingVC];
    myBookingNVC.navigationBarHidden = YES;
    myBookingNVC.view.frame = self.view.bounds;
    
    moreViewCon = [[MoreViewController alloc] init];
    navMore = [[UINavigationController alloc] initWithRootViewController:moreViewCon];
    moreViewCon.title = @"MORE";
    navMore.navigationBarHidden = YES;
    navMore.view.frame = self.view.bounds;
    
    
    priceViewCon = [[PriceListViewController_New alloc]init];
    priceNav = [[UINavigationController alloc]initWithRootViewController:priceViewCon];
    priceNav.title = @"PRICING";
    priceNav.navigationBarHidden = YES;
    priceNav.view.frame = self.view.bounds;
    
    
    mywalletViewCon = [[MyWalletViewController alloc]init];
    mywalletNav = [[UINavigationController alloc]initWithRootViewController:mywalletViewCon];
    mywalletNav.title = @"MY WALLET";
    mywalletNav.navigationBarHidden = YES;
    mywalletNav.view.frame = self.view.bounds;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"y"] == NSOrderedSame)
    {
        self.viewControllers = [NSArray arrayWithObjects:homePageNVC, myBookingNVC, priceNav, navMore, nil];
    }
    else
    {
        self.viewControllers = [NSArray arrayWithObjects:homePageNVC, myBookingNVC, priceNav, mywalletNav, navMore, nil];
    }
    
    self.tabBar.barTintColor = [UIColor clearColor];
    [self.tabBar setBackgroundImage:[UIImage new]];
    
    CGRect frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.tabBar.frame.size.height);
    self.backgroundView = [[UIView alloc] initWithFrame:frame];
    self.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.85];
    [self.tabBar addSubview:self.backgroundView];
    
    
    
    
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.visualEffectView.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.tabBar.frame.size.height);
    //self.visualEffectView.alpha = 0.4;
    //[self.tabBar addSubview:self.visualEffectView];
    
    
    tabBarItem1 = [self.tabBar.items objectAtIndex:0];
    //[tabBarItem1 setImage:[[UIImage imageNamed:@"tab_book_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"tab_book_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"tab_book_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    tabBarItem2 = [self.tabBar.items objectAtIndex:1];
    [tabBarItem2 setImage:[[UIImage imageNamed:@"tab_mybooking_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"tab_mybooking_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST] caseInsensitiveCompare:@"y"] == NSOrderedSame)
    {
        tabBarItem3 = [self.tabBar.items objectAtIndex:2];
        [tabBarItem3 setImage:[[UIImage imageNamed:@"tab_pricing_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"tab_pricing_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        tabBarItem4 = [self.tabBar.items objectAtIndex:3];
        [tabBarItem4 setImage:[[UIImage imageNamed:@"tab_more_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"tab_more_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else
    {
        tabBarItem3 = [self.tabBar.items objectAtIndex:2];
        [tabBarItem3 setImage:[[UIImage imageNamed:@"tab_pricing_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"tab_pricing_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        
        tabBarItem4 = [self.tabBar.items objectAtIndex:3];
        [tabBarItem4 setImage:[[UIImage imageNamed:@"tab_mywallet_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem4 setSelectedImage:[[UIImage imageNamed:@"tab_mywallet_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        tabBarItem5 = [self.tabBar.items objectAtIndex:4];
        [tabBarItem5 setImage:[[UIImage imageNamed:@"tab_more_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [tabBarItem5 setSelectedImage:[[UIImage imageNamed:@"tab_more_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:27/255.0 green:103/255.0 blue:193/255.0 alpha:1.0]
//                                                        } forState:UIControlStateSelected];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
                                                        } forState:UIControlStateSelected];
    
    // doing this results in an easier to read unselected state then the default iOS 7 one
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor grayColor]
                                                        } forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -5.0)];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:27/255.0 green:103/255.0 blue:193/255.0 alpha:1.0]
//                                                        } forState:UIControlStateSelected];
    
    
    AppDelegate *appDel = [PiingHandler sharedHandler].appDel;
    
    appDel.isPriceListFromTab = NO;
    
    if ([item.title isEqualToString:@"BOOK"])
    {
        
        NSArray *array = homePageVC.childViewControllers;
        
        for (UIViewController *vc in array)
        {
            if ([vc isKindOfClass:[BookViewController class]])
            {
                BookViewController *bookVC = (BookViewController *) vc;
                if (bookVC.isFromOrdersList)
                {
                    [bookVC.view removeFromSuperview];
                    [bookVC removeFromParentViewController];
                }
            }
        }
        
//        self.visualEffectView.hidden = NO;
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        self.visualEffectView.effect = blurEffect;
        
        
        
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor whiteColor]
//                                                            } forState:UIControlStateNormal];
//        
//        [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"tab_book_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem2 setImage:[[UIImage imageNamed:@"tab_mybooking_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem3 setImage:[[UIImage imageNamed:@"tab_more_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else if ([item.title isEqualToString:@"MY WASHES"])
    {
//        self.visualEffectView.hidden = NO;
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        self.visualEffectView.effect = blurEffect;
        
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor grayColor]
//                                                            } forState:UIControlStateNormal];
//        
//        [tabBarItem1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                              NSForegroundColorAttributeName : [UIColor grayColor]
//                                              } forState:UIControlStateNormal];
//        
//        [tabBarItem2 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor grayColor]
//                                                            } forState:UIControlStateNormal];
//        
//        [tabBarItem2 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor colorWithRed:27/255.0 green:103/255.0 blue:193/255.0 alpha:1.0]
//                                                            } forState:UIControlStateSelected];
        
        
//        [tabBarItem1 setImage:[[UIImage imageNamed:@"tab_book_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"tab_mybooking_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem3 setImage:[[UIImage imageNamed:@"tab_more_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    else if ([item.title isEqualToString:@"MORE"])
    {
        //self.visualEffectView.hidden = YES;
        
//        [tabBarItem3 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor whiteColor]
//                                                            } forState:UIControlStateNormal];
//        
//        [tabBarItem3 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor colorWithRed:27/255.0 green:103/255.0 blue:193/255.0 alpha:1.0]
//                                                            } forState:UIControlStateSelected];

//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor whiteColor]
//                                                            } forState:UIControlStateNormal];
//        
//        [tabBarItem1 setImage:[[UIImage imageNamed:@"tab_mybooking_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem2 setImage:[[UIImage imageNamed:@"tab_more_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem3 setSelectedImage:[[UIImage imageNamed:@"tab_more_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    else if ([item.title isEqualToString:@"PRICING"])
    {
        appDel.isPriceListFromTab = YES;
    }
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
