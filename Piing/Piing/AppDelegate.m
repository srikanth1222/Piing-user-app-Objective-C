//
//  AppDelegate.m
//  Piing
//
//  Created by SHASHANK on 26/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "AppDelegate.h"
#import "BraintreeCore.h"
#import "BraintreeCard.h"
#import "RESideMenu.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ListViewController.h"


#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "RootViewController.h"
#import "AddressListViewController.h"
#import "PaymentListViewController.h"
#import "EmptyViewController.h"

#import "HomePageViewController.h"
//#import "MyBookingViewController.h"

#import "BookViewController.h"
#import "FXBlurView.h"
#import "IntraScreenViewController.h"
#import "WelcomeScreenViewController.h"

#import "PickupFeedbackViewController.h"
#import "DeliveryFeedbackViewController.h"
#import "iVersion.h"
#import <Tune/Tune.h>
#import "UIImage+animatedGIF.h"

#import <FirebaseCore/FirebaseCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>



#define APPLICATION_SHORTCUTITEMTYPE_BOOKANORDER @"com.piing.userpiing.BookAnOrder"
#define APPLICATION_SHORTCUTITEMTYPE_MYWASHES @"com.piing.userpiing.MyWashes"
#define APPLICATION_SHORTCUTITEMTYPE_PRICELIST @"com.piing.userpiing.PriceList"
#define APPLICATION_SHORTCUTITEMTYPE_MYWALLET @"com.piing.userpiing.MyWallet"

@interface AppDelegate ()<CLLocationManagerDelegate, RESideMenuDelegate, MBProgressHUDDelegate>
{
    RESideMenu *sideMenuViewController;
    
    UIImageView *imgSplashScreen;
    
    UIView *viewAd;
    UIView *view_Middle;
    
    UIBackgroundTaskIdentifier backgroundTaskIdentifier;
}

@property (nonatomic, strong) NSDictionary *loginDetailsGlobal;


@end

NSString *BraintreeDemoAppDelegatePaymentsURLScheme = @"com.piing.userpiing.payments";

@implementation AppDelegate

@synthesize latitude;
@synthesize longitude;


+ (void)initialize
{
    //example configuration
    [iVersion sharedInstance].appStoreID = 1106510073;
    //[iVersion sharedInstance].remoteVersionsPlistURL = @"http://example.com/versions.plist";
}

//+ (void)initialize
//{
//    //set the bundle ID. normally you wouldn't need to do this
//    //as it is picked up automatically from your Info.plist file
//    //but we want to test with an app that's actually on the store
//    [iVersion sharedInstance].applicationBundleID = @"com.piing.userpiing";
//    
//    //configure iVersion. These paths are optional - if you don't set
//    //them, iVersion will just get the release notes from iTunes directly (if your app is on the store)
//    [iVersion sharedInstance].remoteVersionsPlistURL = @"http://charcoaldesign.co.uk/iVersion/versions.plist";
//    [iVersion sharedInstance].localVersionsPlistPath = @"versions.plist";
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1106510073"]];
    
    //com.piing.userpiing
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat height = screenBounds.size.height;
    
    if (height == 568.0)
    {
        self.FONT_SIZE_CUSTOM = 13.0f;
        self.HEADER_LABEL_FONT_SIZE = 18.0f;
    }
    else if (height == 480.0)
    {
        self.FONT_SIZE_CUSTOM = 13.0f;
        self.HEADER_LABEL_FONT_SIZE = 18.0f;
    }
    else if (height == 667.0)
    {
        self.FONT_SIZE_CUSTOM = 15.0f;
        self.HEADER_LABEL_FONT_SIZE = 20.0f;
    }
    else if (height == 736.0)
    {
        self.FONT_SIZE_CUSTOM = 16.0f;
        self.HEADER_LABEL_FONT_SIZE = 22.0f;
    }
    else
    {
        self.FONT_SIZE_CUSTOM = 16.0f;
        self.HEADER_LABEL_FONT_SIZE = 22.0f;
    }
    
//    NSString *devTokenStr = @"1234567890";
//    
//    [[NSUserDefaults standardUserDefaults] setObject:devTokenStr forKey:DEVICETOKEN];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [Tune initializeWithTuneAdvertiserId:TUNE_ADVERTISER_ID
                       tuneConversionKey:TUNE_CONVERSION_KEY];
    
    [BTAppSwitch setReturnURLScheme:@"com.piing.userpiing.payments"];
    
    
    // Use Firebase library to configure APIs
    [FIRApp configure];
    
    //assert(false);
    
    backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
        [[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
        backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }];
    
    
    PiingHandler *handler = [PiingHandler sharedHandler];
    handler.appDel = self;
    
    self.dictImagesSaved = [[NSMutableDictionary alloc]init];
    
    self.dictEachSegmentCount = [[NSMutableDictionary alloc]init];
    
    self.dictPriceImages = [[NSMutableDictionary alloc]init];
    self.dictPriceSelectedImages = [[NSMutableDictionary alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:screenBounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (screenBounds.size.height == 812)
    {
        self.window.frame = CGRectMake(0, 30, screen_width, screen_height);
        NSLog(@"screen height : %f", screen_height);
    }
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    
    [Fabric with:@[CrashlyticsKit]];
    
    //[[Crashlytics sharedInstance] crash];
    
    
//    self.latitude = @"1.274791";
//    self.longitude = @"103.855519";
    
    [GMSServices provideAPIKey:GOOGLE_API_KEY];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerDeviceForPNSWithDevToken) name:REGISTER_DEVICETOKEN object:nil];
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
   
    
    //Required in all app
    if (![[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_TOKEN];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_TOURIST])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:IS_TOURIST];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"referalCode"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"referalCode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:USER_ID])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_ID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:USERNAME])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USERNAME];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
//    EmptyViewController *empty = [[EmptyViewController alloc]initWithNibName:@"EmptyViewController" bundle:nil];
//    self.window.rootViewController = empty;
//    
//    self.HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
//    [self.window addSubview:self.HUD];
//    
//    // Regiser for HUD callbacks so we can remove it from the window at the right time
//    self.HUD.delegate = self;
//    self.HUD.labelText = @"Loading";
//    [self.window addSubview:self.HUD];
//    
//    [self setrootVC];
//    
//    [self.window makeKeyAndVisible];
    
    
    
    
//    WelcomeScreenViewController *welcomeVC = [[WelcomeScreenViewController alloc] initWithNibName:@"WelcomeScreenViewController" bundle:nil];
//    self.window.rootViewController = welcomeVC;
//    [self.window addSubview:welcomeVC.view];
//    [self.window makeKeyAndVisible];
//    return YES;
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"INTRA_SHOWN"])
    {
        IntraScreenViewController *intra = [[IntraScreenViewController alloc]init];
        self.window.rootViewController = intra;
    }
    else
    {
        EmptyViewController *empty = [[EmptyViewController alloc]init];
        self.window.rootViewController = empty;
        
        [self setrootVC];
    }
    
    
    self.HUD = [[MBProgressHUD alloc] initWithWindow:self.window];
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"loader_gif" withExtension:@"gif"];
    //NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *animatedImage = [UIImage animatedImageWithAnimatedGIFURL:url];
    imageView.image = animatedImage;
    //self.HUD.dimBackground = YES;
    self.HUD.customView = imageView;
    self.HUD.color = [UIColor clearColor];
    self.HUD.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    self.HUD.delegate = self;
    //self.HUD.labelText = @"Loading";
    [self.window addSubview:self.HUD];
    
    [Tune setExistingUser:YES];
    
    //Location Services enableing
    
    
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    [locationManager requestAlwaysAuthorization];
    
//    if ([locationManager respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)]) {
//        [locationManager setAllowsBackgroundLocationUpdates:YES];
//    }
    
    locationManager.pausesLocationUpdatesAutomatically = NO;
    
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(shortcutItems)])
    {
        [self initializeShortCutItemList];
    }
    
    self.shortcutItemType = @"";
    
    BOOL shouldPerformAdditionalDelegateHandling = YES;
    
    NSDictionary *aPushNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    UIApplicationShortcutItem *infoShortcutItemKey = launchOptions[UIApplicationLaunchOptionsShortcutItemKey];
    
    if (aPushNotification)
    {
        NSDictionary *dictDetail = [aPushNotification objectForKey:@"aps"];
        
        [self showAlertWithMessage:[dictDetail objectForKey:@"alert"] andTitle:@"" andBtnTitle:@"OK"];
        //[self showAlertWithMessage:[dictDetail objectForKey:@"type"] andTitle:@"" andBtnTitle:@"OK"];
        
        if ([[aPushNotification objectForKey:@"type"] caseInsensitiveCompare:@"info"] == NSOrderedSame)
        {
            //self.openTrackingAuto = YES;
            //self.openBillAuto = YES;
        }
        else if ([[aPushNotification objectForKey:@"type"] caseInsensitiveCompare:@"tracking"] == NSOrderedSame)
        {
            self.openTrackingAuto = YES;
        }
        else if ([[aPushNotification objectForKey:@"type"] caseInsensitiveCompare:@"promotion"] == NSOrderedSame)
        {
            self.openPromotionsAuto = YES;
        }
        else if ([[aPushNotification objectForKey:@"type"] caseInsensitiveCompare:@"billReady"] == NSOrderedSame)
        {
            self.openBillAuto = YES;
        }
        else if ([[aPushNotification objectForKey:@"type"] caseInsensitiveCompare:@"haveAOrderToday"] == NSOrderedSame)
        {
            self.openOrderDetailAuto = YES;
        }
    }
    else if (infoShortcutItemKey)
    {
        self.shortcutItemType = infoShortcutItemKey.type;
        
        shouldPerformAdditionalDelegateHandling = NO;
    }
    
    [self.window makeKeyAndVisible];
    
    return shouldPerformAdditionalDelegateHandling;
}

-(void) initializeShortCutItemList
{
    UIMutableApplicationShortcutItem *bookNow = [[UIMutableApplicationShortcutItem alloc]initWithType:APPLICATION_SHORTCUTITEMTYPE_BOOKANORDER localizedTitle:@"Book An Order"];
    bookNow.icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"booknow"];
    
    UIMutableApplicationShortcutItem *myWashes = [[UIMutableApplicationShortcutItem alloc]initWithType:APPLICATION_SHORTCUTITEMTYPE_MYWASHES localizedTitle:@"My Washes"];
    myWashes.icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"mywashes"];
    
    UIMutableApplicationShortcutItem *priceList = [[UIMutableApplicationShortcutItem alloc]initWithType:APPLICATION_SHORTCUTITEMTYPE_PRICELIST localizedTitle:@"Price List"];
    priceList.icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"pricelist"];
    
    UIMutableApplicationShortcutItem *myWallet = [[UIMutableApplicationShortcutItem alloc]initWithType:APPLICATION_SHORTCUTITEMTYPE_MYWALLET localizedTitle:@"My Wallet"];
    myWallet.icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"mywallet"];
    
    [UIApplication sharedApplication].shortcutItems = @[bookNow, myWashes, priceList, myWallet];
}


#pragma mark Remote notifications Start of APNS

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
    NSString *devTokenStr = [devToken description];
    devTokenStr = [devTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    devTokenStr = [devTokenStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    devTokenStr = [devTokenStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setObject:devTokenStr forKey:DEVICETOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:self.deviceToken delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
    
    //[self registerDeviceForPNSWithDevToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if ([userInfo objectForKey:@"aps"])
    {
        NSDictionary *dictDetail = [userInfo objectForKey:@"aps"];
        
        [self showAlertWithMessage:[dictDetail objectForKey:@"alert"] andTitle:@"" andBtnTitle:@"OK"];
        //[self showAlertWithMessage:[dictDetail objectForKey:@"type"] andTitle:@"" andBtnTitle:@"OK"];
        
        //[self showAlertWithMessage:[userInfo description] andTitle:@"" andBtnTitle:@"OK"];
        
        if ([[userInfo objectForKey:@"type"] caseInsensitiveCompare:@"info"] == NSOrderedSame)
        {
            //self.openBillAuto = YES;
            //self.openTrackingAuto = YES;
        }
        else if ([[userInfo objectForKey:@"type"] caseInsensitiveCompare:@"tracking"] == NSOrderedSame)
        {
            self.openTrackingAuto = YES;
        }
        else if ([[userInfo objectForKey:@"type"] caseInsensitiveCompare:@"promotion"] == NSOrderedSame)
        {
            self.openPromotionsAuto = YES;
        }
        else if ([[userInfo objectForKey:@"type"] caseInsensitiveCompare:@"billReady"] == NSOrderedSame)
        {
            self.openBillAuto = YES;
        }
        else if ([[userInfo objectForKey:@"type"] caseInsensitiveCompare:@"haveAOrderToday"] == NSOrderedSame)
        {
            self.openOrderDetailAuto = YES;
        }
        
        self.customTabBarController.selectedIndex = 1;
    }
}

-(void)registerDeviceForPNSWithDevToken
{
    //NSLog(@"registerDeviceForPNSWithDevToken %@",self.deviceToken);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN] length] > 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID] length] > 0)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"IOS", @"deviceType", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:DEVICETOKEN], @"deviceToken", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user/registerdevice", BASE_URL];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                
                NSLog(@"stored device token in service");
            }
            else {
                
                NSLog(@"failed to store device token in service");
                
            }
        }];
    }
}

-(void) sendUserLocationToServer
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ID])
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", self.latitude, @"lat", self.longitude, @"lon", nil];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user/location/save", BASE_URL];
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
                
                NSLog(@"Saved user location in server!");
            }
            else {
                
                NSLog(@"failed to save user location!!!");
                
            }
        }];
    }
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    self.isStatusBarFrameChanged = YES;
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    if (self.customTabBarController.tabBar.isHidden)
    {
        [self hideTabBar:self.customTabBarController];
    }
    else
    {
        [self showTabBar:self.customTabBarController];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Attribution will not function without the measureSession call included
    
    [Tune measureSession];
}

// for iOS < 9.0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.piing.userpiing.payments"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }
    else
    {
        // when the app is opened due to a deep link, call the Tune deep link setter
        [Tune applicationDidOpenURL:url.absoluteString sourceApplication:sourceApplication];
    }
    
    return NO;
}

// for iOS >= 9.0
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.piing.userpiing.payments"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url options:options];
    }
    else
    {
        // when the app is opened due to a deep link, call the Tune deep link setter
        NSString *sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
        
        [Tune applicationDidOpenURL:url.absoluteString sourceApplication:sourceApplication];
    }
    
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    IsSendUserLocation = NO;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if (self.webViewAppDelegate)
    {
        [self.webViewAppDelegate reload];
    }
    
    [self registerDeviceForPNSWithDevToken];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REGISTER_DEVICETOKEN object:nil];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    self.shortcutItemType = shortcutItem.type;
    
    [self applicationShortcutItemClicked];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.latitude = [NSString stringWithFormat:@"%lf", ((CLLocation*) [locations objectAtIndex:0]).coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%lf", ((CLLocation*) [locations objectAtIndex:0]).coordinate.longitude];
    
    NSLog(@"Getting locations");
    
    if (!IsSendUserLocation)
    {
        IsSendUserLocation = YES;
        [self sendUserLocationToServer];
    }
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // DLog(@"Error: %@",[error localizedDescription]);
    
    // NSString *errorString = @"￼Location manager failed to update the location. Please try again.";
    //    [locationManager stopUpdatingLocation];
    
    //[self showAlertWithMessage:[error localizedDescription] andTitle:@"" andBtnTitle:@"OK"];
    
    switch([error code])
    {
        case kCLErrorDenied:
            //Access denied by user
            // DLog(@"denied by user");
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            //  DLog(@"temporary error");
            //Do something else...
            break;
        default:
            //  DLog(@"unknown error");
            break;
    }
}
#pragma mark - Core Data stack

//@synthesize managedObjectContext = _managedObjectContext;
//@synthesize managedObjectModel = _managedObjectModel;
//@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "piing.Piing" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}
//
//- (NSManagedObjectModel *)managedObjectModel {
//    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
//    if (_managedObjectModel != nil) {
//        return _managedObjectModel;
//    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Piing" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//    return _managedObjectModel;
//}
//
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
//    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    // Create the coordinator and store
//    
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Piing.sqlite"];
//    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:FLT_MAX userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}
//
//
//- (NSManagedObjectContext *)managedObjectContext {
//    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
//    if (_managedObjectContext != nil) {
//        return _managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (!coordinator) {
//        return nil;
//    }
//    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
//    return _managedObjectContext;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        NSError *error = nil;
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//}

#pragma mark CustomLodaer

-(void) showLoader{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        
        [UIView animateWithDuration:0.15 animations:^{
            
            [self.window addSubview:self.HUD];
            [self.window bringSubviewToFront:self.HUD];
            [self.HUD show:NO];
            
            if (self.fetchingTimeSlots)
            {
                self.fetchingTimeSlots = NO;
                self.HUD.labelText = @"Fetching time slots...";
            }
            else
            {
                self.HUD.labelText = @"";
            }
    
        }];
        
    }];
}

-(void)hideLoader{
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [UIView animateWithDuration:0.15 animations:^{
            
            [self.HUD hide:NO];
            self.HUD.labelText = @"";
            
        }];
        
    }];
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"willShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    DLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
-(void)receivedResponse:(id) response
{
    DLog(@"AppDel Response RegisterDevice %@",response);
}
#pragma mark UUID Related
+ (NSString *)GetUUID{
    NSString *uuid;
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    uuid = (__bridge NSString *)string;
    
    [SSKeychain setPassword:uuid forService:@"com.piing.userpiing" account:@"UserPiing"];
    return uuid ;
}

-(NSMutableAttributedString *) getAttributedStringWithString:(NSString *) string WithSpacing:(CGFloat) value
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    
    [attributedString addAttribute:NSKernAttributeName
                             value:@(1.4)
                             range:NSMakeRange(0, string.length)];
    return attributedString;
}


-(NSMutableAttributedString *) getAttributedStringWithSpacing:(NSString *) string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    
    [attributedString addAttribute:NSKernAttributeName
                             value:@(1.4)
                             range:NSMakeRange(0, string.length)];
    return attributedString;
}


-(void) setrootVC
{
    [self callLoginMethod];
}

-(void) userLogout
{
    //    RESideMenu *myNavCon = (RESideMenu*)self.window.rootViewController;
    //    [myNavCon popToRootViewControllerAnimated:YES];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:self withObject:nil];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/logout", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dict andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
        
        if ([[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [self staticUserLogout];
        }
        else
        {
            [self displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(void) staticUserLogout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERNAME];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:IS_TOURIST];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREFERENCES_SELECTED];
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SHOW_BAG_SHOE"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Scroll_Horizantal"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREFERENCES_OPENED];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Price_Jobtypes"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (id view in self.window.subviews)
    {
        [view removeFromSuperview];
    }
    
    IntraScreenViewController *intra = [[IntraScreenViewController alloc]init];
    self.window.rootViewController = intra;
    
    
//    RootViewController *homeViewController = [[RootViewController alloc] init];
//    UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//    
//    self.window.rootViewController = rootNavController;
//    [self.window addSubview:rootNavController.view];
}

- (void)resetDefaults
{
//    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
//    NSDictionary * dict = [defs dictionaryRepresentation];
//    for (id key in dict) {
//        [defs removeObjectForKey:key];
//    }
//    [defs synchronize];
}


-(void) loginCompleted
{
    self.window.backgroundColor = [UIColor whiteColor];
        
    [self getAddress];
    
}

-(void) getAddress
{
    NSString *urlStr = [NSString stringWithFormat:@"%@address/get", BASE_URL];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [PiingHandler sharedHandler].userAddress = [responseObj objectForKey:@"addresses"];
            
            [self getSavedCards];
        }
        else if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 10)
        {
            self.isVerificationCodeEnabled = YES;
            
            for (id view in self.window.subviews)
            {
                [view removeFromSuperview];
            }
            
            RootViewController *homeViewController = [[RootViewController alloc] init];
            UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
            
            [self.window setRootViewController:rootNavController];
            [self.window addSubview:rootNavController.view];
        }
        else if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 2)
        {
            AddressListViewController *listAddressVC = [[AddressListViewController alloc] init];
            self.isFirstTimeAddressAdding = YES;
            UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:listAddressVC];
            
            [self.window setRootViewController:rootNavController];
            [self.window addSubview:rootNavController.view];
        }
        else
        {
            if (!self.loginClicked)
            {
                [self staticUserLogout];
            }
            
            [self displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(void) getSavedCards
{
    NSString *urlStr = [NSString stringWithFormat:@"%@payment/getallpaymentmethods", BASE_URL];
    
    NSMutableDictionary *verificationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            NSDictionary *dict = [responseObj objectForKey:@"paymentMethod"];
            
            NSMutableArray *arrayCards = [self getAllSavedCards:dict];
            
            [PiingHandler sharedHandler].userSavedCards = arrayCards;
            
            [self getUserDetails];
        }
        else {
            
            if (!self.loginClicked)
            {
                [self staticUserLogout];
            }
            
            [self displayErrorMessagErrorResponse:responseObj];
        }
        
    }];
}


-(NSMutableArray *) getAllSavedCards:(NSDictionary *) dict
{
    NSMutableArray *arrayCards = [[NSMutableArray alloc]init];
    
    NSDictionary *dictCash = nil;
    
    if ([[[dict objectForKey:@"cash"] objectForKey:@"default"]intValue] == 1)
    {
        dictCash = [NSDictionary dictionaryWithObjectsAndKeys:@"CASH ON DELIVERY", @"maskedCardNo", @"Cash", @"_id", @"1", @"default", nil];
    }
    else
    {
        dictCash = [NSDictionary dictionaryWithObjectsAndKeys:@"CASH ON DELIVERY", @"maskedCardNo", @"Cash", @"_id", @"0", @"default", nil];
    }
    
    [arrayCards addObject:dictCash];
    
    if ([[[dict objectForKey:@"card"] objectForKey:@"cardList"] count])
    {
        [arrayCards addObjectsFromArray:[[dict objectForKey:@"card"] objectForKey:@"cardList"]];
    }
    
    return arrayCards;
}


-(void) getUserDetails
{
    NSDictionary *verificationDetailsDic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@user/get", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:verificationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1) {
            
            NSDictionary *dictUserDetails = [responseObj objectForKey:@"user"];
            
            NSMutableString *strPref = [@"" mutableCopy];
            
            if ([[dictUserDetails objectForKey:PREFERENCES_SELECTED] count] >= 5)
            {
                NSDictionary *dict1 = [dictUserDetails objectForKey:PREFERENCES_SELECTED];
                
                NSMutableDictionary *dictMain  = [[NSMutableDictionary alloc]init];
                
                for (NSDictionary *dict2 in dict1)
                {
                    [dictMain setObject:[dict2 objectForKey:@"value"] forKey:[dict2 objectForKey:@"name"]];
                }
                
                if ([dictMain count])
                {
                    [strPref appendString:@"["];
                    
                    for (NSString *strakey in dictMain)
                    {
                        [strPref appendFormat:@"%@", [NSString stringWithFormat:@"{\"name\":\"%@\",\"value\":\"%@\"},", strakey, [dictMain objectForKey:strakey]]];
                    }
                    
                    if ([strPref hasSuffix:@","])
                    {
                        strPref = [[strPref substringToIndex:[strPref length]-1]mutableCopy];
                    }
                    
                    [strPref appendString:@"]"];
                }
            }
            else
            {
                
                NSMutableDictionary *dictMain = [self getDefaultPreferences];
                
                if ([dictMain count])
                {
                    [strPref appendString:@"["];
                    
                    for (NSString *strakey in dictMain)
                    {
                        [strPref appendFormat:@"%@", [NSString stringWithFormat:@"{\"name\":\"%@\",\"value\":\"%@\"},", strakey, [dictMain objectForKey:strakey]]];
                    }
                    
                    if ([strPref hasSuffix:@","])
                    {
                        strPref = [[strPref substringToIndex:[strPref length]-1]mutableCopy];
                    }
                    
                    [strPref appendString:@"]"];
                }
            }
            
            self.strGlobalPreferenes = strPref;
            
            [self checkOtherConditions];
        }
        else {
            
            if (!self.loginClicked)
            {
                [self staticUserLogout];
            }
            
            [self displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(NSMutableDictionary *) getDefaultPreferences
{
    NSMutableDictionary *dictMain  = [[NSMutableDictionary alloc]init];
    
    [dictMain setObject:@"Hanger" forKey:@"Shirts"];
    
    [dictMain setObject:@"Standard Hanger" forKey:@"TrousersHanged"];
    
    [dictMain setObject:@"With Crease" forKey:@"TrousersCrease"];
    
    [dictMain setObject:@"No Starch" forKey:@"Starch"];
    
    [dictMain setObject:@"No" forKey:@"Stain"];
    
    [dictMain setObject:@"" forKey:@"Note"];
    
    return dictMain;
}

-(void)callLoginMethod
{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] length])
    {
        
        NSString *passwordStr = [[[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPasswordAllowedCharacterSet]];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USERNAME], @"email", passwordStr, @"password", nil];
        
        NSLog(@"Login Dic : %@", dic);
        
        NSString *urlStr = [NSString stringWithFormat:@"%@user/login", BASE_URL];
        
        //[NSThread detachNewThreadSelector:@selector(showLoader) toTarget:self withObject:nil];
        
        self.loginMethodCalled = YES;
        
        [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
            
            //[NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:[responseObj objectForKey:@"uid"] forKey:USER_ID];
                    [[NSUserDefaults standardUserDefaults] setObject:[responseObj objectForKey:@"t"] forKey:USER_TOKEN];
                    
                    self.strPhoneNumber = [responseObj objectForKey:@"phone"];
                    
                    
                    NSDictionary *loginDetails = [responseObj objectForKey:@"r"];
                    
                    self.loginDetailsGlobal = [[NSDictionary alloc]initWithDictionary:loginDetails];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[loginDetails objectForKey:@"refCode"] forKey:@"referalCode"];
                    
                    NSString *strTourist;
                    
                    if ([[loginDetails objectForKey:IS_TOURIST]intValue] == 0)
                    {
                        strTourist = @"R";
                    }
                    else
                    {
                        strTourist = @"T";
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setObject:strTourist forKey:IS_TOURIST];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:REGISTER_DEVICETOKEN object:self];
                    
                    self.strReferralMessage = [loginDetails objectForKey:@"refMessage"];
                    
                    self.freewashAmount = [[loginDetails objectForKey:@"freeWashDiscount"]floatValue];
                    self.fold_ExtraCharge = [[loginDetails objectForKey:@"foldPrice"]floatValue];
                    self.clipHanger_ExtraCharge = [[loginDetails objectForKey:@"clipHangerPrice"]floatValue];
                    
                    if ([[loginDetails objectForKey:@"recDiscountType"] isEqualToString:@"P"])
                    {
                        self.strRecurringAmount = [NSString stringWithFormat:@"%d%%", [[loginDetails objectForKey:@"recDiscount"] intValue]];
                    }
                    else
                    {
                        self.strRecurringAmount = [NSString stringWithFormat:@"$%.2f", [[loginDetails objectForKey:@"recDiscount"] floatValue]];
                    }
                    
                    self.strShoeClean = [loginDetails objectForKey:@"shoeCleaning"];
                    self.strShoePolish = [loginDetails objectForKey:@"shoePolishing"];
                    self.strBagClean = [loginDetails objectForKey:@"bagCleaning"];
                    self.strCurtainClean = [loginDetails objectForKey:@"curtainCleaning"];
                    
                    self.strShoeStartPrice = [loginDetails objectForKey:@"shoeStartingPrice"];
                    self.strBagStartPrice = [loginDetails objectForKey:@"bagStartPrice"];
                    
                    [self getAddress];
                    
                }
                else if ([[responseObj objectForKey:@"s"] intValue] == 12)
                {
                    self.strPhoneNumber = [NSString stringWithFormat:@"+65 %@", [responseObj objectForKey:@"cno"]];
                    
                    self.isVerificationCodeEnabled = YES;
                    
                    for (id view in self.window.subviews)
                    {
                        [view removeFromSuperview];
                    }
                    
                    RootViewController *homeViewController = [[RootViewController alloc] init];
                    UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
                    
                    [self.window setRootViewController:rootNavController];
                    [self.window addSubview:rootNavController.view];
                }
                else if ([[responseObj objectForKey:@"s"] intValue] == 0)
                {
                    [self showAlertWithMessage:@"Invalid combination. Have another go." andTitle:@"" andBtnTitle:@"OK"];
                    
                    if (!self.loginClicked)
                    {
                        [self staticUserLogout];
                    }
                    else
                    {
                        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
                    }
                }
                else if (responseObj == nil)
                {
                    [self showAlertWithMessage:@"Oops! Something tore. We are working on it right now. Please check back." andTitle:@"" andBtnTitle:@"OK"];
                    
                    if (!self.loginClicked)
                    {
                        [self staticUserLogout];
                    }
                }
                
            }];
            
        }];
    }
    else
    {
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
        
        for (id view in self.window.subviews)
        {
            [view removeFromSuperview];
        }
        
        IntraScreenViewController *intra = [[IntraScreenViewController alloc]init];
        self.window.rootViewController = intra;
        
        
//        RootViewController *homeViewController = [[RootViewController alloc] init];
//        UINavigationController *rootNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//        
//        [self.window setRootViewController:rootNavController];
//        [self.window addSubview:rootNavController.view];
    }
}


-(void) SetHomePage
{
    self.loginClicked = NO;
    
    self.customTabBarController = [[TabBarViewController alloc] init];
    ListViewController *listVC = [[ListViewController alloc] init];
    
    sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:self.customTabBarController
                                                        leftMenuViewController:nil
                                                       rightMenuViewController:listVC];
    
    sideMenuViewController.backgroundImage = [UIImage imageNamed:@"Stars"];
    sideMenuViewController.menuPreferredStatusBarStyle = 1; // UIStatusBarStyleLightContent
    sideMenuViewController.delegate = self;
    sideMenuViewController.contentViewShadowColor = [UIColor blackColor];
    sideMenuViewController.contentViewShadowOffset = CGSizeMake(0, 0);
    sideMenuViewController.contentViewShadowOpacity = 0.3;
    sideMenuViewController.contentViewShadowRadius = 5;
    sideMenuViewController.contentViewShadowEnabled = YES;
    sideMenuViewController.parallaxEnabled = NO;
    
    self.window.rootViewController = sideMenuViewController;
    [self.window addSubview:sideMenuViewController.view];
    
    
//    if ([[self.loginDetailsGlobal objectForKey:@"advtflag"] caseInsensitiveCompare:@"Y"] == NSOrderedSame)
//    {
//        [self showAdvertisement];
//    }
}

-(void) showAdvertisement
{
    viewAd = [[UIView alloc]initWithFrame:self.window.bounds];
    viewAd.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    
    UITapGestureRecognizer *tapAd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAd:)];
    tapAd.numberOfTapsRequired = 1;
    tapAd.numberOfTouchesRequired = 1;
    [viewAd addGestureRecognizer:tapAd];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeAd:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [viewAd addGestureRecognizer:swipeDown];
    
    
    float viewX = 26*MULTIPLYHEIGHT;
    float viewHeight = 180*MULTIPLYHEIGHT;
    
    view_Middle = [[UIView alloc]initWithFrame:CGRectMake(viewX, screen_height, screen_width-(viewX*2), viewHeight)];
    //view_Middle.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.6];
    [viewAd addSubview:view_Middle];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnPromotions:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view_Middle addGestureRecognizer:tap];
    
    
    UIImageView *imgBG = [[UIImageView alloc]initWithFrame:view_Middle.bounds];
    //imgBG.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imgBG.contentMode = UIViewContentModeScaleAspectFill;
    [view_Middle addSubview:imgBG];
    
    
    float btnCloseX = 32*MULTIPLYHEIGHT;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, btnCloseX, btnCloseX);
    [view_Middle addSubview:btnClose];
    //btnClose.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.6];
    [btnClose addTarget:self action:@selector(closeAd:) forControlEvents:UIControlEventTouchUpInside];
    
    
    float yAxis = 102*MULTIPLYHEIGHT;
    
    float btnKnowX = 55*MULTIPLYHEIGHT;
    float btnKnowHeight = 25*MULTIPLYHEIGHT;
    
    UIButton *btnKnowMore = [UIButton buttonWithType:UIButtonTypeCustom];
    //btnKnowMore.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.6];
    btnKnowMore.frame = CGRectMake(btnKnowX, yAxis, view_Middle.frame.size.width-(btnKnowX*2), btnKnowHeight);
    [view_Middle addSubview:btnKnowMore];
    [btnKnowMore addTarget:self action:@selector(btnPromotions:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    float yAxis = 15*MULTIPLYHEIGHT;
//
//    float lblPriceHeight = 25*MULTIPLYHEIGHT;
//    
//    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblPriceHeight)];
//    lblPrice.textAlignment = NSTextAlignmentCenter;
//    lblPrice.textColor = [UIColor darkGrayColor];
//    [view_Middle addSubview:lblPrice];
//    
//    NSString *str1 = @"$10";
//    NSString *str2 = [@" off" uppercaseString];
//    
//    NSString *strPrice = [NSString stringWithFormat:@"%@%@", str1, str2];
//    
//    NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc]initWithString:strPrice];
//    [attrPrice addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:self.HEADER_LABEL_FONT_SIZE]} range:NSMakeRange(0, str1.length)];
//    [attrPrice addAttributes:@{NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:self.FONT_SIZE_CUSTOM]} range:NSMakeRange(str1.length, str2.length)];
//    
//    lblPrice.attributedText = attrPrice;
    
    
    if ([[self.loginDetailsGlobal objectForKey:@"advturl"] length])
    {
        NSString *strurl = [[self.loginDetailsGlobal objectForKey:@"advturl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //NSString *strurl = [@"http://searchengineland.com/figz/wp-content/seloads/2015/12/google-amp-fast-speed-travel-ss-1920-800x450.jpg" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:strurl]];
        
        [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            UIImage *image = [UIImage imageWithData:data];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                imgBG.image = image;
                
                viewAd.alpha = 0.0f;
                [self.window addSubview:viewAd];
                
                [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    viewAd.alpha = 1.0f;
                    view_Middle.frame = CGRectMake(viewX, screen_height/2-viewHeight/2, screen_width-(viewX*2), viewHeight);
                    
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
    else
    {
        imgBG.image = [UIImage imageNamed:@"promotion_ad.png"];
        
        [self.window addSubview:viewAd];
        viewAd.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            viewAd.alpha = 1.0f;
            view_Middle.frame = CGRectMake(viewX, screen_height/2-viewHeight/2, screen_width-(viewX*2), viewHeight);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void) btnPromotions:(id)sender
{
    self.hasAdCode = 1;
    self.customTabBarController.selectedIndex = 2;
    
    [self closeAd:nil];
}

-(void) closeAd:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        viewAd.alpha = 0.0f;
        CGRect rect = view_Middle.frame;
        rect.origin.y = screen_height;
        view_Middle.frame = rect;
        
        
    } completion:^(BOOL finished) {
        
        [viewAd removeFromSuperview];
        viewAd = nil;
        
    }];
}


-(void) callClientOrderDetails
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:self withObject:nil];
    
    NSDictionary *dictDetail = [NSDictionary dictionaryWithObjectsAndKeys:self.cobIdForCurrentBooking, @"oid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/get/byid", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dictDetail andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            if ([[responseObj objectForKey:@"em"] count])
            {
                NSDictionary *dictMain = [[responseObj objectForKey:@"em"] objectAtIndex:0];
                
                NSDictionary *selectedAddressDic;
                
                NSArray *sortedArray1 = [[NSMutableArray alloc]initWithArray:[PiingHandler sharedHandler].userAddress];
                NSPredicate *getDefaultAddPredicate1 = [NSPredicate predicateWithFormat:@"_id == %@", [NSString stringWithFormat:@"%@", [dictMain objectForKey:ORDER_PICKUP_ADDRESS_ID]]];
                
                sortedArray1 = [sortedArray1 filteredArrayUsingPredicate:getDefaultAddPredicate1];
                
                if ([sortedArray1 count] > 0)
                {
                    selectedAddressDic = [sortedArray1 objectAtIndex:0];
                }
                
                AddressFeild *objAddress = [[AddressFeild alloc] init];
                
                objAddress.addressID = [selectedAddressDic objectForKey:@"_id"];
                objAddress.addressName = [selectedAddressDic objectForKey:@"name"];
                objAddress.isAddressDefault = [selectedAddressDic objectForKey:@"default"];
                objAddress.zipCode = [selectedAddressDic objectForKey:@"zipcode"];
                objAddress.notes = [selectedAddressDic objectForKey:@"landMark"];
                
                BookViewController *bookVC = [[BookViewController alloc] init];
                bookVC.isBookNowStarted = YES;
                bookVC.isFromBookNow = YES;
                bookVC.addressField = objAddress;
                bookVC.selectedAddress = selectedAddressDic;
                bookVC.bookNowCobID = self.cobIdForCurrentBooking;
                bookVC.dictBookNowDetails = [[NSDictionary alloc]initWithDictionary:dictMain];
                
                if ([[dictMain objectForKey:@"ppid"] intValue] > 0)
                {
                    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [dictMain objectForKey:@"ppid"], @"pid", nil];
                    
                    NSString *urlStr = [NSString stringWithFormat:@"%@piingo/get", BASE_URL];
                    
                    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
                        
                        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
                        
                        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
                            
                            NSDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[responseObj objectForKey:@"em"]];
                            
                            bookVC.piingoImg = [dict objectForKey:@"image"];
                            
                            bookVC.piingoName = [[dict objectForKey:@"name"] uppercaseString];
                            bookVC.piingoId = [[dict objectForKey:@"pid"] stringValue];
                            bookVC.isCurrentTimeSlot = [[dict objectForKey:@"tracking"] boolValue];
                            
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                
                                UINavigationController *objNavHome = [self.customTabBarController.viewControllers objectAtIndex:0];
                                HomePageViewController *objHome = [objNavHome.viewControllers objectAtIndex:0];
                                
                                bookVC.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                                [objHome addChildViewController:bookVC];
                                [objHome.view addSubview:bookVC.view];
                                
                                [UIView animateWithDuration:0.3 animations:^{
                                    
                                    bookVC.view.frame = objHome.view.bounds;
                                    
                                    //[self hideTabBar:self.customTabBarController];
                                    
                                } completion:^(BOOL finished) {
                                    
                                    
                                }];
                            }];
                        }
                        else {
                            
                            [self displayErrorMessagErrorResponse:responseObj];
                        }
                        
                    }];
                }
                else
                {
                    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
                    
                    if ([[dictMain objectForKey:@"piingoImg"] length])
                    {
                        bookVC.piingoImg = [NSString stringWithFormat:@"%@%@", BASE_TRACKING_URL, [dictMain objectForKey:@"piingoImg"]];
                    }
                    
                    bookVC.piingoName = [[dictMain objectForKey:@"piingoName"] uppercaseString];
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        [self hideTabBar:self.customTabBarController];
                        
                        UINavigationController *objNavHome = [self.customTabBarController.viewControllers objectAtIndex:0];
                        HomePageViewController *objHome = [objNavHome.viewControllers objectAtIndex:0];
                        
                        bookVC.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
                        [objHome addChildViewController:bookVC];
                        [objHome.view addSubview:bookVC.view];
                        
                        [UIView animateWithDuration:0.3 animations:^{
                            
                            bookVC.view.frame = objHome.view.bounds;
                            
                        } completion:^(BOOL finished) {
                            
                            
                        }];
                    }];
                }
            }
            else
            {
                UINavigationController *objNavHome = [self.customTabBarController.viewControllers objectAtIndex:0];
                HomePageViewController *objHome = [objNavHome.viewControllers objectAtIndex:0];
                
                self.isBookNowPending = NO;
                self.customTabBarController.selectedIndex = 0;
                
                [objHome viewWillAppear:YES];
            }
        }
        else {
            
            [self displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(void) checkOtherConditions
{
    if ([self.loginDetailsGlobal objectForKey:@"pFeedBack"] && [[self.loginDetailsGlobal objectForKey:@"pFeedBack"] intValue] == 1)
    {
        [self showPickUpFeedbackScreen];
    }
    else if ([self.loginDetailsGlobal objectForKey:@"dFeedBack"] && [[self.loginDetailsGlobal objectForKey:@"dFeedBack"] intValue] == 1)
    {
        [self showDeliveryFeedbackScreen];
    }
    else
    {
        [self checkConditionsAfterFeedback];
    }
}

-(void) checkConditionsAfterFeedback
{
    if ([[self.loginDetailsGlobal objectForKey:@"pendingOrder"] intValue] == 1)
    {
        self.cobIdForCurrentBooking = [self.loginDetailsGlobal objectForKey:@"pendingOrderId"];
        
        [self SetHomePage];
        
        self.isBookNowPending = YES;
        
        [self callClientOrderDetails];
    }
    else
    {
        [self SetHomePage];
        
        if (self.openTrackingAuto || self.openOrderDetailAuto || self.openBillAuto)
        {
            self.customTabBarController.selectedIndex = 1;
        }
        else
        {
            if ([self.shortcutItemType length])
            {
                [self applicationShortcutItemClicked];
            }
            else
            {
                self.customTabBarController.selectedIndex = 0;
            }
        }
    }
}

-(void) applicationShortcutItemClicked
{
    if ([self.shortcutItemType isEqualToString:APPLICATION_SHORTCUTITEMTYPE_BOOKANORDER])
    {
        self.customTabBarController.selectedIndex = 0;
    }
    else if ([self.shortcutItemType isEqualToString:APPLICATION_SHORTCUTITEMTYPE_MYWASHES])
    {
        self.customTabBarController.selectedIndex = 1;
    }
    else if ([self.shortcutItemType isEqualToString:APPLICATION_SHORTCUTITEMTYPE_PRICELIST])
    {
        self.isPriceListFromTab = YES;
        self.customTabBarController.selectedIndex = 2;
    }
    else if ([self.shortcutItemType isEqualToString:APPLICATION_SHORTCUTITEMTYPE_MYWALLET])
    {
        self.customTabBarController.selectedIndex = 3;
    }
    
    NSLog(@"ShortcutItem type is empty.....!!!!!!!");
    
    self.shortcutItemType = @"";
}


-(void) showPickUpFeedbackScreen
{
    PickupFeedbackViewController *pfbvc = [[PickupFeedbackViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pfbvc];
    nav.navigationBarHidden = YES;
    pfbvc.loginDetails = [[NSDictionary alloc]initWithDictionary:self.loginDetailsGlobal];
    [self.window setRootViewController:nav];
}

-(void) showDeliveryFeedbackScreen
{
    DeliveryFeedbackViewController *pfbvc = [[DeliveryFeedbackViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:pfbvc];
    nav.navigationBarHidden = YES;
    pfbvc.loginDetails = [[NSDictionary alloc]initWithDictionary:self.loginDetailsGlobal];
    [self.window setRootViewController:nav];
}


-(void)displayErrorMessagErrorResponse:(NSDictionary *)response {
    
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if ([[response objectForKey:@"error"] length])
        {
            if([[response objectForKey:@"s"] intValue] == 100)
            {
                [self staticUserLogout];
            }
            else
            {
                [self showAlertWithMessage:[response objectForKey:@"error"] andTitle:@"" andBtnTitle:@"OK"];
            }
        }
        else if([[response objectForKey:@"s"] intValue] == 2)
        {
            [self showAlertWithMessage:@"Email Doesn't Exists" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 3)
        {
            [self showAlertWithMessage:@"Email Already Exists" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 4)
        {
            [self showAlertWithMessage:@"Mobile Number Already Exists" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 5)
        {
            [self showAlertWithMessage:@"Zone Change while updating Address" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 6)
        {
            [self showAlertWithMessage:@"Today is Pickup or Delivery Date Address Update Not Allowed" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 7)
        {
            [self showAlertWithMessage:@"Current Password Doesn't Exists" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 8)
        {
            [self showAlertWithMessage:@"Error while saving data" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 9)
        {
            [self showAlertWithMessage:@"Error while saving data" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 10)
        {
            [self showAlertWithMessage:@"Invalid Input." andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 11)
        {
            [self showAlertWithMessage:@"Referral Code Is Invalid" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 12)
        {
            [self showAlertWithMessage:@"Already registered with this Email Id and activation process is not completed" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 13)
        {
            [self showAlertWithMessage:@"Restriction for Registration with single device more than 3 Times" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 14)
        {
            [self showAlertWithMessage:@"Guest Order Details Saved Successfully" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 15)
        {
            [self showAlertWithMessage:@"Order Already Confirmed" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 17)
        {
            [self showAlertWithMessage:@"Currently there are no piingo available for this zone" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 21)
        {
            [self showAlertWithMessage:@"Card Details does not exist" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 22)
        {
            [self showAlertWithMessage:@"Piingo Id Doesn't Exists" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 23)
        {
            [self showAlertWithMessage:@"Order Doesn't Exists With This Cobid" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 24)
        {
            [self showAlertWithMessage:@"Promocode Does Not Exist" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 25)
        {
            [self showAlertWithMessage:@"ManualTagNo Does Not Exist" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 50)
        {
            [self showAlertWithMessage:@"Please enter valid Verification code" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 51)
        {
            [self showAlertWithMessage:@"Activation Code Expired" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 52)
        {
            [self showAlertWithMessage:@"Zip Code does not exists/ not found" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 53)
        {
            [self showAlertWithMessage:@"Account Not Activated" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 54)
        {
            [self showAlertWithMessage:@"Aname Already Exists" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 55)
        {
            [self showAlertWithMessage:@"Account doesn't exists with this User Id" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 100)
        {
            [self showAlertWithMessage:@"Invalid Token." andTitle:nil andBtnTitle:@"OK"];
            [self staticUserLogout];
        }
        else if([[response objectForKey:@"s"] intValue] == 101)
        {
            [self showAlertWithMessage:@"Error Response from CSS from client order booking" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 102)
        {
            [self showAlertWithMessage:@"Service Denied Details from CSS" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 103)
        {
            [self showAlertWithMessage:@"Confirm Book Now Failed Due to Internal Error in CSS Way Points" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 104)
        {
            [self showAlertWithMessage:@"Error Response from CSS from clientorderdetails" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if([[response objectForKey:@"s"] intValue] == 105)
        {
            [self showAlertWithMessage:@"Error Response from CSS from update client order booking" andTitle:@"" andBtnTitle:@"OK"];
        }
        else if (response == nil)
        {
            //[self showAlertWithMessage:@"The Internet connection appears to be offline." andTitle:@"" andBtnTitle:@"OK"];
            
            [self showAlertWithMessage:@"Oops! Something tore. We are working on it right now. Please check back." andTitle:@"" andBtnTitle:@"OK"];
            
        }
        
    }];
}

- (void)showAlertWithMessage:(NSString *)msg andTitle:(NSString *)title andBtnTitle:(NSString *)btnTitle {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alertController addAction:defaultAction];
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    [topController presentViewController:alertController animated:YES completion:nil];
    
//    return;
//    
//    id viewCon = self.window.rootViewController;
//    
//    if ([viewCon isKindOfClass:[RESideMenu class]])
//    {
//        RESideMenu *obj = (RESideMenu *) viewCon;
//        UINavigationController *nav = (UINavigationController *) obj.contentViewController;
//        [nav presentViewController:alertController animated:YES completion:nil];
//    }
//    else
//    {
//        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
    
    
    
//    [self.window endEditing:YES];
//    
//    NSArray *array = [NSArray arrayWithObjects:title, msg, nil];
//    
//    [self performSelector:@selector(showAlert:) withObject:array afterDelay:0.5];
}

-(void) showAlert:(NSArray *)array
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[array objectAtIndex:0] message:[array objectAtIndex:1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(RESideMenu *)sideMenuViewController {
    
    if([self.window.rootViewController isKindOfClass:[RESideMenu class]])
        return (RESideMenu *)self.window.rootViewController;
    
    return nil;
}


- (TabBarViewController *)homeViewController {
    
    TabBarViewController *tabbarVC = [[TabBarViewController alloc] init];
    tabbarVC.selectedIndex = 0;
    return tabbarVC;
    
}

// Method implementations
- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView animateWithDuration:0.2 animations:^{
        
        for(UIView *view in tabbarcontroller.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                [view setFrame:CGRectMake(view.frame.origin.x, screen_height, view.frame.size.width, view.frame.size.height)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, screen_height)];
            }
            
            NSLog(@"%@", view);
        }
        
    } completion:^(BOOL finished) {
        
        tabbarcontroller.tabBar.hidden = YES;
    }];
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    tabbarcontroller.tabBar.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        for(UIView *view in tabbarcontroller.view.subviews)
        {
            if([view isKindOfClass:[UITabBar class]])
            {
                [view setFrame:CGRectMake(view.frame.origin.x, screen_height-tabbarcontroller.tabBar.frame.size.height, view.frame.size.width, view.frame.size.height)];
                
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, screen_height-tabbarcontroller.tabBar.frame.size.height)];
            }
            
            NSLog(@"%@", view);
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) applyBlurEffectForView:(UIView *)vieww Style:(NSString *)style
{
    UIBlurEffect *blurEffect;
    
    if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_DARK] == NSOrderedSame)
    {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    else if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_LIGHT] == NSOrderedSame)
    {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    else if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_EXTRA_LIGHT] == NSOrderedSame)
    {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }
    
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    bluredEffectView.tag = 987654;
    bluredEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [bluredEffectView setFrame:vieww.bounds];
    
    // Vibrancy Effect
    
//    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//    [vibrancyEffectView setFrame:vieww.bounds];
//    
//    // Add Vibrancy View to Blur View
//    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    
    bluredEffectView.alpha = 1.0;
    [vieww addSubview:bluredEffectView];
    [vieww sendSubviewToBack:bluredEffectView];
}

-(void) applyBlurEffectForView:(UIView *)vieww Style:(NSString *)style Alpha:(CGFloat) alpha
{
    UIBlurEffect *blurEffect;
    
    if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_DARK] == NSOrderedSame)
    {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }
    else if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_LIGHT] == NSOrderedSame)
    {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    else if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_EXTRA_LIGHT] == NSOrderedSame)
    {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    }
    
    UIVisualEffectView *bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    bluredEffectView.tag = 987654;
    bluredEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [bluredEffectView setFrame:vieww.bounds];
    
    // Vibrancy Effect
    
    //    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    //    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    //    [vibrancyEffectView setFrame:vieww.bounds];
    //
    //    // Add Vibrancy View to Blur View
    //    [bluredEffectView.contentView addSubview:vibrancyEffectView];
    
    bluredEffectView.alpha = alpha;
    [vieww addSubview:bluredEffectView];
    [vieww sendSubviewToBack:bluredEffectView];
}

-(void) removeBlurEffectForView:(UIView *) view
{
    UIVisualEffectView *blurEffect = (UIVisualEffectView *) [view viewWithTag:987654];
    
    if (blurEffect)
    {
        [blurEffect removeFromSuperview];
        blurEffect = nil;
    }
}

-(void) applyCustomBlurEffetForView:(UIView *) view WithBlurRadius:(float)radius
{
    FXBlurView *blurEffect = [[FXBlurView alloc]initWithFrame:view.bounds];
    blurEffect.tag = 98765;
    blurEffect.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffect.tintColor = [UIColor blackColor];
    blurEffect.blurRadius = radius;
    blurEffect.dynamic = NO;
    [view addSubview:blurEffect];
    //[blurEffect setNeedsDisplay];
    
    //[view sendSubviewToBack:blurEffect];
    
//    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
//        
//        [blurEffect setNeedsDisplay];
//        
//    } completion:^(BOOL finished) {
//        
//        
//    }];
    
//    [blurEffect updateAsynchronously:YES completion:^{
//        
//        
//    }];
}

-(void) removeCustomBlurEffectToView:(UIView *) view
{
    __block FXBlurView *blurEffect = (FXBlurView *) [view viewWithTag:98765];
    
    if (blurEffect)
    {
//        [blurEffect updateAsynchronously:YES completion:^{
//            
//            [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
//                
//                blurEffect.alpha = 0.0f;
//                
//            } completion:^(BOOL finished) {
//                
//                [blurEffect removeFromSuperview];
//                blurEffect = nil;
//                
//            }];
//
//        }];
        
        [blurEffect removeFromSuperview];
        blurEffect = nil;
    }
}

-(void) setBottomTabBarIndex:(NSInteger) index
{
//    UITabBarItem *tabBarItem1 = [self.customTabBarController.tabBar.items objectAtIndex:0];
//    UITabBarItem *tabBarItem2 = [self.customTabBarController.tabBar.items objectAtIndex:1];
//    //UITabBarItem *tabBarItem3 = [self.customTabBarController.tabBar.items objectAtIndex:2];
//    
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                        NSForegroundColorAttributeName : [UIColor grayColor]
//                                                        } forState:UIControlStateSelected];
//    
//    
////    [tabBarItem1 setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
////                                          NSForegroundColorAttributeName : [UIColor grayColor]
////                                          } forState:UIControlStateSelected];
////    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                          NSForegroundColorAttributeName : [UIColor colorWithRed:27/255.0 green:103/255.0 blue:193/255.0 alpha:1.0]
//                                          } forState:UIControlStateNormal];
//    
//    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"tab_book_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem2 setImage:[[UIImage imageNamed:@"tab_mybooking_blue.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    //[tabBarItem3 setImage:[[UIImage imageNamed:@"tab_more_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
}

-(void) setBottomTabBarColor:(NSString *)colorType BlurEffectStyle:(NSString *)style HideBlurEffect:(BOOL)isBlurEffectHidden
{
//    UIBlurEffect *blurEffect;
//    
//    if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_DARK] == NSOrderedSame)
//    {
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    }
//    else if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_LIGHT] == NSOrderedSame)
//    {
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    }
//    else if ([style caseInsensitiveCompare:BLUR_EFFECT_STYLE_EXTRA_LIGHT] == NSOrderedSame)
//    {
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    }
//    
//    self.customTabBarController.visualEffectView.effect = blurEffect;
//    
//    if (isBlurEffectHidden)
//    {
//        self.customTabBarController.visualEffectView.hidden = YES;
//    }
//    else
//    {
//        self.customTabBarController.visualEffectView.hidden = NO;
//    }
    
//    UITabBarItem *tabBarItem1 = [self.customTabBarController.tabBar.items objectAtIndex:0];
//    UITabBarItem *tabBarItem2 = [self.customTabBarController.tabBar.items objectAtIndex:1];
//    UITabBarItem *tabBarItem3 = [self.customTabBarController.tabBar.items objectAtIndex:2];
//    
//    if ([colorType caseInsensitiveCompare:TABBAR_COLOR_WHITE] == NSOrderedSame)
//    {
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor whiteColor]
//                                                            } forState:UIControlStateNormal];
//        
//        [tabBarItem1 setImage:[[UIImage imageNamed:@"tab_book_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem2 setImage:[[UIImage imageNamed:@"tab_mybooking_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem3 setImage:[[UIImage imageNamed:@"tab_more_white.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    }
//    else if ([colorType caseInsensitiveCompare:TABBAR_COLOR_GREY] == NSOrderedSame)
//    {
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:APPFONT_BOLD size:10.0f],
//                                                            NSForegroundColorAttributeName : [UIColor grayColor]
//                                                            } forState:UIControlStateNormal];
//        
//        [tabBarItem1 setImage:[[UIImage imageNamed:@"tab_book_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem2 setImage:[[UIImage imageNamed:@"tab_mybooking_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [tabBarItem3 setImage:[[UIImage imageNamed:@"tab_more_grey.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    }
    
    
}



-(void) setBottomTabBarColorForTab:(int) tab
{
    if (tab == 1)
    {
        self.customTabBarController.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.85];
    }
    else if (tab == 2)
    {
        self.customTabBarController.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.85];
    }
    else if (tab == 3)
    {
        self.customTabBarController.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.25];
    }
}


+(CGFloat) getLabelHeightForSemiBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_SEMI_BOLD size:fontSize] } context:nil].size;
    
    return size.height;
}

+(CGFloat) getLabelHeightForBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:fontSize] } context:nil].size;
    
    return size.height;
}

+(CGFloat) getLabelHeightForMediumText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:fontSize] } context:nil].size;
    
    return size.height;
}


+(CGFloat) getLabelHeightForRegularText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:fontSize] } context:nil].size;
    
    return size.height;
}


+(CGSize) getLabelSizeForSemiBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_SEMI_BOLD size:fontSize] } context:nil].size;
    
    return size;
}

+(CGSize) getLabelSizeForBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_BOLD size:fontSize] } context:nil].size;
    
    return size;
}

+(CGSize) getLabelSizeForRegularText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:fontSize] } context:nil].size;
    
    return size;
}

+(CGSize) getLabelSizeForMediumText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{ NSFontAttributeName:[UIFont fontWithName:APPFONT_MEDIUM size:fontSize] } context:nil].size;
    
    return size;
}

+(CGSize) getAttributedTextHeightForText:(NSMutableAttributedString *)strText WithWidth:(CGFloat)width
{
    CGSize size = [strText boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) context:nil].size;
    
    return size;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UIImage*)GetImageByScalingAndCroppingImage:(UIImage *)cropimage ForSize:(CGSize)targetSize
{
    
   	UIImage *sourceImage = cropimage;
    float oldWidth = sourceImage.size.width;
    float scaleFactor = 1;
    
    if (oldWidth >= targetSize.width)
    {
        scaleFactor = targetSize.width / oldWidth;
    }
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(void) spacingForTitle:(UILabel *)lblTitle TitleString:(NSString *)strTitle
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strTitle];
    
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [strTitle length])];
    
    lblTitle.attributedText = attributedString;
}

-(void) spacingForTitle:(UILabel *)lblTitle TitleString:(NSString *)strTitle Spacing:(CGFloat) spacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strTitle];
    
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [strTitle length])];
    
    lblTitle.attributedText = attributedString;
}

-(void) spacingForTextField:(UITextField *)textField TitleString:(NSString *)strTitle WithSpace:(float) space
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strTitle];
    
    float spacing = space;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [strTitle length])];
    
    textField.attributedText = attributedString;
}


-(NSMutableAttributedString *) spacingForString:(NSString *)strTitle WithSpace:(float) space withAttributes:(NSDictionary *) params
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strTitle];
    
    float spacing = space;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [strTitle length])];
    
    [attributedString addAttributes:params range:NSMakeRange(0, [strTitle length])];
    
    return attributedString;
}


@end





