//
//  DropAtDoorViewController.h
//  Piing
//
//  Created by Veedepu Srikanth on 23/04/16.
//  Copyright © 2016 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropAtDoorViewControllerDelegate <NSObject>

-(void) didFinishDropAtDoor;

@end


@interface DropAtDoorViewController : UIViewController

@property (nonatomic, strong) id <DropAtDoorViewControllerDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *orderEditDetails;

@end
