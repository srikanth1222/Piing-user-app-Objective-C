//
//  CustomSegmentControl.m
//  Vendle
//
//  Created by Hema on 25/08/14.
//  Copyright (c) 2014 Riktam Technologies. All rights reserved.
//

#import "CustomSegmentControl.h"
#import "CustomButton.h"

//#define GRAY_BACKGROUND_COLOR [[UIColor grayColor] colorWithAlphaComponent:0.6]
#define GRAY_BACKGROUND_COLOR [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]

@implementation CustomSegmentControl
{
    CAShapeLayer *shapeLayer1;
    CAShapeLayer *shapeLayer2;
}

@synthesize segmentTitles = _segmentTitles;

-(id) initWithFrame:(CGRect)frame andButtonTitles:(NSArray *)titles andWithSpacing:(NSNumber *)spacing andSelectionColor:(UIColor *)selColor andDelegate:(id)del andSelector:(NSString *)selctor {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        AppDelegate *appDel = [PiingHandler sharedHandler].appDel;
        self.segmentTitles = [NSMutableArray arrayWithArray:titles];
        self.backgroundColor = GRAY_BACKGROUND_COLOR;
        
        self.callBackSel = selctor;
        self.delegate = del;
        
        for(int i = 0; i<[titles count]; i++)
		{
            
			CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
			btn.tag = i+1;
            btn.frame = CGRectMake((i*frame.size.width/[titles count]) , 0, frame.size.width/[titles count], frame.size.height);
			[btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
			btn.adjustsImageWhenHighlighted = NO;
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
			btn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:appDel.HEADER_LABEL_FONT_SIZE-2];
			btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:GRAY_BACKGROUND_COLOR forState:UIControlStateNormal];
            [btn setBackgroundColor:selColor forState:UIControlStateSelected];
            btn.layer.borderWidth = [spacing floatValue];
            btn.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.7] CGColor];
            btn.layer.cornerRadius = 3.0f;
            
            btn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
            btn.layer.shadowColor = [[UIColor blackColor] CGColor];
            
            btn.clipsToBounds = YES;
            [btn addTarget:self action:@selector(customSegmentClicked:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:btn];
            
		}
        
        [self customSegmentClicked:(CustomButton *)[self viewWithTag:1]];
    }
    
    return self;
}

-(id) initWithFrame:(CGRect)frame andButtonTitles2:(NSArray *)titles andWithSpacing:(NSNumber *)spacing andSelectionColor:(UIColor *)selColor andDelegate:(id)del andSelector:(NSString *)selctor {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        AppDelegate *appDel = [PiingHandler sharedHandler].appDel;
        
        self.segmentTitles = [NSMutableArray arrayWithArray:titles];
        self.backgroundColor = GRAY_BACKGROUND_COLOR;
        
        self.callBackSel = selctor;
        self.delegate = del;
        
        for(int i = 0; i<[titles count]; i++)
        {
            
            CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i+1;
            btn.frame = CGRectMake((i*frame.size.width/[titles count]) , 0, frame.size.width/[titles count], frame.size.height);
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            btn.adjustsImageWhenHighlighted = NO;
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            btn.titleLabel.font = [UIFont fontWithName:APPFONT_SEMI_BOLD size:appDel.FONT_SIZE_CUSTOM-1];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:selColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(customSegmentClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            
            if (i==0)
            {
                
                UIBezierPath *maskPath;
                maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds
                                                 byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerTopLeft)
                                                       cornerRadii:CGSizeMake(5.0, 5.0)];
                
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                //maskLayer.hidden = YES;
                maskLayer.frame =btn.bounds;
                maskLayer.path = maskPath.CGPath;
                btn.layer.mask = maskLayer;
                btn.clipsToBounds = YES;
                btn.layer.masksToBounds = YES;
                
                CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
                borderLayer.hidden = YES;
                borderLayer.frame = CGRectMake(1, 0, btn.frame.size.width, btn.frame.size.height);
                borderLayer.path  = maskPath.CGPath;
                borderLayer.lineWidth   = 1.5f;
                borderLayer.strokeColor = [UIColor whiteColor].CGColor;
                borderLayer.fillColor   = [UIColor clearColor].CGColor;
                
                [btn.layer addSublayer:borderLayer];
                
                shapeLayer1 = borderLayer;
            }
            
            else if (i==1)
            {
//                CALayer *TopBorder = [CALayer layer];
//                TopBorder.frame = CGRectMake(0.0f, 0.0f, btn.frame.size.width, 1.5f);
//                TopBorder.backgroundColor = [UIColor whiteColor].CGColor;
//                [btn.layer addSublayer:TopBorder];
//                
//                CALayer *rightBorder = [CALayer layer];
//                rightBorder.frame = CGRectMake(btn.frame.size.width-4, -1.0f, 2, btn.frame.size.height+2);
//                rightBorder.backgroundColor = [UIColor whiteColor].CGColor;
//                [btn.layer addSublayer:rightBorder];
//                
//                CALayer *bottomBorder = [CALayer layer];
//                bottomBorder.frame = CGRectMake(0.0f, btn.frame.size.height-1.5, btn.frame.size.width, 1.5f);
//                bottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
//                [btn.layer addSublayer:bottomBorder];
                
                UIBezierPath *maskPath;
                maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds
                                                 byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerTopRight)
                                                       cornerRadii:CGSizeMake(5.0, 5.0)];
                
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                //maskLayer.hidden = YES;
                maskLayer.frame =btn.bounds;
                maskLayer.path = maskPath.CGPath;
                btn.layer.mask = maskLayer;
                btn.clipsToBounds = YES;
                btn.layer.masksToBounds = YES;
                
                CAShapeLayer *borderLayer = [[CAShapeLayer alloc] init];
                borderLayer.hidden = YES;
                borderLayer.frame = CGRectMake(-1, 0, btn.frame.size.width, btn.frame.size.height);
                borderLayer.path  = maskPath.CGPath;
                borderLayer.lineWidth   = 1.5f;
                borderLayer.strokeColor = [UIColor whiteColor].CGColor;
                borderLayer.fillColor   = [UIColor clearColor].CGColor;
                
                [btn.layer addSublayer:borderLayer];
                
                shapeLayer2 = borderLayer;
                
            }
        }
        
        [self customSegmentClicked:(CustomButton *)[self viewWithTag:1]];
    }
    
    return self;
}
-(void) customSegmentClicked:(CustomButton *)button
{
    [self resetAllSegments];
    button.selected = YES;
    SEL callBack = NSSelectorFromString(self.callBackSel);
    
    selIndex = button.tag - 1;
    
    if (button.tag == 1)
    {
        shapeLayer1.hidden = YES;
        shapeLayer2.hidden = NO;
    }
    else
    {
        shapeLayer1.hidden = NO;
        shapeLayer2.hidden = YES;
    }
    
    
    if(self.delegate)
        [self.delegate performSelector:callBack withObject:self];
    
}

-(void) resetAllSegments
{
    
    for(int i = 0; i<[self.segmentTitles count]; i++)
    {
        CustomButton *btn = (CustomButton *)[self viewWithTag:i+1];
        [btn setTitle:[self.segmentTitles objectAtIndex:i] forState:UIControlStateNormal];
        btn.selected = NO;
    }
    
}

- (void) setSelectedIndex:(long int)selectedIndex
{
    selIndex = selectedIndex;
    [self customSegmentClicked:(CustomButton *)[self viewWithTag:selIndex+1]];
}

-(long int) selectedIndex
{
    return selIndex;
}

-(void) setSegmentTitles:(NSMutableArray *)segmentTitles
{
    _segmentTitles = segmentTitles;
    
    [self resetAllSegments];
    CustomButton *btn = (CustomButton *)[self viewWithTag:selIndex+1];
    btn.selected = YES;
}

-(NSMutableArray *)segmentTitles
{
    return _segmentTitles;
}


@end




