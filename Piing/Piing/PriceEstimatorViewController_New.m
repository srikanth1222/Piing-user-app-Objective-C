//
//  PriceListViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "PriceEstimatorViewController_New.h"
#import "Piing-Swift.h"
#import "ViewBillEstimatorController.h"
#import "CustomPopoverView.h"
#import "UIButton+CenterImageAndTitle.h"
#import "CalculateViewController.h"


#define ACCEPTABLE_CHARECTERS @"0123456789."


@interface PriceEstimatorViewController_New () <HMSegmentedControlDelegate, CustomPopoverViewDelegate, UITextFieldDelegate, CalculateViewControllerDelegate>
{
    
    UITableView *tblPricing;
    
    UIButton *isExpressBtn;
    
    UIView *view_Express;
    
    NSString *strOrderType,  *strJobType;
    
    HMSegmentedControl *segmentImages;
    
    NSMutableDictionary *dictItemCount;
    NSMutableDictionary *dictTotalPrice;
    
    NSMutableDictionary *dictCountForType;
    NSMutableDictionary *dictViewBill;
    
    UILabel *lblFinalAmount;
    UILabel *lblAmountText;
    
    AppDelegate *appDel;
    
    NSString *strJobName;
    
    UIButton *btnArrow;
    
    //SevenSwitch *mySwitch2;
    //UISegmentedControl *segmentSwitch;
    
    UILabel *lblOrderType;
    
    CGFloat previousSliderValue;
    
    CustomPopoverView *customPopOverView;
    
    UIButton *btnService;
    
    NSMutableArray *arrayCategory, *arraykey, *arrayRow;
    
    NSInteger selectedCategoryIndex;
    
    NSArray *arrayTypes;
    
    NSMutableArray *arrayImagePath;
    NSMutableArray *arrayImagePathSelected;
    
    int imagesDownloaded;
    
    NSMutableArray *arrayImagesDownloaded;
    NSMutableArray *arrayImageSelectedDownloaded;
    
    UIView *view_SegmentBG;
    
    UIView *viewArrow;
    
    UILabel *lblSwitch;
    
    NSTimer *timerSwitch;
    
    NSArray *arrayServiceTypes;
    
    NSString *selectedServiceTypeId;
    
    NSInteger totalCategories;
    
    UITextField *tfGlobal;
    
    UIButton *btnSwitch;
}

@end

@implementation PriceEstimatorViewController_New

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *viewBG = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:viewBG];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [viewBG addGestureRecognizer:tap];
    
    selectedServiceTypeId = @"DC";
    
    dictItemCount = [[NSMutableDictionary alloc]init];
    dictTotalPrice = [[NSMutableDictionary alloc]init];
    dictCountForType = [[NSMutableDictionary alloc]init];
    dictViewBill = [[NSMutableDictionary alloc]init];
    
    arrayCategory = [[NSMutableArray alloc]init];
    arraykey = [[NSMutableArray alloc]init];
    arrayRow = [[NSMutableArray alloc]init];
    arrayImagePath = [[NSMutableArray alloc]init];
    arrayImagePathSelected = [[NSMutableArray alloc]init];
    
    arrayImagesDownloaded = [[NSMutableArray alloc]init];
    arrayImageSelectedDownloaded = [[NSMutableArray alloc]init];
    
    
    arrayTypes = [[NSArray alloc]initWithObjects:@"LOAD WASH", @"DRY CLEANING", @"GREEN DRY CLEANING", @"WASH & IRON", @"IRONING", @"LEATHER CLEANING", @"CARPET CLEANING", nil];
    
    arrayServiceTypes = [[NSArray alloc]initWithObjects:SERVICETYPE_WF, SERVICETYPE_DC, SERVICETYPE_DCG, SERVICETYPE_WI, SERVICETYPE_IR, SERVICETYPE_LE, SERVICETYPE_CA, nil];
    
    self.navigationController.navigationBarHidden = YES;
    
    strOrderType = @"R";
    strJobType = SERVICETYPE_DC;
    
    strJobName = [arrayTypes objectAtIndex:1];
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    btnService = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnService setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnService.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1];
    [self.view addSubview:btnService];
    [btnService setImage:[UIImage imageNamed:@"down_arrow_gray"] forState:UIControlStateNormal];
    
    [btnService addTarget:self action:@selector(btnServiceTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"DRY CLEANING"];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attr length])];
    
    float spacing = 1.0f;
    [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
    [btnService setAttributedTitle:attr forState:UIControlStateNormal];
    
    btnService.frame = CGRectMake(0, yAxis, screen_width, 30*MULTIPLYHEIGHT);
    
    [btnService buttonImageAndTextWithImagePosition:@"RIGHT" WithSpacing:10*MULTIPLYHEIGHT];
    
    UIEdgeInsets imageInsets = btnService.imageEdgeInsets;
    imageInsets.top += 2*MULTIPLYHEIGHT;
    btnService.imageEdgeInsets = imageInsets;
    
    
    if (self.hasBackButton)
    {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(10.0, yAxis, 40.0, 40.0);
        [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backBtn];
    }
    else
    {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(screen_width-45, yAxis, 40.0, 40.0);
        [closeBtn setImage:[UIImage imageNamed:@"cancel_grey"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(backToPreviousScreen) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.backgroundColor = [UIColor clearColor];
        [self.view addSubview:closeBtn];
    }
    
    yAxis += 40+30*MULTIPLYHEIGHT;
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor], NSFontAttributeName:[UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1]}];
    
    float viewSegmentHeight = 72*MULTIPLYHEIGHT+2;
    
    view_SegmentBG = [[UIView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, viewSegmentHeight)];
    //view_SegmentBG.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:view_SegmentBG];
    
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(10*MULTIPLYHEIGHT, 0, view_SegmentBG.frame.size.width-(10*MULTIPLYHEIGHT*2), 1);
    topLayer.backgroundColor = RGBCOLORCODE(240, 240, 240, 1.0).CGColor;
    [view_SegmentBG.layer addSublayer:topLayer];
    
    CALayer *bottomLayer = [[CALayer alloc]init];
    bottomLayer.frame = CGRectMake(25*MULTIPLYHEIGHT, view_SegmentBG.frame.size.height-1, view_SegmentBG.frame.size.width-(25*MULTIPLYHEIGHT*2), 1);
    bottomLayer.backgroundColor = RGBCOLORCODE(240, 240, 240, 1.0).CGColor;
    [view_SegmentBG.layer addSublayer:bottomLayer];
    //view_SegmentBG.hidden = YES;
    
    yAxis += viewSegmentHeight+20*MULTIPLYHEIGHT;
    
    float vH = 23*MULTIPLYHEIGHT;
    
    view_Express = [[UIView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, vH)];
    view_Express.backgroundColor = [UIColor clearColor];
    //[self.view addSubview:view_Express];
    
    CGFloat btnX = 0;
    
    float btnHeight = 20*MULTIPLYHEIGHT;
    CGFloat viewW = 150*MULTIPLYHEIGHT;
    
    UIView *viewType = [[UIView alloc]initWithFrame:CGRectMake(screen_width/2-viewW/2, yAxis, viewW, btnHeight)];
    viewType.layer.cornerRadius = 13.0;
    viewType.backgroundColor = [UIColor clearColor];
    viewType.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
    viewType.layer.borderWidth = 0.6f;
    viewType.layer.masksToBounds = YES;
    [self.view addSubview:viewType];
    
    for (int i = 0; i < 2; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+1;
        btn.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3];
        [viewType addSubview:btn];
        btn.layer.cornerRadius = 13.0;
        
        NSString *str1 = @"REGULAR";
        NSString *str2 = @"EXPRESS";
        
        if (i == 0)
        {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str1];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attr length])];
            
            float spacing = 0.5f;
            [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
            
            NSMutableAttributedString *attrSel = [[NSMutableAttributedString alloc] initWithString:str1];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [attrSel length])];
            [attrSel addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrSel length])];
            
            [btn setAttributedTitle:attr forState:UIControlStateNormal];
            [btn setAttributedTitle:attrSel forState:UIControlStateSelected];
            
            //btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
            btn.backgroundColor = BLUE_COLOR;
            btn.selected = YES;
            
            btnSwitch = btn;
        }
        else
        {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str2];
            [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attr length])];
            
            float spacing = 1.0f;
            [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
            
            NSMutableAttributedString *attrSel = [[NSMutableAttributedString alloc] initWithString:str2];
            [attrSel addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, [attrSel length])];
            [attrSel addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attrSel length])];
            
            [btn setAttributedTitle:attr forState:UIControlStateNormal];
            [btn setAttributedTitle:attrSel forState:UIControlStateSelected];
            
            //btn.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
            
            [viewType sendSubviewToBack:btn];
        }
        
        //btn.layer.borderWidth = 1.0f;
        
        [btn addTarget:self action:@selector(btnOptionsSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        float btnWidth = viewW/2;
        
        btn.frame = CGRectMake(btnX, 0, btnWidth, viewType.frame.size.height);
        
        btnX += btnWidth-1;
    }
    
//    CGFloat sgX = 65 * MULTIPLYHEIGHT;
//    CGFloat sgH = 18 * MULTIPLYHEIGHT;
//    
//    segmentSwitch = [[UISegmentedControl alloc]initWithItems:@[@"REGULAR", @"EXPRESS"]];
//    segmentSwitch.frame = CGRectMake(sgX, yAxis, screen_width-(sgX * 2), sgH);
//    [segmentSwitch setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateSelected];
//    [segmentSwitch setTitleTextAttributes:@{NSForegroundColorAttributeName : RGBCOLORCODE(64, 143, 210, 1.0), NSFontAttributeName: [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-3]} forState:UIControlStateNormal];
//    [segmentSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    segmentSwitch.tintColor = RGBCOLORCODE(64, 143, 210, 1.0);
//    segmentSwitch.selectedSegmentIndex = 0;
//    [self.view addSubview:segmentSwitch];
    
//    mySwitch2 = [[SevenSwitch alloc] initWithFrame:CGRectMake((screen_width/2)-(90/2),  yAxis, 90, 25)];
//    //mySwitch2.center = CGPointMake(self.view.bounds.size.width * 0.5, 30);
//    //mySwitch2.inactiveColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
//    //mySwitch2.onTintColor = [UIColor colorWithRed:0.45f green:0.58f blue:0.67f alpha:1.00f];
//    [mySwitch2 addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
//    //    mySwitch2.offImage = [UIImage imageNamed:@"toggle_nonselected"];
//    //    mySwitch2.onImage = [UIImage imageNamed:@"toggle_selected"];
//    //mySwitch2.onTintColor = [UIColor colorWithHue:0.08f saturation:0.74f brightness:1.00f alpha:1.00f];
//    mySwitch2.activeColor = [UIColor clearColor];
//    mySwitch2.inactiveColor = [UIColor clearColor];
//    mySwitch2.onTintColor = [UIColor clearColor];
//    mySwitch2.onLabel.textColor = BLUE_COLOR;
//    mySwitch2.offLabel.textColor = [UIColor grayColor];
//    mySwitch2.isRounded = YES;
//    mySwitch2.shadowColor = [UIColor clearColor];
//    mySwitch2.activeBorderColor = BLUE_COLOR;
//    mySwitch2.inactiveBorderColor = RGBCOLORCODE(200, 200, 200, 1.0);
//    mySwitch2.onThumbImage = [UIImage imageNamed:@"thumb_selected"];
//    mySwitch2.offThumbImage = [UIImage imageNamed:@"thumb_nonselected"];
//    [mySwitch2 setOn:NO animated:YES];
//    [self.view addSubview:mySwitch2];
    
    
    yAxis += 25+5*MULTIPLYHEIGHT;
    
    float lblSHeight = 16*MULTIPLYHEIGHT;
    
    lblSwitch = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblSHeight)];
    lblSwitch.textAlignment = NSTextAlignmentCenter;
    lblSwitch.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-4];
    lblSwitch.textColor = RGBCOLORCODE(200, 200, 200, 1.0);
    [self.view addSubview:lblSwitch];
    
    yAxis += lblSHeight + 12*MULTIPLYHEIGHT;
    
    
    float lblOX = 95*MULTIPLYHEIGHT;
    float lblOWidth = 45*MULTIPLYHEIGHT;
    
    lblOrderType = [[UILabel alloc]initWithFrame:CGRectMake(lblOX, 0, lblOWidth, vH)];
    lblOrderType.text = @"REGULAR";
    lblOrderType.textColor = RGBCOLORCODE(170, 170, 170, 1.0);
    lblOrderType.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-4];
    [view_Express addSubview:lblOrderType];
    
    UISlider *sliderPer = [[UISlider alloc]initWithFrame:CGRectMake(lblOX+lblOWidth,  0, 35*MULTIPLYHEIGHT, vH)];
    //sliderPer.thumbTintColor = RGBCOLORCODE(24, 157, 153, 1.0);
    sliderPer.tintColor = RGBCOLORCODE(24, 157, 153, 1.0);
    [sliderPer addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [view_Express addSubview:sliderPer];
    sliderPer.continuous = NO;
    [sliderPer setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateNormal];
    [sliderPer setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateHighlighted];
    
    
    //yAxis += vH+20*MULTIPLYHEIGHT;
    
    float minusHeight = 36*MULTIPLYHEIGHT;
    
    UIView *view_Bg = [[UIView alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, screen_height-yAxis-minusHeight)];
    [self.view addSubview:view_Bg];
    
    tblPricing = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-yAxis-minusHeight) style:UITableViewStylePlain];
    //tblPricing.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    tblPricing.backgroundColor = [UIColor whiteColor];
    tblPricing.delegate = self;
    tblPricing.dataSource = self;
    [view_Bg addSubview:tblPricing];
    tblPricing.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblPricing.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    
    UIView *view_bottom = [[UIView alloc]initWithFrame:CGRectMake(0, screen_height-minusHeight, screen_width, minusHeight)];
    view_bottom.backgroundColor = [BLUE_COLOR colorWithAlphaComponent:0.9];
    [self.view addSubview:view_bottom];
    
    float lblX = 15*MULTIPLYHEIGHT;
    
    lblAmountText = [[UILabel alloc]initWithFrame:CGRectMake(lblX, 0, screen_width-(lblX*2), minusHeight)];
    lblAmountText.textAlignment = NSTextAlignmentLeft;
    lblAmountText.text = @"FINAL  AMOUNT";
    lblAmountText.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM];
    lblAmountText.textColor = [UIColor whiteColor];
    lblAmountText.backgroundColor = [UIColor clearColor];
    [view_bottom addSubview:lblAmountText];
    //lblAmountText.transitionDuration = 0.3;
    
    lblFinalAmount = [[UILabel alloc]initWithFrame:CGRectMake(lblX, 0, screen_width-(lblX*3), minusHeight)];
    lblFinalAmount.textAlignment = NSTextAlignmentRight;
    lblFinalAmount.text = @"$0.00";
    lblFinalAmount.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE];
    lblFinalAmount.textColor = [UIColor whiteColor];
    lblFinalAmount.backgroundColor = [UIColor clearColor];
    [view_bottom addSubview:lblFinalAmount];
    //lblFinalAmount.transitionDuration = 0.3;
    
    UIButton *btnViewBill = [UIButton buttonWithType:UIButtonTypeCustom];
    //btnViewBill.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.4];
    btnViewBill.backgroundColor = [UIColor clearColor];
    [btnViewBill setImage:[UIImage imageNamed:@"right_arrow_white"] forState:UIControlStateNormal];
    btnViewBill.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10*MULTIPLYHEIGHT);
    btnViewBill.frame = view_bottom.bounds;
    [view_bottom addSubview:btnViewBill];
    btnViewBill.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnViewBill addTarget:self action:@selector(viewBillClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getCategories];
}

-(void) btnOptionsSelected:(UIButton *) btn
{
    UIView *viewBg = btn.superview;
    
    for (id sender in viewBg.subviews)
    {
        if ([sender isKindOfClass:[UIButton class]])
        {
            UIButton *btn1 = (UIButton *) sender;
            
            if (btn1.tag == btn.tag)
            {
                btn.selected = YES;
                [viewBg bringSubviewToFront:btn];
                
                if (btn.tag == 1)
                {
                    //btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                    btn.backgroundColor = BLUE_COLOR;
                    
                    strOrderType = ORDER_TYPE_REGULAR;
                }
                else if (btn.tag == 2)
                {
                    //btn.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.7].CGColor;
                    btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
                    
                    strOrderType = ORDER_TYPE_EXPRESS;
                }
            }
            else
            {
                //btn1.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
                btn1.backgroundColor = [UIColor clearColor];
                btn1.selected = NO;
            }
        }
    }
    
    if (btnSwitch != btn || !btnSwitch)
    {
        [self getCategories];
    }
    
    btnSwitch = btn;
}

-(void) hidelblSwitch
{
    lblSwitch.alpha = 1.0;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        lblSwitch.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) showlblSwitch
{
    lblSwitch.alpha = 0.0;
    
    [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
        
        lblSwitch.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void) viewTapped:(UIGestureRecognizer *) tap
{
    [self.view endEditing:YES];
}


-(void) viewBillClicked:(id) sender
{
    if ([dictViewBill count])
    {
        ViewBillEstimatorController *vbe = [[ViewBillEstimatorController alloc]init];
        vbe.dictMain = [[NSMutableDictionary alloc]initWithDictionary:dictViewBill];
        vbe.strTotalPrice = lblFinalAmount.text;
        [self presentViewController:vbe animated:YES completion:nil];
    }
}

-(void) btnServiceTypeClicked:(UIButton *) sender
{
    [self viewTapped:nil];
    
    if (sender.selected)
    {
        [self closeCustomPopover];
    }
    else
    {
        sender.selected = YES;
        
        customPopOverView = [[CustomPopoverView alloc]initWithArray:arrayTypes SelectedRow:[arrayServiceTypes indexOfObject:selectedServiceTypeId]];
        customPopOverView.delegate = self;
        [self.view addSubview:customPopOverView];
        customPopOverView.alpha = 1.0;
        customPopOverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        customPopOverView.textColor = RGBCOLORCODE(170, 170, 170, 1.0);
        
        customPopOverView.tblPopover.contentInset = UIEdgeInsetsZero;
        
        CGRect btnRect = [sender.superview convertRect:sender.frame toView:self.view];
        
        customPopOverView.frame = CGRectMake(0, btnRect.origin.y+35, screen_width, 0);
        
        [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
            
            customPopOverView.frame = CGRectMake(0, btnRect.origin.y+35, screen_width, screen_height-(btnRect.origin.y+35));
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
}


#pragma mark CUSTOMPopover Delegate Method

-(void) didSelectFromList:(NSString *) string AtIndex:(NSInteger)row
{
    //selectedCategoryIndex = 0;
    
    btnService.selected = NO;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        CGRect frame = customPopOverView.frame;
        frame.size.height = 0;
        customPopOverView.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
    }];
    
    selectedServiceTypeId = [arrayServiceTypes objectAtIndex:row];
    
    strJobType = [arrayServiceTypes objectAtIndex:row];
    
    strJobName = [arrayTypes objectAtIndex:row];
    
    if ([selectedServiceTypeId isEqualToString:SERVICETYPE_WF] || [selectedServiceTypeId isEqualToString:SERVICETYPE_CA])
    {
        view_SegmentBG.hidden = YES;
        
        segmentImages.hidden = YES;
    }
    else
    {
        view_SegmentBG.hidden = NO;
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [attr length])];
    
    float spacing = 1.0f;
    [attr addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [attr length])];
    [btnService setAttributedTitle:attr forState:UIControlStateNormal];
    
    [self getCategories];
}

-(void) closeCustomPopover
{
    btnService.selected = NO;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        CGRect frame = customPopOverView.frame;
        frame.size.height = 0;
        customPopOverView.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
    }];
}

-(void) getCategories
{
    [self GetDaysToDeliver];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSMutableDictionary *registrationDetailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:strOrderType, @"orderType", strJobType, @"serviceType", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@pricing/get", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:registrationDetailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [arrayCategory removeAllObjects];
            
            [arrayCategory addObjectsFromArray:[responseObj objectForKey:@"prices"]];
            
            if ([strJobType isEqualToString:SERVICETYPE_WF] || [strJobType isEqualToString:SERVICETYPE_CA])
            {
                [tblPricing reloadData];
            }
            else
            {
                [self createCategories];
            }
        }
        else
        {
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}

-(void) createCategories
{
    [arraykey removeAllObjects];
    [arrayImagePath removeAllObjects];
    [arrayImagePathSelected removeAllObjects];
    
    for (int i=0; i<[arrayCategory count]; i++)
    {
        NSArray *arr = [[arrayCategory objectAtIndex:i]allKeys];
        
        for (NSString *str in arr)
        {
            if ([str isEqualToString:@"imgpath"])
            {
                [arrayImagePath addObject:[[arrayCategory objectAtIndex:i] objectForKey:str]];
            }
            else if ([str isEqualToString:@"imgpathblue"])
            {
                [arrayImagePathSelected addObject:[[arrayCategory objectAtIndex:i] objectForKey:str]];
            }
            else
            {
                [arraykey addObject:str];
            }
        }
    }
    
    if (totalCategories == [arraykey count])
    {
        
    }
    else
    {
        selectedCategoryIndex = 0;
        totalCategories = [arraykey count];
    }
    
    [arrayRow removeAllObjects];
    
    NSDictionary *dictRow = [arrayCategory objectAtIndex:selectedCategoryIndex];
    [arrayRow addObjectsFromArray:[dictRow objectForKey:[arraykey objectAtIndex:selectedCategoryIndex]]];
    
    [tblPricing reloadData];
    
    imagesDownloaded = 0;
    
    [arrayImagesDownloaded removeAllObjects];
    [arrayImageSelectedDownloaded removeAllObjects];
    
    [self downloadImagePath];
    
}

-(void) downloadImagePath
{
    
    if ([appDel.dictPriceImages objectForKey:[arrayImagePath objectAtIndex:imagesDownloaded]])
    {
        UIImage *image = [appDel.dictPriceImages objectForKey:[arrayImagePath objectAtIndex:imagesDownloaded]];
        
        [arrayImagesDownloaded addObject:image];
        
        imagesDownloaded++;
        
        if ([arrayImagePath count]-1 >= imagesDownloaded)
        {
            [self downloadImagePath];
        }
        else
        {
            imagesDownloaded = 0;
            [self downloadImagePathSelected];
        }
    }
    else
    {
        if ([[arrayImagePath objectAtIndex:imagesDownloaded] length])
        {
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[arrayImagePath objectAtIndex:imagesDownloaded]]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                
                if (!connectionError && data)
                {
                    UIImage *image = [UIImage imageWithData:data];
                    
                    [arrayImagesDownloaded addObject:image];
                    
                    [appDel.dictPriceImages setObject:image forKey:[arrayImagePath objectAtIndex:imagesDownloaded]];
                    
                    imagesDownloaded++;
                    
                    if ([arrayImagePath count]-1 >= imagesDownloaded)
                    {
                        [self downloadImagePath];
                    }
                    else
                    {
                        imagesDownloaded = 0;
                        [self downloadImagePathSelected];
                    }
                }
            }];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"promotions_loading"];
            
            [arrayImagesDownloaded addObject:image];
            
            [appDel.dictPriceImages setObject:image forKey:[arrayImagePath objectAtIndex:imagesDownloaded]];
            
            imagesDownloaded++;
            
            if ([arrayImagePath count]-1 >= imagesDownloaded)
            {
                [self downloadImagePath];
            }
            else
            {
                imagesDownloaded = 0;
                [self downloadImagePathSelected];
            }
        }
    }
    
}

-(void) downloadImagePathSelected
{
    if ([appDel.dictPriceSelectedImages objectForKey:[arrayImagePathSelected objectAtIndex:imagesDownloaded]])
    {
        UIImage *image = [appDel.dictPriceSelectedImages objectForKey:[arrayImagePathSelected objectAtIndex:imagesDownloaded]];
        
        [arrayImageSelectedDownloaded addObject:image];
        
        imagesDownloaded++;
        
        if ([arrayImagePathSelected count]-1 >= imagesDownloaded)
        {
            [self downloadImagePathSelected];
        }
        else
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self createSegmentcategory];
                
            }];
        }
    }
    else
    {
        if ([[arrayImagePathSelected objectAtIndex:imagesDownloaded] length])
        {
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[arrayImagePathSelected objectAtIndex:imagesDownloaded]]] queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                
                if (!connectionError && data)
                {
                    UIImage *image = [UIImage imageWithData:data];
                    
                    [arrayImageSelectedDownloaded addObject:image];
                    
                    [appDel.dictPriceSelectedImages setObject:image forKey:[arrayImagePathSelected objectAtIndex:imagesDownloaded]];
                    
                    imagesDownloaded++;
                    
                    if ([arrayImagePathSelected count]-1 >= imagesDownloaded)
                    {
                        [self downloadImagePathSelected];
                    }
                    else
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                            [self createSegmentcategory];
                            
                        }];
                    }
                }
            }];
        }
        else
        {
            UIImage *image = [UIImage imageNamed:@"promotions_loading"];
            
            [arrayImageSelectedDownloaded addObject:image];
            
            [appDel.dictPriceSelectedImages setObject:image forKey:[arrayImagePathSelected objectAtIndex:imagesDownloaded]];
            
            imagesDownloaded++;
            
            if ([arrayImagePathSelected count]-1 >= imagesDownloaded)
            {
                [self downloadImagePathSelected];
            }
            else
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    
                    [self createSegmentcategory];
                    
                }];
            }
        }
    }
}

-(void) createSegmentcategory
{
    [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
    
    [segmentImages removeFromSuperview];
    segmentImages = nil;
    
    float segmentHeight = 72*MULTIPLYHEIGHT;
    
    segmentImages = [[HMSegmentedControl alloc]initWithSectionImages:arrayImagesDownloaded sectionSelectedImages:arrayImageSelectedDownloaded titlesForSections:arraykey];
    segmentImages.delegate = self;
    segmentImages.frame = CGRectMake(0, 1, screen_width, segmentHeight);
    
    float left = 15*MULTIPLYHEIGHT;
    float right = 15*MULTIPLYHEIGHT;
    
    segmentImages.segmentEdgeInset = UIEdgeInsetsMake(0, left, 0, right);
    segmentImages.backgroundColor = RGBCOLORCODE(252, 252, 252, 1.0);
    segmentImages.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
    segmentImages.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    segmentImages.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor], NSFontAttributeName : [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1]};
    segmentImages.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : BLUE_COLOR, NSFontAttributeName : [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-1]};
    [segmentImages addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [view_SegmentBG addSubview:segmentImages];
    segmentImages.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    segmentImages.selectionIndicatorColor = [UIColor clearColor];
    segmentImages.selectionIndicatorBoxOpacity = 1.0f;
    segmentImages.verticalDividerEnabled = NO;
    segmentImages.verticalDividerColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    segmentImages.verticalDividerWidth = 1;
    
    __weak typeof(self) weakSelf = self;
    
    [segmentImages setIndexChangeBlock:^(NSInteger index) {
        
        [weakSelf performSelector:@selector(scrollAnimated) withObject:nil afterDelay:0.4];
    }];
    
    //[self segmentedControlChangedValue:segmentImages];
    
    segmentImages.selectedSegmentIndex = selectedCategoryIndex;
    
    float btnHeight = 16*MULTIPLYHEIGHT;
    
    viewArrow = [[UIView alloc]initWithFrame:CGRectMake(screen_width-btnHeight, 0, btnHeight, view_SegmentBG.frame.size.height)];
    viewArrow.backgroundColor = RGBCOLORCODE(252, 252, 252, 1.0);;
    [view_SegmentBG addSubview:viewArrow];
    
    btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    btnArrow.frame = CGRectMake(0, view_SegmentBG.frame.size.height/2 - btnHeight/2, btnHeight, btnHeight);
    [btnArrow setImage:[UIImage imageNamed:@"right_arrow1"] forState:UIControlStateNormal];
    [viewArrow addSubview:btnArrow];
    btnArrow.backgroundColor = [UIColor clearColor];
    
    if (segmentImages.frame.size.width > segmentImages.scrollView.contentSize.width)
    {
        viewArrow.hidden = YES;
    }
    
}

-(void) didStartScroll:(HMSegmentedControl *)segmentControl Scroller:(UIScrollView *)scrollView
{
    float scrollViewWidth = scrollView.frame.size.width;
    float scrollContentSizeWidth = scrollView.contentSize.width;
    float scrollOffset = scrollView.contentOffset.x;
    
    //    if (scrollOffset == 0)
    //    {
    //        // then we are at the top
    //    }
    if (scrollOffset + scrollViewWidth < scrollContentSizeWidth)
    {
        viewArrow.hidden = NO;
    }
    else if (scrollOffset + scrollViewWidth >= scrollContentSizeWidth)
    {
        viewArrow.hidden = YES;
    }
}

-(void) scrollAnimated
{
    float scrollViewWidth = segmentImages.scrollView.frame.size.width;
    float scrollContentSizeWidth = segmentImages.scrollView.contentSize.width;
    float scrollOffset = segmentImages.scrollView.contentOffset.x;
    
    //    if (scrollOffset == 0)
    //    {
    //        // then we are at the top
    //    }
    if (scrollOffset + scrollViewWidth < scrollContentSizeWidth)
    {
        viewArrow.hidden = NO;
    }
    else if (scrollOffset + scrollViewWidth >= scrollContentSizeWidth)
    {
        viewArrow.hidden = YES;
    }
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [appDel hideTabBar:appDel.customTabBarController];
    
    AppDelegate *appdel = [PiingHandler sharedHandler].appDel;
    [appdel setBottomTabBarColor:TABBAR_COLOR_GREY BlurEffectStyle:BLUR_EFFECT_STYLE_LIGHT HideBlurEffect:NO];
}

- (void)backToPreviousScreen {
    
    [appDel.dictEachSegmentCount removeAllObjects];
    
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.view.frame = CGRectMake(0.0, screen_height, screen_width, screen_height);
    //    } completion:^(BOOL finished) {
    //        [self.view removeFromSuperview];
    //    }];
    
    if (self.hasBackButton)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [UIView transitionWithView:self.navigationController.view.superview duration:0.75 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            
            [self.navigationController removeFromParentViewController];
            [self.navigationController.view removeFromSuperview];
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
}

-(void) isExpressionBtnClicked:(UIButton *) sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        strOrderType = @"E";
    }
    else
    {
        strOrderType = @"R";
    }
    
    [self getCategories];
}

-(void) sliderChanged:(UISlider *)slider
{
    
    if (slider.value > previousSliderValue || previousSliderValue == 0)
    {
        lblOrderType.text = @"EXPRESS";
        strOrderType = @"E";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [slider setValue:1.0 animated:YES];
            
        } completion:^(BOOL finished) {
            
        }];
        
        [slider setThumbImage:[UIImage imageNamed:@"selected_thumb"] forState:UIControlStateNormal];
        [slider setThumbImage:[UIImage imageNamed:@"selected_thumb"] forState:UIControlStateHighlighted];
    }
    else
    {
        lblOrderType.text = @"REGULAR";
        strOrderType = @"R";
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [slider setValue:0 animated:YES];
            
        } completion:^(BOOL finished) {
            
        }];
        
        [slider setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateNormal];
        [slider setThumbImage:[UIImage imageNamed:@"unselected_thumb"] forState:UIControlStateHighlighted];
    }
    
    previousSliderValue = slider.value;
    
    [self getCategories];
}

//-(void) switchChanged:(SevenSwitch *)switch1
//{
//    [self viewTapped:nil];
//    
//    if(switch1.on) {
//        strOrderType = @"E";
//    }
//    else {
//        strOrderType = @"R";
//    }
//    
//    [self getCategories];
//}

-(void) switchChanged:(UISegmentedControl *)switch1
{
    [self viewTapped:nil];
    
    if(switch1.selectedSegmentIndex == 1) {
        strOrderType = @"E";
    }
    else {
        strOrderType = @"R";
    }
    
    [self getCategories];
}

-(void)GetDaysToDeliver
{
    NSMutableDictionary *detailsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOEKN], @"t", @"B", @"orderType", strJobType, @"serviceTypes", strOrderType, @"orderSpeed", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@order/estimatedays", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        if([responseObj objectForKey:@"s"] && [[responseObj objectForKey:@"s"] intValue] == 1){
            
            [self showlblSwitch];
            
            if ([[responseObj objectForKey:@"days"] intValue] == 1)
            {
                lblSwitch.text = [NSString stringWithFormat:@"NEXT DAY DELIVERY"];
            }
            else
            {
                lblSwitch.text = [NSString stringWithFormat:@"%d DAY DELIVERY", [[responseObj objectForKey:@"days"] intValue]];
            }
        }
        else {
            
            if ([[responseObj objectForKey:@"s"] intValue] != 100)
            {
                //[mySwitch2 setOn:NO animated:YES];
                //segmentSwitch.selectedSegmentIndex = 0;
                
                UIView *viewBg = btnSwitch.superview;
                
                for (id sender in viewBg.subviews)
                {
                    if ([sender isKindOfClass:[UIButton class]])
                    {
                        UIButton *btn = (UIButton *) sender;
                        
                        if (btn.tag == 1)
                        {
                            btn.layer.borderColor = LIGHT_BLUE_COLOR.CGColor;
                            btn.backgroundColor = BLUE_COLOR;
                            
                            btnSwitch = btn;
                        }
                        else if (btn.tag == 2)
                        {
                            btn.layer.borderColor = RGBCOLORCODE(220, 220, 220, 1.0).CGColor;
                            btn.backgroundColor = [UIColor clearColor];
                            btn.selected = NO;
                        }
                    }
                }
                
                [self btnOptionsSelected:btnSwitch];
                
                [self getCategories];
            }
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
    }];
}


-(void) menuButtonClicked:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}


-(void) segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    [self viewTapped:nil];
    
    if ([dictTotalPrice count])
    {
        [self setFinalAmount];
    }
    else
    {
        lblFinalAmount.text = @"$0.00";
    }
    
    NSDictionary *dictRow = [arrayCategory objectAtIndex:segmentedControl.selectedSegmentIndex];
    
    [arrayRow removeAllObjects];
    
    [arrayRow addObjectsFromArray:[dictRow objectForKey:[arraykey objectAtIndex:segmentedControl.selectedSegmentIndex]]];
    
    selectedCategoryIndex = segmentedControl.selectedSegmentIndex;
    
    [tblPricing reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float lblHeight = 36*MULTIPLYHEIGHT;
    return lblHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([strJobType isEqualToString:SERVICETYPE_WF] || [strJobType isEqualToString:SERVICETYPE_CA])
    {
        return 1;
    }
    else if ([strJobType containsString:@"CC"])
    {
        return [arrayCategory count];
    }
    else
    {
        return [arrayRow count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strCell];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lblWash = [[UILabel alloc]init];
        lblWash.tag = 10;
        lblWash.numberOfLines = 0;
        lblWash.textColor = APP_FONT_COLOR_GREY;
        lblWash.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1];
        [cell.contentView addSubview:lblWash];
        
        UILabel *lblPrice = [[UILabel alloc]init];
        lblPrice.tag = 11;
        lblPrice.textColor = APP_FONT_COLOR_GREY;
        lblPrice.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
        [cell.contentView addSubview:lblPrice];
        
        UILabel *lblWeight = [[UILabel alloc]init];
        lblWeight.tag = 12;
        lblWeight.textColor = APP_FONT_COLOR_GREY;
        lblWeight.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-2];
        [cell.contentView addSubview:lblWeight];
        
        
        UILabel *lblCount = [[UILabel alloc]init];
        lblCount.tag = 14;
        lblCount.text = @"0";
        lblCount.textAlignment = NSTextAlignmentCenter;
        lblCount.textColor = APP_FONT_COLOR_GREY;
        lblCount.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
        [cell.contentView addSubview:lblCount];
        
        UIButton *btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMinus.tag = 13;
        [btnMinus setTitle:@"-" forState:UIControlStateNormal];
        btnMinus.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE+10];
        [btnMinus setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [btnMinus addTarget:self action:@selector(PlusMinusClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnMinus];
        //btnMinus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        
        UIButton *btnPlus = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPlus.tag = 15;
        [btnPlus setTitle:@"+" forState:UIControlStateNormal];
        btnPlus.titleLabel.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE+10];
        [btnPlus setTitleColor:BLUE_COLOR forState:UIControlStateNormal];
        [btnPlus addTarget:self action:@selector(PlusMinusClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnPlus];
        //btnPlus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        
        UITextField *tf = [[UITextField alloc]init];
        tf.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.delegate = self;
        tf.tag = 16;
        tf.textColor = APP_FONT_COLOR_GREY;
        tf.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
        [cell.contentView addSubview:tf];
        
        CALayer *layer = [[CALayer alloc]init];
        [layer setName:@"tf"];
        layer.backgroundColor = [UIColor grayColor].CGColor;
        [tf.layer addSublayer:layer];
        
        CALayer *bottomLayer = [[CALayer alloc]init];
        bottomLayer.frame = CGRectMake(5*MULTIPLYHEIGHT, cell.contentView.frame.size.height-1, screen_width-(5*MULTIPLYHEIGHT*2), 1);
        bottomLayer.backgroundColor = RGBCOLORCODE(240, 240, 240, 1.0).CGColor;
        [cell.contentView.layer addSublayer:bottomLayer];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict;
    
    if ([strJobType isEqualToString:@"WF"] || [strJobType isEqualToString:@"CA"] || [strJobType containsString:@"CC"])
    {
        dict = (NSDictionary *) [arrayCategory objectAtIndex:indexPath.row];
    }
    else
    {
        dict = (NSDictionary *) [arrayRow objectAtIndex:indexPath.row];
    }
    
    UILabel *lblWash = (UILabel *) [cell.contentView viewWithTag:10];
    
    UILabel *lblPrice = (UILabel *) [cell.contentView viewWithTag:11];
    
    UILabel *lblWeight = (UILabel *) [cell.contentView viewWithTag:12];
    
    UIButton *btnMinus = (UIButton *) [cell.contentView viewWithTag:13];
    UILabel *lblCount = (UILabel *) [cell.contentView viewWithTag:14];
    UIButton *btnPlus = (UIButton *) [cell.contentView viewWithTag:15];
    
    UITextField *tf = (UITextField *) [cell.contentView viewWithTag:16];
    tf.hidden = YES;
    
    lblWeight.hidden = YES;
    
    lblCount.hidden = YES;
    btnPlus.hidden = YES;
    btnMinus.hidden = YES;
    
    float lblHeight = 36*MULTIPLYHEIGHT;
    
    NSString *strTag = [NSString stringWithFormat:@"%@-%ld-%ld-%@", strJobType, selectedCategoryIndex, (long)indexPath.row, strOrderType];
    
    NSMutableDictionary *dictCountWeight;
    
    if ([dictItemCount objectForKey:strTag])
    {
        dictCountWeight = [dictItemCount objectForKey:strTag];
    }
    
    if ([strJobType isEqualToString:@"WF"] || [strJobType isEqualToString:@"CA"])
    {
        lblWash.text = [dict objectForKey:@"n"];
        lblWash.hidden = YES;
        
        if ([strJobType isEqualToString:@"WF"])
        {
            lblWeight.text = @"Per KG";
        }
        else if ([strJobType isEqualToString:@"CA"])
        {
            lblWeight.text = @"Per SQFT";
        }
        
        lblWeight.hidden = NO;
        
        
        float xAxis = 10;
        float lblWWidth = 100*MULTIPLYHEIGHT;
        
        lblWeight.frame = CGRectMake(xAxis, 0, lblWWidth, lblHeight);
        xAxis += lblWWidth+5*MULTIPLYHEIGHT;
        
        
        float lblPWidth = 43*MULTIPLYHEIGHT;
        
        lblPrice.frame = CGRectMake(xAxis, 0, lblPWidth, lblHeight);
        xAxis += lblPWidth+35*MULTIPLYHEIGHT;
        
        float tfWidth = 40*MULTIPLYHEIGHT;
        
        tf.text = [dictCountWeight objectForKey:@"weight"];
        
        tf.hidden = NO;
        tf.frame = CGRectMake(screen_width-tfWidth-10*MULTIPLYHEIGHT, 5*MULTIPLYHEIGHT, tfWidth, lblHeight-(5*MULTIPLYHEIGHT*2));
        
        for (CALayer *layer in [tf.layer sublayers])
        {
            if ([layer.name isEqualToString:@"tf"])
            {
                layer.frame = CGRectMake(0, tf.frame.size.height-1, tf.frame.size.width, 1);
            }
        }
    }
    else
    {
        
        lblWash.text = [dict objectForKey:@"n"];
        lblWash.hidden = NO;
        
        float xAxis = 10;
        
        if ([strJobType containsString:@"CC"])
        {
            
            if ([[dict objectForKey:@"uomid"] intValue] == 1)
            {
                float lblWWidth = 110*MULTIPLYHEIGHT;
                
                lblWash.frame = CGRectMake(xAxis, 0, lblWWidth, lblHeight);
                xAxis += lblWWidth+10*MULTIPLYHEIGHT;
                
                
                float lblPWidth = 43*MULTIPLYHEIGHT;
                
                lblPrice.frame = CGRectMake(xAxis, 0, lblPWidth, lblHeight);
                xAxis += lblPWidth+20*MULTIPLYHEIGHT;
                
                lblCount.hidden = NO;
                btnPlus.hidden = NO;
                btnMinus.hidden = NO;
                
                float btnWidth = 40*MULTIPLYHEIGHT;
                
                btnMinus.frame = CGRectMake(xAxis, 0, btnWidth, lblHeight);
                xAxis += btnWidth;
                
                btnPlus.frame = CGRectMake(xAxis, 0, btnWidth, lblHeight);
                
                lblCount.frame = CGRectMake(btnMinus.frame.origin.x, 0, btnWidth*2, lblHeight);
            }
            else
            {
                float lblWWidth = 90*MULTIPLYHEIGHT;
                
                lblWash.frame = CGRectMake(xAxis, 0, lblWWidth, lblHeight);
                xAxis += lblWWidth+5*MULTIPLYHEIGHT;
                
                float lblPWidth = 35*MULTIPLYHEIGHT;
                
                lblPrice.frame = CGRectMake(xAxis, 0, lblPWidth, lblHeight);
                
                xAxis += lblPWidth;
                
                float tfWidth = 40*MULTIPLYHEIGHT;
                
                tf.hidden = NO;
                tf.frame = CGRectMake(screen_width-tfWidth-10*MULTIPLYHEIGHT, 5*MULTIPLYHEIGHT, tfWidth, lblHeight-(5*MULTIPLYHEIGHT*2));
                
                for (CALayer *layer in [tf.layer sublayers])
                {
                    if ([layer.name isEqualToString:@"tf"])
                    {
                        layer.frame = CGRectMake(0, tf.frame.size.height-1, tf.frame.size.width, 1);
                    }
                }
                
                lblCount.hidden = NO;
                btnPlus.hidden = NO;
                btnMinus.hidden = NO;
                
                float btnWidth = 40*MULTIPLYHEIGHT;
                
                btnMinus.frame = CGRectMake(xAxis, 0, btnWidth, lblHeight);
                
                xAxis += btnWidth;
                
                btnPlus.frame = CGRectMake(xAxis, 0, btnWidth, lblHeight);
                
                lblCount.frame = CGRectMake(btnMinus.frame.origin.x, 0, btnWidth*2, lblHeight);
            }
        }
        else if ([[dict objectForKey:@"uomid"] intValue] == 2 || [[dict objectForKey:@"uomid"] intValue] == 3)
        {
            float lblWWidth = 110*MULTIPLYHEIGHT;
            
            lblWash.frame = CGRectMake(xAxis, 0, lblWWidth, lblHeight);
            xAxis += lblWWidth+10*MULTIPLYHEIGHT;
            
            
            float lblPWidth = 43*MULTIPLYHEIGHT;
            
            lblPrice.frame = CGRectMake(xAxis, 0, lblPWidth, lblHeight);
            xAxis += lblPWidth+20*MULTIPLYHEIGHT;
            
            float tfWidth = 40*MULTIPLYHEIGHT;
            
            tf.hidden = NO;
            tf.frame = CGRectMake(screen_width-tfWidth-10*MULTIPLYHEIGHT, 5*MULTIPLYHEIGHT, tfWidth, lblHeight-(5*MULTIPLYHEIGHT*2));
            
            for (CALayer *layer in [tf.layer sublayers])
            {
                if ([layer.name isEqualToString:@"tf"])
                {
                    layer.frame = CGRectMake(0, tf.frame.size.height-1, tf.frame.size.width, 1);
                }
            }
        }
        else
        {
            float lblWWidth = 110*MULTIPLYHEIGHT;
            
            lblWash.frame = CGRectMake(xAxis, 0, lblWWidth, lblHeight);
            xAxis += lblWWidth+10*MULTIPLYHEIGHT;
            
            
            float lblPWidth = 43*MULTIPLYHEIGHT;
            
            lblPrice.frame = CGRectMake(xAxis, 0, lblPWidth, lblHeight);
            xAxis += lblPWidth+20*MULTIPLYHEIGHT;
            
            lblCount.hidden = NO;
            btnPlus.hidden = NO;
            btnMinus.hidden = NO;
            
            float btnWidth = 40*MULTIPLYHEIGHT;
            
            btnMinus.frame = CGRectMake(xAxis, 0, btnWidth, lblHeight);
            xAxis += btnWidth;
            
            btnPlus.frame = CGRectMake(xAxis, 0, btnWidth, lblHeight);
            
            lblCount.frame = CGRectMake(btnMinus.frame.origin.x, 0, btnWidth*2, lblHeight);
        }
    }
    
    if ([strJobType containsString:@"CC"])
    {
        if ([dictCountWeight objectForKey:@"count"])
        {
            lblCount.text = [dictCountWeight objectForKey:@"count"];
        }
        else
        {
            lblCount.text = @"0";
        }
        
        if ([dictCountWeight objectForKey:@"weight"])
        {
            tf.text = [dictCountWeight objectForKey:@"weight"];
        }
        else
        {
            tf.text = @"";
        }
    }
    
    else if ([dictCountWeight objectForKey:@"count"])
    {
        if ([[dict objectForKey:@"uomid"] intValue] == 2 || [[dict objectForKey:@"uomid"] intValue] == 3)
        {
            tf.text = [dictCountWeight objectForKey:@"count"];
        }
        else
        {
            lblCount.text = [dictCountWeight objectForKey:@"count"];
        }
    }
    else if ([dictCountWeight objectForKey:@"weight"])
    {
        
    }
    else
    {
        tf.text = @"";
        
        lblCount.text = @"0";
    }
    
    lblPrice.text = [NSString stringWithFormat:@"$%.2f", [[dict objectForKey:@"ip"] floatValue]];
    
    return cell;
}


-(void) PlusMinusClicked:(UIButton *)sender
{
    CGPoint position = [sender convertPoint:CGPointZero toView:tblPricing];
    NSIndexPath *indexPath = [tblPricing indexPathForRowAtPoint:position];
    
    UITableViewCell *cell = [tblPricing cellForRowAtIndexPath:indexPath];
    
    UILabel *lblCount = (UILabel *) [cell.contentView viewWithTag:14];
    
    if ([lblCount.text intValue] <= 0 && sender.tag == 13)
    {
        return;
    }
    
    NSDictionary *dictRow;
    
    if ([strJobType isEqualToString:@"WF"] || [strJobType isEqualToString:@"CA"])
    {
        dictRow = (NSDictionary *) [arrayCategory objectAtIndex:indexPath.row];
    }
    else
    {
        dictRow = (NSDictionary *) [arrayRow objectAtIndex:indexPath.row];
    }
    
    NSString *strTag = [NSString stringWithFormat:@"%@-%ld-%ld-%@", strJobType, selectedCategoryIndex, (long)indexPath.row, strOrderType];
    
    if (sender.tag == 13)
    {
        if ([dictItemCount objectForKey:strTag])
        {
            NSMutableDictionary *dictCountWeight = [dictItemCount objectForKey:strTag];
            
            NSString *strItemCount = [dictCountWeight objectForKey:@"count"];
            
            NSString *strSegmentIndex = [NSString stringWithFormat:@"%ld", (long)[arrayServiceTypes indexOfObject:selectedServiceTypeId]];
            
            NSString *strTotalPrice = [dictTotalPrice objectForKey:strSegmentIndex];
            
            if ([strItemCount intValue] != 0)
            {
                strItemCount = [NSString stringWithFormat:@"%d", [strItemCount intValue]-1];
                
                if ([strItemCount isEqualToString:@"0"])
                {
                    [dictCountWeight removeObjectForKey:@"count"];
                }
                else
                {
                    [dictCountWeight setObject:strItemCount forKey:@"count"];
                }
                
                double pricevalue = [strTotalPrice doubleValue] - [[dictRow objectForKey:@"ip"]doubleValue];
                [dictTotalPrice setObject:[NSString stringWithFormat:@"%.2f", pricevalue] forKey:strSegmentIndex];
                
                int TotalCountForType = [[dictCountForType objectForKey:strSegmentIndex]intValue];
                
                TotalCountForType -= 1;
                
                [dictCountForType setObject:[NSString stringWithFormat:@"%d", TotalCountForType] forKey:strSegmentIndex];
                
                
                
                
                
                
                BOOL isTagFound = NO;
                
                for (int i=0; i<[dictViewBill count]; i++)
                {
                    NSMutableArray *arrayItemDetails = [[dictViewBill allValues]objectAtIndex:i];
                    
                    for (int j=0; j<[arrayItemDetails count]; j++)
                    {
                        NSMutableDictionary *dictItemDetails = [arrayItemDetails objectAtIndex:j];
                        
                        NSString *strLocalTag = [dictItemDetails objectForKey:strTag];
                        
                        if ([strLocalTag isEqualToString:strTag])
                        {
                            isTagFound = YES;
                            
                            [dictItemDetails setObject:strItemCount forKey:@"quantity"];
                            
                            if ([strItemCount isEqualToString:@"0"])
                            {
                                if ([dictItemDetails objectForKey:@"weight"])
                                {
                                    
                                }
                                else
                                {
                                    [arrayItemDetails removeObject:dictItemDetails];
                                }
                                
                                [dictItemDetails removeObjectForKey:@"quantity"];
                                
                                if (![arrayItemDetails count])
                                {
                                    [dictViewBill removeObjectForKey:strJobName];
                                }
                            }
                            
                            break;
                        }
                    }
                    
                }
                
                if (!isTagFound)
                {
                    NSMutableArray *arrayItemDetails = [dictViewBill objectForKey:strJobName];
                    
                    if (!arrayItemDetails)
                    {
                        arrayItemDetails = [[NSMutableArray alloc]init];
                    }
                    
                    NSMutableDictionary *dictItemDetails = [[NSMutableDictionary alloc]init];
                    [dictItemDetails setObject:@"0123456789" forKey:@"orno"];
                    [dictItemDetails setObject:strJobName forKey:@"jn"];
                    
                    NSMutableDictionary *dictCountWeight = [dictItemCount objectForKey:strTag];
                    
                    [dictItemDetails setObject:[dictCountWeight objectForKey:@"count"] forKey:@"quantity"];
                    
                    [dictItemDetails setObject:[dictRow objectForKey:@"ip"] forKey:@"ip"];
                    [dictItemDetails setObject:[dictRow objectForKey:@"ic"] forKey:@"ic"];
                    
                    [dictItemDetails setObject:[dictRow objectForKey:@"uomid"] forKey:@"UOMId"];
                    
                    [dictItemDetails setObject:strJobType forKey:@"jd"];
                    [dictItemDetails setObject:[dictRow objectForKey:@"n"] forKey:@"n"];
                    [dictItemDetails setObject:strTag forKey:strTag];
                    
                    [arrayItemDetails addObject:dictItemDetails];
                    
                    [dictViewBill setObject:arrayItemDetails forKey:strJobName];
                }
            }
            else
            {
                [dictCountWeight removeObjectForKey:@"count"];
            }
        }
    }
    else if (sender.tag == 15)
    {
        if ([dictItemCount objectForKey:strTag])
        {
            NSMutableDictionary *dictCountWeight = [dictItemCount objectForKey:strTag];
            
            NSString *strItemCount = [dictCountWeight objectForKey:@"count"];
            
            NSString *strSegmentIndex = [NSString stringWithFormat:@"%ld", (long)[arrayServiceTypes indexOfObject:selectedServiceTypeId]];
            
            NSString *strTotalPrice = [dictTotalPrice objectForKey:strSegmentIndex];
            
            strItemCount = [NSString stringWithFormat:@"%d", [strItemCount intValue]+1];
            [dictCountWeight setObject:strItemCount forKey:@"count"];
            
            double pricevalue = [[dictRow objectForKey:@"ip"]doubleValue] + [strTotalPrice doubleValue];
            
            [dictTotalPrice setObject:[NSString stringWithFormat:@"%.2f", pricevalue] forKey:strSegmentIndex];
            
            int TotalCountForType = [[dictCountForType objectForKey:strSegmentIndex]intValue];
            
            TotalCountForType += 1;
            
            [dictCountForType setObject:[NSString stringWithFormat:@"%d", TotalCountForType] forKey:strSegmentIndex];
            
            
            
            
            
            
            
            
            BOOL isTagFound = NO;
            
            for (int i=0; i<[dictViewBill count]; i++)
            {
                NSMutableArray *arrayItemDetails = [[dictViewBill allValues]objectAtIndex:i];
                
                for (int j=0; j<[arrayItemDetails count]; j++)
                {
                    NSMutableDictionary *dictItemDetails = [arrayItemDetails objectAtIndex:j];
                    
                    NSString *strLocalTag = [dictItemDetails objectForKey:strTag];
                    
                    if ([strLocalTag isEqualToString:strTag])
                    {
                        isTagFound = YES;
                        [dictItemDetails setObject:strItemCount forKey:@"quantity"];
                        
                        if ([strItemCount isEqualToString:@"0"])
                        {
                            if ([dictItemDetails objectForKey:@"weight"])
                            {
                                
                            }
                            else
                            {
                                [arrayItemDetails removeObject:dictItemDetails];
                            }
                            
                            [dictItemDetails removeObjectForKey:@"quantity"];
                            
                            if (![arrayItemDetails count])
                            {
                                [dictViewBill removeObjectForKey:strJobName];
                            }
                        }
                        
                        break;
                    }
                }
            }
            
            if (!isTagFound)
            {
                NSMutableArray *arrayItemDetails = [dictViewBill objectForKey:strJobName];
                
                if (!arrayItemDetails)
                {
                    arrayItemDetails = [[NSMutableArray alloc]init];
                }
                
                NSMutableDictionary *dictItemDetails = [[NSMutableDictionary alloc]init];
                [dictItemDetails setObject:@"0123456789" forKey:@"orno"];
                [dictItemDetails setObject:strJobName forKey:@"jn"];
                
                NSMutableDictionary *dictCountWeight = [dictItemCount objectForKey:strTag];
                
                NSString *strItemCount = [dictCountWeight objectForKey:@"count"];
                
                [dictItemDetails setObject:strItemCount forKey:@"quantity"];
                
                [dictItemDetails setObject:[dictRow objectForKey:@"ip"] forKey:@"ip"];
                [dictItemDetails setObject:[dictRow objectForKey:@"ic"] forKey:@"ic"];
                [dictItemDetails setObject:[dictRow objectForKey:@"uomid"] forKey:@"UOMId"];
                
                [dictItemDetails setObject:strJobType forKey:@"jd"];
                [dictItemDetails setObject:[dictRow objectForKey:@"n"] forKey:@"n"];
                [dictItemDetails setObject:strTag forKey:strTag];
                
                [arrayItemDetails addObject:dictItemDetails];
                
                [dictViewBill setObject:arrayItemDetails forKey:strJobName];
            }
        }
        else
        {
            NSMutableDictionary *dictCountWeight = [[NSMutableDictionary alloc]init];
            
            NSString *strItemCount = [NSString stringWithFormat:@"%d", 1];
            [dictCountWeight setObject:strItemCount forKey:@"count"];
            
            [dictItemCount setObject:dictCountWeight forKey:strTag];
            
            NSString *strSegmentIndex = [NSString stringWithFormat:@"%ld", (long)[arrayServiceTypes indexOfObject:selectedServiceTypeId]];
            
            NSString *strTotalPrice = [dictTotalPrice objectForKey:strSegmentIndex];
            
            double pricevalue = [[dictRow objectForKey:@"ip"]doubleValue] + [strTotalPrice doubleValue];
            [dictTotalPrice setObject:[NSString stringWithFormat:@"%.2f", pricevalue] forKey:strSegmentIndex];
            
            int TotalCountForType = [[dictCountForType objectForKey:strSegmentIndex]intValue];
            
            TotalCountForType += 1;
            
            [dictCountForType setObject:[NSString stringWithFormat:@"%d", TotalCountForType] forKey:strSegmentIndex];
            
            
            
            
            
            BOOL isTagFound = NO;
            
            for (int i=0; i<[dictViewBill count]; i++)
            {
                NSMutableArray *arrayItemDetails = [[dictViewBill allValues]objectAtIndex:i];
                
                for (int j=0; j<[arrayItemDetails count]; j++)
                {
                    NSMutableDictionary *dictItemDetails = [arrayItemDetails objectAtIndex:j];
                    
                    NSString *strLocalTag = [dictItemDetails objectForKey:strTag];
                    
                    if ([strLocalTag isEqualToString:strTag])
                    {
                        isTagFound = YES;
                        [dictItemDetails setObject:strItemCount forKey:@"quantity"];
                        
                        if ([strItemCount isEqualToString:@"0"])
                        {
                            if ([dictItemDetails objectForKey:@"weight"])
                            {
                                
                            }
                            else
                            {
                                [arrayItemDetails removeObject:dictItemDetails];
                            }
                            
                            [dictItemDetails removeObjectForKey:@"quantity"];
                            
                            if (![arrayItemDetails count])
                            {
                                [dictViewBill removeObjectForKey:strJobName];
                            }
                        }
                        
                        break;
                    }
                }
                
            }
            
            if (!isTagFound)
            {
                NSMutableArray *arrayItemDetails = [dictViewBill objectForKey:strJobName];
                
                if (!arrayItemDetails)
                {
                    arrayItemDetails = [[NSMutableArray alloc]init];
                }
                
                NSMutableDictionary *dictItemDetails = [[NSMutableDictionary alloc]init];
                [dictItemDetails setObject:@"0123456789" forKey:@"orno"];
                [dictItemDetails setObject:strJobName forKey:@"jn"];
                
                NSMutableDictionary *dictCountWeight = [dictItemCount objectForKey:strTag];
                
                [dictItemDetails setObject:[dictCountWeight objectForKey:@"count"] forKey:@"quantity"];
                
                [dictItemDetails setObject:[dictRow objectForKey:@"uomid"] forKey:@"UOMId"];
                
                [dictItemDetails setObject:[dictRow objectForKey:@"ip"] forKey:@"ip"];
                [dictItemDetails setObject:[dictRow objectForKey:@"ic"] forKey:@"ic"];
                [dictItemDetails setObject:strJobType forKey:@"jd"];
                [dictItemDetails setObject:[dictRow objectForKey:@"n"] forKey:@"n"];
                [dictItemDetails setObject:strTag forKey:strTag];
                
                [arrayItemDetails addObject:dictItemDetails];
                
                [dictViewBill setObject:arrayItemDetails forKey:strJobName];
            }
        }
    }
    
    if ([dictTotalPrice count])
    {
        [self setFinalAmount];
    }
    
    [tblPricing reloadData];
}

-(void) setFinalAmount
{
    float totalPrice = 0;
    
    NSArray *array = [dictTotalPrice allKeys];
    
    for (int i=0; i<[dictTotalPrice count]; i++)
    {
        totalPrice += [[dictTotalPrice objectForKey:[array objectAtIndex:i]] floatValue];
    }
    
    lblFinalAmount.text = [NSString stringWithFormat:@"$%.2f", totalPrice];
}

-(void) addTfdata:(UITextField *)tf value:(NSString *) str
{
    CGPoint position = [tf convertPoint:CGPointZero toView:tblPricing];
    NSIndexPath *indexPath = [tblPricing indexPathForRowAtPoint:position];
    
    NSDictionary *dictRow;
    
    if ([strJobType isEqualToString:@"WF"] || [strJobType isEqualToString:@"CA"])
    {
        dictRow = (NSDictionary *) [arrayCategory objectAtIndex:indexPath.row];
    }
    else
    {
        dictRow = (NSDictionary *) [arrayRow objectAtIndex:indexPath.row];
    }
    
    NSString *strTag = [NSString stringWithFormat:@"%@-%ld-%ld-%@", strJobType, selectedCategoryIndex, (long)indexPath.row, strOrderType];
    
    NSMutableDictionary *dictCountWeight;
    
    if ([dictItemCount objectForKey:strTag])
    {
        dictCountWeight = [dictItemCount objectForKey:strTag];
    }
    else
    {
        dictCountWeight = [[NSMutableDictionary alloc]init];
    }
    
    NSString *strSegmentIndex = [NSString stringWithFormat:@"%ld", (long)[arrayServiceTypes indexOfObject:selectedServiceTypeId]];
    
    NSString *strTotalPrice = [dictTotalPrice objectForKey:strSegmentIndex];
    
    strTotalPrice = [NSString stringWithFormat:@"%.2f", [strTotalPrice floatValue] - ([[dictCountWeight objectForKey:@"weight"] floatValue] * [[dictRow objectForKey:@"ip"] floatValue])];
    
    double pricevalue = ([[dictRow objectForKey:@"ip"] doubleValue] * [str doubleValue]) + [strTotalPrice doubleValue];
    [dictTotalPrice setObject:[NSString stringWithFormat:@"%.2f", pricevalue] forKey:strSegmentIndex];
    
    [dictCountWeight setObject:str forKey:@"weight"];
    
    [dictItemCount setObject:dictCountWeight forKey:strTag];
    
    
    BOOL isTagFound = NO;
    
    for (int i=0; i<[dictViewBill count]; i++)
    {
        NSMutableArray *arrayItemDetails = [[dictViewBill allValues]objectAtIndex:i];
        
        for (int j=0; j<[arrayItemDetails count]; j++)
        {
            NSMutableDictionary *dictItemDetails = [arrayItemDetails objectAtIndex:j];
            
            NSString *strLocalTag = [dictItemDetails objectForKey:strTag];
            
            if ([strLocalTag isEqualToString:strTag])
            {
                isTagFound = YES;
                
                [dictItemDetails setObject:str forKey:@"weight"];
                
                [dictItemDetails setObject:[dictRow objectForKey:@"ip"] forKey:@"ip"];
                
                if ([str isEqualToString:@""] || [str floatValue] == 0.0)
                {
                    if ([dictItemDetails objectForKey:@"quantity"])
                    {
                        
                    }
                    else
                    {
                        [arrayItemDetails removeObject:dictItemDetails];
                    }
                    
                    [dictItemDetails removeObjectForKey:@"weight"];
                    
                    [dictCountWeight removeObjectForKey:@"weight"];
                    
                    //[dictItemCount removeObjectForKey:strTag];
                    
                    if (![arrayItemDetails count])
                    {
                        [dictViewBill removeObjectForKey:strJobName];
                    }
                }
                
                break;
            }
        }
        
    }
    
    if (!isTagFound)
    {
        if ([str isEqualToString:@""] || [str floatValue] == 0.0)
        {
            [dictCountWeight removeObjectForKey:@"weight"];
            
            return;
        }
        
        NSMutableArray *arrayItemDetails = [dictViewBill objectForKey:strJobName];
        
        if (!arrayItemDetails)
        {
            arrayItemDetails = [[NSMutableArray alloc]init];
        }
        
        NSMutableDictionary *dictItemDetails = [[NSMutableDictionary alloc]init];
        [dictItemDetails setObject:@"0123456789" forKey:@"orno"];
        [dictItemDetails setObject:strJobName forKey:@"jn"];
        
        [dictItemDetails setObject:str forKey:@"weight"];
        
        NSString *strPrice = [NSString stringWithFormat:@"%.2f", [[dictRow objectForKey:@"ip"] floatValue] * [str floatValue]];
        
        [dictItemDetails setObject:strPrice forKey:@"ip"];
        [dictItemDetails setObject:[dictRow objectForKey:@"ic"] forKey:@"ic"];
        
        [dictItemDetails setObject:[dictRow objectForKey:@"uomid"] forKey:@"UOMId"];
        
        [dictItemDetails setObject:strJobType forKey:@"jd"];
        [dictItemDetails setObject:[dictRow objectForKey:@"n"] forKey:@"n"];
        [dictItemDetails setObject:strTag forKey:strTag];
        
        [arrayItemDetails addObject:dictItemDetails];
        
        [dictViewBill setObject:arrayItemDetails forKey:strJobName];
    }
    
    if ([dictTotalPrice count])
    {
        [self setFinalAmount];
    }
}

-(void) didAdditems:(CGFloat)value
{
    tfGlobal.text = [NSString stringWithFormat:@"%.2f", value];
    
    if (value == 0.0)
    {
        tfGlobal.text = @"";
    }
    
    [self addTfdata:tfGlobal value:tfGlobal.text];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    CGPoint position = [textField convertPoint:CGPointZero toView:tblPricing];
    NSIndexPath *indexPath = [tblPricing indexPathForRowAtPoint:position];
    
    NSDictionary *dictRow;
    
    if ([strJobType isEqualToString:@"WF"] || [strJobType isEqualToString:@"CA"])
    {
        dictRow = (NSDictionary *) [arrayCategory objectAtIndex:indexPath.row];
    }
    else
    {
        dictRow = (NSDictionary *) [arrayRow objectAtIndex:indexPath.row];
    }
    
    if ([strJobType containsString:@"CC"])
    {
        CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:tblPricing];
        CGPoint contentOffset = tblPricing.contentOffset;
        
        contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
        
        NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
        
        [tblPricing setContentOffset:contentOffset animated:YES];
        
        return YES;
    }
    else if ([[dictRow objectForKey:@"uomid"] isEqualToString:@"3"])
    {
        tfGlobal = textField;
        
        CalculateViewController *objCal = [[CalculateViewController alloc]init];
        objCal.delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:objCal];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    else
    {
        CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:tblPricing];
        CGPoint contentOffset = tblPricing.contentOffset;
        
        contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
        
        NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
        
        [tblPricing setContentOffset:contentOffset animated:YES];
        
        return YES;
    }
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = (UITableViewCell*)textField.superview.superview;
        NSIndexPath *indexPath = [tblPricing indexPathForCell:cell];
        
        [tblPricing scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ([string isEqualToString:filtered])
    {
        NSString *str1 = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        [self addTfdata:textField value:str1];
        
        [textField becomeFirstResponder];
        
        return YES;
    }
    else return NO;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
