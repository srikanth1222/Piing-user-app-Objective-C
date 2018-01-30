//
//  AddAddressViewController.m
//  Piing
//
//  Created by SHASHANK on 27/09/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import "AddAddressViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZipCodeNotFoundController.h"
#import "CustomPopoverView.h"



@interface AddAddressViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CustomPopoverViewDelegate>
{
    MPMoviePlayerController *backGroundplayer;
    
    UIButton *saveBtn;
    UITableView *addAddressTableView;
    UITextField *tempTf;
    
    BOOL isAllFeildsCorrect;
    BOOL isZipCodeValid;
    
    BOOL isFnoApplicable;
    BOOL isUnoApplicable;

    AppDelegate *appDel;
    
    CustomPopoverView *customPopOverView;
    UIView *view_Popover;
    
    BOOL isEditable;
    
    BOOL addressNameAlreadyExists;
    
    BOOL floorColor;
    BOOL unitColor;
    
    NSInteger selectedAddressRow;
}

@end

@implementation AddAddressViewController

@synthesize addressFeild;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    appDel = [PiingHandler sharedHandler].appDel;
    selectedAddressRow = 0;
    
    if (!self.isEditingAddress)
    {
        addressFeild = [[AddressFeild alloc] init];
        addressFeild.addressName = @"HOME";
        isZipCodeValid = NO;
    }
    else
    {
        isZipCodeValid = YES;
    }
    
    
    if (self.isFromReg)
    {
        NSString*thePath=[[NSBundle mainBundle] pathForResource:MOBILE_APP_VIDEO ofType:@"mp4"];
        NSURL*theurl=[NSURL fileURLWithPath:thePath];
        
        backGroundplayer = [[MPMoviePlayerController alloc] initWithContentURL:theurl];
        backGroundplayer.view.frame = CGRectMake(0, 0, screen_width, screen_height);
        backGroundplayer.repeatMode = YES;
        backGroundplayer.view.userInteractionEnabled = YES;
        backGroundplayer.controlStyle = MPMovieControlStyleNone;
        [backGroundplayer prepareToPlay];
        [backGroundplayer setShouldAutoplay:YES]; // And other options you can look through the documentation.
        [self.view addSubview:backGroundplayer.view];
        [backGroundplayer play];
        [backGroundplayer setScalingMode:MPMovieScalingModeAspectFill];
    }
    
    
    UIView *blackTransparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height)];
    //blackTransparentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //blackTransparentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [appDel applyBlurEffectForView:blackTransparentView Style:BLUR_EFFECT_STYLE_DARK];
    [self.view addSubview:blackTransparentView];
    
    if (self.isFromReg)
    {
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, (screen_width/3 ) * 2, 5.0)];
        statusBarView.backgroundColor = BLUE_COLOR;
        [self.view addSubview:statusBarView];
    }
    
    float yAxis = 25*MULTIPLYHEIGHT;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(10.0, yAxis, 35, 35);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_white"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn setShowsTouchWhenHighlighted:YES];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(closeBtn.frame), CGRectGetMinY(closeBtn.frame), screen_width - 130, 35)];
    NSString *str = [@"Address" uppercaseString];
    [appDel spacingForTitle:titleLbl TitleString:str];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont fontWithName:APPFONT_MEDIUM size:appDel.HEADER_LABEL_FONT_SIZE-3];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.center = CGPointMake(screen_width/2.0 ,titleLbl.center.y);
    [self.view addSubview:titleLbl];
    
    float btnWidth = 72*MULTIPLYHEIGHT;
    float btnX = btnWidth+10*MULTIPLYHEIGHT;
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(screen_width - btnX, yAxis, btnWidth, 35);
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setTitle:@"GET ADDRESS" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM-2]];
    [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    saveBtn.userInteractionEnabled = NO;
    saveBtn.alpha = 0.0;
    //saveBtn.backgroundColor = [UIColor redColor];
    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    yAxis += 35+20*MULTIPLYHEIGHT;
    
    if (self.isEditingAddress)
    {
        saveBtn.userInteractionEnabled = YES;
        saveBtn.alpha = 1.0;
        
        [saveBtn setTitle:@"" forState:UIControlStateNormal];
        
        [saveBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"SAVE" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM]] forState:UIControlStateNormal];
    }
    
    addAddressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yAxis, screen_width, screen_height-yAxis)];
    addAddressTableView.delegate = self;
    addAddressTableView.dataSource = self;
    addAddressTableView.separatorColor = [UIColor clearColor];
    addAddressTableView.backgroundColor = [UIColor clearColor];
    addAddressTableView.backgroundView = nil;
    addAddressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:addAddressTableView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark UIControl Actions
-(void) viewTapped
{
    [self dismissKeyboard];
}
-(void) closeBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) saveBtnClicked
{
    [self.view endEditing:YES];
    
    if ([[saveBtn titleForState:UIControlStateNormal] isEqualToString:@"GET ADDRESS"] || !isZipCodeValid)
    {
        if ([addressFeild.zipCode length] > 0)
            [self performSelectorOnMainThread:@selector(validateZipcode) withObject:nil waitUntilDone:NO];
    }
    else
    {
        DLog(@"%@,%@,%@,%@,%@",addressFeild.addressLine1, addressFeild.addressLine2, addressFeild.zipCode, addressFeild.notes, addressFeild.addressType);
        if (Static_screens_Build)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            if ([addressFeild.addressName length] == 0)
            {
                [appDel showAlertWithMessage:@"Please enter address name" andTitle:@"" andBtnTitle:@"OK"];
                return;
            }
            if (isFnoApplicable)
            {
                if ([addressFeild.fno length] == 0)
                {
                    [appDel showAlertWithMessage:@"Please enter floor number" andTitle:@"" andBtnTitle:@"OK"];
                    return;
                }
            }
            if (isUnoApplicable)
            {
                if ([addressFeild.uno length] == 0)
                {
                    [appDel showAlertWithMessage:@"Please enter unit number" andTitle:@"" andBtnTitle:@"OK"];
                    return;
                }
            }
            
            if ([addressFeild.addressName length] < 2)
            {
                [appDel showAlertWithMessage:@"Address name should be at least 3 letters." andTitle:@"" andBtnTitle:@"OK"];
                return;
            }
            
            if ([addressFeild.addressLine2 length] == 0)
            {
                [appDel showAlertWithMessage:@"Please enter address line" andTitle:@"" andBtnTitle:@"OK"];
                return;
            }
            
            if ([addressFeild.fno length] == 0 && [addressFeild.uno length] == 0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure your address doen't have a floor & unit number?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* donthave = [UIAlertAction actionWithTitle:@"I do not have" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    [self callAddressSave];
                    
                }];
                
                [alertController addAction:donthave];
                
                UIAlertAction *have = [UIAlertAction actionWithTitle:@"I have" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    floorColor = YES;
                    unitColor = YES;
                    
                    [addAddressTableView reloadData];
                }];
                
                [alertController addAction:have];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if ([addressFeild.fno length] == 0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you do not have floor no.?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* donthave = [UIAlertAction actionWithTitle:@"I do not have" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    [self callAddressSave];
                    
                }];
                
                [alertController addAction:donthave];
                
                UIAlertAction *have = [UIAlertAction actionWithTitle:@"I have" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    floorColor = YES;
                    
                    [addAddressTableView reloadData];
                    
                }];
                
                [alertController addAction:have];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if ([addressFeild.uno length] == 0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Are you sure you do not have unit no.?" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* donthave = [UIAlertAction actionWithTitle:@"I do not have" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    [self callAddressSave];
                    
                }];
                
                [alertController addAction:donthave];
                
                UIAlertAction *have = [UIAlertAction actionWithTitle:@"I have" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    
                    unitColor = YES;
                    
                    [addAddressTableView reloadData];
                    
                }];
                
                [alertController addAction:have];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                [self callAddressSave];
            }
        }
    }
}

-(void) callAddressSave
{
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    NSDictionary *dict = nil;
    
    if (!self.isEditingAddress)
    {
        if (appDel.isFirstTimeAddressAdding)
        {
            appDel.isFirstTimeAddressAdding = NO;
            addressFeild.isAddressDefault = @"1";
        }
        
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID], @"uid", addressFeild.addressName, @"name", addressFeild.addressLine1, @"line1", addressFeild.addressLine2, @"line2", addressFeild.city, @"city", addressFeild.state, @"state", addressFeild.country, @"country", addressFeild.notes, @"landMark", addressFeild.zipCode, @"zipcode", addressFeild.isAddressDefault, @"default",addressFeild.fno, @"floorNo", addressFeild.uno, @"unitNo", addressFeild.lat, @"lat", addressFeild.lng, @"lon", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    }
    else
    {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID],@"uid", addressFeild.addressName, @"name", addressFeild.addressLine1, @"line1", addressFeild.addressLine2, @"line2", addressFeild.city, @"city", addressFeild.state, @"state", addressFeild.country, @"country",addressFeild.notes, @"landMark", addressFeild.zipCode, @"zipcode", addressFeild.isAddressDefault, @"default",addressFeild.fno, @"floorNo", addressFeild.uno, @"unitNo", addressFeild.addressID, @"_id", addressFeild.lat, @"lat", addressFeild.lng, @"lon", [[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN], @"t", nil];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/save", BASE_URL];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:dict andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([[responseObj objectForKey:@"s"] intValue] == 1)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                
                if (self.delegate)
                {
                    if ([self.delegate respondsToSelector:@selector(didAddNewAddress)])
                    {
                        [self.delegate didAddNewAddress];
                    }
                }
            }];
        }
        else
        {
            if ([[responseObj objectForKey:@"s"]intValue] == 54)
            {
                addressNameAlreadyExists = YES;
            }
            
            [appDel displayErrorMessagErrorResponse:responseObj];
        }
        
        [addAddressTableView reloadData];

    }];
}


-(void) dismissKeyboard
{
    [tempTf resignFirstResponder];
    [addAddressTableView reloadData];
}


#pragma mark Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isZipCodeValid)
        return 6;
    else
        return 1;
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.row == 3)
        CellIdentifier = @"not only text Feild";
    else
        CellIdentifier = @"Only Text Feild";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        if ([CellIdentifier isEqualToString:@"Only Text Feild"])
        {
            
            float bgX = 15*MULTIPLYHEIGHT;
            float bgHeight = 29*MULTIPLYHEIGHT;
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, 0, tableView.frame.size.width-(bgX*2), bgHeight)];
            bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
            bgView.tag = 1232;
            [cell.contentView addSubview:bgView];
            
            float imgX = 8*MULTIPLYHEIGHT;
            float imgWidth = 16*MULTIPLYHEIGHT;
            
            UIImageView *cellimageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 0, imgWidth, bgHeight)];
            cellimageView.tag = 1236;
            cellimageView.contentMode = UIViewContentModeScaleAspectFit;
            [bgView addSubview:cellimageView];
            
            float lblX = imgX+imgWidth+10*MULTIPLYHEIGHT;
            
            UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(lblX, 0, bgView.frame.size.width-(lblX*2),  bgHeight)];
            textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFeild.tag = 1234;
            textFeild.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
            textFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textFeild.autocorrectionType = UITextAutocorrectionTypeNo;
            textFeild.delegate = self;
            textFeild.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM];
            textFeild.textColor = [UIColor whiteColor];
            textFeild.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            textFeild.backgroundColor = [UIColor clearColor];
            [bgView addSubview:textFeild];
            
            float btnAWidth = 29*MULTIPLYHEIGHT;
            
            UIButton *btnArrow = [UIButton buttonWithType:UIButtonTypeCustom];
            btnArrow.frame = CGRectMake(bgView.frame.size.width-btnAWidth, 0, btnAWidth, btnAWidth);
            [btnArrow addTarget:self action:@selector(openPopupForAddressName) forControlEvents:UIControlEventTouchUpInside];
            [btnArrow setImage:[UIImage imageNamed:@"down_arrow_white"] forState:UIControlStateNormal];
            btnArrow.tag = 1238;
            [bgView addSubview:btnArrow];
        }
        else
        {
            float bgX = 15*MULTIPLYHEIGHT;
            float bgHeight = 29*MULTIPLYHEIGHT;
            
            float bgWidth = tableView.frame.size.width/2-(bgX+2*MULTIPLYHEIGHT);
            
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bgX, 0, bgWidth, bgHeight)];
            bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
            bgView.tag = 1232;
            [cell.contentView addSubview:bgView];
            
            float imgX = 8*MULTIPLYHEIGHT;
            float imgWidth = 16*MULTIPLYHEIGHT;
            
            UIImageView *cellimageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 0,imgWidth, bgHeight)];
            cellimageView.tag = 1236;
            cellimageView.contentMode = UIViewContentModeScaleAspectFit;
            [bgView addSubview:cellimageView];
            
            float lblX = imgX+imgWidth+10*MULTIPLYHEIGHT;
            
            UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(lblX, 0, bgView.frame.size.width-lblX, bgHeight)];
            textFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFeild.tag = 1234;
            textFeild.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            textFeild.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
            textFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textFeild.autocorrectionType = UITextAutocorrectionTypeNo;
            textFeild.delegate = self;
            textFeild.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-1];
            textFeild.textColor = [UIColor whiteColor];
            textFeild.returnKeyType = UIReturnKeyDefault;
            textFeild.backgroundColor = [UIColor clearColor];
            [bgView addSubview:textFeild];
            
            UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bgView.frame) + 4*MULTIPLYHEIGHT, 0, bgWidth, bgHeight)];
            bgView2.tag = 1233;
            bgView2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
            [cell.contentView addSubview:bgView2];
            
            UIImageView *cellimageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 0,imgWidth, bgHeight)];
            cellimageView2.tag = 1237;
            cellimageView2.contentMode = UIViewContentModeScaleAspectFit;
            [bgView2 addSubview:cellimageView2];
            
            UITextField *textFeild2 = [[UITextField alloc] initWithFrame:CGRectMake(lblX, 0, bgView.frame.size.width-lblX, bgHeight)];
            textFeild2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            textFeild2.tag = 1235;
            textFeild2.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
            textFeild2.layer.borderColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1.0].CGColor;
            textFeild2.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textFeild2.autocorrectionType = UITextAutocorrectionTypeNo;
            textFeild2.delegate = self;
            textFeild2.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-1];
            textFeild2.textColor = [UIColor whiteColor];
            textFeild2.returnKeyType = UIReturnKeyDefault;
            textFeild2.backgroundColor = [UIColor clearColor];
            [bgView2 addSubview:textFeild2];
        }
    }
    
    UIView *bgView = (UIView *) [cell.contentView viewWithTag:1232];
    UIView *bgView2 = (UIView *) [cell.contentView viewWithTag:1233];
    
    UITextField *cellTextFeild = (UITextField *)[cell viewWithTag:1234];
    UIImageView *cellimageView = (UIImageView *)[cell viewWithTag:1236];
    UIImageView *cellimageView2 = (UIImageView *)[cell viewWithTag:1237];
    
    UIButton *btnArrow = (UIButton *) [cell viewWithTag:1238];
    btnArrow.hidden = YES;
    
    cellTextFeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    if(indexPath.row == 1)
    {
        cellTextFeild.autocapitalizationType = UITextAutocapitalizationTypeWords;
        
        if (addressNameAlreadyExists)
        {
            addressNameAlreadyExists = NO;
            bgView.layer.borderColor = [UIColor redColor].CGColor;
            bgView.layer.borderWidth = 1.0;
        }
        else
        {
            bgView.layer.borderColor = [UIColor clearColor].CGColor;
            bgView.layer.borderWidth = 0.0;
        }
        
        btnArrow.hidden = NO;
        
        tempTf = cellTextFeild;
        
        cellimageView.image = [UIImage imageNamed:@"address_icon"];
        [cellTextFeild setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"ADDRESS NAME" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        cellTextFeild.attributedPlaceholder = str;
        
        cellTextFeild.text = addressFeild.addressName;
        cellTextFeild.keyboardType = UIKeyboardTypeDefault;
        
    }
    else if(indexPath.row == 3)
    {
        if (floorColor)
        {
            floorColor = NO;
            bgView.layer.borderColor = BLUE_COLOR.CGColor;
            bgView.layer.borderWidth = 1.0;
        }
        else
        {
            bgView.layer.borderColor = [UIColor clearColor].CGColor;
            bgView.layer.borderWidth = 0.0;
        }
        
        UITextField *cellTextFeild1 = (UITextField *)[cell viewWithTag:1234];
        UITextField *cellTextFeild2 = (UITextField *)[cell viewWithTag:1235];
        
        cellimageView.image = [UIImage imageNamed:@"floorno_icon"];
        
        [cellTextFeild1 setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"FLOOR NO" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        cellTextFeild1.attributedPlaceholder = str;
        cellTextFeild1.text = addressFeild.fno;
        cellTextFeild1.keyboardType = UIKeyboardTypeDefault;
        
        
        if (unitColor)
        {
            unitColor = NO;
            bgView2.layer.borderColor = BLUE_COLOR.CGColor;
            bgView2.layer.borderWidth = 1.0;
        }
        else
        {
            bgView2.layer.borderColor = [UIColor clearColor].CGColor;
            bgView2.layer.borderWidth = 0.0;
        }
        
        cellimageView2.image = [UIImage imageNamed:@"unitno_icon"];
        
        [cellTextFeild2 setSecureTextEntry:NO];
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"UNIT NO" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        
        cellTextFeild2.attributedPlaceholder = str2;
        cellTextFeild2.text = addressFeild.uno;
        cellTextFeild2.keyboardType = UIKeyboardTypeDefault;
    }
    else if(indexPath.row == 2)
    {
        cellimageView.image = [UIImage imageNamed:@"address_icon"];
        
        [cellTextFeild setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"BUILDING NAME" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        cellTextFeild.attributedPlaceholder = str;
        cellTextFeild.userInteractionEnabled = NO;
        cellTextFeild.text = addressFeild.addressLine1;
        cellTextFeild.keyboardType = UIKeyboardTypeDefault;
        cellTextFeild.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
    }
    else if(indexPath.row == 4)
    {
        cellimageView.image = [UIImage imageNamed:@"address_icon"];
        
        [cellTextFeild setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"ADDRESS" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        cellTextFeild.attributedPlaceholder = str;
        cellTextFeild.userInteractionEnabled = NO;
        cellTextFeild.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2];
        
        cellTextFeild.text = addressFeild.addressLine2;
        cellTextFeild.keyboardType = UIKeyboardTypeDefault;
    }
    else if((indexPath.row == 0))
    {
        cellimageView.image = [UIImage imageNamed:@"zipcode_icon"];
        
        [cellTextFeild setSecureTextEntry:NO];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"POSTAL CODE" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        cellTextFeild.attributedPlaceholder = str;

        cellTextFeild.text = addressFeild.zipCode;
        cellTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    }
    else
    {
        cellimageView.image = [UIImage imageNamed:@"notes_icon"];
        cellTextFeild.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        
        [cellTextFeild setSecureTextEntry:NO];
        cellTextFeild.placeholder = @"Additional notes (security info, parking, etc)";
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Additional notes (security info, parking, etc)" attributes:@{ NSForegroundColorAttributeName : RGBCOLORCODE(150, 150, 150, 1.0) ,NSFontAttributeName : [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-2] }];
        cellTextFeild.attributedPlaceholder = str;
        
        cellTextFeild.text = addressFeild.notes;
        cellTextFeild.keyboardType = UIKeyboardTypeDefault;
    }
    
    return cell;
}

#pragma mark TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float bgHeight = 33*MULTIPLYHEIGHT;
    return bgHeight;
}


#pragma mark - TextFeild Delegate methods

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"ADDRESS NAME"])
    {
        if ([textField.text isEqualToString:@"HOME"] || [textField.text isEqualToString:@"OFFICE"] || (textField.text.length == 0 && !isEditable))
        {
            [textField resignFirstResponder];
            
            [self openPopupForAddressName];
        }
    }
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField.placeholder isEqualToString:@"BUILDING NAME"])
    {
        addressFeild.addressLine1 = str;
    }
    else if ([textField.placeholder isEqualToString:@"ADDRESS NAME"])
    {
        if ([str length] > 6)
        {
            return NO;
        }
        
        addressFeild.addressName = str;
    }
    else if ([textField.placeholder isEqualToString:@"FLOOR NO"])
    {
        if ([str length] > 30)
        {
            return NO;
        }
        
        addressFeild.fno = str;
    }
    else if ([textField.placeholder isEqualToString:@"UNIT NO"])
    {
        if ([str length] > 30)
        {
            return NO;
        }
        
        addressFeild.uno = str;
    }
    else if ([textField.placeholder isEqualToString:@"ADDRESS"])
    {
        addressFeild.addressLine2 = str;
    }
    else if ([textField.placeholder isEqualToString:@"POSTAL CODE"])
    {
        if ([str length] > 6)
        {
            return NO;
        }
        
        isZipCodeValid = NO;
        
        if ([str length] >= 5)
        {
            saveBtn.userInteractionEnabled = YES;
            saveBtn.alpha = 1.0;
            
            if ([string isEqualToString:@""] && [str length] == 5)
            {
                [addAddressTableView reloadData];
                
                [textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
                //[textField becomeFirstResponder];
            }
            else if ([str length] == 6)
            {
                [self saveBtnClicked];
            }
        }
        else
        {
            [saveBtn setAttributedTitle:nil forState:UIControlStateNormal];
            [saveBtn setTitle:@"GET ADDRESS" forState:UIControlStateNormal];
            saveBtn.userInteractionEnabled = NO;
            saveBtn.alpha = 0.0;
        }
        
        addressFeild.zipCode = str;
    }
    else if ([textField.placeholder isEqualToString:@"Additional notes (security info, parking, etc)"])
    {
        if ([str length] > 100)
            return NO;
        
        addressFeild.notes = str;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.placeholder isEqualToString:@"BUILDING NAME"])
    {
        addressFeild.addressLine1 = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"ADDRESS NAME"])
    {
        addressFeild.addressName = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"FLOOR NO"])
    {
        addressFeild.fno = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"UNIT NO"])
    {
        addressFeild.uno = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"ADDRESS"])
    {
        addressFeild.addressLine2 = textField.text;
    }
    else if ([textField.placeholder isEqualToString:@"POSTAL CODE"])
    {
        addressFeild.zipCode = textField.text;
        //        if ([addressFeild.zipCode length] > 0)
        //            [self performSelectorOnMainThread:@selector(validateZipcode) withObject:nil waitUntilDone:NO];
    }
    else if ([textField.placeholder isEqualToString:@"Additional notes (security info, parking, etc)"])
    {
        addressFeild.notes = textField.text;
    }
}


-(void) openPopupForAddressName
{
    view_Popover = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:view_Popover];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(closeCustomPopover)];
    tap.cancelsTouchesInView = NO;
    [view_Popover addGestureRecognizer:tap];
    
    NSArray *arrayTypes = [[NSArray alloc]initWithObjects:@"HOME", @"OFFICE", @"OTHERS", nil];
    customPopOverView = [[CustomPopoverView alloc]initWithArray:arrayTypes SelectedRow:selectedAddressRow];
    customPopOverView.delegate = self;
    [view_Popover addSubview:customPopOverView];
    customPopOverView.alpha = 1.0;
    customPopOverView.backgroundColor = [UIColor clearColor];
    
    CGRect tfRect = [tempTf.superview convertRect:tempTf.frame toView:self.view];
    
    customPopOverView.frame = CGRectMake(20, tfRect.origin.y+35, screen_width-40, 0);
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        customPopOverView.frame = CGRectMake(20, tfRect.origin.y+35, screen_width-40, screen_height-(tfRect.origin.y+35));
        
        
    } completion:^(BOOL finished) {
        
        
    }];

    
}

#pragma mark CUSTOMPopover Delegate Method

-(void) didSelectFromList:(NSString *) string AtIndex:(NSInteger)row
{
    if (![string isEqualToString:@"OTHERS"])
    {
        isEditable = NO;
        tempTf.text = string;
        addressFeild.addressName = string;
    }
    else
    {
        isEditable = YES;
        tempTf.text = @"";
        addressFeild.addressName = @"";
        
        [tempTf becomeFirstResponder];
    }
    
    selectedAddressRow = row;
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        CGRect frame = customPopOverView.frame;
        frame.size.height = 0;
        customPopOverView.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [view_Popover removeFromSuperview];
        view_Popover = nil;
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
    }];

}

-(void) closeCustomPopover
{
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        
        CGRect frame = customPopOverView.frame;
        frame.size.height = 0;
        customPopOverView.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [view_Popover removeFromSuperview];
        view_Popover = nil;
        
        [customPopOverView removeFromSuperview];
        customPopOverView = nil;
        
    }];
}

-(void) validateZipcode
{
    NSDictionary *detailsDic = [NSDictionary dictionaryWithObjectsAndKeys:addressFeild.zipCode, @"zipcode", nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@address/serviceable", BASE_URL];
    
    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:appDel withObject:nil];
    
    [WebserviceMethods sendRequestWithURLString:urlStr requestMethod:@"POST" withDetailsDictionary:detailsDic andResponseCallBack:^(NSURLResponse *response, NSError *error, id responseObj) {
        
        [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:appDel withObject:nil];
        
        if ([[responseObj objectForKey:@"s"] intValue] == 1)
        {
            NSDictionary *dictAddr = [responseObj objectForKey:@"address"];
            
            isZipCodeValid = YES;
            
            [saveBtn setTitle:@"" forState:UIControlStateNormal];
            
            [saveBtn setAttributedTitle:[[WebserviceMethods sharedWebRequest] getAttributedStringWithSpacing:[@"SAVE" uppercaseString] andWithColor:[UIColor whiteColor] andFont:[UIFont fontWithName:APPFONT_BOLD size:appDel.FONT_SIZE_CUSTOM]] forState:UIControlStateNormal];
            
            addressFeild.addressLine1 = [[dictAddr objectForKey:@"building"] isEqualToString:@"NA"]?@"":[dictAddr objectForKey:@"building"];
            
            addressFeild.addressLine2 = [NSString stringWithFormat:@"%@",[[dictAddr objectForKey:@"street"] isEqualToString:@"NA"]?@"":[dictAddr objectForKey:@"street"]];
            
            addressFeild.country = [[dictAddr objectForKey:@"country"] isEqualToString:@"NA"]?@"":[dictAddr objectForKey:@"country"];
            addressFeild.lat = [dictAddr objectForKey:@"lat"];
            addressFeild.lng = [dictAddr objectForKey:@"lon"];
            
//            if ([[dictAddr objectForKey:@"fnoapplicable"] caseInsensitiveCompare:@"Y"] == NSOrderedSame)
//            {
//                isFnoApplicable = YES;
//            }
//            if ([[[[responseObj objectForKey:@"r"] objectAtIndex:0] objectForKey:@"unoapplicable"] caseInsensitiveCompare:@"Y"] == NSOrderedSame)
//            {
//                isUnoApplicable = YES;
//            }
        }
        else
        {
            if ([[responseObj objectForKey:@"s"]intValue] == 17)
            {
                isZipCodeValid = NO;
                
                ZipCodeNotFoundController *zipCode = [[ZipCodeNotFoundController alloc]init];
                [self presentViewController:zipCode animated:YES completion:nil];
            }
            else
            {
                isZipCodeValid = NO;
                
                [appDel showAlertWithMessage:@"Postal code does not exist." andTitle:@"" andBtnTitle:@"OK"];
            }
        }
        
        [addAddressTableView reloadData];
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    [addAddressTableView reloadData];
    
    return YES;
}

#pragma mark ValidateMethod
-(BOOL) validateTextFieldWithText :(NSString*)text With:(NSString*)validateText  {
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validateText];
    return [test evaluateWithObject:text];
}


@end
