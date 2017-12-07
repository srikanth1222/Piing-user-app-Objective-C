//
//  StatusViewController.m
//  Ping
//
//  Created by SHASHANK on 21/05/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import "StatusViewController.h"

@implementation StatusViewController

@synthesize btnDelegate;
@synthesize selectedIndex;
@synthesize completedBtnImages, uncompletedBtnImages, titlesNamesArray;

-(id)initWithFrame:(CGRect)frame titles:(NSArray *)titles unCompletedImages:(NSArray*) unCompletedImages completedImages:(NSArray *)completedImages andCurrentImagesAry:(NSArray *) currentImages seperatorSpacing:(NSNumber *)spacing andDelegate:(id)delegate
{
    float labelY;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        labelY = 2;
    }
    else{
        labelY = 6;
    }
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
            
        self.btnDelegate = delegate;
        self.titlesNamesArray     = [[NSMutableArray alloc] initWithArray:titles];
        self.completedBtnImages   = [[NSMutableArray alloc] initWithArray:completedImages];
        self.uncompletedBtnImages = [[NSMutableArray alloc] initWithArray:unCompletedImages];
        self.currentTaskBtnImages = [[NSMutableArray alloc] initWithArray:currentImages];

        long int totalCount = [titles count] *2 - 1;
        
        for(int i = 0,j = 0; j < [titles count]*2 - 1; j++)
        {
            if (j%2 == 0)
            {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [btn setImage:[UIImage imageNamed:[unCompletedImages objectAtIndex:i]] forState:UIControlStateNormal];
                
                btn.tag = j+1;
                [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
                btn.adjustsImageWhenHighlighted = NO;
                btn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:13];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(spaceSegmentClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake((j*frame.size.width/totalCount), 0, frame.size.width/totalCount, frame.size.height);
//                btn.titleEdgeInsets=UIEdgeInsetsMake(labelY, 0, 0, 0);
                btn.clipsToBounds = YES;
                
                [self addSubview:btn];
                
                i++;
            }
            else
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                
//                [btn setImage:[UIImage imageNamed:[unCompletedImages objectAtIndex:i]] forState:UIControlStateNormal];
                
                btn.tag = j+1;
                [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
                btn.adjustsImageWhenHighlighted = NO;
                btn.titleLabel.font = [UIFont fontWithName:APPFONT_REGULAR size:13];
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(spaceSegmentClicked:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake((j*frame.size.width/totalCount), (frame.size.height-5)/2.0, frame.size.width/totalCount, 5.0);
                btn.layer.borderColor = [UIColor grayColor].CGColor;
                btn.layer.borderWidth = 0.3f;
                btn.backgroundColor = [UIColor clearColor];
//                btn.titleEdgeInsets=UIEdgeInsetsMake(labelY, 0, 0, 0);
                
                [self addSubview:btn];
            }
        }
    }
    
    return self;
    
}
-(void)spaceSegmentClicked:(UIButton *)btn {
    
    [self setSelectedControlIndex:btn.tag-1];
    
    if(selector)
    {
        if([self.btnDelegate respondsToSelector:selector])
        {
            [self.btnDelegate performSelector:selector withObject:self];
        }
    }
}

//setting the image for the priority button when clicked
-(void) setSelectedControlIndex:(long int)index {
    
    NSLog(@"Selected index %ld", index);
    
    for(int i = 0, j=0; j<[self.titlesNamesArray count]*2 - 1; j++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:j+1];
        
        if (j%2 == 0)
        {
            if (index > j)
            {
                [btn setImage:[UIImage imageNamed:[self.completedBtnImages objectAtIndex:i]]  forState:UIControlStateNormal];

            }
            else if (j == index)
            {
                [btn setImage:[UIImage imageNamed:[self.currentTaskBtnImages objectAtIndex:i]]  forState:UIControlStateNormal];

            }
            else
            {
                [btn setImage:[UIImage imageNamed:[self.uncompletedBtnImages objectAtIndex:i]]  forState:UIControlStateNormal];
            }
            
            i++;
        }
        else
        {
            if (index > j)
            {
                btn.backgroundColor = [UIColor grayColor];
            }
            else if (index == j)
            {
                btn.backgroundColor = [UIColor whiteColor];
            }
            else
            {
                btn.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    self.selectedIndex = index;
}

-(void)setTargetSelector:(SEL)selectorAction {
    selector = selectorAction;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code	
}

-(void) makeAllUnselected
{
    for(int i = 0; i<[self.titlesNamesArray count]; i++)
    {
        UIButton *btn = (UIButton *)[self viewWithTag:i+1];
        
        [btn setImage:[UIImage imageNamed:[self.uncompletedBtnImages objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}
-(void) dealloc {
    
    [self.titlesNamesArray release];
    [self.completedBtnImages release];
    [self.uncompletedBtnImages release];
    [self.currentTaskBtnImages release];
    
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
