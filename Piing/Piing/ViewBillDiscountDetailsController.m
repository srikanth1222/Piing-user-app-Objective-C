//
//  ViewBillDiscountDetailsController.m
//  Piing
//
//  Created by Veedepu Srikanth on 19/05/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "ViewBillDiscountDetailsController.h"
#import "NSNull+JSON.h"


@interface ViewBillDiscountDetailsController ()
{
    AppDelegate *appDel;
    
    UILabel *lblTitle;
}

@end

@implementation ViewBillDiscountDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    float yPos = 25*MULTIPLYHEIGHT;
    
    lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, yPos, screen_width, 40)];
    NSString *string = @"VIEW DISCOUNT DETAILS";
    [appDel spacingForTitle:lblTitle TitleString:string];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-4];
    lblTitle.textColor = APP_FONT_COLOR_GREY;
    [self.view addSubview:lblTitle];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(10, yPos, 40.0, 40.0);
    [closeBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:closeBtn];
    
    yPos += 40+10*MULTIPLYHEIGHT;
    
    CALayer *topLayer = [[CALayer alloc]init];
    topLayer.frame = CGRectMake(0, yPos, screen_width, 1);
    topLayer.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3].CGColor;
    [self.view.layer addSublayer:topLayer];
    
    yPos += 10*MULTIPLYHEIGHT;
    
    for (int i=0; i<[self.arrayDiscount count]; i++)
    {
        NSDictionary *dict = [self.arrayDiscount objectAtIndex:i];
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.text = [dict objectForKey:@"displayName"];
        lbl.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM];
        lbl.textColor = [UIColor darkGrayColor];
        [self.view addSubview:lbl];
        
        float lblX = 8*MULTIPLYHEIGHT;
        float lblWidth = screen_width-((lblX*2)+70*MULTIPLYHEIGHT);
        float lblHeight = 25*MULTIPLYHEIGHT;
        
        lbl.frame = CGRectMake(lblX, yPos, lblWidth, lblHeight);
        
        UILabel *lblPrice = [[UILabel alloc]init];
        lblPrice.text = [NSString stringWithFormat:@"$%.2f", [[dict objectForKey:@"displayValue"] floatValue]];
        lblPrice.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM];
        lblPrice.textAlignment = NSTextAlignmentCenter;
        lblPrice.textColor = [UIColor darkGrayColor];
        [self.view addSubview:lblPrice];
        
        lblPrice.frame = CGRectMake(lblX+lblWidth, yPos, screen_width-(lblX+lblWidth), lblHeight);
        
        yPos += lblHeight+10*MULTIPLYHEIGHT;
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [appDel hideTabBar:appDel.customTabBarController];
}

-(void) backBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
