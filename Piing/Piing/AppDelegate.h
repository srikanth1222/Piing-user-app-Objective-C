//
//  AppDelegate.h
//  Piing
//
//  Created by SHASHANK on 26/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CustomLoaderView.h"
#import <CoreLocation/CoreLocation.h>

#import "RESideMenu.h"
#import "TabBarViewController.h"
#import "MBProgressHUD.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager *locationManager;
    NSString *latitude;
    NSString *longitude;
    
    BOOL IsSendUserLocation;
}


@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL isStatusBarFrameChanged;
@property (nonatomic, assign) int hasAdCode;

@property (nonatomic, assign) BOOL fetchingTimeSlots;

@property (nonatomic, assign) CGFloat FONT_SIZE_CUSTOM;
@property (nonatomic, assign) CGFloat HEADER_LABEL_FONT_SIZE;


@property (nonatomic, strong) TabBarViewController *customTabBarController;

//@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;

@property (nonatomic, strong) NSString *cobIdForCurrentBooking;
@property (nonatomic, assign) BOOL isBookNowPending;

@property (nonatomic, assign) BOOL isDeleteBookView;
@property (nonatomic, assign) BOOL isUpdatePiingo;

@property (nonatomic, assign) BOOL openWelcomePopup;
@property (nonatomic, assign) BOOL isFirstTimeAddressAdding;

@property (nonatomic, assign) BOOL isFirstTimeAddPayment;

@property (nonatomic, assign) BOOL isVerificationCodeEnabled;

@property (nonatomic, strong) NSMutableDictionary *dictImagesSaved;

@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, strong) NSMutableDictionary *dictEachSegmentCount;

@property (nonatomic, strong) UIWebView *webViewAppDelegate;

@property (nonatomic, assign) BOOL openScheduleLater;

@property (nonatomic, assign) BOOL loginClicked;

@property (nonatomic, strong) NSString *strReferralMessage;

@property (nonatomic, assign) BOOL directlyGotoOrderDetails;

@property (nonatomic, assign) BOOL isPriceListFromTab;

@property (nonatomic, assign) BOOL hasOpenedOrderDetails;
@property (nonatomic, assign) BOOL automaticAddtoCalendar;
@property (nonatomic, assign) BOOL isAfterBookingOrder;

@property (nonatomic, assign) BOOL isGotResponse;

@property (nonatomic,strong) NSString *strPhoneNumber;

@property (nonatomic, strong) NSString *strRecurringAmount;
@property (nonatomic, assign) CGFloat freewashAmount;

@property (nonatomic, assign) CGFloat fold_ExtraCharge;
@property (nonatomic, assign) CGFloat clipHanger_ExtraCharge;

@property (nonatomic, strong) NSString *strGlobalPreferenes;

@property (nonatomic, strong) NSMutableDictionary *dictPriceImages;
@property (nonatomic, strong) NSMutableDictionary *dictPriceSelectedImages;


@property (nonatomic, assign) BOOL openTrackingAuto;

@property (nonatomic, assign) BOOL openPromotionsAuto;

@property (nonatomic, assign) BOOL openOrderDetailAuto;

@property (nonatomic, assign) BOOL openBillAuto;

@property (nonatomic, strong) NSString *strShoePolish;
@property (nonatomic, strong) NSString *strShoeClean;
@property (nonatomic, strong) NSString *strBagClean;
@property (nonatomic, strong) NSString *strCurtainClean;

@property (nonatomic, strong) NSString *strShoeStartPrice;
@property (nonatomic, strong) NSString *strBagStartPrice;

@property (nonatomic, strong) NSString *strServiceTypeFromHomeage;

@property (nonatomic, assign) BOOL loginMethodCalled;

@property (nonatomic, strong) NSString *shortcutItemType;

@property (nonatomic, assign) CGFloat headingInDegrees;


//- (TabViewController *)homeViewController;
- (TabBarViewController *)homeViewController;

- (RESideMenu *)sideMenuViewController;

//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

-(void) userLogout;
-(void) loginCompleted;
-(void) setrootVC;

-(void) showLoader;
-(void)hideLoader;
- (void)hideTabBar:(UITabBarController *) tabbarcontroller;
- (void)showTabBar:(UITabBarController *) tabbarcontroller;

-(void) applyBlurEffectForView:(UIView *)vieww Style:(NSString *)style;
-(void) applyBlurEffectForView:(UIView *)vieww Style:(NSString *)style Alpha:(CGFloat) alpha;
-(void) removeBlurEffectForView:(UIView *) view;

-(void) setBottomTabBarColor:(NSString *)colorType BlurEffectStyle:(NSString *)style HideBlurEffect:(BOOL)isBlurEffectHidden;

-(void)displayErrorMessagErrorResponse:(NSDictionary *)response;
- (void)showAlertWithMessage:(NSString *)msg andTitle:(NSString *)title andBtnTitle:(NSString *)btnTitle;
-(void) setBottomTabBarIndex:(NSInteger) index;

+(CGFloat) getLabelHeightForBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;
+(CGFloat) getLabelHeightForSemiBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;
+(CGFloat) getLabelHeightForMediumText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;
+(CGFloat) getLabelHeightForRegularText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;

+(CGSize) getLabelSizeForSemiBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;
+(CGSize) getLabelSizeForBoldText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;
+(CGSize) getLabelSizeForRegularText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;
+(CGSize) getLabelSizeForMediumText:(NSString *)strText WithWidth:(CGFloat)width FontSize:(CGFloat)fontSize;

+(CGSize) getAttributedTextHeightForText:(NSMutableAttributedString *)strText WithWidth:(CGFloat)width;


+(UIImage*)GetImageByScalingAndCroppingImage:(UIImage *)cropimage ForSize:(CGSize)targetSize;


-(void)callLoginMethod;
-(void) spacingForTitle:(UILabel *)lblTitle TitleString:(NSString *)strTitle;
-(void) spacingForTitle:(UILabel *)lblTitle TitleString:(NSString *)strTitle Spacing:(CGFloat) spacing;
-(void) spacingForTextField:(UITextField *)textField TitleString:(NSString *)strTitle WithSpace:(float) space;

-(void) setBottomTabBarColorForTab:(int) tab;

-(void) applyCustomBlurEffetForView:(UIView *) view WithBlurRadius:(float)radius;
-(void) removeCustomBlurEffectToView:(UIView *) view;

+ (UIImage *)imageWithColor:(UIColor *)color;

-(void) checkConditionsAfterFeedback;

-(void) checkOtherConditions;

-(NSMutableAttributedString *) getAttributedStringWithString:(NSString *) string WithSpacing:(CGFloat) value;

-(NSMutableDictionary *) getDefaultPreferences;
-(NSMutableArray *) getAllSavedCards:(NSDictionary *) dict;
-(void) sendUserLocationToServer;


@end




