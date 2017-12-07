//
//  DragView2.h
//  DragViewDemo
//
//  Created by Arthur Knopper on 1/13/13.
//  Copyright (c) 2013 Arthur Knopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DragViewDelegate <NSObject>

-(void) touchesDidEndToView:(UIView *)view WithLocation:(CGPoint) location AndPreviousLocation:(CGPoint)previousLocation;
-(void) touchesDidChangeToView:(UIView *)view WithLocation:(CGPoint) location AndPreviousLocation:(CGPoint)previousLocation;

@end

@interface DragView2 : UIView
{
    CGPoint lastLocation;
}

@property (nonatomic, strong) id <DragViewDelegate>  delegate;

@end
