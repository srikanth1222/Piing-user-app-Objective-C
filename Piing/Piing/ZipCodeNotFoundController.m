//
//  ZipCodeNotFoundController.m
//  Piing
//
//  Created by Veedepu Srikanth on 23/03/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import "ZipCodeNotFoundController.h"

@interface ZipCodeNotFoundController ()
{
    AppDelegate *appDel;
}

@end

@implementation ZipCodeNotFoundController

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDel = [PiingHandler sharedHandler].appDel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = [UIImage imageNamed:@"no_zipcode_bg"];
    [self.view addSubview:imgView];
    
    float yAxis = 20*MULTIPLYHEIGHT;
    
    float btnbackHeight = 29*MULTIPLYHEIGHT;
    float btnBackX = 7*MULTIPLYHEIGHT;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(btnBackX, yAxis, btnbackHeight, btnbackHeight);
    [backBtn setImage:[UIImage imageNamed:@"back_grey1"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.backgroundColor = [UIColor whiteColor];
    backBtn.layer.cornerRadius = backBtn.frame.size.width/2;
    
    yAxis += 190*MULTIPLYHEIGHT;
    
    float lblSHeight = 29*MULTIPLYHEIGHT;
    
    UILabel *lblSorry = [[UILabel alloc] initWithFrame:CGRectMake(0.0, yAxis, screen_width, lblSHeight)];
    NSString *string = @"SORRY!";
    [appDel spacingForTitle:lblSorry TitleString:string];
    lblSorry.textAlignment = NSTextAlignmentCenter;
    lblSorry.textColor = [UIColor darkGrayColor];
    lblSorry.backgroundColor = [UIColor clearColor];
    lblSorry.font = [UIFont fontWithName:APPFONT_BOLD size:appDel.HEADER_LABEL_FONT_SIZE+5];
    [self.view addSubview:lblSorry];
    
    yAxis += lblSHeight+5*MULTIPLYHEIGHT;
    
    
    UILabel *lblDesc = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblSHeight)];
    lblDesc.text = @"Your area isn't laundry-free yet.\nBut we are getting there!";
    lblDesc.numberOfLines = 0;
    lblDesc.textAlignment = NSTextAlignmentCenter;
    lblDesc.textColor = [UIColor grayColor];
    lblDesc.backgroundColor = [UIColor clearColor];
    lblDesc.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-1];
    [self.view addSubview:lblDesc];
    
    CGFloat heightDesc = [AppDelegate getLabelHeightForRegularText:lblDesc.text WithWidth:screen_width FontSize:lblDesc.font.pointSize];
    
    CGRect rect = lblDesc.frame;
    rect.size.height = heightDesc;
    lblDesc.frame = rect;
    
    yAxis += heightDesc+30*MULTIPLYHEIGHT;
    
    
    float btnX = 30*MULTIPLYHEIGHT;
    float btnHeight = 29*MULTIPLYHEIGHT;
    
    UIButton *btnPostalCode = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPostalCode.frame = CGRectMake(btnX, yAxis, screen_width-(btnX*2), btnHeight);
    [btnPostalCode setTitle:@"TRY ANOTHER POSTAL CODE" forState:UIControlStateNormal];
    [btnPostalCode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnPostalCode.titleLabel.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.FONT_SIZE_CUSTOM-2];
    btnPostalCode.layer.borderColor = [UIColor grayColor].CGColor;
    btnPostalCode.layer.borderWidth = 2.0f;
    [btnPostalCode addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPostalCode];
    
    yAxis += btnHeight+35*MULTIPLYHEIGHT;
    
    
    UILabel *lblEarn = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblSHeight)];
    lblEarn.text = [@"Earn free washes for life" uppercaseString];
    lblEarn.numberOfLines = 0;
    lblEarn.textAlignment = NSTextAlignmentCenter;
    lblEarn.textColor = [UIColor grayColor];
    lblEarn.backgroundColor = [UIColor clearColor];
    lblEarn.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-5];
    [self.view addSubview:lblEarn];
    
    CGSize sizeEarn = [AppDelegate getLabelSizeForRegularText:lblEarn.text WithWidth:screen_width FontSize:lblEarn.font.pointSize];
    
    CGRect rectEarn = lblEarn.frame;
    rectEarn.origin.x = screen_width/2-sizeEarn.width/2;
    rectEarn.size.width = sizeEarn.width;
    rectEarn.size.height = sizeEarn.height;
    lblEarn.frame = rectEarn;
    
    CALayer *bottomLayer = [[CALayer alloc]init];
    bottomLayer.frame = CGRectMake(0, sizeEarn.height-1, sizeEarn.width, 1);
    bottomLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [lblEarn.layer addSublayer:bottomLayer];
    
    yAxis += sizeEarn.height+25*MULTIPLYHEIGHT;
    
    
    NSString *strSorryMessage = [@"We're sorry we don't serve your location at the moment!\nBut we're expanding rapidly in Singapore and will see you very soon.\nAs a thank you for your patience,here's our promise to give you $10 off\nyour first order when Piing comes to your district" uppercaseString];
    
    UILabel *lblBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, yAxis, screen_width, lblSHeight)];
    lblBottom.text = strSorryMessage;
    lblBottom.numberOfLines = 0;
    lblBottom.textAlignment = NSTextAlignmentCenter;
    lblBottom.textColor = RGBCOLORCODE(150, 150, 150, 1.0);
    lblBottom.backgroundColor = [UIColor clearColor];
    lblBottom.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.FONT_SIZE_CUSTOM-8];
    [self.view addSubview:lblBottom];
    
    CGSize sizeSorry = [AppDelegate getLabelSizeForRegularText:lblBottom.text WithWidth:screen_width FontSize:lblBottom.font.pointSize];
    
    CGRect rectSorry = lblBottom.frame;
    rectSorry.size.height = sizeSorry.height;
    lblBottom.frame = rectSorry;
}


-(void) closeBtnClicked
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
