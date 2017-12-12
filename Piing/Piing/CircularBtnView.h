//
//  CircularBtnView.h
//  Ping
//
//  Created by SHASHANK on 27/02/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularBtnView : UIView
{
    UILabel *countdownLabel;
    UIImageView *anchorimageView;
    
    id paentDel;
}
@property (nonatomic, retain) UILabel *countdownLabel;
@property (nonatomic, retain) id paentDel;

-(id) initWithFrame:(CGRect)frame andDelegate:(id) delegate;
-(void) setDetails:(int) value;

-(void) showOnlyWaves;
-(void) offWaves;
-(void) rotate2:(int) seconds;
-(void) stopRotate2;
-(void) hideAllData;

@end
