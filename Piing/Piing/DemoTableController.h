//
//  DemoTableControllerViewController.h
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DemoTableControllerDelegate <NSObject>

-(void) didSelectFromList:(NSString *) string AtIndex:(NSInteger) row;

@end


@interface DemoTableController : UITableViewController
@property(nonatomic,strong) id <DemoTableControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *arrayList;
@property (nonatomic, assign) BOOL isAddressSelected;

@end
