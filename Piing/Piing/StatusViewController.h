//
//  StatusViewController.h
//  Ping
//
//  Created by SHASHANK on 21/05/15.
//  Copyright (c) 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewController : UIView
{
    id btnDelegate;
    long int selectedIndex;
    
    SEL selector;
    NSMutableArray *selectedBtnImages, *unselectedBtnImages,*titlesNamesArray;
}
@property (nonatomic, retain) id btnDelegate;
@property (nonatomic,readwrite) long int selectedIndex;
@property (nonatomic,retain) NSMutableArray *completedBtnImages;
@property (nonatomic,retain) NSMutableArray *uncompletedBtnImages;
@property (nonatomic,retain) NSMutableArray *currentTaskBtnImages;

@property (nonatomic,retain) NSMutableArray *titlesNamesArray;

-(void) setSelectedControlIndex:(long int)index ;
-(void)setTargetSelector:(SEL)selectorAction;

-(id)initWithFrame:(CGRect)frame titles:(NSArray *)titles unCompletedImages:(NSArray*) unCompletedImages completedImages:(NSArray *)completedImages andCurrentImagesAry:(NSArray *) currentImages seperatorSpacing:(NSNumber *)spacing andDelegate:(id)delegate;

-(void) makeAllUnselected;
@end
