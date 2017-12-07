//
//  TabBarViewController.h
//  Piing
//
//  Created by Veedepu Srikanth on 22/11/15.
//  Copyright © 2015 shashank. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController
{
    
    UITabBarItem *tabBarItem1;
    UITabBarItem *tabBarItem2;
    UITabBarItem *tabBarItem3;
    UITabBarItem *tabBarItem4;
    UITabBarItem *tabBarItem5;
    
    UIVisualEffect *blurEffect;
}

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (nonatomic, strong) UIView *backgroundView;


@end
